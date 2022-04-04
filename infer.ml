
open Ast


exception Type_error of string

(* ty_error msg: reports a type error by raising [Type_error msg]. *)
let type_error msg = raise (Type_error msg)

(* fresh: returns an unused type parameter *)
let fresh =
  let k = ref 0 in
    fun () -> incr k; TParam !k

(* generate_constraints gctx e: infers the type of expression 'e' and a set of
   constraints, 'gctx' refers to the global context 'e' can refer to *)
let generate_constraints gctx e =
	let constrain ctx e =
	match e with
	| Int  _  -> TInt, []
	| Char _  -> TChar, []
	| Bool _  -> TBool, []
