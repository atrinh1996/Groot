# gROOT

The programming language (g)ROOT seeks to abstract the finer details away from this abstract data type in order to curtail the complexities that coincide with tree implementation.

## COMPILE & RUN
- Run with:
    - ./run_tests.sh

*Commands for the group as we are working through the project*
- Compile lexer with:
    - ocamllex scanner.mll
    
    *produces scanner.ml*
- Compile parser with:
    - ocamlyacc parser.mly
    
    *produces parser.ml*
- Compile toplevel with:
    - ocamlbuild toplevel.native
    - make toplevel.native
- Run toplevel with:
    - ./toplevel.native


## FILES
- ast.ml: Abstract Syntax Tree file describes syntatic construct.
- parser.mly: instructions to produces a parser from a context-free grammar specification.
- scanner.mll: lexer file to create a lexical analyzer.
- toplevel.ml: main driver file to drive scanner and parser.
- run_test.sh: bash script to run tests.
- tests/: directory containing tests.
    - test1 ...



## Tasks Completed
- parser recognizes pos and neg ints. toplevel for now prints ints
- parser recognizes char. Syntax: 'c'. toplevel prints strings of ints/chars.
- Char can now print integers represented as chars: '1' and '?' and 'a' we  are
  unsure about escape characters
- We have bools! We had to separately define them because it made sense


## Notes for Us
- Provided a makefile to make edits and checking compilation easier. 
    - make parser
    - make lexer
    - make toplevel.native
    - make clean  
    
    *make clean before you make toplevel. The stuff from making parser and lexer
    separately for some reason interferes with ocamlbuild. If files to remove
    don't exist in top directory, you'll just get file doesn't exist error.
    Thats okay.*