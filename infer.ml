
open Ast
open Tast

module StringMap = Map.Make (String)

exception Type_error of string


(* prims - initializes context with built-in functions with their types *)
(* prims : (id * tyvar) list * (tycon * gtype list) *)
let prims = 
[
  ("printb", ([TVariable (-1)], Tast.functiontype inttype [booltype]));
  ("printi", ([TVariable (-2)], Tast.functiontype inttype [inttype]));
  ("printc", ([TVariable (-3)], Tast.functiontype inttype [chartype]));
  ("+",      ([TVariable (-4)], Tast.functiontype inttype [inttype; inttype]));
  ("-",      ([TVariable (-4)], Tast.functiontype inttype [inttype; inttype]));
  ("/",      ([TVariable (-4)], Tast.functiontype inttype [inttype; inttype]));
  ("*",      ([TVariable (-4)], Tast.functiontype inttype [inttype; inttype]));
  ("mod",    ([TVariable (-4)], Tast.functiontype inttype [inttype; inttype]));
  ("<",      ([TVariable (-5)], Tast.functiontype booltype [inttype; inttype]));
  (">",      ([TVariable (-5)], Tast.functiontype booltype [inttype; inttype]));
  ("<=",     ([TVariable (-5)], Tast.functiontype booltype [inttype; inttype]));
  (">=",     ([TVariable (-5)], Tast.functiontype booltype [inttype; inttype]));
  ("=i",     ([TVariable (-5)], Tast.functiontype booltype [inttype; inttype]));
  ("!=i",    ([TVariable (-5)], Tast.functiontype booltype [inttype; inttype]));
  ("&&",     ([TVariable (-6)], Tast.functiontype booltype [booltype; booltype]));
  ("||",     ([TVariable (-6)], Tast.functiontype booltype [booltype; booltype]));
  ("not",    ([TVariable (-7)], Tast.functiontype booltype [booltype]));
  (* ("-",      ([TVariable (-2)], Tast.functiontype inttype [inttype]))   *)
] 


(* is_ftv - returns true if 'gt' is equal to free type variable 'var' 
    (i.e. 'gt' is a type variable and 'var' is a free type variable). For the
    conapp case, we recurse over the conapp's gtype list searching for any free
    type variables. When this function returns true it means the type variable
    is matching *)
let rec is_ftv (var : tyvar) (gt : gtype) = 
  match gt with
  | TYCON _ -> false
  | TYVAR v -> v = var
  | CONAPP (t, gtlst) -> 
    (* if any x in gtlst is ftv this returns true, else returns false *)
    List.fold_left (fun acc x -> is_ftv var x || acc) false (gtlst)

(* ftvs - returns a list of free type variables amongst a collection of gtypes *)
(* returns : tyvar list *)
let rec ftvs (ty : gtype) = 
  match ty with
  | TYVAR t -> [t]
  | TYCON _ -> []
  | CONAPP (t, gtlst) -> List.fold_left (fun acc x -> acc @ (ftvs x)) [] gtlst


(* fresh - returns a fresh gtype variable (integer) *)
(* returns : tyvar *)
let fresh =
  let k = ref 0 in
  (* fun () -> incr k; TVariable !k *)
  fun () -> incr k; TYVAR (TVariable !k)


