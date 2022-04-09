(* Closure conversion for groot compiler *)

open Ast
open Sast
open Cast 


(***********************************************************************)
(* partial cprog to return from this module *)
let res = 
{
  main      = emptyList; 
  functions = emptyList; 
  rho       = emptyEnv;
  phi       = emptyList;
}


(* puts the given cdefn into the main list *)
let addMain d = res.main <- d :: res.main 

(* puts the given function name (id) mapping to its definition (f) in the 
   functions StringMap *)
let addFunction f = res.functions <- f :: res.functions 

let findFunction id = List.mem id res.phi
let bindFunction id = res.phi <- id :: res.phi 

(* Returns true if the given name id is already bound in the given 
   StringMap env. False otherwise *)
let isBound id env = StringMap.mem id env 

(* Adds a binding of k to v in the given StringMap env *)
let bind k v = res.rho <- StringMap.add k v res.rho 

(* Returns the value id is bound to in the given StringMap env. If the 
   binding doesn't exist, Not_Found exception is raised. *)
let find id env = StringMap.find id env 

(* Given expression an a string name n, returns true if n is 
   a free variable in the expression *)
let freeIn exp n = 
  let rec free (_, e) = match e with  
    | SLiteral _              -> false
    | SVar s                  -> s = n
    | SIf (s1, s2, s3)        -> free s1 || free s2 || free s3
    | SApply (fname, args)  -> fname = n || 
                               List.fold_left 
                                  (fun a b -> a || free b) 
                                  false args
    | SLet (bs, body) -> List.fold_left (fun a (_, e) -> a || free e) false bs 
                         || (free body && not (List.fold_left 
                                                (fun a (x, _) -> a || x = n) 
                                                false bs))
    | SLambda (formals, body) -> let (_, names) = List.split formals in 
        free body && not (List.fold_left (fun a x -> a || x = n) false names)
  in free (IType, exp)

(* Given the formals list and body of a lambda (xs, e), and a 
   variable environment, the function returns an environment with only 
   the free variables of this lambda. *)
let improve (xs, e) rho = 
  StringMap.filter (fun n _ -> freeIn (SLambda (xs, e)) n) rho

(* removes any occurrance of things in no_no list from the env (StringMap)
   and returns the new StringMap *)
let clean no_no env =  
  StringMap.filter (fun n _ -> not (List.mem n no_no)) env

(* Given a var_env, returns a (gtype  * name) list version *)
let toParamList venv = 
  StringMap.fold (fun id (num, ty) res -> (ty, id ^ string_of_int num) :: res) venv []

(* Converts given sexpr to cexpr, and returns the cexpr *)
let rec sexprToCexpr ((ty, e) : sexpr) (env : var_env) = 
  let rec exp ((typ, ex) : sexpr) = match ex with 
    | SLiteral v              -> (ty, CLiteral (value v))
    | SVar s                  -> 
        let occurs = (fst (find s env)) in 
        let vname = s ^ (if occurs = 0 then "" else string_of_int occurs)
        in (ty, CVar (vname))
    | SIf (s1, s2, s3)        -> (ty, CIf (exp s1, exp s2, exp s3))
    | SApply (fname, args)    -> 
        let call = try fname ^ string_of_int (fst (find fname env)) 
                   with Not_found -> fname in 
        (* let call = fname ^ string_of_int occurs in  *)
        (* let call = fname ^ (if occurs = 0 then "" else string_of_int occurs) in  *)
        (ty, CApply (call, List.map exp args))
    | SLet (bs, body) -> 
          (ty, CLet   (List.map (fun (x, e) -> (x, exp e)) bs, 
                       sexprToCexpr body (List.fold_left 
                                            (fun map (x, (t, _)) -> 
                                              StringMap.add x (0, t) map) 
                                            env bs)))
    | SLambda (formals, body) -> 
        (ty, CLambda (formals, 
                      sexprToCexpr body (List.fold_left 
                                          (fun map (t, x) -> 
                                              StringMap.add x (0, t) map) 
                                          env formals))) 
  and value = function 
    | SChar c                 -> CChar c 
    | SInt  i                 -> CInt  i 
    | SBool b                 -> CBool b 
    | SRoot t                 -> CRoot (tree t)
  and tree = function 
    | SLeaf                   -> CLeaf 
    | SBranch (v, t1, t2)     -> CBranch (value v, tree t1, tree t2)
  in exp (ty, e)

(* Converts given SVal to CVal, and returns the CVal *)
let svalToCval (id, (ty, e)) = 
  (* check if id was already defined in rho *)
  let (occurs, _) = 
    (* (0, IType) in  *)
    if (isBound id res.rho) then (find id res.rho) else (0, IType) in 
  let () = bind id (occurs + 1, ty) in 
  let id' = id ^ string_of_int (occurs + 1) in 
  let cval = 
  (match e with 
    | SLambda (fformals, fbody) -> 
        (* let () = bindFunction id in  *)
        let () = if (findFunction id) then () else bindFunction id in
        let f_def = 
          {
            rettyp = ty; 
            fname = id'; 
            formals = fformals;
            frees = toParamList 
                      (clean res.phi (improve (fformals, fbody) res.rho)); 
            body = sexprToCexpr fbody (List.fold_left 
                                        (fun map (typ, x) -> 
                                          StringMap.add x (0, typ) map)
                                        res.rho fformals);
          } 
        in 
        let () = addFunction f_def in  None 
    | _ ->  (* let (occurs, _) = if (isBound id res.rho) then (find id res.rho) 
                              else (0, IType) 
            in 
            let () = bind id (occurs + 1, ty) in *) 
            Some (CVal (id', sexprToCexpr (ty, e) res.rho))
  )
  in cval 
(***********************************************************************)



(* Given an sprog (which is an sdefn list), convert returns a 
   cprog version. *)
let conversion sdefns =

  (* With a given sdefn, function converts it to the appropriate CAST type
     and sorts it to the appropriate list in a cprog type. *)
  let convert = function 
    | SVal (id, (ty, sexp)) -> 
        let def = svalToCval (id, (ty, sexp)) in 
        (match def with 
            | Some cval -> addMain cval 
            | None      -> ())
    | SExpr e -> addMain (CExpr (sexprToCexpr e res.rho))
  in 
    
  let _ = List.iter convert sdefns in 

  {
    main      = List.rev res.main;
    functions = res.functions;
    rho       = res.rho;
    phi       = res.phi;
  }
