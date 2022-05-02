open Ast
open Tast
module StringMap = Map.Make (String)

exception Type_error of string

(* prims - initializes context with built-in functions with their types *)
(* prims : (id * tyvar) list * (tycon * gtype list) *)
let prims =
  [
    ("printb", ([ TVariable (-1) ], Tast.functiontype inttype [ booltype ]));
    ("printi", ([ TVariable (-2) ], Tast.functiontype inttype [ inttype ]));
    ("printc", ([ TVariable (-3) ], Tast.functiontype inttype [ chartype ]));
    ("+", ([ TVariable (-4) ], Tast.functiontype inttype [ inttype; inttype ]));
    ("-", ([ TVariable (-4) ], Tast.functiontype inttype [ inttype; inttype ]));
    ("/", ([ TVariable (-4) ], Tast.functiontype inttype [ inttype; inttype ]));
    ("*", ([ TVariable (-4) ], Tast.functiontype inttype [ inttype; inttype ]));
    ("mod", ([ TVariable (-4) ], Tast.functiontype inttype [ inttype; inttype ]));
    ("<", ([ TVariable (-5) ], Tast.functiontype booltype [ inttype; inttype ]));
    (">", ([ TVariable (-5) ], Tast.functiontype booltype [ inttype; inttype ]));
    ("<=", ([ TVariable (-5) ], Tast.functiontype booltype [ inttype; inttype ]));
    (">=", ([ TVariable (-5) ], Tast.functiontype booltype [ inttype; inttype ]));
    ("=i", ([ TVariable (-5) ], Tast.functiontype booltype [ inttype; inttype ]));
    ( "!=i",
      ([ TVariable (-5) ], Tast.functiontype booltype [ inttype; inttype ]) );
    ( "&&",
      ([ TVariable (-6) ], Tast.functiontype booltype [ booltype; booltype ]) );
    ( "||",
      ([ TVariable (-6) ], Tast.functiontype booltype [ booltype; booltype ]) );
    ("not", ([ TVariable (-7) ], Tast.functiontype booltype [ booltype ]))
    (* ("-",      ([TVariable (-2)], Tast.functiontype inttype [inttype]))   *);
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
      List.fold_left (fun acc x -> is_ftv var x || acc) false gtlst

(* ftvs - returns a list of free type variables amongst a collection of gtypes *)
(* retty : tyvar list *)
let rec ftvs (ty : gtype) =
  match ty with
  | TYVAR t -> [ t ]
  | TYCON _ -> []
  | CONAPP (t, gtlst) -> List.fold_left (fun acc x -> acc @ ftvs x) [] gtlst

(* fresh - returns a fresh gtype variable (integer) *)
let fresh =
  let k = ref 0 in
  (* fun () -> incr k; TVariable !k *)
  fun () -> incr k; TYVAR (TVariable !k)


(* sub - updates a list of constraints with substitutions in theta *)
let sub (theta : (tyvar * gtype) list) (cns : (gtype * gtype) list) =
  (* sub_one - takes in single constraint and updates it with substitution in theta *)
  let sub_one (cn : gtype * gtype) =
    List.fold_left
      (fun ((c1, c2) : gtype * gtype) ((tv, gt) : tyvar * gtype) ->
        match (c1, c2) with
        | TYVAR t1, TYVAR t2 ->
            if tv = t1 then (gt, c2) else if tv = t2 then (c1, gt) else (c1, c2)
        | TYVAR t1, _ -> if tv = t1 then (gt, c2) else (c1, c2)
        | _, TYVAR t2 -> if tv = t2 then (c1, gt) else (c1, c2)
        | _, _ -> (c1, c2))
      cn theta
  in
  List.map sub_one cns

(* compose - applies the substitutions in theta1 to theta2 *)
let compose theta1 theta2 =
  (* sub_one - takes a single substitution in theta1 and applies it to theta2 *)
  let sub_one cn =
    List.fold_left
      (fun (acc : tyvar * gtype) (one_sub : tyvar * gtype) ->
        match (acc, one_sub) with
        | (a1, TYVAR a2), (s1, TYVAR s2) ->
            if s1 = a1 then (s1, TYVAR a2)
            else if s1 = a2 then (a1, TYVAR s2)
            else acc
        | (a1, a2), (s1, TYVAR s2) -> if a1 = s1 then (s1, a2) else acc
        | (a1, a2), (s1, s2) -> if a1 = s1 then (s1, s2) else acc)
      cn theta1
  in
  List.map sub_one theta2

(* solve': solves a single constraint 'c' *)
let rec solve' (c : gtype * gtype) =
  match c with
  | TYVAR t1, TYVAR t2 -> [ (t1, TYVAR t2) ]
  | TYVAR t1, TYCON t2 -> [ (t1, TYCON t2) ]
  | TYVAR t1, CONAPP t2 ->
      if is_ftv t1 (CONAPP t2) then
        raise
          (Type_error
             "type error: type variable is not free type in type constructor")
      else [ (t1, CONAPP t2) ]
  | TYCON t1, TYVAR t2 -> solve' (TYVAR t2, TYCON t1)
  | TYCON (TArrow (TYVAR t1)), TYCON t2 -> [ (t1, TYCON t2) ]
  | TYCON t1, TYCON (TArrow (TYVAR t2)) -> [ (t2, TYCON t1) ]
  | TYCON t1, TYCON t2 ->
      if t1 = t2 then []
      else
        raise
          (Type_error
             ("type error: type constructor mismatch " ^ string_of_tycon t1
            ^ " != " ^ string_of_tycon t2))
  | TYCON t1, CONAPP t2 ->
      raise
        (Type_error
           ("type error: type constructor mismatch " ^ string_of_tycon t1
          ^ " != " ^ string_of_conapp t2))
  | CONAPP t1, TYVAR t2 -> solve' (TYVAR t2, CONAPP t1)
  | CONAPP t1, TYCON t2 ->
      raise
        (Type_error
           ("type error: type constructor mismatch " ^ string_of_conapp t1
          ^ " != " ^ string_of_tycon t2))
  | CONAPP t1, CONAPP t2 -> (
      match (t1, t2) with
      | (TArrow t1, tys1), (TArrow t2, tys2) ->
          solve ((t1, t2) :: List.combine tys1 tys2)
      | _ ->
          raise
            (Type_error
               ("type error: type constructor mismatch " ^ string_of_conapp t1
              ^ " != " ^ string_of_conapp t2)))


(* solve - solves a list of constraints, calls 'solver' to iterate through the
           constraint list, once constraint list has been iterated 'compose' is
           called to tie 'theta1' and 'theta2' together, returns theta *)
and solve (constraints : (gtype * gtype) list) =
  let solver cns =
    match cns with
    | [] -> []
    | cn :: cns ->  
        let theta1 = solve' cn in
        let theta2 = solve (sub theta1 cns) in
        (compose theta2 theta1) @ theta2
  in solver constraints 


(* generate_constraints gctx e:
     infers the type of expression 'e' and a generates a set of constraints,
     'gctx' refers to the global context 'e' can refer to.

   Type References:
        ctx : (ident * tyscheme) list == (ident * (tyvar list * gtype)) list
   tyscheme : (tyvar list * gtype)
      retty : gtype * (gtype * gtype) list * (gtype * tx) *)
let rec generate_constraints gctx e =
  let rec constrain ctx e =
    match e with
    | Literal e -> value e
    | Var name ->
        let _, (_, tau) = List.find (fun x -> fst x = name) ctx in
        (tau, [], (tau, TypedVar name))
    | If (e1, e2, e3) ->
        let t1, c1, tex1 = generate_constraints gctx e1 in
        let t2, c2, tex2 = generate_constraints gctx e2 in
        let t3, c3, tex3 = generate_constraints gctx e3 in
        let c = [ (booltype, t1); (t3, t2) ] @ c1 @ c2 @ c3 in
        let tex = TypedIf (tex1, tex2, tex3) in
        (t3, c, (t3, tex))
    | Apply (f, args) ->
        let t1, c1, tex1 = generate_constraints ctx f in
        let ts2, c2, texs2 =
          List.fold_left
            (fun acc e ->
              let t, c, x = generate_constraints ctx e in
              let ts, cs, xs = acc in
              (t :: ts, c @ cs, x :: xs))
            ([], c1, []) (List.rev args)
        in
        (* reverse args to maintain arg order *)
        let retType = fresh () in
        ( retType,
          (t1, Tast.functiontype retType ts2) :: c2,
          (retType, TypedApply (tex1, texs2)) )
    | Let (bindings, expr) ->
        let l = List.map (fun (n, e) -> generate_constraints ctx e) bindings in
        let cns = List.concat (List.map (fun (_, c, _) -> c) l) in
        let taus = List.map (fun (t, _, _) -> t) l in
        let asts = List.map (fun (_, _, a) -> a) l in
        let names = List.map fst bindings in
        let ctx_addition =
          List.map (fun (n, t) -> (n, ([], t))) (List.combine names taus)
        in
        let new_ctx = ctx_addition @ ctx in
        let b_tau, b_cns, b_tast = generate_constraints new_ctx expr in
        (b_tau, b_cns @ cns, (b_tau, TypedLet (List.combine names asts, b_tast)))
    | Lambda (formals, body) ->
        let binding = List.map (fun x -> (x, ([], fresh ()))) formals in
        let new_context = binding @ ctx in
        let t, c, tex = generate_constraints new_context body in
        let ids, tyschms = List.split binding in
        let tvs, formaltys = List.split tyschms in
        let typedFormals = List.combine formaltys formals in
        ( Tast.functiontype t formaltys,
          c,
          (Tast.functiontype t formaltys, TypedLambda (typedFormals, tex)) )
  and value v =
    match v with
    | Int  e -> (inttype, [],  (inttype,  TLiteral (TInt e)))
    | Char e -> (chartype, [], (chartype, TLiteral (TChar e)))
    | Bool e -> (booltype, [], (booltype, TLiteral (TBool e)))
    | Root t -> tree t
  and tree t =
    match t with
    | Leaf -> raise (Failure "Infer TODO: generate constraints for Leaf")
    | Branch _ -> raise (Failure "Infer TODO: generate constraints for Branch")
  in
  constrain gctx e


(* gimme_tycon_gtype - sort of a hack function that we made to solve the bug we
   came across in applying substitutions, called in tysubst *)
let gimme_tycon_gtype gt = function
  | TYCON c -> c
  | TYVAR t -> 
    raise (Type_error ("the variable " ^ string_of_tyvar t 
            ^ " has type tyvar but an expression was exprected of type tycon"))
  | CONAPP a -> 
      raise (Type_error ("the constructor " ^ string_of_conapp a 
            ^ " has type conapp but an expression was exprected of type tycon"))



(* tysubst - subs in the type in place of type variable  *)
let rec tysubst (one_sub : tyvar * gtype) (t : gtype) =
  match (one_sub, t) with
  | (x, y), TYVAR z -> if x = z then y else TYVAR z
  | (x, y), TYCON (TArrow retty) -> TYCON (TArrow (tysubst one_sub retty))
  | (x, y), TYCON c -> TYCON c
  | (x, y), CONAPP (a, bs) ->
      let tycn = gimme_tycon_gtype x in
      CONAPP (tycn (tysubst one_sub (TYCON a)), (List.map (tysubst one_sub)) bs)

(* get_constraints - returns a list of Tasts
        Tast : [ (ident * (gtype * tx)) ] = [ (ident * texpr) | texpr ] = [ tdefns ]
    tyscheme : (tyvar list * gtype) *)
let rec get_constraints (ctx : (ident * tyscheme) list) (d : defn) =
  match d with
  | Val (name, e) ->
      let t, c, tex = generate_constraints ctx e in
      (t, c, TVal (name, tex))
  | Expr e ->
    let (t, c, tex) = generate_constraints ctx e in 
    (t, c, TExpr tex)


(*  input: (tyvar * gtype) list *)
(*  retty: tdefn -> tdefn *)
let apply_subs (sub : (tyvar * gtype) list) =
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
          let temp = (tysubst (tv, gt) tast_gt, updated_tast_tx) in temp) x xs in
      match tdef with 
      | TVal (name, x) -> TVal (name, (expr_only_case x))
        (* Do we need to do anything with updating context here? *)
      | TExpr x -> TExpr (expr_only_case x)
    )
  in final_ans

(* update_ctx - if the typed definition is a TVal this function will make sure
   there are no unbound type variables and tha *)
let update_ctx ctx tydefn =
match tydefn with
| TVal (name, (gt, tx)) -> 
    (name, (List.filter (fun x -> List.exists (fun y -> y = x) (ftvs gt)) (ftvs gt), gt))::ctx
| TExpr (x, tx) -> ctx


(* type_infer
      input : ( ident | ident * expr ) list
    returns : ( ident * (gtype * tx) ) list *)

let type_infer (ds : defn list) =
  let rec infer_defns ctx defn =
    match defn with
    | [] -> []
    | d :: ds ->
        (* get the constraints for the defn *)
        let t, cs, tex = get_constraints ctx d in
        (* subs -> (Infer.tyvar * Infer.gtype) list *)
        let subs = solve cs in
        (* apply subs to tdefns *)
        let tdefn = (apply_subs subs) tex in
        (* update ctx *)
        let ctx' = update_ctx ctx tdefn in
        (* recurse *)
        tdefn :: infer_defns ctx' ds
  in
  infer_defns prims ds

(* type_infer
      input : ( ident | ident * expr ) list
    returns : ( ident * (gtype * tx) ) list *)
