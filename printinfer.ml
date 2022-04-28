(* Below lies Nick's futile attempt at printing *)	
open Ast 
open Type


type texpr = gtype * tx
	and tx = 
		| TLiteral of tvalue
		| TVar     of ident
		| TIf      of texpr * texpr * texpr
		| TApply   of texpr * texpr list
		| TLet     of (ident * texpr) list * texpr
		| TLambda  of ident list * texpr
	and tvalue = 
		| TChar    of char
		| TInt     of int
		(* | Float   of float *)
		| TBool    of bool
		| TRoot    of ttree
	and ttree =  
		| TLeaf
		| TBranch of tvalue * ttree * ttree

type tdefn = 
	| TVal of ident * texpr
	| TExpr of texpr
	
type tprog = tdefn list	
	
let rec string_of_typ = function
  | TYCON ty -> string_of_tycon ty
  | TYVAR tp -> string_of_tyvar tp
  | CONAPP con -> string_of_conapp con
and string_of_tycon = function 
  | TInt -> "int"
  | TBool -> "bool"
  | TChar -> "char"
  | TArrow a -> string_of_typ (a)
and string_of_tyvar = function 
  | TVar n -> "tyvar" ^ string_of_int n
and string_of_conapp (tyc, tys) = 
  "conapp: " ^ string_of_tycon tyc ^ " " ^ String.concat " " (List.map string_of_typ tys)
and string_of_constraints = function
	| [] -> ""
	| (f, s)::cs -> "(" ^ string_of_typ f ^ ", " ^ string_of_typ s ^ ") " ^ string_of_constraints cs
and string_of_gencons = function
	| [] -> ""
	| (g, lcons)::gs -> "(" ^ string_of_typ g ^ ", " ^ string_of_constraints lcons ^ ") " ^ string_of_gencons gs

let rec string_of_texpr (t, s) = 
	"[" ^ string_of_typ t ^ ": " ^ string_of_tx s ^ "]"
and string_of_tx = function
	| TLiteral v -> string_of_tvalue v
	| TVar n -> string_of_tyvar (TVar (int_of_string n))
	| TIf (e1, e2, e3) -> "if " ^ string_of_texpr e1 ^ " then " ^ string_of_texpr e2 ^ " else " ^ string_of_texpr e3
	| TApply (rt, (ft)) -> "(" ^ string_of_texpr rt ^ ", " ^ String.concat " " (List.map string_of_texpr ft) ^ ")"
	(* | TLet (binds, body) -> "let " ^ String.concat " " (List.map string_of_tvalue (TVal binds)) ^ " in " ^ string_of_texpr body *)
	(* | TLambda (formals, body)-> "\\" ^ String.concat " " (List.map string_of_tx formals) ^ " -> " ^ string_of_texpr body *)
and string_of_tvalue = function
	| TChar c -> string_of_tycon (TChar)
	| TInt i -> string_of_int i
	| TBool b -> string_of_bool b
	| TRoot t -> string_of_ttree t
and string_of_ttree = function
	| TLeaf -> "SLeaf"
	| TBranch (v, l, r) -> "SBranch " ^ string_of_tvalue v ^ " " ^ string_of_ttree l ^ " " ^ string_of_ttree r

let string_of_tdefn = function 
	| TVal(id, e) -> "(val " ^ id ^ " " ^ string_of_texpr e ^ ")"
	| TExpr e -> string_of_texpr e

let rec string_of_tprog tdefns =
	String.concat "\n" (List.map string_of_tdefn tdefns) ^ "\n"
