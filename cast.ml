(*
    Closure converted Abstract Syntax tree 
    Assumes name-check and type-check have already happened
*)

open Ast
open Sast 
module StringMap = Map.Make(String)

(* int StringMap.t - for our rho/variable environment 
   (DOES NOT MAP TO VALUES) *)
type var_env = int StringMap.t
let emptyEnv = StringMap.empty

type cname = string


type cexpr = gtype * cx
and cx =
    | CLiteral  of cvalue 
    | CVar      of cname 
    | CIf       of cexpr * cexpr * cexpr
    | CApply    of cname * cexpr list 
    | CLet      of (cname * cexpr) list * cexpr 
    | CLambda   of (gtype * cname) list * cexpr
and cvalue = 
    | CChar     of char
    | CInt      of int
    | CBool     of bool
    | CRoot     of ctree
and ctree = 
    | CLeaf 
    | CBranch   of cvalue * ctree * ctree


type fdef = 
{
    rettyp  : gtype; 
    fname   : cname; 
    formals : (gtype * cname) list;
    frees   : var_env; 
    body    : cexpr;
}
type func_env = fdef StringMap.t


type cdefn = 
    | CVal      of cname * cexpr
    | CExpr     of cexpr


type cprog = 
{
    main        : cdefn list;
    functions   : func_env;
    rho         : var_env; (* could also simply be a string list *)
}


(***********************************************************************)
(* Returns true if the given name id is already bound in the given 
   StringMap env. False otherwise *)
let isBound id env = StringMap.mem id env 

(* Adds a binding of k to v in the given StringMap env *)
let bind k v env = StringMap.add k v env 

(* Returns the value id is bound to in the given StringMap env. If the 
   binding doesn't exist, Not_Found exception is raised. *)
let find id env = StringMap.find id env 


(* partial cprog to return from this module *)
let res = 
{
  main      = []; 
  functions = emptyEnv; 
  rho       = emptyEnv;
}

(* puts the given cdefn into the main list *)
let addMain d = d :: res.main 

(* puts the given function name (id) mapping to its definition (f) in the 
   functions StringMap *)
let addFunctions id f = StringMap.add id f res.functions 

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
  in free (Void, exp)

(* Given the formals list and body of a lambda (xs, e), and a 
   variable environment, the function returns an environment with only 
   the free variables of this lambda. *)
let improve (xs, e) rho = 
  StringMap.filter (fun n _ -> freeIn (SLambda (xs, e)) n) rho

(* Converts given sexpr to cexpr, and returns the cexpr *)
let rec sexprToCexpr ((ty, e) : sexpr) = match e with 
  | SLiteral v              -> (ty, CLiteral (value v))
  | SVar s                  -> (ty, CVar s)
  | SIf (s1, s2, s3)        -> (ty, CIf (sexprToCexpr s1, 
                                         sexprToCexpr s2, 
                                         sexprToCexpr s3))
  | SApply (fname, args)    -> (ty, CApply (fname, List.map sexprToCexpr args))
  | SLet (bs, body) -> 
        (ty, CLet   (List.map (fun (x, e) -> (x, sexprToCexpr e)) bs, 
                     sexprToCexpr body))
  | SLambda (formals, body) -> (ty, CLambda (formals, sexprToCexpr body)) 
and value = function 
  | SChar c                 -> CChar c 
  | SInt  i                 -> CInt  i 
  | SBool b                 -> CBool b 
  | SRoot t                 -> CRoot (tree t)
and tree = function 
  | SLeaf                   -> CLeaf 
  | SBranch (v, t1, t2)     -> CBranch (value v, tree t1, tree t2)

(* Converts given SVal to CVal, and returns the CVal *)
let svalToCval (id, (ty, e)) = 
  (* check if id was already defined in rho *)
  let occurs = if (isBound id res.rho) then (find id res.rho) else 0 in 
  let _ = bind id (occurs + 1) res.rho in 
  let cval = 
  (match e with 
    | SLambda (fformals, fbody) -> 
        let f_def = 
          {
            rettyp = ty; 
            fname = id; 
            formals = fformals;
            frees = improve (fformals, fbody) res.rho; 
            body = sexprToCexpr fbody;
          } 
        in 
        let _ = StringMap.add   (id ^ string_of_int (find id res.rho)) 
                                f_def res.functions
        in None 
    | _-> Some (CVal (id, sexprToCexpr (ty, e)))
  )
  in cval 