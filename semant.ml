(*
fun canonicalize; seems to generate the type variable names;
	'a through 'z
	once those are exhausted, then v1 and up, to infinity

*)

open Ast
open Sast

module StringMap = Map.Make(String)

(* Takes an Ast (defn list) and will return an Sast (sdefn list) *)
(* 

type defn = 
	| Val of ident * expr
	| Expr of expr

type sdefn = 
  | SVal of ident * sexpr
  | SExpr of sexpr

type sexpr = Ast.typ * Sast.sx

*)

let semantic_check (defns) =
	
(* check global bindings - are they of a void type, do they duplicate another,
		previously checked binding?*)


(*add names to symbol table, allow retrieval*)


(*handle type-checking for evaluation - make sure the expression returns the
	correct type, build local symbol table and do local type checking*)





	let check_defn d = match d with
		| Val (name, e) -> raise (Failure ("TODO - check_defn in Val"))
		| Expr (e)      -> raise (Failure ("TODO - check_defn in Expr"))
in List.map check_defn defns 

(* Probably will map a check-function over the defns (defn list : defs) *)
(* check-function will take a defn and return an sdefn *)
