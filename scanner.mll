(*
        scanner.mll

    lexer file to create a lexical analyzer from a set of reg exs
    
    Compile with command to produce scanner.ml with the ocaml code:
        ocamllex scanner.mll
*)

(* Header *)
{ 
  open Parser
}


(* Regular Expressions (optional *)
let digit = ['0'-'9']
let integer = ['-']?['0'-'9']+
let alpha = ['a'-'z']
let leaf = ("leaf"|"()")
let chrcode = digit+
(* digit (digit | digit digit)? as ord *)

(* digit | digit digit | ['0'-'2'] digit digit *)


(* all visible characters *)
(* let ident = ['!'-'~']+ *)

(* all visible characters, excluding ()'[]\;{}| *)
let ident = ['!'-'&' '*'-':' '<'-'Z' '^'-'z' '~' '|']+
(* let ident = ['a'-'z' 'A'-'Z' '0'-'9' '_']+ *)
(* ['a'-'z' 'A'-'Z' '0'-'9' '_']* *)


(* Entry Points *)
rule tokenize = parse
  | [' ' '\n' '\t' '\r'] { tokenize lexbuf }
  | "(;"                 { comment lexbuf }
  | '('                  { LPAREN }
  | ')'                  { RPAREN }
  | '['                  { LSQUARE }
  | ']'                  { RSQUARE }

(*
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
*)
  | "tree"               { BRANCH }
  | "leaf"               { LEAF }
  | "if"                 { IF }

 (* | "'"                  { opchar lexbuf } *)
  (* | "'"(_ as c)"'"        { CHAR(c) } *)

  | "'"                  { apos_handler lexbuf }
  | integer as ival      { INT(int_of_string ival) }
  | "#t"                 { BOOL(true) }
  | "#f"                 { BOOL(false) }
  | "lambda"             { LAMBDA }
  | "let"                { LET }
  | "val"                { VAL }
  | ident as id          { ID(id) }

(*
  | ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_']* as lxm { ID(lxm) }
*)

(*
  | "&&"                 { AND }
  | "||"                 { OR }
  | '!'                  { NOT }
*)
  | eof                  { EOF }
  | _                    { Diagnostic.error(Diagnostic.lex_error "unrecognized character" lexbuf) }

  (*
  | _ as c            { raise(Failure("illegal character " 
                                          ^ Char.escaped c)) }
*)
and comment = parse
  | ";)"               { tokenize lexbuf }
  | _                  { comment lexbuf }

(* apostrophe handler *)
and apos_handler = parse
  | '('[^''']      { tree_builder lexbuf }    
  | '''            { Diagnostic.error(Diagnostic.lex_error "empty character literal" lexbuf) }
  | '\\'           { escaped_char_handler lexbuf }
  | _ as c         { char_builder c lexbuf }

and tree_builder = parse
  (* | ")" { TREE(1, 1) } *)

  (* | _+ { TREE(tokenize "5", tree_builder lexbuf, tree_builder lexbuf)} *)
  (* | "()" { LEAF } *) 
  | _ { Diagnostic.error(Diagnostic.Unimplemented "in-place tree syntax") }

and char_builder c = parse
  | '''   { CHAR(c) } 
  | _ { Diagnostic.error(Diagnostic.lex_error "character literal contains more than one token" lexbuf) }

and escaped_char_handler = parse
  | '\\' { char_builder '\\' lexbuf }
  | '"'  { char_builder '\"' lexbuf  }
  | '''  { char_builder '\'' lexbuf  }
  | 'n'  { char_builder '\n' lexbuf  }
  | 'r'  { char_builder '\r' lexbuf  }
  | 't'  { char_builder '\t' lexbuf  }
  | 'b'  { char_builder '\b' lexbuf  }
  | ' '  { char_builder '\ ' lexbuf  }
  | chrcode as ord
         { print_string ord; if int_of_string ord > 255
           then Diagnostic.error(Diagnostic.lex_error "invalid escape sequence ASCII value" lexbuf)
           else char_builder (Char.chr (int_of_string ord)) lexbuf }
  | _    { Diagnostic.error(Diagnostic.lex_error "unrecognized escape sequence" lexbuf) }

 


(*
let char_handler = function
  | "_{1}" as c { CHAR(c) }
  | _  as c { raise(Failure("multiple characters inside char literal" ^ c)) }
*)
(* I believe this is to just match with a single character
 * but better to use pattern matching?
 *)
 (*
and opchar = parse
  | _ as c               { clchar c lexbuf  }
  (* | _ as char          { raise(Failure("illegal character " 
                                          ^ Char.escaped char)) } *)*)
(*
and clchar c = parse
| '''                { CHAR(c) }
| _ as char          { raise(Failure("illegal character " 
                                        ^ Char.escaped char)) }

  *)