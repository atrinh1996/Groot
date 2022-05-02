(* Closure conversion for groot compiler *)


open Mast
open Cast 


(***********************************************************************)

(* Pre-load rho with prints built in *)
let prerho env = 
  let add_prints map (k, v) =
    StringMap.add k [v] map
  in List.fold_left add_prints env [("printi", (0, intty));   ("printb", (0, boolty)); 
                                    ("printc", (0, charty));  ("+", (0, intty));
                                    ("-", (0, intty));        ("*", (0, intty));
                                    ("/", (0, intty));        ("mod", (0, intty));
                                    ("<", (0, boolty));       (">", (0, boolty)); 
                                    ("<=", (0, boolty));      (">=", (0, boolty));
                                    ("!=i", (0, boolty));     ("=i", (0, boolty));
                                    ("&&", (0, boolty));      ("||", (0, boolty)); 
                                    ("not", (0, boolty));     ("~", (0, intty))     ]

(* list of variable names that get ignored/are not to be considered frees *)
let ignores = [ "printi"; "printb"; "printc"; 
                "+"; "-"; "*"; "/"; "mod"; "~";
                "<"; ">"; ">="; "<="; 
                "!=i"; "=i"; "&&"; "||"; "not" ]


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
let rec ofMtype = function
    Mtycon ty    -> Tycon (ofTycon ty)
  | Mtyvar _    -> raise (Failure "Closure: cannot close with a polymorphic type")
  | Mconapp con  -> Conapp (ofConapp con)
and ofTycon = function 
    MIntty        -> Intty
  | MBoolty       -> Boolty
  | MCharty       -> Charty
  | MTarrow retty -> Tarrow (ofMtype retty)
and ofConapp (tyc, tys) = (ofTycon tyc, List.map ofMtype tys)


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
  let localList = (0, ofMtype t) :: currList in 
  StringMap.add k localList map

(* Given expression an a string name n, returns true if n is 
   a free variable in the expression *)
let freeIn exp n = 
  let rec free (_, e) = match e with  
    | MLiteral _        -> false
    | MVar s            -> s = n
    | MIf (s1, s2, s3)  -> free s1 || free s2 || free s3
    | MApply (f, args)  -> free f  || List.fold_left 
                                        (fun a b -> a || free b) 
                                        false args
    | MLet (bs, body) -> List.fold_left (fun a (_, e) -> a || free e) false bs 
                         || (free body && not (List.fold_left 
                                                (fun a (x, _) -> a || x = n) 
                                                false bs))
    | MLambda (formals, body) -> 
        let (_, names) = List.split formals in 
        free body && not (List.fold_left (fun a x -> a || x = n) false names)
  in free (Mtycon MIntty, exp)


(* Given the formals list and body of a lambda (xs, e), and a 
   variable environment, the function returns an environment with only 
   the free variables of this lambda. The environment of frees shall
   not inculde the names of built-in functions and primitives *)
let improve (xs, e) rho = 
  StringMap.filter 
    (fun n _ -> 
        if List.mem n ignores
          then false
        else freeIn (MLambda (xs, e)) n) 
    rho

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
let newFuntype  (origTyp : mtype) (newRet : ctype) 
                (toAdd : (ctype * cname) list) = 
  (match origTyp with 
    Mconapp (MTarrow _, argstyp) -> 
      let newFormalTys = List.map ofMtype argstyp in 
      let (newFreeTys, _) = List.split toAdd in 
      (* Tycon (Tarrow (newRet, newFormalTys @ newFreeTys)) *)
      funty (newRet, newFormalTys @ newFreeTys)
  | _ -> raise (Failure "Non-function function type"))



