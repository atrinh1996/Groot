(* Closure converted Abstract Syntax tree 
    Assumes name-check and type-check have already happened
*)

open Ast
open Sast 

module StringMap = Map.Make(String)


type cname = string 
type 'a env = (cname * 'a) list
let emptyEnv = []

type ctyp = 
    | CInttyp 
    | CChartyp
    | CBooltyp
    | CTreetyp
    | CXtyp of int 
    | CVoidtyp

type cexpr = 
    | CLiteral  of cvalue 
    | CVar      of cname 
    | CIf       of cexpr * cexpr * cexpr
    | CApply    of cname * cexpr list 
    | CLet      of (cname * cexpr) list * cexpr 
    | CLambda   of lambda
and cvalue = 
    | CChar     of char
    | CInt      of int 
    | CBool     of bool  
    | CRoot     of ctree
    (* Closure: << code, environment >> *)
    (* | CClosure  of lambda * cvalue ref env *)
    | CClosure  of lambda * cvalue StringMap.t
    (* | CPRIMITIVE of primitive *)
and ctree = 
    | CLeaf 
    | CBranch of cvalue * ctree * ctree
and lambda = cname list * cexpr
(* and primitive = cexpr * cvalue list -> cvalue *)

(* function definitions: (val xyz (lambda ...)) 
   fdef has: 1) return type, 2) name, 3) param type list, 4) body*)
(* type fdef = ctyp * cname * ctyp list * cexpr *)

type decl = (cname * (ctyp list * ctyp))

type fdef = 
{
    rettyp : ctyp; 
    fname : cname; 
    formals : (cname * ctyp) list; 
    body : cexpr;
    (* closure : cvalue ref env; *)
    closure : cvalue;
}

type cdefn = 
    | CVal of cname * cexpr
    | CExpr of cexpr

type cprog = {
    decls   : decl list;
    main    : cexpr list;
    fdefs   : fdef list;
}








exception NotFound of ident 
exception BindListLength



(* Searches for given name in the given environment. Raises NotFound error
   if the name isn't in the environment. 
   ident * 'a env -> 'a *)
let rec find (name, environ) = 
    match environ with 
    | [] -> raise (NotFound name)
    | (target, value) :: tail -> 
        if name = target then value else find (name, tail)

(* Checks for the existence of name in the environ *)
let rec isBound (name, environ) = 
    match environ with 
    | []                        -> false
    | (target, value) :: tail   -> name = target || isBound (name, tail)

(* Adds a new binding in the environment, and returns the updated environment. 
   ident * 'a * 'a env -> 'a env *)
let bind (name, value, environ) = (name, value) :: environ

(* Adds each name in variables list bound to the equivalent value ini values
   binding to current environment. 
   ident list * 'a list * 'a env -> 'a env *)
let rec bindList (variables, values, environ) = 
    match (variables, values) with 
    | (x :: vars, v :: vals)    -> bindList (vars, vals, bind (x, v, environ))
    | ([], [])                  -> environ 
    | _                         -> raise BindListLength

(* Creates an environment from the given two list of names and values. 
   ident list * 'a list -> 'a env *)
let mkEnv (variables, values) = bindList (variables, values, emptyEnv)

(* Checks for duplicates in the environment. Returns option None if 
   no duplicates are found, or Some option for the duplicate if found. 
   ident list -> name option *)
let rec duplicateName environ = 
    match environ with 
    | [] -> None 
    | x :: xs ->    if List.exists (fun elem -> elem = x) xs 
                        then Some x  
                    else duplicateName xs


type basis = cvalue ref env 

(* type initial_basis = 
    emptyEnv *)
(*     let rho = List.fold_left 
                (fun (name, prim) rho -> bind (name, PRIMITIVE (), rho)) 
                emptyEnv 
                [] 
    in rho *)