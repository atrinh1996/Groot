
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
    | TVar of int

let semantic_check defns =

	let fresh =
		let k = ref 0 in
  		fun () -> incr k; TVar !k
	in

	let rec generate_constraints env expr = match expr with
		| Literal v -> 
			let literal_check v = match v with
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
			in literal_check v
		| If (e1, e2, e3) ->
			let if_check e1 e2 e3 =
				let t1, c1 = generate_constraints env e1 in
					let	t2, c2 = generate_constraints env e2 in
						let t3, c3 = generate_constraints env e3 in
							let tau = fresh () in (tau, [(TBool, t1); (tau, t2); (tau, t3)] @ c1 @ c2 @ c3)
			in if_check e1 e2 e3
    | Var (_) -> (fresh (), [])
    | Apply (_, _) -> raise (Failure ("missing case for type checking"))
    | Let (_, _)   -> raise (Failure ("missing case for type checking"))
    | Lambda (formals , body) ->
    		generate_constraints ((List.fold_left (fun acc n -> (fresh (), n)::acc)) formals []) body
  in
			

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
	(* let rec expr = function
                                (* Problem - I force the Ast.typ to be Integer *)
		| Literal(lit)          -> (IType, SLiteral(value lit))
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
  in *)

  (* For the given Ast.defn, returns an Sast.sdefn *)
	let check_defn d = match d with
(*
		| Val (name, e) -> 
				let e' = expr e in 
				SVal(name, e')
		| Expr (_)      -> raise (Failure ("TODO - check_defn in Expr"))
*)
		| Val (_, e) -> generate_constraints StringMap.empty e 
		| Expr (e)   -> generate_constraints StringMap.empty e
	in List.map check_defn defns 
	
semantic_check defns 

(* Probably will map a check-function over the defns (defn list : defs) *)
(* check-function will take a defn and return an sdefn *)
