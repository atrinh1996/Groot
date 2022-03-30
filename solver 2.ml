
open Infer

let rec solve_constraints sub cs = match cs with
	| [] -> true
	| c::cs -> match c with
		| (TVar, e) -> solve_constraints e


in solve_constraints [] Infer.semantic_check
