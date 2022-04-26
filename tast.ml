(*
    TAST
    Type inference.  
*)

open Ast

exception Type_error of string

let type_error msg = raise (Type_error msg)

type gtype =
  | TYCON of tycon
  | TYVAR of tyvar
  | CONAPP of conapp
and tycon =
  | TInt 
  | TBool 
  | TChar 
  | TArrow of gtype 
and tyvar =
  | TVariable of int 
and conapp = (tycon * gtype list)

type tyscheme = (tyvar list * gtype)


let inttype = TYCON TInt 
let chartype = TYCON TChar
let booltype = TYCON TBool
let functiontype resultType formalsTypes = 
        CONAPP (TArrow resultType, formalsTypes)
(* let functiontype resultType formalsTypes = CONAPP (TArrow resultType, formalsTypes) *)
(* let funtype resultType formalsTypes = CONAPP (TArrow resultType, formalsTypes) *)

(* TAST expression *)
type texpr = gtype * tx
and tx = 
    | TLiteral     of tvalue
    | TypedVar     of ident
    | TypedIf      of texpr * texpr * texpr
    | TypedApply   of texpr * texpr list
    | TypedLet     of (ident * texpr) list * texpr
    | TypedLambda  of (gtype * ident) list * texpr
    (* | TypedLambda  of (tyvar list * ident list) * texpr *)
and tvalue = 
    | TChar    of char
    | TInt     of int
    | TBool    of bool
    | TRoot    of ttree
and ttree =  
    | TLeaf
    | TBranch of tvalue * ttree * ttree


type tdefn = 
    | TVal of ident * texpr
    | TExpr of texpr


type tprog = tdefn list 



(* Pretty printer *)

(* String of gtypes *)
let rec string_of_ttype = function 
  | TYCON ty -> string_of_tycon ty
  | TYVAR tp -> string_of_tyvar tp
  | CONAPP con -> string_of_conapp con
and string_of_tycon = function 
  | TInt -> "int"
  | TBool -> "bool"
  | TChar -> "char"
  | TArrow (retty) -> string_of_ttype retty 
and string_of_tyvar = function
  | TVariable n -> string_of_int n
and string_of_conapp (tyc, tys) = 
    string_of_tycon tyc ^ " (" ^ String.concat " " (List.map string_of_ttype tys) ^ ")"


(* String of a typed expression (texpr) == (type, t-expression) *)
let rec string_of_texpr (typ, exp) = 
    "[" ^ string_of_ttype typ ^ "] " ^ string_of_tx exp
and string_of_tx = function 
    TLiteral v -> string_of_tvalue v
  | TypedVar id -> id
  | TypedIf (te1, te2, te3) -> 
      "(if "  ^ string_of_texpr te1 ^ " " 
              ^ string_of_texpr te2 ^ " " 
              ^ string_of_texpr te3 ^ ")"
  | TypedApply (f, args) -> 
      "(" ^ string_of_texpr f ^ " " 
          ^ String.concat " " (List.map string_of_texpr args) ^ ")"
  | TypedLet (binds, body) -> 
      let string_of_binding (id, e) = 
              "[" ^ id ^ " " ^ (string_of_texpr e) ^ "]"
      in
      "(let ("  ^ String.concat " " (List.map string_of_binding binds) ^ ") " 
                ^ string_of_texpr body ^ ")"
  | TypedLambda (formals, body) ->
      (* let (tys, names) = List.split formals in 
      "(lambda (" ^ (List.fold_left2 (fun space ty para -> string_of_ttype ty ^ space ^ para) " " tys names) ^ ") " 
                  ^ string_of_texpr body ^ ")" *)
    let formalStringlist = List.map (fun (ty, x) -> string_of_ttype ty ^ " " ^ x) formals in 
    "(lambda (" ^ String.concat ", "  formalStringlist
            ^ ") " ^ string_of_texpr body ^ ")"
(* toString for Sast.svalue *)
and string_of_tvalue = function
    TChar c -> String.make 1 c 
  | TInt i -> string_of_int i
  | TBool b -> if b then "#t" else "#f"
  | TRoot tr -> string_of_ttree tr
(* toString for Sast.stree *)
and string_of_ttree = function
    TLeaf -> "leaf"
  | TBranch (v, sib, child) -> 
        "(tree " ^ string_of_tvalue v ^ " " 
                 ^ string_of_ttree sib ^ " " 
                 ^ string_of_ttree child ^ ")"



(* String of a typed defn (tdefn) *)
let string_of_tdefn = function
    | TVal (id, te) -> "(val " ^ id ^ " " ^ string_of_texpr te ^ ")"
    | TExpr te    -> string_of_texpr te

(* String of the tprog == tdefn list *)
let string_of_tprog tdefns = 
    String.concat "\n" (List.map string_of_tdefn tdefns) ^ "\n"

(* Semantically-checked Abstract Syntax Tree and functions for printing it *)

(* open Ast *)



