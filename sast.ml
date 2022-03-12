(* Semantically-checked Abstract Syntax Tree and functions for printing it *)

open Ast

type sexpr = gtype * sx

and     sx = SLiteral of svalue
           | SVar     of ident
           | SIf      of sexpr * sexpr * sexpr
           | SApply   of sexpr * sexpr list
           | SLet     of (ident * sexpr) list * sexpr
           | SLambda  of ident list * sexpr

and svalue = SChar    of char
           | SInt     of int
           (*| Float   of float*)
           | SBool    of bool
           | SRoot    of tree
           | SClosure of ident list * sexpr * (unit -> value env) (* not sure abt this? *)
          (*| Primitive of primop * value list -> value*)

and stree =  SLeaf
           | SBranch of svalue * tree * tree
           (* NOTE: the sastSBranch  does not store sexpr, not directly analogous to AST Branch *)



type sdefn = 
  | SVal of ident * sexpr
  | SExpr of sexpr

type sprog = sdefn list