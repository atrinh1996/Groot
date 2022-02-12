(* Toplevel file to run scanner and parser on some input *)

open Ast


(* Evaluator *)
let rec eval expr =
    match expr with
      Int(x) -> string_of_int x
    | Unary(op, e1) -> 
        let v1 = eval e1 in 
        let v1 = (-1) * (int_of_string v1) 
        in string_of_int v1
    | Char(c) -> String.make 1 c


(* Temporary code to print what parser evaluates *)
let () = 
    let lex_buf = Lexing.from_channel stdin in
    let expr = Parser.expr Scanner.tokenize lex_buf in
    let result = eval expr in
    print_endline result 