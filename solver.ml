
open Infer

let solve cons = 
	let rec solve_constraints subs cons =
	match cons with
	| [] -> true
	| c::cons -> 
		match c with
	 	| (TVar, e) -> solve_constraints e
	 	| (TFunc, e) -> 


	in solve_constraints [] Infer.type_infer
