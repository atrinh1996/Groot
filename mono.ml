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
      TInt        -> MIntty
    | TBool       -> MBoolty
    | TChar       -> MCharty
    | TArrow rety -> MTarrow (ofGtype rety)
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


  (* Given a function type, returns a list of arg tys *)
  let find_arg_tys (ty : mtype) = match ty with 
      Mconapp (MTarrow _, args) -> args
    | _ -> raise (Failure "Non function type")
  in 

  (* Takes a name and an polyty_env, and inserts it into the map *)
  let set_aside (id : mname) ((ty, exp) : mexpr) (gamma : polyty_env) = 
    (* let tylist = find_arg_tys ty in  *)
    (* StringMap.add id ((ty, exp), tylist) gamma *)
    StringMap.add id (ty, exp) gamma
  in


  (* Returns trye if ty is a type variable *)
  let isTyvar (ty : mtype) = match ty with 
      Mtycon _  -> false 
    | Mtyvar _  -> true
    | Mconapp _ -> false
  in 

  (* given an expression thats a function type, applies the types in the 
     given mtype list to all the tyvariables  in order to turn the 
     polymorphic expression into a monomorphic one. 
     Returns the monomorphized mexpr and the prog with any added instructions *)
  let rec resolve_poly (gamma : polyty_env) (prog : mprog) (tys : mtype list) ((fty, exp) : mexpr) = 
    let argsType = find_arg_tys fty in 
    let substitutions = List.combine argsType tys in
    (* Takes a substitution of arg ~ sub, and substitutes all occurrances
       of arg with sub in the type, IF arg is a type variable *)
    let apply_sub_ty (typ : mtype) ((arg, sub) : mtype * mtype) = 
      if isTyvar arg 
        then 
          let tyvarID = (match arg with 
                          Mtyvar i -> i 
                        | _ -> raise (Failure "Mono: non-tyvar substitution")) 
          in 
          let typ' = 
            let rec search_mtype = function 
                Mtycon tyc -> Mtycon (search_tycon tyc)
              | Mtyvar i   -> if i = tyvarID then sub else Mtyvar i
              | Mconapp con -> Mconapp (search_con con)
            and search_tycon = function 
                MIntty  -> MIntty
              | MCharty -> MCharty
              | MBoolty -> MBoolty
              | MTarrow retty -> MTarrow (search_mtype retty)
            and search_con (tyc, mtys) = (search_tycon tyc, List.map search_mtype mtys)
            in search_mtype typ
          in typ'
        else typ
    in 
    (* Monomorphized function type *)
    let fty' = List.fold_left apply_sub_ty fty substitutions in 

    (* substitutes any tyvars in the mx sub-expression types, and returns
       the monomorphized mx and the program *)
    let rec apply_sub_expr ((ex, prog) : mx * mprog) = 
      (match ex with 
        MLiteral l -> (MLiteral l, prog)
      | MVar     v -> 
          (try 
              (* Inject a new lambda expression into the program*)
              let (_, newExpr) = lookup v gamma in 
              let (newExpr', prog1)  = apply_sub_expr (newExpr, prog) in 
              let lambdaDef = MVal (secret ^ v, (fty', newExpr')) in 
              let prog2 = lambdaDef :: prog1 in 
              (MVar (secret ^ v), prog2)
          with Not_found -> (MVar v, prog))
      | MIf      _ -> raise (Failure "TODO: Mono - ")
      | MApply (f, args) -> raise (Failure "TODO: Mono - ")
      | MLet     _ -> raise (Failure "TODO: Mono - ")
      | MLambda  (formals, body) -> 
          (* raise (Failure "TODO: Mono - ") *)
          let (formaltys, names) = List.split formals in 
          let monoFormalTys = 
            List.map (fun fmty -> List.fold_left apply_sub_ty fmty substitutions) formaltys
          in 
          let formals' = List.combine monoFormalTys names in 
          let bodyTy = List.fold_left apply_sub_ty (fst body) substitutions in 
          let (bodyExp, prog2) = apply_sub_expr (snd body, prog) in 
          let body' = (bodyTy, bodyExp) in 
          (MLambda (formals', body'), prog2)

      ) 
    in 
    (* (mx * mprog) *)
    let (exp', prog') = apply_sub_expr (exp, prog) in 
    ((fty', exp'), prog')

  in 


  (* Takes a texpr and returns the equivalent mexpr and the prog (list of mdefns) *)
  let rec expr (gamma : polyty_env) (prog : mprog) ((ty, ex) : texpr) = match ex with 
    | TLiteral l -> ((ofGtype ty, MLiteral (value l)), prog)
    | TypedVar v -> ((ofGtype ty, MVar v), prog)
        (* let vartyp = (try lookup v gamma with Not_found -> ofGtype ty) in  *)
    | TypedIf  (t1, t2, t3) -> 
        let (mexp1, _) = expr gamma prog t1 
        and (mexp2, _) = expr gamma prog t2
        and (mexp3, _) = expr gamma prog t3 in 
        ((fst mexp2, MIf (mexp1, mexp2, mexp3)), prog)
    | TypedApply (f, args) -> 
        (* raise (Failure "TODO: Mono - ") *)
        (* 1. Get the (ty, mx) of f *)
        let ((fty, f'), _) = expr gamma prog f in 
        let (args', _) = List.split (List.map (expr gamma prog) args) in 

        (* 2. Check if it is polymorphic,  *)
        if isPolymorphic fty 
          (* 2b. If it is poly,  *)
          then 
              (* 3a. make a tys list from the args list *)
              let (tys, _) = List.split args' in 
              (* let ((fty', f''), prog') =  *)
              resolve_poly gamma prog tys (fty, f')  
              (* in raise (Failure "TODO: Mono - ") *)

          (* 2a. If not poly, proceed *)
          else ((ofGtype ty, MApply ((fty, f'), args')), prog)

    | TypedLet (bs, body) -> raise (Failure "TODO: Mono - ")
    | TypedLambda (formals, body) -> raise (Failure "TODO: Mono - ")
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
        (* raise (Failure "TODO: Mono - Val") *)
        (* 1. Using the TEXPR, get the MEXPR *)
        let ((mty, mexp), prog') = expr gamma prog (ty, texp) in 

        (* 2. Check it is is Polymorphic *)
        if isPolymorphic mty 

          (* 2a. if yes, set_aside *)
          then 
            let gamma' = set_aside id (mty, mexp) gamma in 
            (gamma', prog)

          (* 2b. if not, add to the prog, return the prog *)
          else (gamma, MVal (id, (mty, mexp)) :: prog')

    | TExpr (ty, texp) -> 
        (* raise (Failure "TODO: Mono - Expr") *)
        (* 1. Using the TEXPR, get the MEXPR *)
        let ((mty, mexp), prog') = expr gamma prog (ty, texp) in 
        (* 2. Check it is is Polymorphic *)
        if isPolymorphic mty
          (* 2a. if yes, toss it *)
          then (gamma, prog')
          (* 2b. if not, add to the prog, return the prog *)
          else (gamma, MExpr (mty, mexp) :: prog')
  in 

  let (_, program) = List.fold_left mono (StringMap.empty, []) tdefns 
  in List.rev program