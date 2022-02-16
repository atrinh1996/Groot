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
%token LPAREN RPAREN
%token MINUS EOF
%token IF
%token <int>  INT
%token <bool> BOOL

%start expr
%type <Ast.expr> expr


%%

/* Rules */
literal:
    | INT                   { Int($1) }
    | BOOL                  { Bool($1) }

expr:
    | literal               { $1 }
    | MINUS expr            { Unary(Neg, $2) }
    | LPAREN expr RPAREN    { $2 }
    | LPAREN IF LPAREN expr RPAREN expr expr RPAREN
                            { If($4, $6, $7)}



/* %% Trailer */
