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
%token LPAREN  RPAREN
%token LSQUARE RSQUARE
%token PLUS MINUS TIMES DIVIDE MOD
%token EQ NEQ LT GT LEQ GEQ AND OR NOT
%token IF
%token <char> CHAR
%token <int>  INT
%token <bool> BOOL
%token <string> ID
%token BRANCH LEAF
%token EOF
%token LAMBDA LET VAL

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
%nonassoc BRANCH LEAF


/* Declarations */
%start prog
%type <Ast.prog> prog

%%
prog:
    | defn_list EOF       { $1 }

defn_list:
    | /* nothing */      { [] }
    | defn defn_list     { $1 :: $2 }

defn: 
    | expr                                   { Expr($1)    }
    | LPAREN VAL ID expr RPAREN              { Val($3, $4) }

formals_opt:
  | /* nothing */ { [] }
  | formal_list   { $1 }

formal_list:
  | ID                  { [$1] }
  | ID formal_list      { $1 :: $2 }


/* Rules */
value:
    | CHAR                                   { Char($1) }
    | INT                                    { Int($1) }
    | BOOL                                   { Bool($1) }
    | tree                                   { Root($1) }
    /* note, tree is not a token, there is no need for a ROOT token while scanning */

tree:
    | LEAF                                   { Leaf }
    | LPAREN BRANCH expr tree tree RPAREN    { Branch($3, $4, $5) }

/*
let_binding:
    | LSQUARE ID expr RSQUARE                { ($2, $3) }
    | LSQUARE RSQUARE                        { raise(Failure("asdf")) }
    */
    
let_binding_list:
    | /* nothing */      { [] }
    | LSQUARE RSQUARE let_binding_list
        { Diagnostic.warning(Diagnostic.parse_warning "empty let binding" 1); $3 } /* NON FATAL */
    | LSQUARE expr RSQUARE let_binding_list
        { Diagnostic.error(Diagnostic.parse_error "let binding must contain id and value" 2) } /* FATAL */
    | LSQUARE ID expr RSQUARE let_binding_list { ($2, $3) :: $5 }
    /*
    | let_binding let_binding_list { $1 :: $2 }
    */

expr_list:
    | /* nothing */      { [] }
    | expr expr_list     { $1 :: $2 }

expr:
    | value                                  { Literal($1) }
    | ID                                     { Var($1) }
/*
    | MINUS expr %prec NEG                   { Unary(Neg, $2) }
    | NOT expr                               { Unary(Not, $2) }
*/
    | LPAREN expr expr_list RPAREN           { Apply($2, $3) }
    | LPAREN LET LPAREN let_binding_list RPAREN expr RPAREN    { Let($4, $6)}
    | LPAREN IF expr expr expr RPAREN        { If($3, $4, $5) }
/*
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
*/
    | LPAREN LAMBDA LPAREN formals_opt RPAREN expr RPAREN  { Lambda($4, $6) }

/* Trailer */
