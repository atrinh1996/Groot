
open Ast

module StringMap = Map.Make(String)

let semantic env dlist =

	let check_defn d = match d with
		| Val (_, e) -> raise (Failure ("Val not implemented"))
		| Expr e     -> 
			let check_expr env e = match e with
				| Literal         -> SLiteral(e)
				| Var             -> e
				| If (e1, e2, e3) -> check_expr env e1; check_expr env e2; check_expr env e3; 
				| Apply   -> raise (Failure ("Apply not implemented"))
				| Let     -> raise (Failure ("Let not implemented"))
				| Lambda  -> raise (Failure ("Lambda not implemented"))

in semantic StringMap.empty defns 
