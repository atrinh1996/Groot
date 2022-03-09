(* Abstract Syntax Tree for groot 
   Functions for printing
*)




type ident = string

(*type primop = Add | Sub | Mul | Div | Mod | Eq | Neq 
            | Lt  | Gt  | Leq | Geq | And | Or*)

type 'a env = (ident * 'a) list
(* mutuallly recursive expression * value types *)
type expr = Literal of value
          | Var     of ident
          | If      of expr * expr * expr
          | Apply   of expr * expr list
          | Let     of (ident * expr) list * expr
          | Lambda  of ident list * expr
and value = Char    of char
          | Int     of int
          (*| Float   of float*)
          | Bool    of bool
          | Root    of tree
          | Closure of ident list * expr * (unit -> value env) (* not sure abt this? *)
          (*| Primitive of primop * value list -> value*)
and tree =  Leaf
          | Branch of expr * tree * tree

(* top-level definitions *)
type defn = Val of ident * expr
          | Expr of expr
          (*| Define of ident * ident list * expr*)
          (* fn name, arg names, body*)
          (*| Use of ident*)

(* short for program, analogous to main *)
type prog = defn list


(* String of Program *)


let rec string_of_expr = function
    | Literal(lit) -> "[LITERAL of " ^ string_of_value(lit) ^ "]"
    | Var(v)       -> "[VAR: " ^ v ^ "]"
    | If(condition, true_branch, false_branch) ->
        "[IF, " ^
            "COND: "         ^ (string_of_expr condition)   ^ ", " ^
            "TRUE-BRANCH: "  ^ (string_of_expr true_branch) ^ ", " ^
            "FALSE-BRANCH: " ^ (string_of_expr true_branch) ^ "]"
    | Apply(func, args) ->
        "[APPLY, " ^
            "FUNCTION: " ^ string_of_expr func ^ ", " ^
            "ARGS: [" ^ (String.concat " "(List.map string_of_expr args)) ^ "]]"
       (*of expr * expr list*)
    | Let(binds, body) -> "[LET: string_of_let unimplemented]"
    | Lambda(args, body) ->  "[LAMBDA: string_of_lambda unimplemented]"
and string_of_value = function
    | Char(c)     -> "CHAR: " ^ (String.make 1 c)
    | Int(i)      -> "INT: "  ^ (string_of_int i)
    | Bool(b)     -> "BOOL: " ^ (if b then "#t" else "#f")
    | Root(tr)    -> "ROOT: " ^ (string_of_tree tr)
    | Closure(a,b,c) -> "CLOSURE: string_of_closure unimplemented" 
and string_of_tree = function
    | Leaf -> "LEAF"
    | Branch(e, s, c) ->
        "[BRANCH, "^
            "VALUE: "   ^ string_of_expr(e)  ^ ", " ^
            "SIBLING: " ^ string_of_tree(s)  ^ ", " ^
            "CHILD: "   ^ string_of_tree(c)  ^ "]"

let rec string_of_defn = function
    | Val(id, e) -> "[VAL, ID: " ^ id ^ " , EXPR: " ^ string_of_expr e ^ "]"
    | Expr(e)    -> "[EXPR: " ^ string_of_expr e ^ "]"

let string_of_prog defns = 
    String.concat "\n" (List.map string_of_defn defns) ^ "\n"


(* maybe add PRIMITIVE of value list -> value *)
          (* | LETX    of let_kind * (ident * exp) list * exp
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
    | Let(ident, e1, e2) -> "(let " ^ ident ^ " " ^ string_of_expr e1 ^ " " ^ string_of_expr e2 ^ ")"
    | Val(ident, e) -> "(val " ^ ident ^ " " ^ string_of_expr e ^ ")"
    | Apply(ident, es) -> (match es with 
            | [] -> "(" ^ ident ^ ")" 
            | _ -> "(" ^ ident ^ " " ^ String.concat " " (List.map string_of_expr es) ^ ") ")

let string_of_main exprs = 
    String.concat "\n" (List.map string_of_expr exprs) ^ "\n"
*)

