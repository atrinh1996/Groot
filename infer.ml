
open Ast

module StringMap = Map.Make (String)

exception Type_error of string

type gtype =
  | TYCON of tycon
  | TYVAR of tyvar
  | CONAPP of conapp
and tycon =
  | TInt                    								 (** integers [int] *)
  | TBool                  							   (** booleans [bool] *)
  | TChar           								 (** chars    [char] *)
  | TArrow of gtype * gtype                  (** Function type [s -> t] *)
  (* | TTree of gtype * gscheme * gscheme       (** Trees *) *)
and tyvar =
	| TParam of int          (** parameter *)
and conapp = (tycon * gtype list)

module TypeSet = Set.Make (
	struct
		let compare = Pervasives.compare
		type t = gtype  
	end )

(* ty_error msg: reports a type error by raising [Type_error msg]. *)
let type_error msg = raise (Type_error msg)

let rec is_free_type_var var gt = 
	match gt with
	| TYCON _ -> false
	| TYVAR tvar -> var = tvar
	| CONAPP tcon -> List.fold_left 
		(fun acc x -> is_free_type_var var x || acc)
		false
		(snd tcon)

(* fresh: returns an unused type parameter *)
let fresh =
  let k = ref 0 in
	fun () -> incr k; TParam !k

let solve (constraints : 'a list) = 
	let rec solver cns (subs : (tyvar * gtype) list) =
		match cns with
		| [] -> []
		| (TYVAR t1, TYVAR t2) :: cns ->  solver cns ((t1, TYVAR t2)::subs)
		| (TYVAR t, TYCON c) :: cns -> solver cns ((t, TYCON c)::subs)
		(* TODO is there a cleaner way to do this? *)
		| (TYVAR t, CONAPP a) :: cns -> 
				if (List.fold_left (fun acc x -> (is_free_type_var t x || acc)) false (snd a)) 
				then raise (Type_error "type error")
				else solver cns ((t, CONAPP a)::subs)
		| (TYCON c, TYVAR t) :: cns -> solver cns ((t, TYCON c)::subs)
		| (TYCON c1, TYCON c2) :: cns -> 
				if c1 = c2 
				then solver cns subs 
				else raise (Type_error "type error: (tycon,tycon)")
		| (TYCON c, CONAPP a) :: cns -> raise (Type_error "type error: (tycon, conapp")
		| (CONAPP a, TYVAR t) :: cns -> solver ((TYVAR t, CONAPP a)::cns) subs
		| (CONAPP a, TYCON c) :: cns -> raise (Type_error "type error: (conapp, tycon")
		| (CONAPP a1, CONAPP a2) :: cns -> solver ((List.combine (snd a1) (snd a2)) @ ((TYCON (fst a1), TYCON (fst a2))::cns)) subs

	in solver constraints []


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
		| Int e ->  TYCON TInt, []
		| Char e -> TYCON TChar, []
		| Bool e -> TYCON TBool, []
		and tree t =
		match t with 
		| Leaf -> raise (Type_error "missing case for Leaf")
		| Branch (e, t1, t2) -> raise (Type_error "missing case for Branch")
	in constrain gctx e


let type_infer (ctx : 'a StringMap.t ) (d : defn list) =
	raise (Type_error "not yet implemented")
