# gROOT

The programming language (g)ROOT seeks to abstract the finer details away 
from the tree abstract data type in order to curtail the complexities that 
coincide with tree implementation. It is a functional programming language 
based on LISP-style syntax. 

Currently we have implemented toplevel.native, which drives the parser and
lexer for the (g)ROOT language, and will print the given input (formatted)
if the syntax is correct. 


## Contributors
- Samuel Russo          samuel.russo@tufts.edu
- Amy Bui               amy.bui@tufts.edu
- Eliza Encherman       elizabeth.encherman@tufts.edu
- Zachary Goldstein     zachary.goldstein@tufts.edu
- Nickolas Gravel       nickolas.gravel@tufts.edu


## Compile & Run 
- **Compile the g(ROOT) compiler with**
    > make 
- **Run test(s)**
    > ./testall.sh
- **Compile a source file: hello.gt, to executable, hello.exe**
    > make hello 
- **Run hello executable (prints 'h')**
    > ./hello.exe


## Files
- README: this file
- Makefile: file of rules and commands to build toplevel and run test(s).
- ast.ml: Abstract Syntax Tree file describes syntatic construct and provides
  a way to print the formatted syntax.
- parser.mly: instructions to produce a parser from a context-free grammar
  specification.
- scanner.mll: lexer file to create a lexical analyzer.
- toplevel.ml: main driver file to drive scanner and parser.
- sast.ml: Semantically checked Abstract Syntax Tree file describes 
    syntatic construct and provides a way to print the formatted syntax.
- semant.ml: module that generates a SAST from a given AST.
- codegen.ml: module that generates llvm code from the sast of the (g)ROOT code.
- llgtypes.ml: module that defines what Llvm types equate to which (g)ROOT type.
- testall.sh: bash script to run all our phase2 tests.
- testfiles/: directory containing unit test files and expected outputs.
    - testfiles/ref\*: directory with files containing expected outputs of pass
      or failure tests of the test files in testfiles/ of the same name. 




## Testing
The testfiles directory has 4 files that can be compiled down to LLVM and then
to executables using the above commands. For example, test-hello.gt can be 
made into LLVM code. The outputted LLVM code is diff'd against the corresponding
expected LLVM we put in ref_llvm. Likewise, the output when we run the 
executable is compared against a reference output. 


## Tasks Completed
- Semant: module currently does basic type checking with literals, and forces
    type checking for function application for purposes of being able to 
    test codegen module
- Codegen: generates the LLVM code for the required main function definition, 
    as well as function declarations for std C's printf and puts. Codegen for
    literals and print function application are done. 
