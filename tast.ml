(*
    TAST
    Type inference.  
*)

open Ast

exception Type_error of string

let type_error msg = raise (Type_error msg)

type gtype =
  | TYCON of tycon
  | TYVAR of tyvar
  | CONAPP of conapp
and tycon =
  | TInt 
  | TBool 
  | TChar 
  | TArrow of gtype 
and tyvar =
  | TVariable of int 
and conapp = (tycon * gtype list)

type tyscheme = (tyvar list * gtype)


let inttype = TYCON TInt 
let chartype = TYCON TChar
let booltype = TYCON TBool
let functiontype resultType formalsTypes = 
  CONAPP (TArrow resultType, formalsTypes)


(* TAST expression *)
type texpr = gtype * tx
and tx = 
| TLiteral     of tvalue
| TypedVar     of ident
| TypedIf      of texpr * texpr * texpr
| TypedApply   of texpr * texpr list
| TypedLet     of (ident * texpr) list * texpr
| TypedLambda  of (gtype * ident) list * texpr
(* | TypedLambda  of (tyvar list * ident list) * texpr *)
and tvalue = 
| TChar    of char
| TInt     of int
| TBool    of bool
| TRoot    of ttree
and ttree =  
| TLeaf
| TBranch of tvalue * ttree * ttree


type tdefn = 
| TVal of ident * texpr
| TExpr of texpr


type tprog = tdefn list 



(* Pretty printer *)

(* String of gtypes *)
let rec string_of_ttype = function 
  | TYCON ty -> string_of_tycon ty
  | TYVAR tp -> string_of_tyvar tp
  | CONAPP con -> string_of_conapp con
and string_of_tycon = function 
  | TInt -> "int"
  | TBool -> "bool"
  | TChar -> "char"
  | TArrow (retty) -> string_of_ttype retty 
and string_of_tyvar = function
  | TVariable n -> "'" ^ string_of_int n
and string_of_tyscheme (tvlst, gt) =  
let tvstr = List.map string_of_tyvar tvlst in
 "([" ^ String.concat ", " tvstr ^ "]" ^ ":" ^ string_of_ttype gt ^ ")"
and string_of_conapp (tyc, tys) = match tyc with 
  | TArrow retty -> "[" ^ String.concat " " (List.map string_of_ttype tys) ^ "] -> " ^  string_of_tycon tyc 
  | _ -> raise (Type_error "conapp print")
  
and string_of_constraint (t1, t2) = "(" ^ string_of_ttype t1 ^ ", " ^ string_of_ttype t2 ^ ")"
and string_of_constraints cs =
  "[ " ^ String.concat " | , | " (List.map string_of_constraint cs) ^ " ]"
and string_of_subs = function
| [] -> ""
(* | (id, tyscm) :: cs -> "(" ^ id  ^ ", " ^ string_of_tyscheme tyscm ^ ") " ^ string_of_constraints cs *)
| (t1, t2) :: cs -> "(" ^ string_of_tyvar t1 ^ ", " ^ string_of_ttype t2 ^ ") " ^ string_of_subs cs
and string_of_context = function
| [] -> ""
| (ident, (tvs, gt)) :: ctx -> "\n=: " ^ ident ^ ", ([" ^ String.concat ", "(List.map string_of_tyvar tvs) ^ "], " ^ string_of_ttype gt ^ ")" ^ string_of_context ctx
and string_of_tyformals (gt, ident) = "(" ^ ident ^ " : " ^ string_of_ttype gt ^ ")"

(* String of a typed expression (texpr) == (type, t-expression) *)
let rec string_of_texpr (typ, exp) = 
  "[" ^ string_of_ttype typ ^ "] " ^ string_of_tx exp
and string_of_tx = function 
  | TLiteral v -> string_of_tvalue v
  | TypedVar id -> id
  | TypedIf (te1, te2, te3) -> 
    "(if "  ^ string_of_texpr te1 ^ " " 
            ^ string_of_texpr te2 ^ " " 
            ^ string_of_texpr te3 ^ ")"
  | TypedApply (f, args) -> 
    "(" ^ string_of_texpr f ^ " [" 
        ^ String.concat " -> " (List.map string_of_texpr args) ^ "])"
  | TypedLet (binds, body) -> 
    let string_of_binding (id, e) = 
            "[" ^ id ^ " " ^ (string_of_texpr e) ^ "]"
    in
    "(let ("  ^ String.concat " " (List.map string_of_binding binds) ^ ") " 
              ^ string_of_texpr body ^ ")"
  | TypedLambda (formals, body) ->
    let formalStringlist = 
      List.map (fun (ty, x) -> string_of_ttype ty ^ " " ^ x) formals in 
    "(lambda (" ^ String.concat ", "  formalStringlist ^ ") " ^ 
    string_of_texpr body ^ ")"
and string_of_tvalue = function
  | TChar c -> String.make 1 c 
  | TInt i -> string_of_int i
  | TBool b -> if b then "#t" else "#f"
  | TRoot tr -> string_of_ttree tr
(* toString for Sast.stree *)
and string_of_ttree = function
  | TLeaf -> "leaf"
  | TBranch (v, sib, child) -> 
        "(tree " ^ string_of_tvalue v ^ " " 
                 ^ string_of_ttree sib ^ " " 
                 ^ string_of_ttree child ^ ")"



(* String of a typed defn (tdefn) *)
let string_of_tdefn = function
    | TVal (id, te) -> "(val " ^ id ^ " " ^ string_of_texpr te ^ ")"
    | TExpr te    -> string_of_texpr te

(* String of the tprog == tdefn list *)
let string_of_tprog tdefns = 
    String.concat "\n" (List.map string_of_tdefn tdefns) ^ "\n"
