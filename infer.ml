open Ast
open Tast

module StringMap = Map.Make (String)

exception Type_error of string

(* type gtype =
  | TYCON of tycon
  | TYVAR of tyvar
  | CONAPP of conapp
and tycon =
  | TInt                                          (** integers [int] *)
  | TBool                                         (** booleans [bool] *)
  | TChar                                         (** chars    [char] *)
  | TArrow of gtype                               (** Function type [s -> t] *)
    How do functions work? A function is encoded as a CONAPP of TArrow 
       where the TArrow's gtype is the return type and the gtype list 
       associated with the CONAPP is the types of the arguments
  (* | TTree of gtype * gscheme * gscheme         (** Trees *) *)
and tyvar =
  | TVariable of int                              (** parameter *)
and conapp = (tycon * gtype list)

type tyscheme = (tyvar list * gtype)


let functiontype resultType formalsTypes = CONAPP (TArrow resultType, formalsTypes) *)


(* TAST Types*)
(* type texpr = gtype * tx
  and tx = 
    | TLiteral     of tvalue
    | TypedVar     of ident
    | TypedIf      of texpr * texpr * texpr
    | TypedApply   of texpr * texpr list
    | TypedLet     of (ident * texpr) list * texpr
    | TypedLambda  of (gtype * ident) list * texpr
    | TypedLambda  of (gtype * ident) list * texpr
  and tvalue = 
    | TChar    of char
    | TInt     of int
    | TBool    of bool
    | TRoot    of ttree
  and ttree =  
    | TLeaf
    | TBranch of tvalue * ttree * ttree

type tdefn = 
  | TVal of ident * texpr
  | TExpr of texpr
  
type tprog = tdefn list  *)



(* Printing *)
(* let rec string_of_typ = function
  | TYCON ty -> string_of_tycon ty
  | TYVAR tp -> string_of_tyvar tp
  | CONAPP con -> string_of_conapp con
and string_of_tycon = function 
  | TInt -> "int"
  | TBool -> "bool"
  | TChar -> "char"
  | TArrow a -> string_of_typ (a)
and string_of_tyvar = function 
  | TVariable n -> "tyvar" ^ string_of_int n
and string_of_conapp (tyc, tys) = 
  "conapp: " ^ string_of_tycon tyc ^ " " ^ String.concat " " (List.map string_of_typ tys)
and string_of_constraints = function
  | [] -> ""
  | (f, s)::cs -> "(" ^ string_of_typ f ^ ", " ^ string_of_typ s ^ ") " ^ string_of_constraints cs
and string_of_gencons = function
  | [] -> ""
  | (g, lcons)::gs -> "(" ^ string_of_typ g ^ ", " ^ string_of_constraints lcons ^ ") " ^ string_of_gencons gs *)
(* End Printing *)



(* Begin Type Inferencer *)
(* ty_error msg: reports a type error by raising [Type_error msg]. *)
(* let type_error msg = raise (Type_error msg) *)

(* is_free_type_var: returns false if no type variable is free, else returns the type variable *)
let rec is_free_type_var var gt = 
  match gt with
  | TYCON _ -> false
  | TYVAR tvar -> var = tvar
  | CONAPP tcon -> 
    List.fold_left (fun acc x -> is_free_type_var var x || acc) false (snd tcon)


let rec ftvs (ty : gtype) = 
  match ty with
  | TYVAR t -> [t]
  | TYCON _ -> []
  | CONAPP a -> List.fold_left (fun acc x -> acc @ (ftvs x)) [] (snd a)

let tysubst (theta: (tyvar * gtype) list) (t : gtype) (ftvs: tyvar list) =
match t with
| TYVAR t -> let (_, tau) = List.find (fun (x : tyvar * gtype) -> (fst x) = t) theta in if (List.exists (fun x -> x = t) ftvs) then tau else TYVAR t 
| TYCON c -> TYCON c
| _ -> raise (Type_error "missing case for CONAPP")
(* | CONAPP a -> CONAPP ((tysubst theta (fst a) ftvs), List.map (fun x -> tysubst theta x ftvs) (snd a)) *)

