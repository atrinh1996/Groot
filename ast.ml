(* Abstract Syntax Tree for groot *)

type bin_operator = Sub | Eq

type uni_operator = Neg

type expr = 
    | Int   of int
    | Unary of uni_operator * expr
    | Bool  of bool
    | If of expr * expr * expr
    | Binops of bin_operator * expr * expr
    | Lambda of string list * expr
