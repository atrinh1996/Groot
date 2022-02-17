(*
        scanner.mll

    lexer file to create a lexical analyzer from a set of reg exs
    
    Compile with command to produce scanner.ml with the ocaml code:
        ocamllex scanner.mll
*)

(* Header *)
{ 
  open Parser 
  exception Eof
} 

(* Regular Expressions (optional *)
let digit = ['0'-'9']
let integer = ['-']?['0'-'9']+


(* Entry Points *)
rule tokenize = parse
  (* RegEx { action } *)
  | [' ' '\n' '\t' '\r'] { tokenize lexbuf }
  | "(;"                 { comment lexbuf }                  
  | '('                  { LPAREN }
  | ')'                  { RPAREN }
  | '+'                  { PLUS }
  | '-'                  { MINUS }
  | '*'                  { TIMES }
  | '/'                  { DIVIDE }
  | "mod"                { MOD }
  | "=="                 { EQ }
  | "!="                 { NEQ }
  | "<="                 { LEQ }
  | ">="                 { GEQ }
  | '<'                  { LT }
  | '>'                  { GT }
  | "if"                 { IF }
  | integer as ival      { INT(int_of_string ival) }
  | "#t"                 { BOOL(true) }
  | "#f"                 { BOOL(false) }
<<<<<<< HEAD
  | "&&"                 { AND }
  | "||"                 { OR }
=======
  | eof                  { raise Eof }
>>>>>>> 39ee01ca74ca8c97aae639e60d9639a98ece47a4
  and comment = parse
    | ";)"               { tokenize lexbuf }
    | _                  { comment lexbuf }
      
