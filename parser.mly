/*
 *  parser.mly
 *    produces a parser from a context-free grammar specification
 *
 *    Compile with command to produce parser.ml with the ocaml code:
 *      ocamlyacc parser.mly
 */

/* Header */
%{
    open Ast
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
  | defn_list EOF                 { $1 }

defn_list:
  | /* nothing */                 { [] }
  | defn defn_list                { $1 :: $2 }

defn:
  | expr                          { Expr($1) }
  | LPAREN VAL ID expr RPAREN     { Val($3, $4) }

formals_opt:
  | /* nothing */                 { [] }
  | formal_list                   { $1 }

formal_list:
  | ID                            { [$1] }
  | ID formal_list                { $1 :: $2 }


/* Rules */
value:
  | CHAR                          { Char($1) }
  | INT                           { Int($1) }
  | BOOL                          { Bool($1) }
  | tree                          { Root($1) }
  /* ! Note: tree is not a token - no need for a ROOT token while scanning */


tree:
  | LEAF                                  { Leaf }
  | LPAREN BRANCH expr tree tree RPAREN   { Branch($3, $4, $5) }


let_binding_list:
  | /* nothing */                             { [] }
  | LSQUARE RSQUARE let_binding_list  
    { Diagnostic.warning (Diagnostic.parse_warning "empty let binding" 1); $3 } 
    /* NON FATAL */
  | LSQUARE expr RSQUARE let_binding_list     
    { Diagnostic.error (Diagnostic.parse_error ("let binding must contain" 
      ^ " id and value") 2) } /* FATAL */
  | LSQUARE ID expr RSQUARE let_binding_list  { ($2, $3) :: $5 }


expr_list:
  | /* null */         { [] }
  | expr expr_list     { $1 :: $2 }


expr:
  | value                                                 { Literal($1) }
  | ID                                                    { Var($1) }
  | LPAREN expr expr_list RPAREN                          { Apply($2, $3) }
  | LPAREN LET LPAREN let_binding_list RPAREN expr RPAREN { Let($4, $6)}
  | LPAREN IF expr expr expr RPAREN                       { If($3, $4, $5) }
  | LPAREN LAMBDA LPAREN formals_opt RPAREN expr RPAREN   { Lambda($4, $6) }
