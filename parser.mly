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
%token LPAREN RPAREN MINUS 
%token EQUALS
%token IF
%token <int>  INT
%token <bool> BOOL
%token EOF

%start expr
%type <Ast.expr> expr

%left EQUALS

%%

/* Rules */
literal:
    | INT                   { Int($1) }
    | BOOL                  { Bool($1) }

expr:
    | literal               { $1 }
    | MINUS expr            { Unary(Neg, $2) }
    | LPAREN expr RPAREN    { $2 }
    | LPAREN IF expr expr expr RPAREN
                            { If($3, $4, $5)}
    | LPAREN EQUALS expr expr RPAREN
                            { Binops(Eql, $3, $4) }
    | LPAREN MINUS expr expr RPAREN %prec EQUALS
                            { Binops(Sub, $3, $4) }




/* %% Trailer */
