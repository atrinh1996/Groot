(* Abstract Syntax Tree for groot *)

type operator = Sub

type expr = 
      Int of int
    | Char of char
    | Unary of operator * expr