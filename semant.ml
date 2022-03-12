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

type typ = Integer | Character | Boolean

*)

let semantic_check (defns) =
	
(* check global bindings - are they of a void type, do they duplicate another,
		previously checked binding?*)


(*add names to symbol table, allow retrieval*)
(* let symbols = StringMap.empty in *)


(*handle type-checking for evaluation - make sure the expression returns the
	correct type, build local symbol table and do local type checking*)

	(* Lookup what Ast.typ value that the key name s maps to. *)
	(* let typeof_identifier s = 
		Requires creation of symbols table
		   code for try: StringMap.find s symbols
		try StringMap.find s symbols
		with Not_found -> raise (Failure ("undeclared identifier" ^ s))
	in *)

	(* Returns the Sast.sexpr (Ast.typ, Sast.sx) version of the given Ast.expr *)
	let rec expr = function
                                (* Problem - I force the Ast.typ to be Integer *)
		| Literal(lit)          -> (Integer, SLiteral(value lit))
    | Var(_)                -> raise (Failure ("TODO - expr to sexpr of Var"))
    | If(_, _, _)           -> raise (Failure ("TODO - expr to sexpr of If"))
    | Apply(_, _)           -> raise (Failure ("TODO - expr to sexpr of Apply"))
    | Let(_, _)             -> raise (Failure ("TODO - expr to sexpr of Let"))
    | Lambda(_, _)          -> raise (Failure ("TODO - expr to sexpr of Lambda"))
  (* Returns the Sast.svalue version fo the given Ast.value *)
  and value = function 
  	| Char(_)     -> raise (Failure ("TODO - value to svalue of Char"))
    | Int(i)      -> SInt i
    | Bool(_)     -> raise (Failure ("TODO - value to svalue of Bool"))
    | Root(_)     -> raise (Failure ("TODO - value to svalue of Root"))
  in

  (* For the given Ast.defn, returns an Sast.sdefn*)
	let check_defn d = match d with
		| Val (name, e) -> 
				(* let t = typeof_identifier name in  *)
				let e' = expr e in 
				SVal(name, e')
		| Expr (_)      -> raise (Failure ("TODO - check_defn in Expr"))

in List.map check_defn defns 

(* Probably will map a check-function over the defns (defn list : defs) *)
(* check-function will take a defn and return an sdefn *)
