# gROOT

The programming language (g)ROOT seeks to abstract the finer details away
from the tree abstract data type in order to curtail the complexities that
coincide with tree implementation. It is a functional programming language
based on LISP-style syntax.

Currently we have implemented toplevel.native, which drives the parser and
lexer for the (g)ROOT language, and are able to compile and print literals.


## Contributors
- Samuel Russo          samuel.russo@tufts.edu
- Amy Bui               amy.bui@tufts.edu
- Eliza Encherman       elizabeth.encherman@tufts.edu
- Zachary Goldstein     zachary.goldstein@tufts.edu
- Nickolas Gravel       nickolas.gravel@tufts.edu


## Compile & Run
- **Compile the g(ROOT) compiler with ONE of these two**
    > make
    > make toplevel.native
- **Run test(s)**
    > ./testall.bash
- **Compile a source file: hello.gt, to executable, hello.exe**
    > make hello
- **Run hello executable (prints 'h')**
    > ./hello.exe
- **Compile and create executable for any given source file in our language,
    which must have the format [filename].gt**
   *We provide a hello.gt and a cat.gt as example files.*
    > make [filename].exe
    > ./[filename].exe





## Files
-          README: this file
-        Makefile: file of rules and commands to build toplevel and run test(s).
-          ast.ml: Abstract Syntax Tree file describes syntatic construct and provides
                     a way to print the formatted syntax.
-      parser.mly: instructions to produce a parser from a context-free grammar
                     specification.
-     scanner.mll: lexer file to create a lexical analyzer.
-     toplevel.ml: main driver file to drive scanner and parser.
-         sast.ml: Semantically checked Abstract Syntax Tree file describes
                     syntatic construct and provides a way to print the formatted syntax.
-       semant.ml: module that generates a SAST from a given AST.
-      codegen.ml: module that generates llvm code from the sast of the (g)ROOT code.
-     llgtypes.ml: module that defines what Llvm types equate to which (g)ROOT type.
-      testall.sh: bash script to run all our phase2 tests.
-   extract_test_descriptions.bash: get all the descriptions from all the tests
-       testsets/: directory containing testsets
-     testsets/\*: individual testsets
- testsets/\*/tests: the test files in a testset
- testfiles/\*/ref_\*: directory with files containing expected outputs of pass
                    or failure tests
- \_docker: directory containing the source for the docker development container
- \_docker/Dockerfile: the Dockerfile for the base container
- \_docker/Dockerfile.extended: the Dockerfile for the extended features container
- \_docker/ll_links.sh: utility script to initialize the container LLVM binaries
- \_docker/opam_pacakges.txt: lists required OPAM packages
- \_docker/build.sh: utility script for convenient image building
- \_docker/.bashrc: user initialization for containerized OS 



## Testing
The testsets directory has 13 testsets containing a total of 159 tests; each can be
compiled down to LLVM and then to executables using the above commands. All are
short programs that print a different data type or result. The generated LLVM code is
diff'd against the corresponding expected LLVM we put in ref_llvm. Likewise, the output
when we run the executable is compared against a reference output.

Tests succeed if each prints to stdout the diff statements followed by "I AM GROOT!" in green.
If tests fail, they will print "I am groot..." in red, followed by a description of where it fails. The name of a test determines how the testing script will behave. Tests that begin with
"test-" are expected to compile successfully; tests that begin with "fail-" are expected to
elicit a compilation error.




## Tasks Completed
- Semant: module currently does basic type checking with literals (int, bool, and char),
    and forces type checking for function application for purposes of being able to
    test codegen module. All other expressions will raise a failure. Currently contains
    the start of our type-inference code, commented out.
- Codegen: generates the LLVM code for the required main function definition,
    as well as function declarations for std C's printf and puts and the stringptr
    for the hardcoded strings #t and #f for representing booleans. Codegen for
    literals and print function application are done.
- Sast: Semantically-checked Abstract Syntax Tree and functions for printing it. This will
    currently fail tested on anything that is not "printc", "printb" or "printi", or a literal.


## Environment
This was created using opam-2.1 and llvm-13.

If there are compilation issues that may be due to versioning, we have a docker image that may help:
documentation on using it is available at https://hub.docker.com/r/zegger/llvm-opam
