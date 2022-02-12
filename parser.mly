/* 
            parser.mly

    produces a parser from a context-free grammar specification

    Compile with command to produce parser.ml with the ocaml code:
        ocamlyacc parser.mly

*/


%{ open Ast %} /* Header */


/* Declarations:
        %token

        precedences
 */
%token MINUS EOF
%token <char> CHAR
%token <int>  INT
%token <bool> BOOL

%start expr
%type <Ast.expr> expr


%%

/* Rules */
expr:
    | INT                   { Int($1) }
    | CHAR                  { Char($1) }
    | BOOL                  { Bool($1) }
    | MINUS expr            { Unary(Neg, $2) }



/* %% Trailer */