(* type gtype =
    TYCON of tycon
  | TYVAR of tyvar
  | CONAPP of conapp 
and tycon =  
    TInt  
  | TChar 
  | TBool 
  | TArrow of gtype * gtype list
and tyvar = 
    TParam of int
and conapp = (tycon * gtype list)

let inttype = TYCON TInt 
let chartype = TYCON TChar
let booltype = TYCON TBool

let funtype (res, args) = TYCON (TArrow (res, args)) *)



(* let inttype     = TYCON "int"
let booltype    = TYCON "bool"
let chartype    = TYCON "char"
let treetype ty = CONAPP (TYCON "tree", [ty])
let funtype (args, res) = 
  CONAPP (TYCON "function", [CONAPP (TYCON "arguments", args); res]) *)

(* and tycon =
  | TInt                                     (** integers [int] *)
  | TBool                                  (** booleans [bool] *)
  | TChar                            (** chars    [char] *)
  | TArrow of gtype * gtype  *)                 (** Function type [s -> t] *)
  (* | TTree of gtype * gscheme * gscheme       (** Trees *) *)
(* and tyvar =
  | TParam of int  *)         (** parameter *)
(* and conapp = (tycon * gtype list) *)


(* NOTE: SEXPR is a tupe of SAST.gtype * SEXPRESSION (sx) *)
(* type sexpr = gtype * sx
and sx = 
    SLiteral of svalue
  | SVar     of ident
  | SIf      of sexpr * sexpr * sexpr
  | SApply   of sexpr * sexpr list
  | SLet     of (ident * sexpr) list * sexpr
  | SLambda  of (gtype * ident) list * sexpr
and svalue = 
    SChar    of char
  | SInt     of int
  | SBool    of bool
  | SRoot    of stree
and stree =  
    SLeaf
  | SBranch of svalue * stree * stree *)
  (* NOTE: the sastSBranch  does not store sexpr, not directly analogous to AST Branch *)

(* type sdefn = 
  | SVal of ident * sexpr
  | SExpr of sexpr

type sprog = sdefn list
 *)

(* Pretty printing functions *)

(* toString for Sast.gtype *)
(* let rec string_of_typ = function
    TYCON ty -> string_of_tycon ty
  | TYVAR tp -> string_of_tyvar tp
  | CONAPP con -> string_of_conapp con
and string_of_tycon = function 
    TInt            -> "int"
  | TBool           -> "bool"
  | TChar           -> "char"
  | TArrow (retty, argsty) -> string_of_typ retty ^ " (" ^ String.concat " " (List.map string_of_typ argsty) ^ ")" 
and string_of_tyvar = function 
    TParam n -> string_of_int n
and string_of_conapp (tyc, tys) = 
  string_of_tycon tyc ^ " " ^ String.concat " " (List.map string_of_typ tys) *)




(* toString for Sast.sexpr *)
(* let rec string_of_sexpr (t, s) = 
    "[" ^ string_of_typ t ^ ": " ^ string_of_sx s ^ "]"
(* toString for Sast.sx *)
and string_of_sx = function 
    SLiteral v -> string_of_svalue v
  | SVar id -> id
  | SIf(se1, se2, se3) -> 
      "(if "  ^ string_of_sexpr se1 ^ " " 
              ^ string_of_sexpr se2 ^ " " 
              ^ string_of_sexpr se3 ^ ")"
  | SApply(f, args) -> 
      "(" ^ string_of_sexpr f ^ " " 
          ^ String.concat " " (List.map string_of_sexpr args) ^ ")"
  | SLet(binds, body) -> 
      let string_of_binding (id, e) = 
              "[" ^ id ^ " " ^ (string_of_sexpr e) ^ "]"
      in
      "(let ("  ^ String.concat " " (List.map string_of_binding binds) ^ ") " 
                ^ string_of_sexpr body ^ ")"
  | SLambda (formals, body) ->
      let (tys, names) = List.split formals in 
      "(lambda (" ^ (List.fold_left2 (fun space ty para -> string_of_typ ty ^ space ^ para) " " tys names) ^ ") " 
                  ^ string_of_sexpr body ^ ")"
(* toString for Sast.svalue *)
and string_of_svalue = function
    SChar c -> String.make 1 c 
  | SInt i -> string_of_int i
  | SBool b -> if b then "#t" else "#f"
  | SRoot tr -> string_of_stree tr
(* toString for Sast.stree *)
and string_of_stree = function
    SLeaf -> "leaf"
  | SBranch(v, sib, child) -> 
        "(tree " ^ string_of_svalue v ^ " " 
                 ^ string_of_stree sib ^ " " 
                 ^ string_of_stree child ^ ")"

(* toString for Sast.sdefn *)
let string_of_sdefn = function 
  | SVal(id, e) -> "(val " ^ id ^ " " ^ string_of_sexpr e ^ ")"
  | SExpr e -> string_of_sexpr e 

(* toString for Sast.sprog *)
let string_of_sprog defns = 
    String.concat "\n" (List.map string_of_sdefn defns) ^ "\n"  *)