let rec sub_theta_into_gamma (theta : (tyvar * gtype) list) (gamma : (ident * tyscheme) list) = 
  match gamma with
    | [] -> []
    | (g :: gs) -> 
      let (name, tysch) = g in
      let (bound_types, btypes) = tysch in
      let freetypes = List.filter (fun (x : tyvar) -> List.exists (fun (y : tyvar) -> y = x) bound_types) (ftvs btypes) in
      let new_btype = tysubst theta btypes freetypes in
      (name, (bound_types, new_btype)) :: sub_theta_into_gamma theta gs 


(* fresh: returns an unused type variable *)
let fresh =
  let k = ref 0 in
  (* fun () -> incr k; TVariable !k *)
    fun () -> incr k; TYVAR (TVariable !k)


(* sub: updates a list of constraints with any substitutions in theta *)
let sub (theta : (tyvar * gtype) list) (cns : (gtype * gtype) list) =
  (* sub1: takes in a single constraint and updates it with any substitutions in theta *)
  let sub1 cn = 
    List.fold_left 
      (fun (acc : (gtype * gtype)) (one_sub : tyvar * gtype) ->
        match acc with
        | (TYVAR t1, TYVAR t2) -> 
          if (fst one_sub = t1) then (snd one_sub, snd acc)
          else if (fst one_sub = t2) then (fst acc, snd one_sub)
          else acc
        | (TYVAR t1, _) -> 
          if (fst one_sub = t1) then (snd one_sub, snd acc)
          else acc
        | (_, TYVAR t2) -> 
          if (fst one_sub = t2) then (fst acc, snd one_sub)
          else acc
      | (_, _) -> acc)
      cn theta in 
  List.map sub1 cns


(* compose: applies the substitutions in theta1 to theta2 TODO do we have to reverse it? *)
let compose theta1 theta2 =
  (* sub1: takes in a single substitution in theta1 and applies it to theta 2 *)
  let sub1 cn = 
    List.fold_left 
    (fun (acc : tyvar * gtype) (one_sub : tyvar * gtype) ->
      match acc, one_sub with
      | (a1, TYVAR a2), (s1, TYVAR _) -> 
          if a1 = s1 then (s1, snd acc)
          else if s1 = a2 then (a1, snd one_sub)
          else acc
      | (a1, a2), (s1, TYVAR _) -> 
          if (a1 = s1) then (s1, a2)
          else acc
      | (_,_), _ -> acc
    )
    cn theta1 in 
  List.map sub1 theta2


