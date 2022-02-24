# gROOT

The programming language (g)ROOT seeks to abstract the finer details away 
from the tree abstract data type in order to curtail the complexities that 
coincide with tree implementation. It is a functional programming language 
based on LISP-style syntax. 

This program drives the parser and lexer for the (g)ROOT language, 
and will 
print the given input (formatted) if the syntax is correct. 


## Contributors
- Samuel Russo          samuel.russo@tufts.edu
- Amy Bui               amy.bui@tufts.edu
- Eliza Encherman       elizabeth.encherman@tufts.edu
- Zachary Goldstein     zachary.goldstein@tufts.edu
- Nickolas Gravel       nickolas.gravel@tufts.edu



## COMPILE & RUN
- **Compile toplevel with**:
    > make toplevel.native
- **Run toplevel with one of these**:
    - runs on standard input and prints ast to stdout, use EOF (ctrl+d) to end input
    > ./toplevel.native
    - runs on given file, outputs ast to stdout
    > ./toplevel.native [file.gt]
    - prints the ast from given file or stdin (default)
    > ./toplevel.native -a [file.gt] 
    - not yet implemented, will be compilation
    > ./toplevel.native -c [file.gt] 
    - pipes whatever expressions are \<input\> into toplevel.native
    > echo "\<input\>" | ./toplevel.native  
- **Run tests with**:
    > ./testall.sh



## FILES
- README: this file
- Makefile: file of rules and commands to build toplevel.
- ast.ml: Abstract Syntax Tree file describes syntatic construct and provides way to print the formatted syntax.
- parser.mly: instructions to produces a parser from a context-free grammar specification.
- scanner.mll: lexer file to create a lexical analyzer.
- toplevel.ml: main driver file to drive scanner and parser.
- testall.sh: bash script to run all our tests.
- testfiles/: directory containing unit test files and expected outputs.
    - testfiles/ref: directory with files containing expected outputs of pass and failure tests of the test files in testfiles/ of the same name. Each tests' stdout/stderr can be diff'd againsts it's reference. 



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
    - Integers: 3, -3   
    - Booleans: #t, #f
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
        - (let x 4 (+ 2 x)), (let x 4 (let y 5 (let z 9 (* x (* y z)))))
    - Val: "val"
        - (val x 4), (val func (lambda (x) (+ x 1)))
    - Unary operators
        - Sign negation (Neg): '-'
            - Valid: -3, (-(+ 3 4)), -(+ 3 4), -(if 1 2 3), -x
            - Currently still allows: -#t
        - Boolean negation (Not): '!'
            - Valid: !#t, !(#t), (!#t), !(boolean_expr)
            - Currently still allows: !3, !(if 1 2 3)
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
            - Ex: (+ 3 5), (+ 3 (+ 4 5)), (+ x y), (+ 4 #t), (+ #t #f), (/ 4 0), (mod (+ x y) (* 4 5))
