
(* Tinfer.ml will conduct all type inferencing and return an SAST *)

open Ast

(* Create a type exception for compiler to raise in the even of type mismatch*)
exception Type_error of string

(* Create a function to throw type error if one occurs *)
let type_error msg = raise (Type_error msg)

module StringMap = Map.Make(String)

type gtype = 
    | TInt 
    | TChar 
    | TBool 
    | TTree
    | TFunc of (gtype * gtype)
    | TVar of int


let semantic_check defns =
	(* fresh : returns a unique type variable to use as placeholder *)
	let fresh =
		let k = ref 0 in
  		fun () -> incr k; TVar !k 
  	in

	(* generate_constraints : takes environment and expression and returns a tuple of (type_variable, constraint_list) *)
	let rec generate_constraints env expr = match expr with
		| Literal v -> 
			let literal_check v = match v with				(* literal_check : infers the type of a literal and returns a tuple of (gtype, constraint_list) *)
				| Char _ -> (TChar, [])
				| Int  _ -> (TInt, [])
				| Bool _ -> (TBool, []) 
				| Root r -> 
					let rec tree_check t = match t with
						| Leaf -> (TTree, [])
						| Branch (e, t1, t2) -> 
							let branch_check e t1 t2 =
								let e, c1 = generate_constraints env e in
									let t1, c2 = tree_check t1 in 
										let t2, c3 = tree_check t2 in 
											let tau = fresh () in (TTree, [(tau, e); (TTree, t1); (TTree, t2)] @ c1 @ c2 @ c3)
							in branch_check e t1 t2
					in tree_check r
			in literal_check  v
		| If (e1, e2, e3) ->
			let if_check e1 e2 e3 =
				let t1, c1 = generate_constraints env e1 in
					let	t2, c2 = generate_constraints env e2 in
						let t3, c3 = generate_constraints env e3 in
							let tau = fresh () in (tau, [(TBool, t1); (tau, t2); (tau, t3)] @ c1 @ c2 @ c3)
			in if_check e1 e2 e3
    | Var (_) -> (fresh (), [])
    | Apply (e1, e2) -> 
    	let apply_check e1 e2  =
    		let t1, c1 = generate_constraints env e1 in
    			let t2, c2 = generate_constraints env e2 in 
    				let tau = fresh() in (tau, (t1, TFunc(t2, t)) :: c1 @ c2)

    | Let (_, _)   -> raise (Failure ("missing case for type checking"))

    | Lambda (formals , body) ->
			let lambda_check f b = 
  			generate_constraints (List.fold_left (fun acc x -> (fresh (), x)::acc) [] formals) b
  		in lambda_check formals body
	in

	let check_defn env d = match d with
		| Val (_, e) -> generate_constraints env e 
		| Expr (e)   -> generate_constraints env e
	in List.map check_defn defns

	

(* Probably will map a check-function over the defns (defn list : defs) *)
(* check-function will take a defn and return an sdefn *)