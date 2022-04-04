
(* infer.ml will conduct all type inferencing and pass off a list of (TVar,
   [constraints]) *)

(*CONAPP -> u * ty list *)

open Ast

(* Create a type exception for compiler to raise in the even of type mismatch*)
exception Type_error of string

(* Create a function to throw type error if one occurs *)
let type_error msg = raise (Type_error msg)

(* module StringMap = Map.Make(String) *) (* Do we need this? *)

type tycon = 
  | TInt
  | TChar 
  | TBool 
  (* | TTree *)
  | TFunc

type typeScheme = 
	| TVar   of int
	| TYCON  of tycon
	| CONAPP of tycon * typeScheme list

let functiontype resultType formalsTypes = CONAPP (TFunc, formalsTypes @ [resultType]) 

(* type_infer: 'a list -> 'b list *)
let type_infer defns =
	(* fresh : returns a unique type variable to use as placeholder *)
	let fresh =
		let k = ref 0 in
		fun () -> incr k; TVar !k in

	(* generate_constraints : takes environment and expression and returns a tuple
		 of (type_variable, constraint_list) *)
	let rec generate_constraints env expr =
		match expr with
		| Literal v ->
			(match v with
			| Char _ -> (TChar, [])
			| Int  _ -> (TInt, [])
			| Bool _ -> (TBool, [])
(* 			| Root r ->
				let rec tree_check t =
					(match t with
					| Leaf -> (TTree, [])
					| Branch (e, t1, t2) -> 
							let (e, c1) = generate_constraints env e in
							let (t1, c2) = tree_check t1 in 
							let (t2, c3) = tree_check t2 in 
							let tau = fresh () in
							(TTree,[(tau, e); (TTree, t1); (TTree, t2)] @ c1 @ c2 @ c3)
					) in
					tree_check r *)
			)
		| If (e1, e2, e3) ->
				let t1, c1 = generate_constraints env e1 in
				let t2, c2 = generate_constraints env e2 in
				let t3, c3 = generate_constraints env e3 in
				(t3, [(TBool, t1); (t3, t2)] @ c1 @ c2 @ c3);
    | Var (_) -> (fresh (), [])
    | Apply (e1, es) -> 
    		let t1, c1 = generate_constraints env e1 in
  			let ts2, c2 = List.fold_left (fun acc e -> let t, c = generate_constraints env e in 
				let ts, cs = acc in t::ts, c::cs) [] es in
				let retType = fresh() in (retType, (t1, functiontype resultType ts2) @ c1 @ c2)
    | Let (_, _)   -> raise (Failure ("missing case for type checking"))
    | Lambda (formals , body) -> (* TODO - Lambda need fixing *)
				generate_constraints (List.fold_left (fun acc x -> (fresh (), x)::acc) [] f) b
	in

	(* check_defn : 'a list -> 'b list -> 'c list *)
	let check_defn env d =
		match d with
		| Val (_, e) -> generate_constraints env e 
		| Expr (e)   -> generate_constraints env e
	in List.fold_left check_defn [] defns
	(* TODO - Above line need fixing *)
			

(* Probably will map a check-function over the defns (defn list : defs) *)
(* check-function will take a defn and return an sdefn *)