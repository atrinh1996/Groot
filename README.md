# gROOT

The programming language (g)ROOT seeks to abstract the finer details away from this abstract data type in order to curtail the complexities that coincide with tree implementation.


## Contributors
- Samuel Russo
- Amy Bui
- Eliza Encherman
- Zachary Goldstein
- Nickolas Gravel



## COMPILE & RUN
- Run tests with:
    - ./run_tests.sh

- **Compile toplevel with one of these**:
    - ocamlbuild toplevel.native
    - make toplevel.native
- **Run toplevel with one of these**:
    - ./toplevel.native
    - ./toplevel.native [file.gt]
    - ./toplevel.native -a [file.gt]
    - echo "\<input\>" | toplevel.native



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
    - Integers: 3, (3). -3, (-3)
    - Booleans: #t, #f, (#t), (#f)
    - Variable names (ID): x, y, a, cat, dog, Howie, cs_107
    - Whilespaces ignored: ' ', '\n', '\t', '\r'
    - Parentheses: '(' (LPAREN), ')' (RPAREN)
        - Does not accept "()" as an expression
    - Comments: (; this is a comment (winky faces) ;)
    - If: "if"
        - (if 1 2 3), (if #t 1 0), (if (> x y) (+ 3 x) (== x 4))

    - Lambda: "lambda"
        - (lambda () #t), (lambda (x) (+ 1 2)), (lambda (x y) (+ x y)) 

    - Let: "let"
    - Val: "val"

    - Unary operators
        - Negation: '-'
            - Works: -3, -(3), (-(+ 3 4)), -(+ 3 4), -#t, -(if 1 2 3), -x
        - Not: '!'
            - Works: !#t, !#t, !#t, !3, !(if 1 2 3)
    - Binary Operators (with examples for arithmetic operators)
        - Addition: '+'
            - Works: (+ 3 5), (+ 3 (+ 4 5)), (+ x y), (+ 4 #t) (+ #t #f)
            - Does not work: + 3 4, (3 + 4)
        - Subtraction: '-'
            - Works: (- 3 4), (- 3 (- 4 5)), (- x 4)
            - Doesn't work: - 3 4, (3 - 4), (- 3 4 (- 5 6))
        - Multiplication: '\*'
            - Works: (* #t h), (* (* 4 5) (* 2 1))
        - Division: '/'
            - Works: (/ 4 0), (/ 4 2), (/ x y), (/ (+ x y) (* x x))
            - Does not work: / 3 4, (3 / 4)
        - Modulus: "mod"
        - Greater Than: ">"
        - Less Than: "<"
        - Greater Than or Equal to: ">="
        - Less Than or Equal to: "<="
        - Equal to: "=="
        - Not Equal to: "!="
        - And: "&&": (&& #t #f), (&& h x), (&& (if 1 2 3) (lambda () x))
        - Or: "||": (|| 3 0), (|| 12 42), (|| #f #f)

