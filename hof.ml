(* Resolve higher order function uses (takes or returns functions)
   to take or return closures. *)
open Mast 
open Hast 
module StringMap = Map.Make(String)

(* name used for anonymizing lambda functions *)
let anon = "_anon"
let count = ref 0

(* Pre-load rho with prints built in *)
let prerho env =
  let add_prints map (k, v) =
    StringMap.add k [v] map
  in List.fold_left add_prints env 
     [("printi", (0, intTy));   ("printb", (0, boolTy));
      ("printc", (0, charTy));  ("+", (0, intTy));
      ("-", (0, intTy));        ("*", (0, intTy));
      ("/", (0, intTy));        ("mod", (0, intTy));
      ("<", (0, boolTy));       (">", (0, boolTy));
      ("<=", (0, boolTy));      (">=", (0, boolTy));
      ("!=i", (0, boolTy));     ("=i", (0, boolTy));
      ("&&", (0, boolTy));      ("||", (0, boolTy));
      ("not", (0, boolTy));     ("~", (0, intTy))          ]

(* list of variable names that get ignored/are not to be considered frees *)
let ignores = [ "printi"; "printb"; "printc";
                "+"; "-"; "*"; "/"; "mod";
                "<"; ">"; ">="; "<=";
                "!=i"; "=i"; "~";
                "&&"; "||"; "not"            ]


(* partial cprog to return from this module *)
let res =
  {
    program  = emptyListEnv;
    gamma    = prerho emptyEnvironment;
    hofs     = emptyEnvironment;
  }

(* Inserts a hdefn into main hdefn list *)
let addMain d = res.program <- d :: res.program

(* Returns true if the given name id is already bound in the given
   StringMap env. False otherwise *)
let isBound id env = StringMap.mem id env

