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

type cname = string

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
    | CLambda   of cname list * cexpr
and cvalue = 
    | CChar     of char
    | CInt      of int
    | CBool     of bool
    | CRoot     of ctree
and ctree = 
    | CLeaf 
    | CBranch   of cvalue * ctree * ctree

type cdefn = 
    | CVal      of cname * cexpr
    | CExpr     of cexpr

type fdef = 
{
    rettyp  : ctyp; 
    fname   : cname; 
    formals : (cname * ctyp) list;
    frees   : var_env; 
    body    : cexpr;
}

type func_env = fdef StringMap.t

type cprog = 
{
    main        : cdefn list;
    functions   : func_env;
    rho         : var_env; (* could also simply be a string list *)
}








(* exception NotFound of ident 
exception BindListLength *)



(* Searches for given name in the given environment. Raises NotFound error
   if the name isn't in the environment. 
   ident * 'a env -> 'a *)
(* let rec find (name, environ) = 
    match environ with 
    | [] -> raise (NotFound name)
    | (target, value) :: tail -> 
        if name = target then value else find (name, tail) *)

(* Checks for the existence of name in the environ *)
(* let rec isBound (name, environ) = 
    match environ with 
    | []                        -> false
    | (target, value) :: tail   -> name = target || isBound (name, tail) *)

(* Adds a new binding in the environment, and returns the updated environment. 
   ident * 'a * 'a env -> 'a env *)
(* let bind (name, value, environ) = (name, value) :: environ *)

(* Adds each name in variables list bound to the equivalent value ini values
   binding to current environment. 
   ident list * 'a list * 'a env -> 'a env *)
(* let rec bindList (variables, values, environ) = 
    match (variables, values) with 
    | (x :: vars, v :: vals)    -> bindList (vars, vals, bind (x, v, environ))
    | ([], [])                  -> environ 
    | _                         -> raise BindListLength
 *)
(* Creates an environment from the given two list of names and values. 
   ident list * 'a list -> 'a env *)
(* let mkEnv (variables, values) = bindList (variables, values, emptyEnv) *)

(* Checks for duplicates in the environment. Returns option None if 
   no duplicates are found, or Some option for the duplicate if found. 
   ident list -> name option *)
(* let rec duplicateName environ = 
    match environ with 
    | [] -> None 
    | x :: xs ->    if List.exists (fun elem -> elem = x) xs 
                        then Some x  
                    else duplicateName xs
 *)

(* type basis = cvalue ref env  *)

(* type initial_basis = 
    emptyEnv *)
(*     let rho = List.fold_left 
                (fun (name, prim) rho -> bind (name, PRIMITIVE (), rho)) 
                emptyEnv 
                [] 
    in rho
*)