(* Closure conversion for groot compiler *)


open Sast
open Cast 


(***********************************************************************)

(* Pre-load rho with prints built in *)
let prerho env = 
  let add_prints map (k, v) =
    StringMap.add k [v] map
  in List.fold_left add_prints env [("printi", (0, intty)); 
                                    ("printb", (0, boolty)); 
                                    ("printc", (0, charty)); ]

(* partial cprog to return from this module *)
let res = 
{
  main        = emptyList; 
  functions   = emptyList; 
  rho         = prerho emptyEnv;
  structures  = emptyList
}

(* name used for anonymous lambda functions *)
let anon = "anon"
let count = ref 0

(* Converts a gtype to a ctype *)
let rec ofGtype = function
    TYCON ty    -> Tycon (ofTycon ty)
  | TYVAR tp    -> Tyvar (ofTyvar tp)
  | CONAPP con  -> Conapp (ofConapp con)
and ofTycon = function 
    TInt        -> Intty
  | TBool       -> Boolty
  | TChar       -> Charty
  | TArrow (retty, argsty) -> Tarrow (ofGtype retty, List.map ofGtype argsty)
and ofTyvar = function 
    TParam n -> Tparam n
and ofConapp (tyc, tys) = (ofTycon tyc, List.map ofGtype tys)


(* puts the given cdefn into the main list *)
let addMain d = res.main <- d :: res.main 

(* puts the given function name (id) mapping to its definition (f) in the 
   functions StringMap *)
let addFunction f = res.functions <- f :: res.functions 

let getFunction id = 
  List.find (fun frecord -> id = frecord.fname) res.functions

let addClosure elem = res.structures <- elem :: res.structures

(* Returns true if the given name id is already bound in the given 
   StringMap env. False otherwise *)
let isBound id env = StringMap.mem id env 

(* Adds a binding of k to v in the global StringMap env *)
let bind k v = res.rho <- 
  let currList = if isBound k res.rho then StringMap.find k res.rho else [] in
  let newList = v :: currList in 
  StringMap.add k newList res.rho

