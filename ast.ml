(* Abstract Syntax Tree for groot 
   Functions for printing
*)

(* any identifier *)
type ident = string


type gtype = 
    | IType 
    | CType 
    | BType 
    | TType
    | XType of int
    | Void


(*type primop = Add | Sub | Mul | Div | Mod | Eq | Neq 
            | Lt  | Gt  | Leq | Geq | And | Or*)

type 'a env = (ident * 'a) list
(* mutuallly recursive expression * value types *)
type expr = Literal of value
          | Var     of ident
          | If      of expr * expr * expr
          | Apply   of ident * expr list
          | Let     of (ident * expr) list * expr
          | Lambda  of ident list * expr
and value = Char    of char
          | Int     of int
          (*| Float   of float*)
          | Bool    of bool
          | Root    of tree
          (* | Closure of ident list * expr * (unit -> value env) *)
          (* not sure abt this? *)
          (*| Primitive of primop * value list -> value*)
and tree =  Leaf
          | Branch of expr * tree * tree
          (* TODO: maybe change "value * tree * tree" *)
          (* Perhaps in the SAST, this is a value *)

(* top-level definitions *)
type defn = 
          | Val of ident * expr
          | Expr of expr
          (*| Define of ident * ident list * expr*)
          (* fn name, arg names, body*)
          (*| Use of ident*)

type fdecl = 
{ rettyp : gtype;
  fname : string;
  formals : (gtype * string) list;
  locals : (gtype * string) list;
  body : expr list 
} 


(* short for program, analogous to main *)
type prog = defn list



(* Pretty printing functions *)

(* toString for Ast.typ *)
let string_of_typ = function
      IType     -> "int"
    | CType     -> "char"
    | BType     -> "bool"
    | TType     -> "TREE"
    | XType _   -> "typPARAM"
    | _         -> "STRINGOFTYPE: unknown" 

(* toString for Ast.expr *)
let rec string_of_expr = function
    | Literal(lit) -> string_of_value lit
    | Var(v) -> v 
    | If(condition, true_branch, false_branch) ->
        "(if "  ^ string_of_expr condition ^ " " 
                ^ string_of_expr true_branch ^ " " 
                ^ string_of_expr false_branch ^ ")"
    | Apply(f, args) ->
        "(" ^ f ^ " " 
            ^ String.concat " " (List.map string_of_expr args) ^ ")"
    | Let(binds, body)   ->
        let string_of_binding = function
              (id, e) -> "[" ^ id ^ " " ^ (string_of_expr e) ^ "]"
        in
        "(let (" ^ String.concat " " (List.map string_of_binding binds) ^ ") " 
                 ^ string_of_expr body ^ ")"
    | Lambda(formals, body) ->
        "(lambda (" ^ String.concat " " formals ^ ") " 
                    ^ string_of_expr body ^ ")"

(* toString for Ast.value *)
and string_of_value = function
    | Char(c)     -> "'" ^ String.make 1 c ^ "'"
    | Int(i)      -> string_of_int i
    | Bool(b)     -> if b then "#t" else "#f"
    | Root(tr)    -> string_of_tree tr
    (*| Closure(a,b,c) -> "CLOSURE: string_of_closure unimplemented" *)
    (*| Primitive(p, vals) -> "PRIMITIVE: string_of_primitive unimplemented" *)

(* toString for Ast.tree *)
and string_of_tree = function
    | Leaf -> "leaf"
    | Branch(ex, sib, child) ->
        (* Branch type is given by "tree" string *)
        "(tree " ^ string_of_expr ex ^ " " 
                 ^ string_of_tree sib ^ " " 
                 ^ string_of_tree child ^ ")"

(* toString for Ast.defn *)
let string_of_defn = function
    | Val(id, e) -> "(val " ^ id ^ " " ^ string_of_expr e ^ ")"
    | Expr(e)    -> string_of_expr e

(* toString for Ast.prog *)
let string_of_prog defns = 
    String.concat "\n" (List.map string_of_defn defns) ^ "\n"



(* let rec string_of_expr = function
    | Literal(lit) -> "[LITERAL of " ^ string_of_value(lit) ^ "]"
    | Var(v)       -> "[VAR: " ^ v ^ "]"
    | If(condition, true_branch, false_branch) ->
        "[IF, " ^
            "COND: "         ^ (string_of_expr condition)   ^ ", " ^
            "TRUE-BRANCH: "  ^ (string_of_expr true_branch) ^ ", " ^
            "FALSE-BRANCH: " ^ (string_of_expr false_branch) ^ "]"
    | Apply(func, args) ->
        "[APPLY, " ^
            "FUNCTION: " ^ string_of_expr func ^ ", " ^
            "ARGS: [" ^ (String.concat " " (List.map string_of_expr args)) ^ "]]"
    | Let(binds, body)   ->
        let string_of_binding = function
              (id, e) -> "[ID: " ^ id ^ " VALUE: " ^ (string_of_expr e) ^ "]"
        in
        "[LET, " ^
            "LOCALS: [" ^ (String.concat " "(List.map string_of_binding binds)) ^ "], " ^
            "BODY: "    ^ (string_of_expr body) ^ "]"
    | Lambda(formals, body) ->
        "[LAMBDA, " ^
            "ARGS: [" ^ (String.concat " " formals) ^ "], " ^
            "BODY: "  ^ (string_of_expr body) ^ "]"
and string_of_value = function
    | Char(c)     -> "CHAR: " ^ (String.make 1 c)
    | Int(i)      -> "INT: "  ^ (string_of_int i)
    | Bool(b)     -> "BOOL: " ^ (if b then "#t" else "#f")
    | Root(tr)    -> "ROOT: " ^ (string_of_tree tr)
    (*| Closure(a,b,c) -> "CLOSURE: string_of_closure unimplemented" *)
    (*| Primitive(p, vals) -> "PRIMITIVE: string_of_primitive unimplemented" *)
and string_of_tree = function
    | Leaf -> "LEAF"
    | Branch(e, s, c) ->
        "[BRANCH, "^
            "VALUE: "   ^ string_of_expr(e)  ^ ", " ^
            "SIBLING: " ^ string_of_tree(s)  ^ ", " ^
            "CHILD: "   ^ string_of_tree(c)  ^ "]"

let string_of_defn = function
    | Val(id, e) -> "[VAL, ID: " ^ id ^ " , EXPR: " ^ string_of_expr e ^ "]"
    | Expr(e)    -> "[EXPR: " ^ string_of_expr e ^ "]"

let string_of_prog defns = 
    String.concat "\n" (List.map string_of_defn defns) ^ "\n" *)

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

