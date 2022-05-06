(* Closure conversion for groot compiler *)
open Hast
open Cast

module StringMap = Map.Make(String)

(***********************************************************************)

(* Pre-load rho with prints built in *)
let prerho env =
  let add_prints map (k, v) =
    StringMap.add k [v] map
  in List.fold_left add_prints env 
     [("printi", (0, intty));   ("printb", (0, boolty));
      ("printc", (0, charty));  ("+", (0, intty));
      ("-", (0, intty));        ("*", (0, intty));
      ("/", (0, intty));        ("mod", (0, intty));
      ("<", (0, boolty));       (">", (0, boolty));
      ("<=", (0, boolty));      (">=", (0, boolty));
      ("!=i", (0, boolty));     ("=i", (0, boolty));
      ("&&", (0, boolty));      ("||", (0, boolty));
      ("not", (0, boolty));     ("~", (0, intty))       ]

(* list of variable names that get ignored/are not to be considered frees *)
let ignores = [ "printi"; "printb"; "printc";
                "+"; "-"; "*"; "/"; "mod";
                "<"; ">"; ">="; "<="; "!=i"; "=i"; 
                "&&"; "||"; "not"; "~"           ]


(* partial cprog to return from this module *)
let res =
  {
    main        = emptyList;
    functions   = emptyList;
    rho         = prerho emptyEnv;
    structures  = emptyList
  }




(* Converts a htype to a ctype *)
let rec ofHtype = function
    HTycon ty    -> Tycon (ofTycon ty)
  | HConapp con  -> Conapp (ofConapp con)