(* reset_fresh - resets the fresh value to 0 *)
(* TODO - I don't know if I need this yet, put here just in case *)
let reset_fresh =
  let k = ref 0 in
  fun () -> k := 0


(* sub - updates a list of constraints with substitutions in theta *)
let sub (theta : (tyvar * gtype) list) (cns : (gtype * gtype) list) =
  (* sub_one - takes in single constraint and updates it with substitution in theta *)
  let sub_one (cn : gtype * gtype) = 
    (* acc : cn    : gtype * gtype *)
    (*   x : theta : (tyvar * gtype) list *)
    List.fold_left (fun ((c1, c2) : gtype * gtype) ((tv, gt) : tyvar * gtype) ->
      match (c1, c2) with
      | (TYVAR t1, TYVAR t2) -> 
        (* TODO - do we want to replace fst acc *)
        if (tv = t1) then (gt, c2)
        else if (tv = t2) then (c1, gt)
        else (c1, c2)
      | (TYVAR t1, _) -> 
        if (tv = t1) then (gt, c2)
        else (c1, c2)
      | (_, TYVAR t2) -> 
        if (tv = t2) then (c1, gt)
        else (c1, c2)
      | (_, _) -> (c1, c2))
    cn theta in 
  List.map sub_one cns


(* compose - applies the substitutions in theta1 to theta2 *)
let compose theta1 theta2 =
  (* sub_one - takes a single substitution in theta1 and applies it to theta2 *)
  let sub_one cn = 
    List.fold_left 
    (fun (acc : tyvar * gtype) (one_sub : tyvar * gtype) ->
      match acc, one_sub with
      | (a1, TYVAR a2), (s1, TYVAR s2) -> 
        if s1 = a1 then (s1, TYVAR a2)
        else if s1 = a2 then (a1, TYVAR s2)
        else acc
      | (a1, a2), (s1, TYVAR s2) -> 
        if (a1 = s1) then (s1, a2)
        else acc
      | (a1, a2), (s1, s2) -> 
        if (a1 = s1) then (s1, s2)
        else acc
      (* | (_,_), _ -> acc *) (* TODO - changed to make more explicit *)
    ) cn theta1 in
  List.map sub_one theta2


(* solve': solves a single constraint 'c' *)
let rec solve' (c : gtype * gtype)  = 
  match c with
  | (TYVAR t1, TYVAR t2) -> let () = print_endline "HERE1" in [(t1, TYVAR t2)]
  | (TYVAR t1, TYCON t2) -> 
    let () = print_endline (":=SOLVE=: (TYVAR t1, TYCON t2) = " ^ Tast.string_of_constraint c ^ " -> (" ^ Tast.string_of_tyvar t1 ^ ", " ^ Tast.string_of_ttype (TYCON t2) ^ ")") in
    [(t1, TYCON t2)]
  | (TYVAR t1, CONAPP t2) -> 
    let () = print_endline "HERE3" in
    if is_ftv t1 (CONAPP t2) then raise (Type_error "type error: type variable is not free in type constructor")
    else [(t1, (CONAPP t2))]
      (* if List.fold_left 
        (fun acc x -> (is_ftv t x || acc)) false (snd a)
      then raise (Type_error "type error")
      else [(t, CONAPP a)] *) (* TODO - changed to make more compact - gave is_ftv a conapp case *)
  | (TYCON t1, TYVAR t2) -> let () = 
      print_endline (":=SOLVE=: (TYCON t1, TYVAR t2) = " ^ Tast.string_of_constraint c ^ " -> (" ^ Tast.string_of_tyvar t2 ^ ", " ^ Tast.string_of_tycon t1 ^ ")") in 
      solve' (TYVAR t2, TYCON t1)
  | (TYCON (TArrow (TYVAR t1)), TYCON t2) -> let () = print_endline "HERE5" in [(t1, TYCON t2)] 
  | (TYCON t1, TYCON (TArrow (TYVAR t2))) -> 
    let () = print_endline (":=SOLVE=: (TYCON t1, TYCON (TArrow (TYVAR t2))) = " ^ Tast.string_of_constraint c ^ " -> (" ^ Tast.string_of_tyvar t2 ^ ", " ^ Tast.string_of_tycon t1 ^ ")") in 
    [(t2, TYCON t1)] 
  | (TYCON t1, TYCON t2) -> 
    let () = print_endline (":=SOLVE=: (TYCON t1, TYCON t2) = " ^ Tast.string_of_constraint c ^ " -> (if (" ^ Tast.string_of_tycon t1 ^ " = " ^ Tast.string_of_tycon t2 ^ ") then [] else \"type error: type constructor mismatch " ^ string_of_tycon t1 ^ " != " ^ string_of_tycon t2 ^ "\"") in
    if t1 = t2 then []
    else raise (Type_error ("type error: type constructor mismatch " ^ string_of_tycon t1 ^ " != " ^ string_of_tycon t2))
  | (TYCON t1, CONAPP t2) -> raise (Type_error ("type error: type constructor mismatch " ^ string_of_tycon t1 ^ " != " ^ string_of_conapp t2))
  | (CONAPP t1, TYVAR t2) -> let () = print_endline "HERE8" in solve' (TYVAR t2, CONAPP t1)
  | (CONAPP t1, TYCON t2) -> raise (Type_error ("type error: type constructor mismatch " ^ string_of_conapp t1 ^ " != " ^ string_of_tycon t2))
  | (CONAPP t1, CONAPP t2) -> 
    match t1, t2 with 
    | ((TArrow t1, tys1), (TArrow t2, tys2)) ->
      let () = print_endline (":=SOLVE=: (CONAPP t1, CONAPP t2) = " ^ Tast.string_of_constraint c ^ " -> solve [" ^ String.concat ", " (List.map (string_of_ttype) tys1) ^ "] U [" ^ String.concat ", " (List.map string_of_ttype tys2) ^ "] @ [" ^ string_of_ttype t1 ^ ", " ^ string_of_ttype t2 ^ "]") in
      solve ((t1, t2) :: (List.combine tys1 tys2))
    | _ -> raise (Type_error ("type error: type constructor mismatch " ^ string_of_conapp t1 ^ " != " ^ string_of_conapp t2))



(* solve - solves a list of constraints, calls 'solver' to iterate through the
           constraint list, once constraint list has been iterated 'compose' is
           called to tie 'theta1' and 'theta2' together, returns theta *)
and solve (constraints : (gtype * gtype) list) =
  let solver cns  =
    match cns with
    | [] -> []
    | cn :: cns ->  
      let theta1 = solve' cn in
      let () = print_endline (":=SOLVE=: current cn: " ^ Tast.string_of_constraint cn) in
      let () = print_endline (":=SOLVE=: theta1: " ^ string_of_subs theta1) in
      let theta2 = solve (sub theta1 cns) in
      (compose theta2 theta1) @ theta2
  in solver constraints 


(* generate_constraints gctx e: 
    infers the type of expression 'e' and a generates a set of constraints,
    'gctx' refers to the global context 'e' can refer to.

  Type References:
       ctx : (ident * tyscheme) list == (ident * (tyvar list * gtype)) list
  tyscheme : (tyvar list * gtype)
   returns : gtype * (gtype * gtype) list * (gtype * tx) *)
let rec generate_constraints gctx e =
  let rec constrain ctx e =
    match e with
    | Literal e -> value e
    | Var name -> 
      (* DEBUG *)
      let () = print_endline (":=GENCONS=: (var) name: " ^ name) in 
      let (_, (_, tau)) = List.find (fun x -> fst x = name) ctx in
      (* DEBUG *)
      let () = print_endline (":=GENCONS=: (var) tau: " ^ string_of_ttype tau) in
      (tau, [], (tau, (TypedVar name)))
    | If (e1, e2, e3) -> 
      let (t1, c1, tex1) = generate_constraints gctx e1 in (* TODO - change 'gctx' to 'ctx'? *)
      let (t2, c2, tex2) = generate_constraints gctx e2 in (* TODO - change 'gctx' to 'ctx'? *)
      let (t3, c3, tex3) = generate_constraints gctx e3 in (* TODO - change 'gctx' to 'ctx'? *)
      let c = [(TYCON TBool, t1); (t3, t2)] @ c1 @ c2 @ c3 in
      let tex = TypedIf(tex1, tex2, tex3) in
      (t3, c, (t3, tex))
    | Apply (f, args) ->
      let t1, c1, tex1 = generate_constraints ctx f in
      (* DEBUG *)
      let () = print_endline(":=GENCONS=: (apply) t1: " ^ string_of_ttype t1) in
      let () = print_endline(":=GENCONS=: (apply) c1: " ^ string_of_constraints c1) in
      let () = print_endline(":=GENCONS=: (apply) tex1: " ^ string_of_texpr tex1) in
      let ts2, c2, texs2 = List.fold_left (fun acc e -> 
        let t, c, x = generate_constraints ctx e in 
        let ts, cs, xs = acc in (t::ts, c @ cs, x::xs)) 
      ([], c1, []) (List.rev args) in   (* reverse args to maintain arg order *)
      let retType = (fresh ()) in
      (* DEBUG *)
      let () = print_endline(":=GENCONS=: (apply) ts2: [(" ^ String.concat "), (" (List.map string_of_ttype ts2) ^ ")]") in
      let () = print_endline(":=GENCONS=: (apply) c2: " ^ string_of_constraints c2) in
      let () = print_endline(":=GENCONS=: (apply) texs2: [(" ^ String.concat "), (" (List.map string_of_texpr texs2) ^ ")]") in
      let () = print_endline (":=GENCONS=: (apply) retType: " ^ string_of_ttype retType) in
      (retType, 
        (t1, Tast.functiontype retType ts2) :: c2, 
        (retType, TypedApply(tex1, texs2)))
    | Let (bindings, expr) ->
      let l = List.map (fun (n, e) -> generate_constraints ctx e) bindings in
      let cns = List.concat (List.map (fun (_, c, _) -> c) l) in
      let taus = List.map (fun (t,_, _) -> t) l in
      let asts = List.map (fun (_, _, a) -> a) l in
      let names = List.map fst bindings in
      let ctx_addition = List.map (fun (n, t) -> 
        (n, ([], t))) (List.combine names taus) in
      let new_ctx = ctx_addition @ ctx in
      let (b_tau, b_cns, b_tast) = generate_constraints new_ctx expr in
      (b_tau, b_cns @ cns, (b_tau, TypedLet((List.combine names asts), b_tast)))
    | Lambda (formals, body) -> 
      (* check for nested lambdas - if nested lambda throw type error *)
      let is_nested_lambda = function
      | Lambda _ -> true 
      | _ -> false in
      if is_nested_lambda body then raise (Type_error "type error: nested lambda")
      else
      (* if not nested lambda, then continue generating constraints *)
      let binding = List.map (fun x -> (x, ([], fresh ()))) formals in
      let new_context = binding @ ctx in
      let (t, c, tex) = generate_constraints new_context body in
      (* DEBUG *)
      let () = print_endline (":=GENCONS=: (lambda)   t: " ^ string_of_ttype t) in
      let () = print_endline (":=GENCONS=: (lambda)   c: " ^ string_of_constraints c) in
      let () = print_endline (":=GENCONS=: (lambda) tex: " ^ string_of_texpr tex) in
      let (ids, tyschms) = List.split binding in
      let () = print_endline(":=GENCONS=: (lambda) tychms: " ^ String.concat ", " (List.map string_of_tyscheme tyschms)) in
      let (tvs, formaltys) = List.split tyschms in
      (* let formaltys = snd (List.split (snd (List.split binding))) in  *)
      let () = print_endline (":=GENCONS=: (lambda) tvs: " ^ String.concat ", " (List.map string_of_tyvar (List.flatten tvs))) in
      let typedFormals = List.combine formaltys formals in
      let () = print_endline (":=GENCONS=: (lambda) typedFormals: " ^ String.concat ", " (List.map string_of_tyformals typedFormals)) in
      ((Tast.functiontype t formaltys), c,                                 (* TODO - why? *)
      (* (CONAPP (TArrow t, formaltys), c,                                 TODO - WHY? *)
        (Tast.functiontype t formaltys, TypedLambda (typedFormals, tex)))
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


(* let subst (theta : (tyvar * gtype) list) (t : gtype) (ftvs: tyvar list) =
  match t with
  | TYVAR t -> List.find (fun (x : tyvar * gtype) -> x = (t, TYVAR t)) theta
  | TYCON c -> (TYCON c, t)
  | CONAPP a -> (CONAPP a, t) *)

(* let rec tysubst (one_sub: (tyvar * gtype)) (t : gtype) =
  match one_sub, t with
  | (x, y), (TYVAR z)  -> if x = z then y else (TYVAR z)
  | (x, y), (TYCON c)  -> 
    (match c with 
    | TArrow retty -> TYCON (TArrow (tysubst one_sub retty))
    | _ -> (TYCON c))
  | (x, y), (CONAPP (a, bs)) -> CONAPP (((fun (TYCON x) -> x)
    (tysubst one_sub (TYCON a))), ((List.map (tysubst one_sub)) bs)) *)

let rec tysubst (one_sub: (tyvar * gtype)) (t : gtype) =
  match one_sub, t with
  | (x, y), (TYVAR z)  -> if x = z then y else (TYVAR z)
  | (x, y), (TYCON c)  -> 
    (match c with 
    | TArrow retty -> TYCON (TArrow (tysubst one_sub retty))
    | _ -> (TYCON c))
  | (x, y), (CONAPP (a, bs)) -> CONAPP (((fun (TYCON x) -> x)
    (tysubst one_sub (TYCON a))), ((List.map (tysubst one_sub)) bs))

(* get_constraints - returns a list of Tasts
        Tast : [ (ident * (gtype * tx)) ] = [ (ident * texpr) | texpr ] = [ tdefns ]
    tyscheme : (tyvar list * gtype) *)
let rec get_constraints (ctx : (ident * tyscheme) list ) (d : defn) =
  match d with
  | Val (name, e) -> 
    (* let ctx' = update_ctx ctx d in *)
    let (t, c, tex) = generate_constraints ctx e in
    (t, c, (TVal (name, tex)))
  | Expr e ->
    let (t, c, tex) = generate_constraints ctx e in 
    (t, c, TExpr tex)

(*  input: (tyvar * gtype) list *)
(* return: tdefn -> tdefn *)
let apply_subs (sub : (tyvar * gtype) list) =
  let () = print_endline (":=APPLYSUBS=: " ^ string_of_subs sub) in
match sub with
| [] -> (fun x -> x)
| xs ->
  let final_ans =
    (fun tdef -> 
      (* xs - the list of substitutions we want to apply *)
      (* tdef - the tdefn we want to apply the substitutions to *)
      let rec expr_only_case (x : texpr) =
        List.fold_left 
        (* anon fun - takes one texpr and takes one substitution and subs substitution into the texpr *)
        (fun (tast_gt, tast_tx) (tv, gt) -> 
          let () = print_endline (":=APPLYSUBS_ANON=:   sub: " ^ string_of_subs [(tv, gt)]) in
          (* let () = print_endline (":=APPLYSUBS_ANON=: texpr:" ^ string_of_texpr (tast_gt, tast_tx)) in *)
          (* updated_tast_tx - matches texpr with tx and recurses on expressions *)
          let updated_tast_tx = match tast_tx with
            | TypedIf (x, y, z) -> 
                TypedIf (expr_only_case x, expr_only_case y, expr_only_case z)
            | TypedApply (x, xs) -> 
                let txs = List.map expr_only_case xs in
                TypedApply (expr_only_case x, txs)
            | TypedLet ((its), x) -> TypedLet (List.map (fun (x, y) -> 
                (x, expr_only_case y)) its, expr_only_case x)
            | TypedLambda (tyformals, body) -> 
                TypedLambda ((List.map (fun (x, y) -> (tysubst (tv, gt) x, y))
                tyformals), expr_only_case body)
            | TLiteral x -> TLiteral x
            | TypedVar x -> TypedVar x
          in
          let temp = (tysubst (tv, gt) tast_gt, updated_tast_tx) in
        let () = print_endline (":=APPLYSUBS_ANON=: texpr " ^ string_of_texpr temp) in temp) x xs in
      match tdef with 
      | TVal (name, x) -> TVal (name, (expr_only_case x))
        (* Do we need to do anything with updating context here? *)
      | TExpr x -> TExpr (expr_only_case x)
    )
  in final_ans

let update_ctx ctx tydefn =
match tydefn with
| TVal (name, (gt, tx)) -> 
  let () = print_endline (":=UPDATECTX=: (tval) id: " ^ name ^ " gt: " ^ string_of_ttype gt ^ " tx: " ^ string_of_tx tx) in
  (name, (List.filter (fun x -> List.exists (fun y -> y = x) (ftvs gt)) (ftvs gt), gt))::ctx
| TExpr (x, tx) -> 
  (* DEBUG *)
  let () = print_endline (":=UPDATECTX=: (texpr) x: " ^ String.concat ", " (List.map string_of_tyvar (ftvs x))) in
  ctx
  (* (tx, (List.filter (fun x -> List.exists (fun y -> y = x) (ftvs x)) (ftvs x), x))::ctx *)


(* type_infer
      input : ( ident | ident * expr ) list
    returns : ( ident * (gtype * tx) ) list *)
let type_infer (ds : defn list) = 
let rec infer_defns ctx defn = match defn with
| [] -> []
| d :: ds -> 
  (* get the constraints for the defn *)
  let (t, c, tex) = (get_constraints ctx d) in
  (* constraints -> gtype list *)
  let constraints = c in
  (* DEBUG *)
  let () = print_endline(":=INFER=: cons: " ^ (string_of_constraints constraints)) in 
  (* tasts -> tdefn list *)
  let tdefn = tex in
  (* DEBUG *)
  let () = print_endline(":=INFER=: tdefn: " ^ (string_of_tdefn tdefn)) in 
  (* subs -> (Infer.tyvar * Infer.gtype) list *)
  let subs = solve constraints in
  (* DEBUG *)
  let () = print_endline(":=INFER=: subs: " ^ (string_of_subs subs)) in
  (* apply subs to tdefns *)
  let tdefns = ((apply_subs subs) tdefn) in 
  let () = print_endline (":=INFER=: ctx: " ^ string_of_context ctx ^ "\n") in
  (* update ctx *)
  let ctx' = update_ctx ctx tdefns in
  (* DEBUG *)
  let () = print_endline (":=INFER=: ctx': " ^ string_of_context ctx') in
  (* recurse *)
  (tdefns :: infer_defns ctx' ds) in 
infer_defns prims ds

  (* (t, c, (TVal (name, tex))) *)
(* type_infer_file
      input : ( ident | ident * expr ) list
    returns : ( ident * (gtype * tx) ) list *)

  

