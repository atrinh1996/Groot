(* SAST = sdefn list *)
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
  | TInt                    								 			(** integers [int] *)
  | TBool                  							  				(** booleans [bool] *)
  | TChar           								 							(** chars    [char] *)
  | TArrow of gtype            			(** Function type [s -> t] *)
  (* | TTree of gtype * gscheme * gscheme       	(** Trees *) *)
and tyvar =
	| TVar of int          (** parameter *)
and conapp = (tycon * gtype list)

type tyscheme = (tyvar list * gtype)

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
	| CONAPP tcon -> 
		List.fold_left (fun acc x -> is_free_type_var var x || acc) false (snd tcon)

(* fresh: returns an unused type parameter *)
let fresh =
  let k = ref 0 in
	fun () -> incr k; TVar !k

let sub (theta : (tyvar * gtype) list) (cns : (gtype * gtype) list) =
	(* sub1 takes in a single constraint and updates it with any substitutions in theta *)
	let sub1 cn = 
		List.fold_left 
			(fun (acc : (gtype * gtype)) (one_sub : tyvar * gtype) ->
				match acc with
				| (TYVAR t1, TYVAR t2) -> 
		      if (fst one_sub = t1) then (snd one_sub, snd acc)
					else if (fst one_sub = t2) then (fst acc, snd one_sub)
					else acc
				| (TYVAR t1, _) -> 
		      if (fst one_sub = t1) then (snd one_sub, snd acc)
					else acc
				| (_, TYVAR t2) -> 
		      if (fst one_sub = t2) then (fst acc, snd one_sub)
					else acc
			| (_, _) -> acc)
			cn theta in 
	List.map sub1 cns

(* currently applies the substitutions in theta1 to theta2 but TODO do we have
   to reverse it? *)
let compose theta1 theta2 =
	let sub1 cn = 
		List.fold_left 
		(fun (acc : tyvar * gtype) (one_sub : tyvar * gtype) ->
			match acc, one_sub with
			| (a1, TYVAR a2), (s1, TYVAR s2) -> 
	      	if a1 = s1 then (s1, snd acc)
					else if s1 = a2 then (a1, snd one_sub)
					else acc
			| (a1, a2), (s1, TYVAR s2) -> 
		      if (a1 = s1) then (s1, a2)
					else acc
	    | (a1,_), _ -> acc
	  )
		cn theta1 in 
	List.map sub1 theta2


let rec solve' c1 = 
	match c1 with
	| (TYVAR t1, TYVAR t2) -> [(t1, TYVAR t2)]
	| (TYVAR t, TYCON c) -> [(t, TYCON c)]
	| (TYVAR t, CONAPP a) -> 	
			if List.fold_left 
				(fun acc x -> (is_free_type_var t x || acc)) false (snd a)
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
(* let functiontype resultType formalsTypes = CONAPP (TArrow , formalsTypes @ [resultType])  *)

let rec generate_constraints gctx e =
	let rec constrain ctx e =
		match e with
		| Literal e -> value e
		| Var name -> 
			let (_, (_, tau)) = List.find (fun x -> fst x = name) ctx in
			(tau, [])
		| If (e1, e2, e3) -> 
			let t1, c1 = generate_constraints gctx e1 in
			let t2, c2 = generate_constraints gctx e2 in
			let t3, c3 = generate_constraints gctx e2 in
			(t3, [((TYCON TBool), t1); (t3, t2)] @ c1 @ c2 @ c3)
		| Apply (name, formals) ->
			let t1, c1 = generate_constraints ctx name in
			let ts2, c2 = List.fold_left 
				(fun acc e -> 
					let t, c = generate_constraints ctx e in 
					let ts, cs = acc in (t::ts, c @ cs)
				) ([], c1)
				formals in
			let retType = TYVAR (fresh()) in 
			(retType, (t1, (CONAPP (TArrow retType, ts2)))::c2)
		| Let (_, _) -> raise (Type_error "missing case for Let")
		| Lambda (f,b) -> 
			generate_constraints (List.fold_left 
				(fun acc x -> (x, ([(fresh ())], TYVAR (fresh ())))::acc) ctx f) b
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

let rec ftvs (ty : gtype) = 
	match ty with
	| TYVAR t -> [t]
	| TYCON c -> []
	| CONAPP a -> List.fold_left (fun acc x -> acc @ (ftvs x)) [] (snd a)

(* let subst (theta : (tyvar * gtype) list) (t : gtype) (ftvs: tyvar list) =
	match t with
	| TYVAR t -> List.find (fun (x : tyvar * gtype) -> x = (t, TYVAR t)) theta
	| TYCON c -> (TYCON c, t)
	| CONAPP a -> (CONAPP a, t) *)

let rec tysubst (theta: (tyvar * gtype) list) (t : gtype) (ftvs: tyvar list) =
	match t with
	| TYVAR t -> let (alpha, tau) = List.find (fun (x : tyvar * gtype) -> (fst x) = t) theta in if (List.exists (fun x -> x = t) ftvs) then tau else TYVAR t 
	| TYCON c -> TYCON c
	| _ -> raise (Type_error "missing case for CONAPP")
	(* | CONAPP a -> CONAPP ((tysubst theta (fst a) ftvs), List.map (fun x -> tysubst theta x ftvs) (snd a)) *)

