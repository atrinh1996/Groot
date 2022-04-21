(* Closure conversion for groot compiler *)

(* open Ast *)
open Sast
open Cast 


(***********************************************************************)
(* partial cprog to return from this module *)
(* Pre-load rho with prints built in *)
let prerho env = 
  let add_prints map (k, v) =
    StringMap.add k v map
  in List.fold_left add_prints env [  ("printi", (0, inttype)); 
                                      ("printb", (0, booltype)); 
                                      ("printc", (0, chartype)); 
                                    ]

let built_ins = ["printi"; "printc"; "printb"]

let res = 
{
  main      = emptyList; 
  functions = emptyList; 
  rho       = prerho emptyEnv;
  phi       = emptyList;
}

(* name used for anonymous lambda functions *)
let anon = "anon"
let count = ref 0



(* puts the given cdefn into the main list *)
let addMain d = res.main <- d :: res.main 

(* puts the given function name (id) mapping to its definition (f) in the 
   functions StringMap *)
let addFunction f = res.functions <- f :: res.functions 

let getFunction id = 
  List.find (fun frecord -> 
              (* let () = print_endline ("Comparing against \"" ^ frecord.fname ^ "\"") in *)
              id = frecord.fname) 
            res.functions

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
    | SApply (f, args)      -> free f || 
                               List.fold_left 
                                  (fun a b -> a || free b) 
                                  false args
    | SLet (bs, body) -> List.fold_left (fun a (_, e) -> a || free e) false bs 
                         || (free body && not (List.fold_left 
                                                (fun a (x, _) -> a || x = n) 
                                                false bs))
    | SLambda (formals, body) -> let (_, names) = List.split formals in 
        free body && not (List.fold_left (fun a x -> a || x = n) false names)
  in free (inttype, exp)

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
  StringMap.fold  (fun id (num, ty) res -> 
                      let id' = if num = 0 then id else "_" ^ id ^ "_" ^ string_of_int num in 
                      (ty, id') :: res
                  ) 
                  venv []

(* Returns the list of cexpr that are free in f *)
let findFrees ((_, f) : cexpr) (body : sexpr) (rho : var_env) = 
  (* gets the fdef record type for the function definiton *)
  let flookup name = getFunction name in 
  (* returns an fdef frees list, which is of type: (gtype * cname) list *)
  let getFrees fdefn = fdefn.frees in 
  (* conver each (gtype * cname) to a cexpr: (gtype, CVar cname) *)
  let toCVarCexpr (ty, id) = (ty, CVar id) in 
  (match f with 
      CVar id | CLambda (id, _, _) -> 
          if List.mem id built_ins then [] else  
          let frees = getFrees (flookup id) 
          in List.map toCVarCexpr frees 
    | _ -> let frees = toParamList (improve ([], body) rho) in List.map toCVarCexpr frees

  )

(* Generate a new function gtype for lambda expressions in order to account
   for free variables, when given the original function type and an 
   association list of gtypes and var names to add to the new formals list
   of the function type. *)
let newFuntype (origTyp : gtype) (toAdd : (gtype * cname) list) = 
  let (newTys, _) = List.split toAdd in 
  let ftyp = (match origTyp with 
                TYCON (TArrow (rettyp, argstyp)) -> 
                  TYCON (TArrow (rettyp, argstyp @ newTys))
              | _ -> raise (Failure "Non-function function type"))
  in ftyp

(* Converts given sexpr to cexpr, and returns the cexpr *)
(* let rec sexprToCexpr ((ty, e) : sexpr) = match e with  *)
let rec sexprToCexpr ((ty, e) : sexpr) (env : var_env) =
  let rec exp ((typ, ex) : sexpr) = match ex with
    | SLiteral v -> (typ, CLiteral (value v))
    | SVar s     -> 
        let occurs = (fst (find s env)) in 
        let vname = if occurs = 0 then s else "_" ^ s ^ "_" ^ string_of_int occurs
        in (ty, CVar (vname))
    | SIf (s1, s2, s3) -> (typ, CIf (exp s1, exp s2, exp s3))
    | SApply (f, args) -> 
        let f' = exp f in 
        let normalargs = List.map exp args in 
        let freeargs = findFrees f' f env in 
        (* let () = print_endline "found the frees" in  *)
        (* create_anon_function_call f args restyp env *)
        (typ, CApply (f', normalargs @ freeargs))
    | SLet (bs, body) -> 
        (typ, CLet (List.map (fun (x, e) -> (x, exp e)) bs, 
                   sexprToCexpr body (List.fold_left 
                                        (fun map (x, (t, _)) -> 
                                          StringMap.add x (0, t) map) 
                                        env bs)))
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
and create_anon_function (fformals : (gtype * string) list) (fbody : sexpr) (ty : gtype) (env : var_env) = 
  let id = anon ^ string_of_int !count in 
  let () = count := !count + 1 in
  let () = bindFunction id in 
  let f_def = 
    {
      rettyp  = (match ty with 
                    TYCON (TArrow (res, _)) -> res 
                  | _ -> raise (Failure "Non-function function type")); 
      fname   = id; 
      formals = fformals;
      frees   = toParamList (improve (fformals, fbody) env);
      body    = sexprToCexpr fbody (List.fold_left 
                                      (fun map (typ, x) -> 
                                        StringMap.add x (0, typ) map)
                                      env fformals);
    } 
  in 
  let () = addFunction f_def in 
  let ty' = newFuntype ty f_def.frees in 
  let () = bind id (1, ty') in 
  (ty', CLambda (id, f_def.formals @ f_def.frees, f_def.body))
(* When given an expression to apply in function application, the expression 
   turns into a named function call. 
   This helps enures during a call, the resulting call behaves 
   as though it has access to its freevars. *)
(* and create_anon_function_call (fbody : sexpr) (args : sexpr list) (retyp : gtype) (env : var_env) = 
  let id = anon ^ string_of_int !count in 
  let () = count := !count + 1 in 
  let () = bindFunction id in 
  let f_def = 
    {
      rettyp = retyp;  return type should be a function type to actually apply
      fname = id; 
      formals = [];
      frees = toParamList (improve ([], fbody) env);
      body = sexprToCexpr fbody env;
    }
  in 
  let () = addFunction f_def in 
  let ty' = newFuntype retyp f_def.frees in 
  (ty', CApply ((retyp, CVar f_def.fname), f_def.formals @ f_def.frees)) *)


(* Converts given SVal to CVal, and returns the CVal *)
let svalToCval (id, (ty, e)) = 
  (* check if id was already defined in rho *)
  let (occurs, _) = if (isBound id res.rho) then (find id res.rho) else (0, ty) in 
  let id' = "_" ^ id ^ "_" ^ string_of_int (occurs + 1) in 
  let cval = 
  (match e with 
    | SLambda (fformals, fbody) -> 
        let () = if (findFunction id) then () else bindFunction id in
        let f_def = 
          {
            rettyp  = (match ty with 
                          TYCON (TArrow (res, _)) -> res 
                          | _ -> raise (Failure "Non-function function type"));
            fname   = id'; 
            formals = fformals;
            frees   = toParamList (improve (fformals, fbody) res.rho); 
              (* toParamList (clean res.phi (improve (fformals, fbody) res.rho));  *)
            body    = sexprToCexpr fbody (List.fold_left 
                                            (fun map (typ, x) -> 
                                              StringMap.add x (0, typ) map)
                                            res.rho fformals);
          } 
        in 
        let () = addFunction f_def in
        let ty' = newFuntype ty f_def.frees in 
        let () = bind id (occurs + 1, ty') in 
        Some (CVal (id', (ty', CLambda (id', f_def.formals @ f_def.frees, f_def.body))))
    | _ ->  
        let () = bind id (occurs + 1, ty) in 
        Some (CVal (id', sexprToCexpr (ty, e) res.rho)))
  in cval 
(***********************************************************************)



(* Given an sprog (which is an sdefn list), convert returns a 
   cprog version. *)
let conversion sdefns =

  (* With a given sdefn, function converts it to the appropriate CAST type
     and sorts it to the appropriate list in a cprog type. *)
  let convert = function 
    | SVal (id, (ty, sexp)) -> 
        (match svalToCval (id, (ty, sexp)) with 
            | Some cval -> addMain cval 
            | None      -> ())
    | SExpr e -> (* addMain (CExpr (sexprToCexpr e res.rho)) *)
        (match (sexprToCexpr e res.rho) with 
            | (_, CLambda _) -> ()
            | cexp      -> addMain (CExpr cexp))
  in 
    
  let _ = List.iter convert sdefns in 
  (* let () = print_endline "exiting coversion" in  *)
    {
      main      = List.rev res.main;
      functions = res.functions;
      rho       = res.rho;
      phi       = res.phi;
    }
