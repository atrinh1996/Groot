
open Ast

module StringMap = Map.Make (String)

exception Type_error of string

type gtype =
  | TYCON of tycon
  | TYVAR of tyvar
  | CONAPP of conapp
and tycon =
  | TInt of int                    								 (** integers [int] *)
  | TBool of bool                  							   (** booleans [bool] *)
  | TChar of char	           								 (** chars    [char] *)
  | TArrow of gtype * gtype                  (** Function type [s -> t] *)
  (* | TTree of gtype * gscheme * gscheme       (** Trees *) *)
and tyvar =
	| TParam of int          (** parameter *)
and conapp = (tycon * gtype list)

(* ty_error msg: reports a type error by raising [Type_error msg]. *)
let type_error msg = raise (Type_error msg)

(* fresh: returns an unused type parameter *)
let fresh =
  let k = ref 0 in
	fun () -> incr k; TParam !k

let solve (cns : 'a list) = 
	let rec solver cns subs =
		match cns with
		| [] -> StringMap.empty
		| (TYVAR k1, TYVAR k2) :: cns -> raise (Type_error "missing case in solver (case 1)")
		| (TYVAR k, TYCON t) :: cns -> raise (Type_error "missing case in solver")
		| (TYVAR k, CONAPP s) :: cns -> raise (Type_error "missing case in solver (case 3)")
		| (TYCON t, TYVAR k) :: cns -> raise (Type_error "same as case 1")
		| (TYCON t1, TYCON t2) :: cns -> raise (Type_error "missing case in solver")
		| (TYCON t, CONAPP s) :: cns -> raise (Type_error "missing case in solver (case 6)")
		| (CONAPP s, TYVAR k) :: cns -> raise (Type_error "same as case 3")
		| (CONAPP s, TYCON t) :: cns -> raise (Type_error "same as case 6")
		| (CONAPP s1, CONAPP s2) :: cns -> raise (Type_error "missing case in solver")
	in solve cns []


(* generate_constraints gctx e: infers the type of expression 'e' and a set of
   constraints, 'gctx' refers to the global context 'e' can refer to *)
let rec generate_constraints gctx e =
	let rec constrain ctx e =
		match e with
		| Literal e -> value e
		| Var _ -> TYVAR (fresh ()), []
		| If (e1, e2, e3) -> raise (Type_error "missing case for If")
		| Apply (_, _) -> raise (Type_error "missing case for Apply")
		| Let (_, _) -> raise (Type_error "missing case for Let")
		| Lambda (_,_) -> raise (Type_error "missing case for Lambda")
		and value v = 
		match v with
		| Int e  ->  TYCON (TInt e), []
		| Char e  -> TYCON (TChar e), []
		| Bool e  -> TYCON (TBool e), []
		and tree t =
		match t with 
		| Leaf 		-> raise (Type_error "missing case for Leaf")
		| Branch (e, t1, t2) -> raise (Type_error "missing case for Branch")
	in constrain gctx e


let type_infer (ctx : 'a StringMap.t ) (d : defn list) =
	raise (Type_error "not yet implemented")