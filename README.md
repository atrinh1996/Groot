# gROOT

The programming language (g)ROOT seeks to abstract the finer details away from the tree abstract data type in order to curtail the complexities that coincide with tree implementation. It is a functional programming language based on LISP-style syntax. 


## Contributors
- Samuel Russo          samuel.russo@tufts.edu
- Amy Bui               amy.bui@tufts.edu
- Eliza Encherman       elizabeth.encherman@tufts.edu
- Zachary Goldstein     zachary.goldstein@tufts.edu
- Nickolas Gravel       nickolas.gravel@tufts.edu



## COMPILE & RUN
- **Compile toplevel with one of these**:
    - ocamlbuild toplevel.native 
    - make toplevel.native
- **Run toplevel with one of these**:
    - ./toplevel.native                     -- runs on standard input and prints ast to stdout, use EOF (ctrl+d) to end input
    - ./toplevel.native [file.gt]           -- runs on given file, outputs ast to stdout 
    - ./toplevel.native -a [file.gt]        -- prints the ast from given file or stdin (default)
    - ./toplevel.native -c [file.gt]        -- not yet implemented, will be compilation
    - echo "\<input\>" | ./toplevel.native  -- pipes whatever expressions are \<input\> into toplevel.native
- **Run tests with:
    - ./run_tests.sh



## FILES
- README: this file
- Makefile: file of rules and commands to run toplevel.
- ast.ml: Abstract Syntax Tree file describes syntatic construct.
- parser.mly: instructions to produces a parser from a context-free grammar specification.
- scanner.mll: lexer file to create a lexical analyzer.
- toplevel.ml: main driver file to drive scanner and parser.
- run_test.sh: bash script to run tests.
- tests/: directory containing tests.
    - test1 ...



## Tasks Completed
- AST:
    - types for:
        - binary operators
        - unary operators
        - expressions
        - main (program): list of expressions
        - pretty print
- Toplevel:
    - Takes input from stdin or file
    - Call to AST's string_of_main (pretty print)
- Scanner/Parser:
    - Integers: 3 (3) -3 (-3)    are all valid
    - Booleans: #t, #f, (#t), (#f)
    - Variable names (ID): x, y, a, cat, dog, Howie, cs_107
    - Whilespaces ignored: ' ', '\n', '\t', '\r'
    - Parentheses: '(' (LPAREN), ')' (RPAREN)
        - Does not accept "()" as an expression
    - Comments: (; this is a comment, same for multi- or single-line ;)
    - If: "if"
        - (if 1 2 3), (if #t 1 0), (if (> x y) (+ 3 x) (== x 4))

    - Lambda: "lambda"
        - (lambda () #t), (lambda (x) (+ 1 2)), (lambda (x y) (+ x y)) 

    - Let: "let"
    - Val: "val"

    - Unary operators
        - Sign negation (Neg): '-'
            - Valid: -3, -(3), (-(+ 3 4)), -(+ 3 4), -(if 1 2 3), -x
            - Currently still allows: -#t
        - Boolean negation (Not): '!'
            - Valid: !#t, !(#t), (!#t), !(boolean_expr)
            - Currently still allows: !3, !(if 1 2 3)
    - Binary Operators (with examples for arithmetic operators)
        - Addition: '+'
            - Valid: (+ 3 5), (+ 3 (+ 4 5)), (+ x y),
            - Invalid: + 3 4, (3 + 4), (+ 3 4 5)
            - Currently still allows:  (+ 4 #t) (+ #t #f)
        - Subtraction: '-'
            - Valid: (- 3 4), (- 3 (- 4 5)), (- x 4)
            - Invalid: - 3 4, (3 - 4), (- 3 4 5)
            - Currently still allows: (- 4 #t) (- #t #t)
        - Multiplication: '\*'
            - Valid: (* 4 5),  (* (* 4 5) (* 2 1))
            - Invalid:  * 4 5
            - Currently still allows: (* #t h)
        - Division: '/'
            - Valid: (/ 4 0), (/ 4 2), (/ x y), (/ (+ x y) (* x x))
            - Invalid: / 3 4, (3 / 4)
            - Currently still allows: (/ #t 8)
        - Modulus: "mod"
            - Valid: (mod 4 2), (mod x y), (mod (+ x y) (* 4 5))
            - Invalid: mod 3 4, (3 mod 4)
            - Currently still allows: (/ #t 8)
        - Greater Than: ">"
            - Valid: ( 4 2), ( x y), ( (+ x y) (* 4 5))
            - Invalid:  3 4, (3  4)
            - Currently still allows: (/ #t 8)
        - Less Than: "<"
        - Greater Than or Equal to: ">="
        - Less Than or Equal to: "<="
        - Equal to: "=="
        - Not Equal to: "!="
        - And: "&&": (&& #t #f), (&& h x), (&& (if 1 2 3) (lambda () x))
        - Or: "||": (|| 3 0), (|| 12 42), (|| #f #f)

PROPOSED SUBSTITUTION FOR BINOPS EXAMPLES ABOVE:

    - Binary operators (binops):  - + * / mod < > <= => == != && ||
        - Valid syntax, where operands could be int/bool literals, ids, or expressions:  
            -(binop operand operand)
            -(binop (expression) (expression))
        - Invalid syntax:   
            - binop operand operand
            - binop (operand operand)
            - (operand binop operand)
            - (binop operand)
        - Currently still allowed, but to be changed later:
            - Boolean literals and expressions in mathematical operations
            - Int literals and expressions in boolean operations
            - Mixes of ints and bools in any operation
        
