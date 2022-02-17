/* 
    parser.mly

    produces a parser from a context-free grammar specification

    Compile with command to produce parser.ml with the ocaml code:
        ocamlyacc parser.mly

*/

/* Header */
%{ open Ast %} 

/* Tokens */
%token LPAREN RPAREN MINUS 
%token EQ
%token IF
%token <int>  INT
%token <bool> BOOL
%token <string> ID
%token EOF
%token LAMBDA

/* Precedence */
%left EQ
%nonassoc NEG

/* Declarations */
%start expr
%type <Ast.expr> expr

%%

formals_opt:
    /* nothing */ { [] }
  | formal_list   { $1 }

formal_list:
    ID                   { [$1] }
  | ID formal_list { $1 :: $2 }


/* Rules */
literal:
    | INT                                    { Int($1) }
    | BOOL                                   { Bool($1) }

expr:
    | literal                                { $1 }
    | LPAREN MINUS expr %prec NEG RPAREN                 { Unary(Neg, $3) }
    | LPAREN expr RPAREN                     { $2 }
    | LPAREN IF expr expr expr RPAREN        { If($3, $4, $5)}
    | LPAREN EQ expr expr RPAREN             { Binops(Eq, $3, $4) }
    | LPAREN MINUS expr expr RPAREN          { Binops(Sub, $3, $4) }
    | LPAREN LAMBDA formals_opt expr RPAREN  { $4 }


/* Trailer */
