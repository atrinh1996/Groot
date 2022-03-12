(*
fun canonicalize; seems to generate the type variable names;
	'a through 'z
	once those are exhausted, then v1 and up, to infinity

*)

open Ast
open Sast

module StringMap = Map.Make(String)

(* type TConsts = {typ : } *)

type grootType = 
				| BoolType 
				| CharType
				| IntType
				| TreeType

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
<<<<<<< HEAD
	
(* check global bindings - are they of a void type, do they duplicate another,
		previously checked binding?*)


(*add names to symbol table, allow retrieval*)

=======
	let fresh =
  		let k = ref 0 in
    		fun () -> incr k; XType !k
		in

	let rec generate_constraints expr = match expr with
		| Literal v -> 
			let literal_check v = match v with
				| Char _ -> (CType, [])
				| Int  _ -> (IType, [])
				| Bool _ -> (BType, []) 
				| Root r -> 
					let rec tree_check t = match t with
						| Leaf   -> (TType, [])
						| Branch (e, t1, t2) -> 
							let branch_check e t1 t2 =
								let e, c1 = generate_constraints e in
									let t1, c2 = tree_check t1 in 
										let t2, c3 = tree_check t2 in 
											let alpha = fresh () in (TType, [(alpha, e); (TType, t1); (TType, t2)] @ c1 @ c2 @ c3)
							in branch_check e t1 t2
						| _ -> raise (Failure ("You done fucked up the tree."))
					in tree_check r
			in literal_check v
		| If (e1, e2, e3) ->
			(* TODO is there a more OCamlese way to match in assignment, like x, y = generate_constraint e1 *)
			let if_check e1 e2 e3 =
				let t1, c1 = generate_constraints e1 in
					let	t2, c2 = generate_constraints e2 in
						let t3, c3 = generate_constraints e3 in
							let alpha = fresh () in (alpha, [(BType, t1); (alpha, t2); (alpha, t3)] @ c1 @ c2 @ c3)
			in if_check e1 e2 e3
		
			(* | _ -> raise (Failure ("missing case for type checking")) *)
in
			
>>>>>>> c9d0fdd (<feat> (semant.ml sast.ml toplevel.ml ast.ml) generate constrains for literals, trees, and ifs, made fresh func)

(*handle type-checking for evaluation - make sure the expression returns the
	correct type, build local symbol table and do local type checking*)





	let check_defn d = match d with
		| Val (name, e) -> generate_constraints e 
		| Expr (e)      -> generate_constraints e
in List.map check_defn defns 

(* Probably will map a check-function over the defns (defn list : defs) *)
(* check-function will take a defn and return an sdefn *)
