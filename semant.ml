(*
fun canonicalize; seems to generate the type variable names;
	'a through 'z
	once those are exhausted, then v1 and up, to infinity

*)

open Ast
open Sast

module StringMap = Map.Make(String)

(* type TConsts = {typ : } *)

(* type grootType = 
				| BoolType 
				| CharType
				| IntType
				| TreeType
 *)
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
	(* let fresh =
  		let k = ref 0 in
    		fun () -> incr k; XType !k
		in *)

	(* let rec generate_constraints expr = match expr with
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
in *)
			

(*handle type-checking for evaluation - make sure the expression returns the
	correct type, build local symbol table and do local type checking*)

	(* Lookup what Ast.typ value that the key name s maps to. *)
	(* let typeof_identifier s = 
		Requires creation of symbols table
		   code for try: StringMap.find s symbols
		try StringMap.find s symbols
		with Not_found -> raise (Failure ("undeclared identifier" ^ s))
	in *)

  (* Collection function declarations for built in prints *)
  let built_in_decls =  
    let add_bind map (name, ty) =  
      StringMap.add 
        name 
        { rettyp = Void;
          fname = name;
          formals = [(ty, "x")];
          locals = [];
          body = [] } 
        map 
    in List.fold_left add_bind StringMap.empty [ ("printi", IType ); 
                                                 ("printc", CType); 
                                                 ("printb", BType) ]
  in

  (* Returns a function from out symbol table *)
  let find_func fname = 
    try StringMap.find fname built_in_decls
    with Not_found -> raise (Failure ("unrecognized function " ^ fname))
  in

	(* Returns the Sast.sexpr (Ast.typ, Sast.sx) version of the given Ast.expr *)
	let rec expr = function
		| Literal(lit)          -> 
      let s = value lit in 
        ((match s with 
            SInt _ -> IType
          | SChar _ -> CType
          | SBool _ -> BType
          | SRoot _ -> TType)
        , SLiteral s)
    | Var(_)                -> raise (Failure ("TODO - expr to sexpr of Var"))
    | If(_, _, _)           -> raise (Failure ("TODO - expr to sexpr of If"))
    | Apply(fname, args)        -> 
            let fd = find_func fname in 
             let formals_length = List.length fd.formals in 
             let param_length = List.length args in 
             if param_length != formals_length 
                then raise (Failure ("expected number of args, but got different number"))
             else 
                let check_call (ft, _) e = 
                  let (et, e') = expr e in 
                  if et = ft then (et, e') else raise 
                  (Failure ("illegal argument found " ^ string_of_typ et 
                    ^ " expected " ^ string_of_typ ft ^ " in " ^ string_of_expr e))
                in
             let args' = List.map2 check_call fd.formals args
             in (fd.rettyp, SApply (fname, args'))
    | Let(_, _)             -> raise (Failure ("TODO - expr to sexpr of Let"))
    | Lambda(_, _)          -> raise (Failure ("TODO - expr to sexpr of Lambda"))
  (* Returns the Sast.svalue version fo the given Ast.value *)
  and value = function 
  	| Char(c)     -> SChar c
    | Int(i)      -> SInt i
    | Bool(b)     -> SBool b
    | Root(_)     -> raise (Failure ("TODO - value to svalue of Root"))
  in

  (* For the given Ast.defn, returns an Sast.sdefn, eventually should call 
  		constraint-generation for type inferencing*)
	let check_defn d = match d with
		| Val (name, e) -> 
				let e' = expr e in 
				SVal(name, e')
		| Expr e      -> SExpr (expr e)
(* 	| Val (name, e) -> generate_constraints e 
		| Expr (e)      -> generate_constraints e
 *)

in List.map check_defn defns 

(* Probably will map a check-function over the defns (defn list : defs) *)
(* check-function will take a defn and return an sdefn *)
