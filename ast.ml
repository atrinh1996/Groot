(* Abstract Syntax Tree for groot 
   Functions for printing
*)

type bin_operator = Sub | Eq

type uni_operator = Neg

type expr = 
    | Int   of int
    | Unary of uni_operator * expr
    | Bool  of bool
    | If of expr * expr * expr
    | Binops of bin_operator * expr * expr
    | Lambda of string list * expr

(* Pretty print functions *)

let string_of_binop = function
      Sub -> "-"
    | Eq -> "=="

let string_of_uop = function
    | Neg -> "-"

let rec string_of_expr = function
    | Int(x) -> string_of_int x
    | Unary(o, e) -> string_of_uop o ^ string_of_expr e
    | Bool(true) -> "#t"
    | Bool(false) -> "#f"
    | If(e1, e2, e3) -> "(if "  ^ string_of_expr e1 ^ " " 
                                ^ string_of_expr e2 ^ " " 
                                ^ string_of_expr e3 ^ ")"
    | Binops(o, e1, e2) -> "("  ^ string_of_binop o ^ " " 
                                ^ string_of_expr e1 ^ " " 
                                ^ string_of_expr e2 ^ ")"
    | Lambda(xs, e) -> "(lambda (" ^ String.concat "" xs ^ ") " ^ 
        string_of_expr e ^ ")"
