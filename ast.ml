(* Abstract Syntax Tree (AST) for Groot *)

(* Type of Variable Names *)
type ident = string




(* Groot Expressions *)
type expr = 
  | Literal of value
  | Var     of ident
  | If      of expr * expr * expr
  | Apply   of expr * expr list
  | Let     of (ident * expr) list * expr
  | Lambda  of ident list * expr
and value = 
  | Char    of char
  | Int     of int
  | Bool    of bool
  | Root    of tree
and tree =  
  | Leaf
  | Branch of expr * tree * tree


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
and tree =  Leaf
          | Branch of expr * tree * tree


type defn = 
  | Val  of ident * expr
  | Expr of expr



(* short for program, analogous to main *)
type prog = defn list



(* Pretty printing functions *)


(* toString for Ast.expr *)
let rec string_of_expr = function
    | Literal(lit) -> string_of_value lit
    | Var(v) -> v 
    | If(condition, true_branch, false_branch) ->
        "(if "  ^ string_of_expr condition ^ " " 
                ^ string_of_expr true_branch ^ " " 
                ^ string_of_expr false_branch ^ ")"
    | Apply(f, args) ->
        "(" ^ string_of_expr f ^ " " 
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
