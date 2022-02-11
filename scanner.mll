(*
        scanner.mll

    lexer file to create a lexical analyzer from a set of reg exs
    
    Compile with command to produce scanner.ml with the ocaml code:
        ocamllex scanner.mll
*)

{ open Parser } (* Header *)

(* Regular Expressions (optional *)
let digits = ['0'-'9']+


(* Entry Points *)
rule tokenize = parse
    (* RegEx { action } *)
      '-'               { MINUS }
    | digits as lit     { LITERAL(int_of_string lit) }
    | eof               { EOF }