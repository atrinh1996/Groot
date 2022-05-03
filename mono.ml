(* Monopmorphizes a typed (incl poly) program *)

open Tast
open Mast

(* Update name to ensure all mono-typed expressions are unique from their
   siblings. *)
let secret = "_typed_"
let count = ref 0


(* Function takes a tprog (list of typed definitions),
   and monomorphizes it. to produce a mprog *)
let monomorphize (tdefns : tprog) =

  (* Takes a Tast.gtype and returns the equivalent Mast.mtype *)
  let rec ofGtype = function
      TYCON ty    -> Mtycon  (ofTycon ty)
    | TYVAR tp    -> Mtyvar   (ofTyvar tp)
    | CONAPP con  -> Mconapp (ofConapp con)
  and ofTycon = function
      TyInt        -> MIntty
    | TyBool       -> MBoolty
    | TyChar       -> MCharty
    | TArrow rety  -> MTarrow (ofGtype rety)
  and ofTyvar = function
      TVariable n -> n
  and ofConapp (tyc, tys) = (ofTycon tyc, List.map ofGtype tys)
  in




  (* Takes an mtype, and returns true if it is polymorphic, false o.w. *)
  let rec isPolymorphic (typ : mtype) = match typ with
    | Mtycon  t -> poly_tycon t
    | Mtyvar  _ -> true
    | Mconapp c -> poly_conapp c
  and poly_tycon = function
      MIntty | MBoolty | MCharty -> false
    | MTarrow t -> isPolymorphic t
  and poly_conapp (tyc, mtys) =
    (poly_tycon tyc)
    || (List.fold_left (fun init mtyp -> init || (isPolymorphic mtyp))
          false mtys)
  in



  (* Takes a type environment and a string key "id". Returns the
       value (mtype) that the key mapts to. *)
  let lookup (id : mname) (gamma : polyty_env) =
    StringMap.find id gamma
  in


  (* Takes a name and an polyty_env, and inserts it into the map *)
  let set_aside (id : mname) ((ty, exp) : mexpr) (gamma : polyty_env) =
    StringMap.add id (ty, exp) gamma
  in


  (* Returns true if ty is a type variable *)
  let isTyvar (ty : mtype) = match ty with
      Mtycon _  -> false
    | Mtyvar _  -> true
    | Mconapp _ -> false
  in

  (* Returns true if ty is a function type *)
  let isFunctionType (ty : mtype) = match ty with
      Mconapp (MTarrow _, _)  -> true
    | _                       -> false
  in


  (* (fty, exp) == poly lambda expression
     (ty) == mono function type *)
  let resolve (prog : mprog) (id : mname) (ty : mtype) ((fty, exp) : mexpr) =
    (* Given a function type, returns the list of the types of the arguments *)
    let get_type_of_args = function
        Mconapp (MTarrow _, formaltys) -> formaltys
      | _ -> Diagnostic.error (Diagnostic.MonoError "cannot monomorphize non-function type")
    in

    let formaltys     = get_type_of_args ty  in (* mono *)
    let polyargtys    = get_type_of_args fty in (* poly *)
    let substitutions = List.combine polyargtys formaltys in

    (* Given a (polymorphic) mtype, returns the monomorphic version *)
    let resolve_mty (mty : mtype) =
      let apply_subs typ (arg, sub) =
        if isTyvar arg
        then
          let tyvarID =
            (match arg with
               Mtyvar i -> i
             | _ -> Diagnostic.error (Diagnostic.MonoError "non-tyvar substitution"))
          in
          let rec search_mtype = function
              Mtycon tyc -> Mtycon (search_tycon tyc)
            | Mtyvar i   -> if i = tyvarID then sub else Mtyvar i
            | Mconapp con -> Mconapp (search_con con)
          and search_tycon = function
              MIntty  -> MIntty
            | MCharty -> MCharty
            | MBoolty -> MBoolty
            | MTarrow retty -> MTarrow (search_mtype retty)
          and search_con (tyc, mtys) =
            (search_tycon tyc, List.map search_mtype mtys)
          in search_mtype typ
        else typ
      in List.fold_left apply_subs mty substitutions
    in

    (* Given an (polymorphic) mx, returns the monomorphic version, with an
       updated program, if any. *)
    let rec resolve_mx pro = function
        MLiteral l -> (MLiteral l, pro)
      | MVar     v -> (MVar v, pro)
      | MIf ((t1, e1), (t2, e2), (t3, e3)) ->
        let t1' = resolve_mty t1 in
        let t2' = resolve_mty t2 in
        let t3' = resolve_mty t3 in
        let (e1', pro1) = resolve_mx pro  e1 in
        let (e2', pro2) = resolve_mx pro1 e2 in
        let (e3', pro3) = resolve_mx pro2 e3 in
        (MIf ((t1', e1'), (t2', e2'), (t3', e3')), pro3)
      | MApply ((appty, app), args) ->
        let appty' = resolve_mty appty in
        let (app', pro') = resolve_mx pro app in

        let (argtys, argexps) = List.split args in
        let argtys' = List.map resolve_mty argtys in
        let (argexps', _) = List.split (List.map (resolve_mx pro) argexps) in
        let args' = List.combine argtys' argexps' in

        (MApply ((appty', app'), args'), pro)

      | MLet (bs, body) -> Diagnostic.error (Diagnostic.MonoError "typed let")

      | MLambda  (formals, (bodyty, bodyexp)) ->
        let (formaltys, names) = List.split formals in
        let formaltys' = List.map resolve_mty formaltys in
        let formals' = List.combine formaltys' names in

        let bodyty' = resolve_mty bodyty in
        let (bodyexp', pro') = resolve_mx pro bodyexp in
        let body' = (bodyty', bodyexp') in

        let lambdaExp = MLambda (formals', body') in
        let pro'' = (MVal (id, (ty, lambdaExp))) :: pro' in
        (lambdaExp, pro'')
    in

    let (exp', prog') = resolve_mx prog exp in
    ((ty, exp'), prog')

  in




  (* Takes a texpr and returns the equivalent mexpr 
     and the prog (list of mdefns) *)
  let rec expr (gamma : polyty_env) (prog : mprog) ((ty, ex) : texpr) = 
    match ex with
      TLiteral l -> ((ofGtype ty, MLiteral (value l)), prog)
    | TypedVar v ->
        let vartyp = (try fst (lookup v gamma)
                      with Not_found -> ofGtype ty) in
        let actualtyp = ofGtype ty in
        if (isPolymorphic vartyp) && (isFunctionType vartyp)
          then
            let polyexp = lookup v gamma in
            let (_, prog') = resolve prog v actualtyp polyexp in
            ((actualtyp, MVar v), prog')
        else ((actualtyp, MVar v), prog)
    | TypedIf  (t1, t2, t3) ->
        let (mexp1, _) = expr gamma prog t1
        and (mexp2, _) = expr gamma prog t2
        and (mexp3, _) = expr gamma prog t3 in
        ((fst mexp2, MIf (mexp1, mexp2, mexp3)), prog)
    | TypedApply (f, args) ->
        let (f', prog') = expr gamma prog f in
        let (args', prog'') =
          List.fold_left  (fun (arglst, pro) arg ->
              let (arg', pro') = expr gamma pro arg in
              (arg' :: arglst, pro'))
            ([], prog') args
        in
        let args' = List.rev args' in
        ((ofGtype ty, MApply (f', args')), prog'')
    | TypedLet (bs, body) -> 
        let binding (x, e) =  let (e', _) = expr gamma prog e in (x, e') in 
        let bs' = List.map binding bs in 
        let (body', prog') = expr gamma prog body in 
        ((ofGtype ty, MLet (bs', body')), prog')
    | TypedLambda (formals, body) ->
        let (formaltys, names) = List.split formals in
        let formaltys' = List.map ofGtype formaltys in
        let formals'   = List.combine formaltys' names in
        let (body', prog') = expr gamma prog body in
        ((ofGtype ty, MLambda (formals', body')), prog')
  and value = function
    | TChar c -> MChar c
    | TInt  i -> MInt i
    | TBool b -> MBool b
    | TRoot t -> MRoot (tree t)
  and tree = function
    | TLeaf               -> MLeaf
    | TBranch (v, t1, t2) -> MBranch (value v, tree t1, tree t2)
  in


  (* Takes the current mprog built so far, and one tdefn, and adds
     the monomorphized version to the mprog. Returns a new mprog
     with the new definition added in.  *)
  let mono ((gamma, prog) : polyty_env * mprog) = function
      TVal (id, (ty, texp)) ->
        let ((mty, mexp), prog') = expr gamma prog (ty, texp) in
        if isPolymorphic mty
          then
            let gamma' = set_aside id (mty, mexp) gamma in
            (gamma', prog)
        else (gamma, MVal (id, (mty, mexp)) :: prog')
    | TExpr (ty, texp) ->
        let ((mty, mexp), prog') = expr gamma prog (ty, texp) in
        if isPolymorphic mty
          then (gamma, prog')
        else (gamma, MExpr (mty, mexp) :: prog')
  in

  let (_, program) = List.fold_left mono (StringMap.empty, []) tdefns
  in List.rev program