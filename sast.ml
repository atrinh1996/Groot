(* Semantically-checked Abstract Syntax Tree and functions for printing it *)

open Ast

type sexpr = gtype * sx
and sx = 
   SLiteral of svalue
 | SVar     of ident
 | SIf      of sexpr * sexpr * sexpr
 | SApply   of ident * sexpr list
 | SLet     of (ident * sexpr) list * sexpr
 | SLambda  of (gtype * ident) list * sexpr
and svalue = 
    SChar    of char
  | SInt     of int
  | SBool    of bool
  | SRoot    of stree
and stree =  
    SLeaf
  | SBranch of svalue * stree * stree
  (* NOTE: the sastSBranch  does not store sexpr, not directly analogous to AST Branch *)

type sdefn = 
  | SVal of ident * sexpr
  | SExpr of sexpr

type sprog = sdefn list


(* Pretty printing functions *)


(* toString for Sast.sexpr *)
let rec string_of_sexpr (t, s) = 
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
      "(" ^ f ^ " " 
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
    String.concat "\n" (List.map string_of_sdefn defns) ^ "\n"