(* Returns the first element of th value that "id" is bound to in the given 
   StringMap env. If the binding doesn't exist, Not_Found exception is raised. *)
let find id env =
  let occursList = StringMap.find id env in List.nth occursList 0

(* Adds a binding of k to v in the global StringMap env *)
let bindGamma k v = res.gamma <-
  let currList =  if isBound k res.gamma 
                  then StringMap.find k res.gamma else [] in
  let newList = v :: currList in
  StringMap.add k newList res.gamma

let addHofs id lambda = res.hofs <- StringMap.add id lambda res.hofs 

(* Adds a local binding of k to v in the given StringMap env *)
let bindLocal map k v =
  let currList = if isBound k map then StringMap.find k map else [] in
  let localList = (0, v) :: currList in
  StringMap.add k localList map

(* Given a h-closure type, returns the closure's id *)
let getClosureId (cls : htype) = match cls with  
    HTycon (HCls (id, _, _, _)) -> id  
  | _ -> Diagnostic.error (Diagnostic.TypeError ("Nonclosure-type accessed when trying to get closure ID"))


(* Converts a mtype to a htype *)
let rec ofMtype = function
    Mtycon ty    -> HTycon (ofTycon ty)
  | Mtyvar _     -> Diagnostic.error 
                    (Diagnostic.TypeError ("unresolved polymorphic type"))
  | Mconapp con  -> HConapp (ofConapp con)
and ofTycon = function
    MIntty        -> HIntty
  | MBoolty       -> HBoolty
  | MCharty       -> HCharty
  | MTarrow retty -> HTarrow (ofMtype retty)
and ofConapp (tyc, tys) = (ofTycon tyc, List.map ofMtype tys)




(* Returns true if given htype is a function type *)
let rec isFunctionType = function 
    HTycon t  -> hof_tycon t
  | HConapp t -> hof_conapp t
and hof_tycon = function 
    HIntty | HCharty | HBoolty -> false 
  | HTarrow _ -> true 
  | HCls (_, retty, argsty, _) -> 
      isFunctionType retty 
      || (List.fold_left (fun init argty -> init || (isFunctionType argty)) false argsty)
and hof_conapp (tyc, tys) =  
      hof_tycon tyc 
      || (List.fold_left (fun init typ -> init || (isFunctionType typ)) false tys)

(* Returns true if the given htype indicates a higher order function *)
let isHOF = function 
    HTycon (HCls (_, retty, argsty, _)) -> 
      isFunctionType retty 
      || (List.fold_left (fun init argty -> init || (isFunctionType argty)) false argsty)
  | _ -> false 





(* Given expression an a string name n, returns true if n is
   a free variable in the expression *)
let freeIn exp n =
  let rec free (_, e) = match e with
    | MLiteral _        -> false
    | MVar s            -> s = n
    | MIf (m1, m2, m3)  -> free m1 || free m2 || free m3
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
  in free (integerTy, exp)

(* Given the formals list and body of a lambda (xs, e), and a
   variable environment, the function returns a list of the types of the 
   free variables of the expression. The list of free tyes shall
   not inculde those of built-in functions and primitives *)
let freeTypesOf (xs, e) gamma =
  let freeGamma = 
    StringMap.filter
      (fun n _ ->
         if List.mem n ignores
          then false
         else freeIn (MLambda (xs, e)) n)
      gamma
  in 
  let getTy _ occursList res = 
    let (_, ty) = List.nth occursList 0 in 
    (* let id' = if num = 0 then id else "_" ^ id "_" ^ string_of_int num in  *)
    (* (ty, id') :: res  *)
    ty :: res
  in 
  StringMap.fold getTy freeGamma []


(* *)
let clean (mdefns : mprog) = 

  let rec h_expr (env : ty_env) ((typ, exp) : hexpr) = match exp with 
    | HLiteral l -> (typ, HLiteral l)
    | HVar v -> let (_, typ') = find v env in (typ', HVar v) 
    | HIf (e1, e2, e3) -> 
        let e1' = h_expr env e1 in 
        let e2' = h_expr env e2 in 
        let e3' = h_expr env e3 in 
        (fst e2', HIf (e1', e2', e3'))
    | HApply (f, args) -> 
        let f' = h_expr env f in 
        let args' = List.map (h_expr env) args in 
        let retty = 
          (match fst f' with  
            HTycon (HCls (_, ret, _, _)) -> ret
          | _ -> intTy)
        in (retty, HApply (f', args'))
    | HLet (bs, body) -> 
        let bs' = List.map (fun (name, exp) -> (name, h_expr env exp)) bs in
        let local_env = List.fold_left (fun map (name, (ty, _)) -> 
                                          bindLocal map name ty) 
                                       env bs' in 
        let body' = h_expr local_env body in 
        (fst body, HLet (bs', body')) 
    | HLambda (formals, body) ->  
        let local_env = List.fold_left (fun map (ty, name) -> 
                                          bindLocal map name ty) 
                                       env formals in 
        let body' = h_expr local_env body in 
        (fst body, HLambda (formals, body'))
  in 

  (* Given a mexpr, returns the equivalent hexpr *)
  (* let rec expr (env : ty_env) (id : hname) (mexp : mexpr) =  *)
  let rec expr (env : ty_env) (mexp : mexpr) = 
    let rec expr' (ty, exp) = match exp with 
        MLiteral l -> (ofMtype ty, HLiteral (value l))
      | MVar v -> let (_, typ) = find v env in (typ, HVar v) 
      | MIf (e1, e2, e3) -> 
          let e1' = expr' e1 in 
          let e2' = expr' e2 in 
          let e3' = expr' e3 in 
          (fst e2', HIf (e1', e2', e3'))
      | MApply (f, args) -> 
          let (fty, f') = expr' f in 
          let args' = List.map expr' args in 
          if isHOF fty 
            then let (retty, fty') = resolveHOF env fty args' in 
                 (retty, HApply ((fty', f'), args'))
          else (ofMtype ty, HApply ((fty, f'), args'))
      | MLet (bs, body) ->
          let bs' = List.map (fun (name, e) -> (name, expr' e)) bs in
          let local_env = List.fold_left (fun map (name, (typ, _)) -> 
                                            bindLocal map name typ) 
                                         env bs' in 
          let body' = expr local_env body in 
          (fst body', HLet (bs', body')) 
      | MLambda (formals, body) -> 
          (* name the closure *)
          let id = anon ^ string_of_int !count in
          let () = count := !count + 1 in

          (* Put the formals in the environment *)
          let (formaltys, formalnames) = List.split formals in 
          let formaltys' = List.map ofMtype formaltys in 
          let formals' = List.combine formaltys' formalnames in 
          let local_env = List.fold_left (fun map (typ, name) -> 
                                            bindLocal map name typ) 
                                         env formals' in 
          let body' = expr local_env body in 
          let retty = fst body' in 
          let freetys = freeTypesOf (formals, body) env in 

          (* Create new closure type *)
          let closureType = partialClosurety (id, retty, formaltys', freetys) in 
          (closureType, HLambda (formals', body'))
    and value = function 
      | MChar c -> HChar c
      | MInt  i -> HInt  i
      | MBool b -> HBool b
      | MRoot t -> HRoot (tree t) 
    and tree = function 
      | MLeaf -> HLeaf
      | MBranch (v, t1, t2) -> HBranch (value v, tree t1, tree t2)
    and resolveHOF (env : ty_env) (closuretype : htype) (arguments : hexpr list) = 
          (* Extract argument actual types, and name of closure being referenced *)
          let (argtypes, _) = List.split arguments in 
          let cloName = getClosureId closuretype in 
          let (id, (_, lambdaexp)) = StringMap.find cloName res.hofs in 
          (* Function returns the subexpressions of a lambda expression *)
          let get_lambda_subxs = function 
              HLambda (formals, body) -> (formals, body)
            | _ -> Diagnostic.error (Diagnostic.TypeError ("Nonclosure-type accessed when tryong to get lambda subexpressions"))
          in
          (* Function replaces return types and argument types of a closure 
             type with the new given types passed in. *)
          let resolve_cls_ty retty argtys = function 
              HTycon (HCls (id, _, _, freetys)) -> HTycon (HCls (id, retty, argtys, freetys))
            | _ -> Diagnostic.error (Diagnostic.TypeError ("Nonclosure-type accessed when tyring to resolve closure type"))
          in 
          (* Lambda subexpressions *)
          let (formals, body) = get_lambda_subxs lambdaexp in 
          let (_, formalnames) = List.split formals in 
          let formals' = List.combine argtypes formalnames in 

          let local_env = List.fold_left (fun map (typ, name) -> 
                                            bindLocal map name typ) 
                                         env formals'  in
          let body' = h_expr local_env body in 
          let retty = fst body' in 
          (* Resolve new closure types within closure types *)
          let newClsty = resolve_cls_ty retty argtypes closuretype in 
          let newLambDef = HVal (id, (newClsty, HLambda (formals', body'))) in 
          let () = addMain newLambDef in 
          (retty, newClsty)

    in expr' mexp
  in 


  (* iterate through each defn and remove the hofs uses *)
  let hofDef (def : mdefn) = match def with 
      MVal (id, ex) -> 
        let (occurs, _) = if (isBound id res.gamma)
                            then (find id res.gamma)
                          else (0, intTy) in
        let (ty, ex') = expr res.gamma ex in 
        let () = bindGamma id (occurs + 1, ty) in 
        if isHOF ty then addHofs (getClosureId ty) (id, (ty, ex'))
        else addMain (HVal (id, (ty, ex')))
    | MExpr ex -> 
        let hexp = expr res.gamma ex in addMain (HExpr hexp)

  in 

  let _ = List.iter hofDef mdefns in 
  List.rev res.program 
