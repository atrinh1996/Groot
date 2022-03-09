(* Abstract Syntax Tree for groot 
   Functions for printing
*)




type id = string

(*type primop = Add | Sub | Mul | Div | Mod | Eq | Neq 
            | Lt  | Gt  | Leq | Geq | And | Or*)

type 'a env = (id * 'a) list
(* mutuallly recursive expression * value types *)
type expr = Literal of value
          | Var     of id
          | If      of expr * expr * expr
          | Apply   of expr * expr list
          | Let     of (id * expr) list * expr
          | Lambda  of id list * expr
and value = Char    of char
          | Int     of int
          (*| Float   of float*)
          | Bool    of bool
          | Root    of tree
          | Closure of id list * expr * (unit -> value env) (* not sure abt this? *)
          (*| Primitive of primop * value list -> value*)
and tree =  Leaf
          | Branch of value * tree * tree

(* top-level definitions *)
type defn = Val of id * expr
          | Expr of expr
          (*| Define of id * id list * expr*)
          (* fn name, arg names, body*)
          (*| Use of id*)

(* short for program, analogous to main *)
type prog = defn list


(* maybe add PRIMITIVE of value list -> value *)
          (* | LETX    of let_kind * (id * exp) list * exp
          and let_kind = LET | LETREC | LETSTAR*)
          (*| FLOAT of float, stretch*)





(*let string_of_value = function
    Char(ch)      -> String.make 1 ch
  | Int(number)   -> string_of_int number
  | Bool(boolean) -> string_of_bool boolean
  | Closure _     -> "<function>" 

let rec string_of_tree = function
  | Leaf          -> "leaf"
  | Branch(element, sibling, child) ->
        "(" ^ (string_of_value element) ^ " "
            ^ (string_of_tree sibling) ^ " "
            ^ (string_of_tree child)   ^ ")"

let string_of_program = function
    _ -> "hello world!\n"*)

(***************************************************************************)

(*type bin_operator = Add | Sub | Mul | Div | Mod | Eq | Neq 
                  | Lt  | Gt  | Leq | Geq | And | Or

type uni_operator = Neg | Not

type expr = 
    | Char of char
    | Int   of int
    | Unary of uni_operator * expr
    | Bool  of bool
    | Id of string
    | If of expr * expr * expr
    | Binops of bin_operator * expr * expr
    | Lambda of string list * expr
    | Let of string * expr * expr
    | Val of string * expr
    | Apply of string * expr list

type main = expr list
*)
(* Pretty print functions *)
(*
let string_of_binop = function
    | Add -> "+"
    | Sub -> "-"
    | Mul -> "*"
    | Div -> "/"
    | Mod -> "mod"
    | Eq -> "=="
    | Neq -> "!="
    | Lt -> "<"
    | Gt -> ">"
    | Leq -> "<="
    | Geq -> ">="
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
    | Id(s) -> s
    | Char(y) -> String.make 1 y 
    | If(e1, e2, e3) -> "(if "  ^ string_of_expr e1 ^ " " 
                                ^ string_of_expr e2 ^ " " 
                                ^ string_of_expr e3 ^ ")"
    | Binops(o, e1, e2) -> "("  ^ string_of_binop o ^ " " 
                                ^ string_of_expr e1 ^ " " 
                                ^ string_of_expr e2 ^ ")"
    | Lambda(xs, e) -> "(lambda (" ^ String.concat " " xs ^ ") " ^ 
        string_of_expr e ^ ")"
    | Let(id, e1, e2) -> "(let " ^ id ^ " " ^ string_of_expr e1 ^ " " ^ string_of_expr e2 ^ ")"
    | Val(id, e) -> "(val " ^ id ^ " " ^ string_of_expr e ^ ")"
    | Apply(id, es) -> (match es with 
            | [] -> "(" ^ id ^ ")" 
            | _ -> "(" ^ id ^ " " ^ String.concat " " (List.map string_of_expr es) ^ ") ")

let string_of_main exprs = 
    String.concat "\n" (List.map string_of_expr exprs) ^ "\n"
*)

let string_of_main exprs = 
    "hello world!"

