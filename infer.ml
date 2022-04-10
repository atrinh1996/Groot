2(* SAST = sdefn list *)
(* sdefn = (id, sexpr *)
(* sexpr = (gtype, sx) *)
(* sx = AST.expr with sexpr inplace of expr *)
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

(* TODO implement this *)
let sub (theta : (tyvar * gtype) list) (cns : (gtype * gtype) list) =
	(* sub1 takes in a single constraint and updates it with any substitutions in theta *)
	let sub1 cn = 
		List.fold_left 
			(fun (acc : (gtype * gtype)) (one_sub : tyvar * gtype) ->
				match acc with
				| (TYVAR t1, TYVAR t2) -> 
		      (if (fst one_sub = t1) then (snd one_sub, snd acc)
					else if (fst one_sub = t2) then (fst acc, snd one_sub)
					else acc)
				| (TYVAR t1, _) -> 
		      (if (fst one_sub = t1) then (snd one_sub, snd acc)
					else acc)
				| (_, TYVAR t2) -> 
		      (if (fst one_sub = t2) then (fst acc, snd one_sub)
					else acc)
			| (_, _) -> acc)
			cn theta in 
	List.map sub1 cns

(* onesub theta1  = {x, y}
acc theta2 = {z, n} -> {y, n} *)

(* TODO implement this. Can it be the same as sub or use it somehow? *)
(* currently applies the substitutions in theta1 to theta2 but TODO do we have
   to reverse it? *)
let compose theta1 theta2 =
		let sub1 cn = 
			List.fold_left 
			(fun (acc : tyvar * gtype) (one_sub : tyvar * gtype) ->
				match acc, one_sub with
				| (a1, TYVAR a2), (s1, TYVAR s2) -> 
		      	if s1 = a1 then 
		      	(s1, 
		      	snd acc)
						else if fst one_sub = a2 then fst acc, snd one_sub
						else acc
				| (a1, _), (s1, TYVAR s2) -> 
			      if (s1 = a1) then (s1, snd acc)
						else acc
		    | (a1,_) , _ -> acc
		  )
			cn theta1 in 
	List.map sub1 theta2


let rec solve' c1 = 
	match c1 with
	| (TYVAR t1, TYVAR t2) -> [(t1, TYVAR t2)]
	| (TYVAR t, TYCON c) -> [(t, TYCON c)]
	| (TYVAR t, CONAPP a) -> 	
			if (List.fold_left (fun acc x -> (is_free_type_var t x || acc)) false (snd a)) 
															then raise (Type_error "type error")
															else [(t, CONAPP a)]
	| (TYCON c, TYVAR t) -> solve' (TYVAR t, TYCON c)
	| (TYCON c1, TYCON c2) -> 
					if c1 = c2 
						then []
						else raise (Type_error "type error: (tycon,tycon)")
	| (TYCON c, CONAPP a) -> raise (Type_error "type error: (tycon, conapp")
	| (CONAPP a, TYVAR t) -> solve' (TYVAR t, CONAPP a)
	| (CONAPP a, TYCON c) -> raise (Type_error "type error: (conapp, tycon")
	| (CONAPP a1, CONAPP a2) -> solve ((List.combine (snd a1) (snd a2)) @ [((TYCON (fst a1), TYCON (fst a2)))])


and solve (constraints : (gtype * gtype) list) = 
	let rec solver cns (subs : (tyvar * gtype) list) =
		match cns with
		| [] -> []
		| cn :: cns -> 	
			let theta1 = solve' cn in 						 	
			let theta2 = solve (sub theta1 cns) in
			compose theta2 theta1
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