and ofTycon = function
    HIntty        -> Intty
  | HBoolty       -> Boolty
  | HCharty       -> Charty
  | HTarrow retty -> Tarrow (ofHtype retty)
  | HCls (id, retty, argsty, freetys) -> 
      let retty' = ofHtype retty in 
      let argsty' = List.map ofHtype argsty in 
      let freetys' = List.map ofHtype freetys in 
      Clo (id ^ "_struct", funty (retty', argsty' @ freetys'), freetys')
and ofConapp (tyc, tys) = (ofTycon tyc, List.map ofHtype tys)


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

(* Adds a local binding of k to ctype in the given StringMap env *)
let bindLocal map k ty =
  let currList = if isBound k map then StringMap.find k map else [] in
  let localList = (0, ty) :: currList in
  StringMap.add k localList map

(* Given expression an a string name n, returns true if n is
   a free variable in the expression *)
let freeIn exp n =
  let rec free (_, e) = match e with
    | HLiteral _        -> false
    | HVar s            -> s = n
    | HIf (s1, s2, s3)  -> free s1 || free s2 || free s3
    | HApply (f, args)  -> free f  || List.fold_left
                             (fun a b -> a || free b)
                             false args
    | HLet (bs, body) -> List.fold_left (fun a (_, e) -> a || free e) false bs
                         || (free body && not (List.fold_left
                                                 (fun a (x, _) -> a || x = n)
                                                 false bs))
    | HLambda (formals, body) ->
      let (_, names) = List.split formals in
      free body && not (List.fold_left (fun a x -> a || x = n) false names)
  in free (intTy, exp)


(* Given the formals list and body of a lambda (xs, e), and a
   variable environment, the function returns an environment with only
   the free variables of this lambda. The environment of frees shall
   not inculde the names of built-in functions and primitives *)
let improve (xs, e) rho =
  StringMap.filter
    (fun n _ ->
       if List.mem n ignores
       then false
       else freeIn (HLambda (xs, e)) n)
    rho


(* Given a var_env, returns a (ctype  * name) list version *)
let toParamList (venv : var_env) =
  StringMap.fold  
    (fun id occursList res ->
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
let newFuntype  (origTyp : htype) (newRet : ctype)
    (toAdd : (ctype * cname) list) =
  (match origTyp with
     HTycon (HCls (_, _, argsty, _)) ->
     let newFormalTys = List.map ofHtype argsty in
     let (newFreeTys, _) = List.split toAdd in
     funty (newRet, newFormalTys @ newFreeTys)
   | _ -> raise (Failure "Non-function function type"))



(* Converts given sexpr to cexpr, and returns the cexpr *)
let rec hexprToCexpr (env : var_env) (e : hexpr)  =
  let rec expr ((typ, ex) : hexpr) = match ex with
    | HLiteral v -> (ofHtype typ, CLiteral (value v))
    | HVar s     ->
        (* In case s is a name of a define, get the closure type *)
        let (occurs, ctyp) = find s env in
        (* to match the renaming convention in svalToCval, and to ignore
           built in prints *)
        let vname = if occurs = 0
                      then s
                    else "_" ^ s ^ "_" ^ string_of_int occurs
        in (ctyp, CVar (vname))
    | HIf (e1, e2, e3) ->
        let e1' = expr e1
        and e2' = expr e2
        and e3' = expr e3 in
        (fst e2', CIf (e1', e2', e3'))
    | HApply (f, args) ->
        let (ctyp, f') = expr f in
        let normalargs = List.map expr args in
        (* actual type of the function application is the type of the return*)
        let (retty, freesCount) =
          (match ctyp with
             Tycon (Clo (_, functy, freetys)) ->
             (match functy with
                Conapp (Tarrow ret, _) -> (ret, List.length freetys)
              | _ -> raise (Failure "Non-function function type"))
           | _ -> (intty, 0)) in
        (retty, CApply ((ctyp, f'), normalargs, freesCount))
    | HLet (bs, body) ->
        let bs' = List.map (fun (name, hex) -> (name, expr hex)) bs in
        let local_env = 
            List.fold_left (fun map (name, (ty, _)) ->
                              bindLocal map name ty)
                           env bs' in
        let (ctyp, body') = hexprToCexpr local_env body  in
        (ctyp, CLet (bs', (ctyp, body')))
    (* Supose we hit a lambda expression, turn it into a closure *)
    | HLambda (formals, body) -> create_anon_function formals body typ env
  and value = function
    | HChar c             -> CChar c
    | HInt  i             -> CInt  i
    | HBool b             -> CBool b
    | HRoot t             -> CRoot (tree t)
  and tree = function
    | HLeaf               -> CLeaf
    | HBranch (v, t1, t2) -> CBranch (value v, tree t1, tree t2)
  in expr e
(* When given just a lambda expresion withot a user defined identity/name
   this function will generate a name and give the function a body --
   Lambda lifting. *)
and create_anon_function  (fformals : (htype * hname) list) (fbody : hexpr)
                          (closurety : htype) (env : var_env) =

  
  let fformals' = List.map (fun (hty, x) -> (ofHtype hty, x)) fformals in 
  let local_env = List.fold_left 
                    (fun map (formtyp, name) ->
                      bindLocal map name formtyp)
                    env fformals' in
  let func_body = hexprToCexpr local_env fbody in
  let rettype = fst func_body in 
  let freeformals = toParamList (improve (fformals, fbody) env) in 

  (* All anonymous functions are named the same and numbered. *)
  (* Given a h-closure type, returns the closure's id *)
  let getClsID (cls : htype) = match cls with  
      HTycon (HCls (id, _, _, _)) -> id  
    | _ -> Diagnostic.error 
           (Diagnostic.TypeError ("Conversion: Nonclosure-type accessed" 
                                  ^ " when trying to get closure ID"))
  in 
  let id = getClsID closurety in 

  (* Create the record that represents the function body and definition *)
  let func_def =
    {
      body    = func_body;
      rettyp  = rettype;
      fname   = id;
      formals = fformals';
      frees   = freeformals;
    }
  in
  let () = addFunction func_def in

  (* New function type will include the types of free arguments *)
  let anonFunTy = newFuntype closurety rettype freeformals in
  (* Record the type of the anonymous function and its "rea" ftype *)
  let () = bind id (1, anonFunTy) in
  (* The value of a Lambda expression is a Closure -- new type construction
     will help create the structs in codegen that represents the closure *)
  let (freetys, _) = List.split freeformals in
  let clo_ty = closuretype (id ^ "_struct", anonFunTy, freetys) in
  let () = addClosure clo_ty in
  let freeVars = convertToVars freeformals in
  (clo_ty, CLambda (id, freeVars))



(* Converts given SVal to CVal, and returns the CVal *)
let hvalToCval (id, (ty, e)) =
  (* check if id was already defined in rho, in order to get
     the actual frequency the variable name was defined.
     The (0, inttype is a placeholder) *)
  let (occurs, _) = if (isBound id res.rho)
                      then (find id res.rho)
                    else (0, intty) in
  (* Modify the name to account for the redefinitions, and so old closures
     can access original variable values *)
  let id' = "_" ^ id ^ "_" ^ string_of_int (occurs + 1) in
  let (ty', cexp) = hexprToCexpr res.rho (ty, e) in
  (* bind original name to the number of occurrances and the variable's type *)
  let () = bind id (occurs + 1, ty') in
  (* Return the possibly new CVal definition *)
  CVal (id', (ty', cexp))
(***********************************************************************)



(* Given an hprog (which is an hdefn list), convert returns a
   cprog version. *)
let conversion hdefns =
  (* With a given sdefn, function converts it to the appropriate CAST type
     and sorts it to the appropriate list in a cprog type. *)
  let convert = function
    | HVal (id, (ty, hexp)) ->
        let cval = hvalToCval (id, (ty, hexp)) in addMain cval
    | HExpr e ->
        let cexp = hexprToCexpr res.rho e in addMain (CExpr cexp)
  in

  let _ = List.iter convert hdefns in
  {
    main       = List.rev res.main;
    functions  = res.functions;
    rho        = res.rho;
    structures = res.structures
  }