let rec sub_theta_into_gamma (theta : (tyvar * gtype) list) (gamma : (ident * tyscheme) list) = 
	match gamma with
		| [] -> []
		| (g :: gs) -> 
			let (name, tysch) = g in
			let (bound_types, btypes) = tysch in
			let freetypes = List.filter (fun (x : tyvar) -> List.exists (fun (y : tyvar) -> y = x) bound_types) (ftvs btypes) in
			let new_btype = tysubst theta btypes freetypes in
			(name, (bound_types, new_btype)) :: sub_theta_into_gamma theta gs 

(* type_infer should resturn a list of tasts *)
(* TAST = [ tdefns ] *)
(* defn list = [ (ident, expr) | expr ]*)
let rec type_infer (ctx : (ident * tyscheme) list ) (d : defn list) =
	match d with
	| [] -> []
	| Val (name, e)::ds -> 
		let (t, c) = generate_constraints ctx e in
		let new_ctx = (name, (List.filter (fun (x : tyvar) -> List.exists (fun (y : tyvar) -> y = x) (ftvs t)) (ftvs t), t)) :: ctx in
		type_infer new_ctx ds
	| Expr (e)::ds ->
		let (t, c) = generate_constraints ctx e in 
		(t, c) :: type_infer ctx ds
 

(* Below lies Nick's futile attempt at printing *)	

type texpr = gtype * tx
	and tx = 
		| TLiteral of tvalue
		| TVar     of ident
		| TIf      of texpr * texpr * texpr
		| TApply   of texpr * texpr list
		| TLet     of (ident * texpr) list * texpr
		| TLambda  of ident list * texpr
	and tvalue = 
		| TChar    of char
		| TInt     of int
		(* | Float   of float *)
		| TBool    of bool
		| TRoot    of ttree
	and ttree =  
		| TLeaf
		| TBranch of tvalue * ttree * ttree

type tdefn = 
	| TVal of ident * texpr
	| TExpr of texpr
	
type tprog = tdefn list	
	
let rec string_of_typ = function
  | TYCON ty -> string_of_tycon ty
  | TYVAR tp -> string_of_tyvar tp
  | CONAPP con -> string_of_conapp con
and string_of_tycon = function 
  | TInt -> "int"
  | TBool -> "bool"
  | TChar -> "char"
  (* | TArrow (retty, argsty) -> string_of_typ retty ^ " (" ^ String.concat " " (List.map string_of_typ argsty) ^ ")"  *)
and string_of_tyvar = function 
  | TVar n -> string_of_int n
and string_of_conapp (tyc, tys) = 
  string_of_tycon tyc ^ " " ^ String.concat " " (List.map string_of_typ tys)

let rec string_of_texpr (t, s) = 
	"[" ^ string_of_typ t ^ ": " ^ string_of_tx s ^ "]"
and string_of_tx = function
	| TLiteral v -> string_of_tvalue v
	| TVar n -> string_of_tyvar (TVar (int_of_string n))
	| TIf (e1, e2, e3) -> "if " ^ string_of_texpr e1 ^ " then " ^ string_of_texpr e2 ^ " else " ^ string_of_texpr e3
	(* | TApply (f, a) -> "(" ^ string_of_texpr f ^ " " ^ String.concat " " (List.map string_of_texpr a) ^ ")" *)
	(* | TLet (binds, body) -> "let " ^ String.concat " " (List.map string_of_tvalue (TVal binds)) ^ " in " ^ string_of_texpr body
	| TLambda (formals, body)-> "\\" ^ String.concat " " (List.map string_of_tx formals) ^ " -> " ^ string_of_texpr body *)
and string_of_tvalue = function
	| TChar c -> string_of_tycon (TChar)
	| TInt i -> string_of_int i
	| TBool b -> string_of_bool b
	| TRoot t -> string_of_ttree t
and string_of_ttree = function
	| TLeaf -> "SLeaf"
	| TBranch (v, l, r) -> "SBranch " ^ string_of_tvalue v ^ " " ^ string_of_ttree l ^ " " ^ string_of_ttree r

let string_of_tdefn = function 
	| TVal(id, e) -> "(val " ^ id ^ " " ^ string_of_texpr e ^ ")"
	| TExpr e -> string_of_texpr e

let rec string_of_constraints = function
	| [] -> ""
	| (f, s)::cs -> "(" ^ string_of_typ f ^ ", " ^ string_of_typ s ^ ") " ^ string_of_constraints cs

(* ('a, [(TBool, TBool) ('a, 'a)] *)
let rec string_of_gencons = function
	| [] -> ""
	| (g, lcons)::gs -> "(" ^ string_of_typ g ^ ", " ^ string_of_constraints lcons ^ ") " ^ string_of_gencons gs

let rec string_of_tprog tdefns =
	String.concat "\n" (List.map string_of_tdefn tdefns) ^ "\n"