(* solve': *)
let rec solve' c1 = 
  match c1 with
  | (TYVAR t1, TYVAR t2) -> [(t1, TYVAR t2)]
  | (TYVAR t, TYCON c) -> [(t, TYCON c)]
  | (TYVAR t, CONAPP a) ->  
      if List.fold_left 
        (fun acc x -> (is_free_type_var t x || acc)) false (snd a)
      then raise (Type_error "type error")
      else [(t, CONAPP a)]
  | (TYCON c, TYVAR t) -> solve' (TYVAR t, TYCON c)
  | (TYCON (TArrow (TYVAR a)), TYCON b) -> [(a, TYCON b)] 
  | (TYCON b, TYCON (TArrow (TYVAR a))) -> [(a, TYCON b)] 
  | (TYCON c1, TYCON c2) -> 
      if c1 = c2 
      then []
      else 
      (* let cone = string_of_tycon c1 in let _ = print_string cone in *)
      (* let ctwo = string_of_tycon c2 in let _ = print_string ctwo in *)
      raise (Type_error "type error: (tycon,tycon)")
  | (TYCON _, CONAPP _) -> raise (Type_error "type error: (tycon, conapp")
  | (CONAPP a, TYVAR t) -> solve' (TYVAR t, CONAPP a)
  | (CONAPP _, TYCON _) -> raise (Type_error "type error: (conapp, tycon")
  | (CONAPP a1, CONAPP a2) -> solve ((List.combine (snd a1) (snd a2)) @ [((TYCON (fst a1), TYCON (fst a2)))])


(* solve: *)
and solve (constraints : (gtype * gtype) list) =
(* solver: *) 
  (* let solver cns (subs : (tyvar * gtype) list) = *)
  let solver cns  =
    match cns with
    | [] -> []
    | cn :: cns ->  
      let theta1 = solve' cn in               
      let theta2 = solve (sub theta1 cns) in
      compose theta2 theta1
  (* in solver constraints [] *)
  in solver constraints 

(* generate_constraints gctx e: infers the type of expression 'e' and a set of
    constraints, 'gctx' refers to the global context 'e' can refer to *)


(* (ctx : (ident * tyscheme) list ) *)
(* type tyscheme = (tyvar list * gtype) *)
(* generate_constraints:
    returns: gtype * (gtype * gtype) list * tx                                *)
let rec generate_constraints gctx e =
  let rec constrain ctx e =
    match e with
    | Literal e -> value e
    | Var name -> 
      let (_, (_, tau)) = List.find (fun x -> fst x = name) ctx in
      (tau, [], (tau, (TypedVar name)))
    | If (e1, e2, e3) -> 
      let (t1, c1, tex1) = generate_constraints gctx e1 in
      let (t2, c2, tex2) = generate_constraints gctx e2 in
      let (t3, c3, tex3) = generate_constraints gctx e3 in
      let c = [(TYCON TBool, t1); (t3, t2)] @ c1 @ c2 @ c3 in
      let tex = TypedIf(tex1, tex2, tex3) in
      (t3, c, (t3, tex))
    | Apply (f, args) ->
    let t1, c1, tex1 = generate_constraints ctx f in
      let ts2, c2, texs2 = List.fold_left (fun acc e -> 
        let t, c, x = generate_constraints ctx e in 
        let ts, cs, xs = acc in (t::ts, c @ cs, x::xs)) 
      ([], c1, []) args in
      let retType = fresh () in 
      (retType, 
        (t1, (CONAPP (TArrow retType, ts2)))::c2, 
        (CONAPP (TArrow retType, ts2), TypedApply(tex1, texs2)))
    | Let (bindings, expr) ->
    	let ctx1, cs = (List.fold_left (fun (running_ctx, running_cons) (id, e) -> 
    		let new_ty, new_con, _ = generate_constraints ctx e in
  			((id, ([], new_ty))::running_ctx, new_con @ running_cons)) (ctx, []) bindings) in
    	let ctx' = sub_theta_into_gamma 
    	cs
    	 ctx in
			let t, c, tex = generate_constraints ctx' expr in
			(t, 
				cs @ c, 
				TypedLet(fs, tex))
    | Lambda (formals, body) -> 
      (* Constrain each formal (string) to fresh type var. fresh returns the
         gtype: TYVAR (TVariable int).
         binding looks like a ctx:
              ident * tyscheme ==     ident (tyvar list * gtype) *)
      let binding = List.map (fun x -> (x,   ([],        fresh () ))) formals in
      (* let binding_as_gtype = List.map (fun (x, (y, z)) -> (x, (y, TYVAR z))) binding in *)
      (* ctx : Ast.ident * ('a * gtype) *)
      let new_context = binding @ ctx in
      let (t, c, tex) = generate_constraints new_context body in
      let formaltys = snd (List.split (snd (List.split binding))) in
      let typedFormals = List.combine formaltys formals in 
      (CONAPP (TArrow t, formaltys), c,
        (CONAPP (TArrow t, formaltys), TypedLambda (typedFormals, tex)))
    and value v =  
      match v with
      | Int e  -> (TYCON TInt, [], (TYCON TInt, TLiteral (TInt e)))
      | Char e -> (TYCON TChar, [], (TYCON TChar, TLiteral (TChar e)))
      | Bool e -> (TYCON TBool, [], (TYCON TBool, TLiteral (TBool e)))
      | Root t -> tree t
    and tree t = 
      match t with 
      | Leaf -> raise (Failure ("Infer TODO: generate constraints for Leaf"))
      | Branch _ -> raise (Failure ("Infer TODO: generate constraints for Branch"))
  in constrain gctx e



(* get_constraints should resturn a list of tasts *)
(* TAST = [ (ident * (gtype * tx)) ] = [ (ident * texpr) | texpr ] = [ tdefns ] = *)
(* type tyscheme = (tyvar list * gtype) *)
let rec get_constraints (ctx : (ident * tyscheme) list ) (d : defn list) =
  match d with
  | [] -> []
  | Val (name, e) :: ds -> 
    let (t, c, tex) = generate_constraints ctx e in
    let new_ctx = (name, 
                       (List.filter (fun (x : tyvar) -> 
                                        List.exists (fun (y : tyvar) -> y = x) 
                                                    (ftvs t)) 
                                    (ftvs t), 
                        t)
                      ) :: ctx in
    (t, c, (TVal (name, tex))) :: (get_constraints new_ctx ds)
  | Expr e :: ds ->
    let (t, c, tex) = generate_constraints ctx e in 
    (t, c, TExpr tex) :: get_constraints ctx ds


(* input: (tyvar * gtype) list                                 *)
(* return: tdefn -> tdefn *)
  let apply_subs (sub : (tyvar * gtype) list) = match sub with
  | [] -> (fun x -> x)
  | xs -> 
    let final_ans =
      (fun tdef -> 
        (* input: texpr *)
        (* return: texpr *)
        let rec expr_only_case (x : texpr) =

        List.fold_left (fun (tast_gt, tast_tx) (tv, gt) -> 
          let updated_tast_tx = match tast_tx with
            | TypedIf (x, y, z) -> TypedIf (expr_only_case x, expr_only_case y, expr_only_case z)
            | TypedApply (x, xs) -> TypedApply (expr_only_case x,(List.map expr_only_case xs))
            | TypedLet ((its), x) -> TypedLet (List.map (fun (x, y) -> (x, expr_only_case y)) its, expr_only_case x)
            | TypedLambda (tyformals, z) -> TypedLambda (tyformals, (expr_only_case z))
            | TLiteral x -> TLiteral x
            | TypedVar x -> TypedVar x
          in 
          if (TYVAR tv = tast_gt) then (gt, updated_tast_tx) 
          else  (tast_gt, updated_tast_tx))
        x xs
      in
        match tdef with 
        | TVal (name, x) -> TVal (name, (expr_only_case x))
        | TExpr x -> TExpr (expr_only_case x))
    in final_ans


(* currently is returning -> Infer.texpr list * (Infer.tyvar * Infer.gtype) list *)
(*          should return -> tdefn list = (ident * (gtype * tx)) list *)
let type_infer (ds : defn list) =
    let type_infer' (ctx : (ident * tyscheme) list) =
      (* TODO this is the worst name for a variable ever but I don't really know what it is *)
      (* ans -> )(Type_of_the_whole, list_of_constraints, expressions_in_chunk*)
      (* ans -> (Infer.gtype * (Infer.gtype * Infer.gtype) list * Infer.texpr) list *)
      let ans = (get_constraints ctx ds) in
      
      (* constraints -> gtype list *)
      let constraints = List.flatten (List.map (fun (_, x, _) -> x) ans) in
      (* tasts -> tdefn list *)
      let tdefns = (List.map (fun (_, _, x) -> x) ans) in
      (* subs -> (Infer.tyvar * Infer.gtype) list *)
      let subs = solve constraints in
      (* almost -> texpr list *)
      let almost = List.map (apply_subs subs) tdefns in
      almost
    in type_infer' []