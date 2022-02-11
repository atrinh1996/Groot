(* Toplevel file to run scanner and parser on some input *)

open Ast


(* Evaluator *)
let rec eval expr =
    match expr with
      Lit(x) -> x
    | Unary(op, e1) -> let v1 = eval e1 in let v1 = (-1) * v1 in v1


(* Temporary code to print what parser evaluates *)
let () = 
    let lex_buf = Lexing.from_channel stdin in
    let expr = Parser.expr Scanner.tokenize lex_buf in
    let result = eval expr in
    print_endline (string_of_int result)