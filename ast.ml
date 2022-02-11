(* Abstract Syntax Tree for groot *)

type operator = Sub

type expr = 
      Lit of int
    | Unary of operator * expr