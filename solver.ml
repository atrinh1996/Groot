
open Infer

let solve cons = 
	let rec solve subs cons = match cs with
		| [] -> true
		| c::cons -> match c with
			| (TVar, e) -> solve_constraints e


	in solve_constraints [] Infer.type_infer
