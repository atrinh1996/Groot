(*
        scanner.mll

    lexer file to create a lexical analyzer from a set of reg exs
    
    Compile with command to produce scanner.ml with the ocaml code:
        ocamllex scanner.mll
*)

{ open Parser } (* Header *)

(* Regular Expressions (optional *)
let digit = ['0'-'9']
let integer = '-'?['0'-'9']['0'-'9']*


(* Entry Points *)
rule tokenize = parse
    (* RegEx { action } *)
      '-'               { MINUS }
    | '''               { TICK }
    | integer           { INT(int_of_string (Lexing.lexeme lexbuf)) }
    | eof               { EOF }
    | _ as lit          { CHAR(lit) }
