(* Toplevel file to run scanner and parser on some input *)

open Ast


(* Evaluator *)
let rec eval expr =
  match expr with
  | Int(x) -> string_of_int x
  | Unary(op, e1) -> 
      let v1 = (int_of_string (eval e1)) in 
      let v1 = (-1) * v1
      in string_of_int v1
  | Bool(b) -> if b then "#t" else "#f"


(* Temporary code to print what parser evaluates *)
let () = 
  let lex_buf = Lexing.from_channel stdin in
    while true do
      let expr = Parser.expr Scanner.tokenize lex_buf in
      let result = eval expr in
      print_endline result 
    done
