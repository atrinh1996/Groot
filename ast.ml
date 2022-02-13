(* Abstract Syntax Tree for groot *)

type bin_operator = Sub

type uni_operator = Neg

type expr = 
      Int   of int
    | Unary of uni_operator * expr
    | Bool  of bool
    (* | Binary of bin_operator * expr * expr *)
