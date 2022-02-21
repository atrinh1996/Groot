(* Abstract Syntax Tree for groot 
   Functions for printing
*)

type bin_operator = Add | Sub | Mul | Div | Mod | Eq | Neq 
                    | Lt | Gt | Leq | Geq | And | Or

type uni_operator = Neg | Not

type expr = 
    | Int   of int
    | Unary of uni_operator * expr
    | Bool  of bool
    | If of expr * expr * expr
    | Binops of bin_operator * expr * expr
    | Lambda of string list * expr
    | Let of string * expr

type main = expr list

(* Pretty print functions *)

let string_of_binop = function
      Add -> "+"
    | Sub -> "-"
    | Mul -> "*"
    | Div -> "/"
    | Mod -> "mod"
    | Eq -> "=="
    | Neq -> "!="
    | Lt -> "<"
    | Gt -> ">"
    | Leq -> "<="
    | Geq -> "<="
    | And -> "&&"
    | Or -> "||"

let string_of_uop = function
    | Neg -> "-"
    | Not -> "!"

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
    | Lambda(xs, e) -> "(lambda (" ^ String.concat " " xs ^ ") " ^ 
        string_of_expr e ^ ")"
    | Let(id, e) -> "(let " ^ id ^ " " ^ string_of_expr e ^ ")"

let string_of_main exprs = 
    String.concat "\n" (List.map string_of_expr exprs) ^ "\n"
