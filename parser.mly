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
%token MINUS EOF TICK
%token <char> CHAR
%token <int> INT

%start expr
%type <Ast.expr> expr


%%

/* Rules */
expr:
    | INT                   { Int($1) }
    | CHAR                  { Char($1) }
    | MINUS expr            { Unary(Sub, $2) }



/* %% Trailer */