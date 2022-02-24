/* 
    parser.mly

    produces a parser from a context-free grammar specification

    Compile with command to produce parser.ml with the ocaml code:
        ocamlyacc parser.mly

*/

/* Header */
%{ 
    open Ast
    exception Eof
%} 

/* Tokens */
%token LPAREN RPAREN PLUS MINUS TIMES DIVIDE MOD
%token EQ NEQ LT GT LEQ GEQ AND OR NOT
%token IF
%token <char> CHAR
%token <int>  INT
%token <bool> BOOL
%token <string> ID
%token EOF
%token LAMBDA LET

/* Precedence */
%nonassoc OR
%nonassoc AND
%nonassoc LT GT
%nonassoc EQ NEQ 
%nonassoc LEQ GEQ
%nonassoc PLUS MINUS
%nonassoc TIMES DIVIDE
%nonassoc NEG
%nonassoc NOT


/* Declarations */
%start main
%type <Ast.main> main

%%

formals_opt:
    /* nothing */ { [] }
  | formal_list   { $1 }

formal_list:
    ID                  { [$1] }
  | ID formal_list      { $1 :: $2 }


/* Rules */
literal:
    | INT                                    { Int($1) }
    | BOOL                                   { Bool($1) }
    | CHAR                                   { Char($1) }

expr:
    | literal                                { $1 }
    | ID                                     { Id($1) }
    | MINUS expr %prec NEG                   { Unary(Neg, $2) }
    | NOT expr                               { Unary(Not, $2) }
    | LPAREN expr RPAREN                     { $2 }
    | LPAREN ID expr_list RPAREN             { Apply($2, $3) }
    | LPAREN LET ID expr RPAREN              { Let($3, $4)}
    | LPAREN IF expr expr expr RPAREN        { If($3, $4, $5) }
    | LPAREN LT expr expr RPAREN             { Binops(Lt, $3, $4) }
    | LPAREN GT expr expr RPAREN             { Binops(Gt, $3, $4) }
    | LPAREN EQ expr expr RPAREN             { Binops(Eq, $3, $4) }
    | LPAREN NEQ expr expr RPAREN            { Binops(Neq, $3, $4) }
    | LPAREN LEQ expr expr RPAREN            { Binops(Leq, $3, $4) }
    | LPAREN GEQ expr expr RPAREN            { Binops(Geq, $3, $4) }
    | LPAREN PLUS expr expr RPAREN           { Binops(Add, $3, $4) }
    | LPAREN MINUS expr expr RPAREN          { Binops(Sub, $3, $4) }
    | LPAREN TIMES expr expr RPAREN          { Binops(Mul, $3, $4) }
    | LPAREN DIVIDE expr expr RPAREN         { Binops(Div, $3, $4) }
    | LPAREN MOD expr expr RPAREN            { Binops(Mod, $3, $4) }
    | LPAREN AND expr expr RPAREN            { Binops(And, $3, $4) }
    | LPAREN OR expr expr RPAREN             { Binops(Or, $3, $4) }
    | LPAREN LAMBDA LPAREN formals_opt RPAREN expr RPAREN  { Lambda($4, $6) }

main:
    expr_list EOF       { $1 }

expr_list:
    /* nothing */       { [] }
    | expr expr_list    { $1 :: $2 }
/* Trailer */
