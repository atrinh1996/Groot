(* Abstract Syntax Tree for groot *)

type bin_operator = Add | Sub | Mul | Div | Mod | Eq | Neq | Lt | Gt | Leq | Geq | And | Or

type uni_operator = Neg

type expr = 
    | Int   of int
    | Unary of uni_operator * expr
    | Bool  of bool
    | If of expr * expr * expr
    | Binops of bin_operator * expr * expr