(* Returns the value id is bound to in the given StringMap env. If the 
   binding doesn't exist, Not_Found exception is raised. *)
let find id env = 
  let occursList = StringMap.find id env in List.nth occursList 0

(* Adds a local binding of k to v in the given StringMap env *)
let bindLocal map k (t, _) =
  let currList = if isBound k map then StringMap.find k map else [] in
  let localList = (0, ofGtype t) :: currList in 
  StringMap.add k localList map

(* Given expression an a string name n, returns true if n is 
   a free variable in the expression *)
let freeIn exp n = 
  let rec free (_, e) = match e with  
    | SLiteral _        -> false
    | SVar s            -> s = n
    | SIf (s1, s2, s3)  -> free s1 || free s2 || free s3
    | SApply (f, args)  -> free f  || List.fold_left 
                                        (fun a b -> a || free b) 
                                        false args
    | SLet (bs, body) -> List.fold_left (fun a (_, e) -> a || free e) false bs 
                         || (free body && not (List.fold_left 
                                                (fun a (x, _) -> a || x = n) 
                                                false bs))
    | SLambda (formals, body) -> 
        let (_, names) = List.split formals in 
        free body && not (List.fold_left (fun a x -> a || x = n) false names)
  in free (TYCON TInt, exp)


(* Given the formals list and body of a lambda (xs, e), and a 
   variable environment, the function returns an environment with only 
   the free variables of this lambda. *)
let improve (xs, e) rho = 
  StringMap.filter (fun n _ -> freeIn (SLambda (xs, e)) n) rho

(* removes any occurrance of things in no_no list from the env (StringMap)
   and returns the new StringMap *)
let clean no_no env =  
  StringMap.filter (fun n _ -> not (List.mem n no_no)) env

(* Given a var_env, returns a (ctype  * name) list version *)
let toParamList (venv : var_env) = 
  StringMap.fold  (fun id occursList res -> 
                      let (num, ty) = List.nth occursList 0 in 
                      let id' = if num = 0 then id 
                                else "_" ^ id ^ "_" ^ string_of_int num in 
                      (ty, id') :: res)
                  venv []

(* turns a list of ty * name list to a Var list  *)
let convertToVars (frees : (ctype * cname) list) = 
    List.map (fun (t, n) -> (t, CVar n)) frees 



(* Generate a new function type for lambda expressions in order to account
   for free variables, when given the original function type and an 
   association list of gtypes and var names to add to the new formals list
   of the function type. *)
let newFuntype  (origTyp : gtype) (newRet : ctype) 
                (toAdd : (ctype * cname) list) = 
  (match origTyp with 
    TYCON (TArrow (_, argstyp)) -> 
      let newFormalTys = List.map ofGtype argstyp in 
      let (newFreeTys, _) = List.split toAdd in 
      (* Tycon (Tarrow (newRet, newFormalTys @ newFreeTys)) *)
      funty (newRet, newFormalTys @ newFreeTys)
  | _ -> raise (Failure "Non-function function type"))



(* Converts given sexpr to cexpr, and returns the cexpr *)
let rec sexprToCexpr ((ty, e) : sexpr) (env : var_env) =
  let rec exp ((typ, ex) : sexpr) = match ex with
    | SLiteral v -> (ofGtype typ, CLiteral (value v))
    | SVar s     -> 
        (* In case s is a name of a define, get the closure type *)
        let (occurs, ctyp) = find s env in 
        (* to match the renaming convention in svalToCval, and to ignore
           built in prints *)
        let vname = if occurs = 0 
                      then s 
                    else "_" ^ s ^ "_" ^ string_of_int occurs
        in (ctyp, CVar (vname))
    | SIf (s1, s2, s3) -> 
        let cexp1 = exp s1 
        and cexp2 = exp s2
        and cexp3 = exp s3 in 
        (fst cexp2, CIf (cexp1, cexp2, cexp3))
    | SApply (f, args) -> 
        let (ctyp, f') = exp f in 
        let normalargs = List.map exp args in 
        (* actual type of the function application is the type of the return*)
        let (retty, freesCount) = 
          (match ctyp with 
              Tycon (Clo (_, functy, freetys)) -> 
                (match functy with 
                    Tycon (Tarrow (ret, _)) -> (ret, List.length freetys)
                  | _ -> raise (Failure "Non-function function type"))
            | _ -> (intty, 0)) in 
        (retty, CApply ((retty, f'), normalargs, freesCount))
    | SLet (bs, body) -> 
        let local_env = (List.fold_left (fun map (x, se) -> 
                                          bindLocal map x se) 
                                        env bs) in 
        let c_bs = List.map (fun (x, e) -> (x, exp e)) bs in 
        let (ctyp, body') = sexprToCexpr body local_env in 
        (ctyp, CLet (c_bs, (ctyp, body')))
    (* Supose we hit a lambda expression, turn it into a closure *)
    | SLambda (formals, body) -> create_anon_function formals body typ env
  and value = function 
    | SChar c             -> CChar c 
    | SInt  i             -> CInt  i 
    | SBool b             -> CBool b 
    | SRoot t             -> CRoot (tree t)
  and tree = function 
    | SLeaf               -> CLeaf 
    | SBranch (v, t1, t2) -> CBranch (value v, tree t1, tree t2)
  in exp (ty, e)
(* When given just a lambda expresion withot a user defined identity/name 
   this function will generate a name and give the function a body --
   Lambda lifting. *)
and create_anon_function  (fformals : (gtype * string) list) (fbody : sexpr) 
                          (ty : gtype) (env : var_env) = 
  (* All anonymous functions are named the same and numbered. *)
  let id = anon ^ string_of_int !count in 
  let () = count := !count + 1 in
  (* Create the record that represents the function body and definition *)
  let local_env = List.fold_left (fun map (typ, x) -> 
                                    bindLocal map x (typ, SVar x))
                                  env fformals in 
  let func_body = sexprToCexpr fbody local_env in 
  let f_def = 
    {
      body    = func_body;
      rettyp  = fst func_body;
      fname   = id; 
      formals = List.map (fun (ty, nm) -> (ofGtype ty, nm)) fformals;
      frees   = toParamList (improve (fformals, fbody) env);
    } 
  in 
  let () = addFunction f_def in 
  (* New function type will include the types of free arguments *)
  let anonFunTy = newFuntype ty f_def.rettyp f_def.frees in 
  (* Record the type of the anonymous function and its "rea" ftype *)
  let () = bind id (1, anonFunTy) in 
  (* The value of a Lambda expression is a Closure -- new type construction 
     will help create the structs in codegen that represents the closure *)
  let (freetys, _) = List.split f_def.frees in 
  let clo_ty = closurety (id ^ "_struct", anonFunTy, freetys) in 
  let () = addClosure clo_ty in 
  let freeVars = convertToVars f_def.frees in 
  (clo_ty, CLambda (id, freeVars))



(* Converts given SVal to CVal, and returns the CVal *)
let svalToCval (id, (ty, e)) = 
  (* check if id was already defined in rho, in order to get 
     the actual frequency the variable name was defined. 
     The (0, inttype is a placeholder) *)
  let (occurs, _) = if (isBound id res.rho) 
                      then (find id res.rho) 
                    else (0, intty) in
  (* Modify the name to account for the redefinitions, and so old closures 
     can access original variable values *)
  let id' = "_" ^ id ^ "_" ^ string_of_int (occurs + 1) in 
  let (ty', cexp) = sexprToCexpr (ty, e) res.rho in 
  (* bind original name to the number of occurrances and the variable's type *)
  let () = bind id (occurs + 1, ty') in 
  (* Return the possibly new CVal definition *)
  CVal (id', (ty', cexp))
(***********************************************************************)



(* Given an sprog (which is an sdefn list), convert returns a 
   cprog version. *)
let conversion sdefns =
  (* With a given sdefn, function converts it to the appropriate CAST type
     and sorts it to the appropriate list in a cprog type. *)
  let convert = function 
    | SVal (id, (ty, sexp)) -> 
        let cval = svalToCval (id, (ty, sexp)) in addMain cval
    | SExpr e -> 
        let cexp = sexprToCexpr e res.rho in addMain (CExpr cexp)
  in 
    
  let _ = List.iter convert sdefns in 
    {
      main       = List.rev res.main;
      functions  = res.functions;
      rho        = res.rho;
      structures = res.structures
    }