(* Converts given sexpr to cexpr, and returns the cexpr *)
let rec mexprToCexpr ((ty, e) : mexpr) (env : var_env) =
  let rec exp ((typ, ex) : mexpr) = match ex with
    | MLiteral v -> (ofMtype typ, CLiteral (value v))
    | MVar s     -> 
        (* In case s is a name of a define, get the closure type *)
        let (occurs, ctyp) = find s env in 
        (* to match the renaming convention in svalToCval, and to ignore
           built in prints *)
        let vname = if occurs = 0 
                      then s 
                    else "_" ^ s ^ "_" ^ string_of_int occurs
        in (ctyp, CVar (vname))
    | MIf (t1, t2, t3) -> 
        let cexp1 = exp t1 
        and cexp2 = exp t2
        and cexp3 = exp t3 in 
        (fst cexp2, CIf (cexp1, cexp2, cexp3))
    | MApply (f, args) -> 
        let (ctyp, f') = exp f in 
        let normalargs = List.map exp args in 
        (* actual type of the function application is the type of the return*)
        let (retty, freesCount) = 
          (match ctyp with 
              Tycon (Clo (_, functy, freetys)) -> 
                (match functy with 
                    Conapp (Tarrow ret, _) -> (ret, List.length freetys)
                  | _ -> raise (Failure "Non-function function type"))
            | _ -> (intty, 0)) in 
        (retty, CApply ((retty, f'), normalargs, freesCount))
    | MLet (bs, body) -> 
        let local_env = (List.fold_left (fun map (x, se) -> 
                                          bindLocal map x se) 
                                        env bs) in 
        let c_bs = List.map (fun (x, e) -> (x, exp e)) bs in 
        let (ctyp, body') = mexprToCexpr body local_env in 
        (ctyp, CLet (c_bs, (ctyp, body')))
    (* Supose we hit a lambda expression, turn it into a closure *)
    | MLambda (formals, body) -> create_anon_function formals body typ env
  and value = function 
    | MChar c             -> CChar c 
    | MInt  i             -> CInt  i 
    | MBool b             -> CBool b 
    | MRoot t             -> CRoot (tree t)
  and tree = function 
    | MLeaf               -> CLeaf 
    | MBranch (v, t1, t2) -> CBranch (value v, tree t1, tree t2)
  in exp (ty, e)
(* When given just a lambda expresion withot a user defined identity/name 
   this function will generate a name and give the function a body --
   Lambda lifting. *)
and create_anon_function  (fformals : (mtype * string) list) (fbody : mexpr) 
                          (ty : mtype) (env : var_env) = 
  (* All anonymous functions are named the same and numbered. *)
  let id = anon ^ string_of_int !count in 
  let () = count := !count + 1 in
  (* Create the record that represents the function body and definition *)
  let local_env = List.fold_left (fun map (typ, x) -> 
                                    bindLocal map x (typ, MVar x))
                                  env fformals in 
  let func_body = mexprToCexpr fbody local_env in 
  let f_def = 
    {
      body    = func_body;
      rettyp  = fst func_body;
      fname   = id; 
      formals = List.map (fun (ty, nm) -> (ofMtype ty, nm)) fformals;
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
let mvalToCval (id, (ty, e)) = 
  (* check if id was already defined in rho, in order to get 
     the actual frequency the variable name was defined. 
     The (0, inttype is a placeholder) *)
  let (occurs, _) = if (isBound id res.rho) 
                      then (find id res.rho) 
                    else (0, intty) in
  (* Modify the name to account for the redefinitions, and so old closures 
     can access original variable values *)
  let id' = "_" ^ id ^ "_" ^ string_of_int (occurs + 1) in 
  let (ty', cexp) = mexprToCexpr (ty, e) res.rho in 
  (* bind original name to the number of occurrances and the variable's type *)
  let () = bind id (occurs + 1, ty') in 
  (* Return the possibly new CVal definition *)
  CVal (id', (ty', cexp))
(***********************************************************************)



(* Given an sprog (which is an sdefn list), convert returns a 
   cprog version. *)
let conversion mdefns =
  (* With a given sdefn, function converts it to the appropriate CAST type
     and sorts it to the appropriate list in a cprog type. *)
  let convert = function 
    | MVal (id, (ty, mexp)) -> 
        let cval = mvalToCval (id, (ty, mexp)) in addMain cval
    | MExpr e -> 
        let cexp = mexprToCexpr e res.rho in addMain (CExpr cexp)
  in 
    
  let _ = List.iter convert mdefns in 
    {
      main       = List.rev res.main;
      functions  = res.functions;
      rho        = res.rho;
      structures = res.structures
    }
