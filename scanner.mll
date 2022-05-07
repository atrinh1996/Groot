(*
    scanner.mll

  Lexer file to create a lexical analyzer from a set of regular expressions.

  Compile with command to produce scanner.ml with the ocaml code:
        ocamllex scanner.mll
*)

(* Header *)
{
  open Parser
}

(* Regular Expressions *)
let digit = ['0'-'9']
let integer = ['-']?['0'-'9']+
let alpha = ['a'-'z']
let leaf = ("leaf"|"()")
let chrcode = digit+

(* all visible characters, excluding ()'[]\;{}| *)
let ident = ['!'-'&' '*'-':' '<'-'Z' '`'-'z' '~' '|']
            ['!'-'&' '*'-':' '<'-'Z' '^'-'z' '~' '|']*


(* ToKeNiZe *)
rule tokenize = parse
  | [' ' '\n' '\t' '\r'] { tokenize lexbuf }
  | ";;"                 { single_comment lexbuf }
  | "(;"                 { multi_comment lexbuf }
  | '('                  { LPAREN }
  | ')'                  { RPAREN }
  | '['                  { LSQUARE }
  | ']'                  { RSQUARE }
  | "tree"               { BRANCH }
  | "leaf"               { LEAF }
  | "if"                 { IF }
  | "'"                  { apos_handler lexbuf }
  | integer as ival      { INT(int_of_string ival) }
  | "#t"                 { BOOL(true) }
  | "#f"                 { BOOL(false) }
  | "lambda"             { LAMBDA }
  | "let"                { LET }
  | "val"                { VAL }
  | ident as id          { ID(id) }
  | eof                  { EOF }
  | _                    { Diagnostic.error(Diagnostic.lex_error "unrecognized character" lexbuf) }
and single_comment = parse
  | '\n'                 { tokenize lexbuf }
  | eof                  { EOF }
  | _                    { single_comment lexbuf }
and multi_comment  = parse
  | ";)"                 { tokenize lexbuf }
  | eof                  { EOF }
  | _                    { multi_comment lexbuf }

(* apostrophe handler *)
and apos_handler = parse
  | '('[^''']      { tree_builder lexbuf }
  | '''            { Diagnostic.error (Diagnostic.lex_error "empty character literal" lexbuf) }
  | '\\'           { escaped_char_handler lexbuf }
  | _ as c         { char_builder c lexbuf }

and tree_builder = parse
  | _ { Diagnostic.error (Diagnostic.Unimplemented "in-place tree syntax") }

and char_builder c = parse
  | '''   { CHAR(c) }
  | _ { Diagnostic.error
          (Diagnostic.lex_error ("character literal contains more " 
           ^ "than one token") lexbuf) }

and escaped_char_handler = parse
  | '\\' { char_builder '\\' lexbuf }
  | '"'  { char_builder '\"' lexbuf }
  | '''  { char_builder '\'' lexbuf }
  | 'n'  { char_builder '\n' lexbuf }
  | 'r'  { char_builder '\r' lexbuf }
  | 't'  { char_builder '\t' lexbuf }
  | 'b'  { char_builder '\b' lexbuf }
  | ' '  { char_builder '\ ' lexbuf }
  | chrcode as ord
         { print_string ord; if int_of_string ord > 255
           then Diagnostic.error
                (Diagnostic.lex_error "invalid escape sequence ASCII value" 
                lexbuf)
           else char_builder (Char.chr (int_of_string ord)) lexbuf }
  | _    { Diagnostic.error
          (Diagnostic.lex_error "unrecognized escape sequence" lexbuf) }
