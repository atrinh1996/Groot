/* 
    parser.mly

    produces a parser from a context-free grammar specification

    Compile with command to produce parser.ml with the ocaml code:
        ocamlyacc parser.mly

*/

/* Header */
%{ open Ast %} 

/* Tokens */
%token LPAREN RPAREN PLUS MINUS TIMES DIVIDE MOD
%token EQ NEQ LT GT LEQ GEQ AND OR
%token IF
%token <int>  INT
%token <bool> BOOL

/* Precedence */
%nonassoc OR
%nonassoc AND
%nonassoc LT GT
%nonassoc EQ NEQ 
%nonassoc LEQ GEQ
%nonassoc PLUS MINUS
%nonassoc TIMES DIVIDE
%nonassoc NEG

/* Declarations */
%start main
%type <Ast.main> main

%%

/* Rules */
literal:
    | INT                                    { Int($1) }
    | BOOL                                   { Bool($1) }

expr:
    | literal                                { $1 }
    | LPAREN MINUS expr %prec NEG RPAREN     { Unary(Neg, $3) }
    | LPAREN expr RPAREN                     { $2 }
    | LPAREN IF expr expr expr RPAREN        { If($3, $4, $5) }
    | LPAREN LT expr expr RPAREN             { Binops(Lt, $3, $4) }
    | LPAREN GT expr expr RPAREN             { Binops(Gt, $3, $4) }
    | LPAREN EQ expr expr RPAREN             { Binops(Eq, $3, $4) }
    | LPAREN NEQ expr expr RPAREN            { Binops(Neq, $3, $4) }
    | LPAREN LEQ expr expr RPAREN            { Binops(Leq, $3, $4) }
    | LPAREN GEQ expr expr RPAREN            { Binops(Geq, $3, $4) }
    | LPAREN PLUS expr expr RPAREN           { Binops(Add, $3, $4) }
    | LPAREN MINUS expr expr RPAREN          { Binops(Sub, $3, $4) }
<<<<<<< HEAD
    | LPAREN TIMES expr expr RPAREN          { Binops(Mul, $3, $4) }
    | LPAREN DIVIDE expr expr RPAREN         { Binops(Div, $3, $4) }
    | LPAREN MOD expr expr RPAREN            { Binops(Mod, $3, $4) }
    | LPAREN AND expr expr RPAREN            { Binops(And, $3, $4) }
    | LPAREN OR expr expr RPAREN             { Binops(Or, $3, $4) }

=======
main:
    expr                                 { $1 }
>>>>>>> 39ee01ca74ca8c97aae639e60d9639a98ece47a4
/* Trailer */
