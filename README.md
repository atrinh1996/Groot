# gROOT

The programming language (g)ROOT seeks to abstract the finer details away
from the tree abstract data type in order to curtail the complexities that
coincide with tree implementation. It is a functional programming language
based on LISP-style syntax.

Final Paper & Language Reference Manual: https://github.com/atrinh1996/groot/blob/main/FinalReport/groot.pdf
Slide Presentation: https://github.com/atrinh1996/groot/blob/main/FinalPresentation/groot-presentation.pdf


## Contributors
- Samuel Russo          samuel.russo@tufts.edu
- Amy Bui               amy.bui@tufts.edu
- Eliza Encherman       elizabeth.encherman@tufts.edu
- Zachary Goldstein     zachary.goldstein@tufts.edu
- Nickolas Gravel       nickolas.gravel@tufts.edu


- **Compile the g(ROOT) compiler with ONE of these two**
    > make
    > make toplevel.native
- **Run testsuite**
   *Includes cleaning and re-making compiler, compiling and running all tests,
    comparing them against the references, and printing the success or failures
    of said comparisons*
    > ./testall.bash
- **Compile and create executable and intermediate files for any given source  
    file in our language, which must have the format [filename].gt**
   *Intermediate files are stored in toplevel as tmp.ll and tmp.s, respectively*
    > make [filename].exe
- **Compile one source file [filename].gt in our language to LLVM**
    *Assumes that toplevel.native exists and is current*
    > ./toplevel.native -c < [filename].gt
- **Run [filename].exe executable**
    > ./[filename].exe
- **Compiler options**
    *usage: ./toplevel.native [flag] [filename].gt
    > -a        Print the AST (default)
    > -n        Print the AST (name-checking)
    > -t        Print the TAST (type-checked)
    > -m        Print the MAST (monomorphized)
    > -h        Print the HAST (closure conversion 1)
    > -v        Print the CAST (closure conversion 2)
    > -l        Print the generated LLVM IR
    > -c        Check and print the generated LLVM IR
    > -help     Display this list of options
    > --help    Display this list of options





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
-    testall.bash: bash script to run all our phase2 tests.
- extract_test_descriptions.bash: get all the descriptions from all the tests
-               testsets/: directory containing testsets
-             testsets/\*: individual testsets
-       testsets/\*/tests: the test files in a testset
-     testfiles/\*/ref_\*: directory with files containing expected outputs of pass
                            or failure tests
-                       \_docker: directory containing the source for the docker development container
-            \_docker/Dockerfile: the Dockerfile for the base container
-   \_docker/Dockerfile.extended: the Dockerfile for the extended features container
-           \_docker/ll_links.sh: utility script to initialize the container LLVM binaries
-     \_docker/opam_pacakges.txt: lists required OPAM packages
-              \_docker/build.sh: utility script for convenient image building
-               \_docker/.bashrc: user initialization for containerized OS 



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



## Environment
This was created using opam-2.1 and llvm-13.

If there are compilation issues that may be due to versioning, we have a docker image that may help:
documentation on using it is available at https://hub.docker.com/r/zegger/llvm-opam





## Testing descriptions

---


Testset: apply

	- fail-application-less-args : test for failure when too few params provided to application
	- fail-application-more-args : test for failure when too many params provided to application
	- test-application1    : generic function application 
	- test-application2    : global lambda closure stress-test
	- test-application3    : no-args lambdas that return closures upon evaluation
	- test-application4    : ensure correct behavior of global capture
	- test-application5    : passing ID as param to application


---


Testset: arithmetic_binops

	- fail-binop+1         : ensure failure with too few args
	- fail-binop+2         : ensure failure with too many args
	- fail-binop+3         : ensure failure with missing parens
	- fail-binop-1         : ensure failure with too many args
	- fail-binop-div-by-bool : ensure failure with type mismatch for div
	- fail-binop-mul4      : ensure failure with type mismatch for multiply
	- fail-binop_div1      : ensure failure with too few args
	- fail-binop_div2      : ensure failure with too many args
	- fail-binop_div3      : ensure failure with lacking parens
	- fail-binop_mod1      : ensure failure with too many args
	- fail-binop_mod2      : ensure failure with too few args
	- fail-binop_mod3      : ensure failure with lacking parens
	- fail-binop_mul1      : ensure failure with too few args
	- fail-binop_mul2      : ensure failure with too many args
	- fail-binop_mul3      : ensure failure with lacking parens
	- fail-nestedbinops    : ensure failure when non-integer is given 
	- test-add             : ensure correct basic arithmetic
	- test-binop+          : additional sanity check
	- test-binop-          : subtractional sanity check
	- test-binop-div-divisible : divisional sanity check
	- test-binop-mod       : modulo sanity check
	- test-binop-mul       : multiplicational sanity check
	- test-div-by-zero     : ensure that division by zero is possible
	- test-nestedbinops    : basic arithmetic stresstest


---


Testset: boolean_binops

	- fail-AND1            : ensure failure with too many args
	- fail-AND2            : ensure failure with too many args that are ill-typed 
	- fail-AND3            : ensure failure with lacking parens
	- fail-AND4            : ensure failure with correct arg count but type mismatch
	- fail-OR1             : ensure failure with too many args
	- fail-OR2             : ensure failure with too many args that are ill-typed 
	- fail-OR3             : ensure failure with lacking parens
	- fail-OR4             : ensure failure with correct arg count but type mismatch
	- test-AND             : ensure correct truth table for all possible inputs
	- test-OR              : ensure correct truth table for all possible inputs


---


Testset: comparison_binops

	- fail-equalto1        : ensure failure with too many args and type mismatch
	- fail-equalto2        : ensure failure with too few args
	- fail-equalto3        : ensure failure with lacking parens
	- fail-equalto4        : ensure failure with type mismatch
	- fail-equalto5        : ensure failure with unbound var
	- fail-greaterequal1   : ensure failure with too many args and type mismatch
	- fail-greaterequal2   : ensure failure with too few args
	- fail-greaterequal3   : ensure failure with lacking parens
	- fail-greaterequal4   : ensure failure with type mismatch
	- fail-greaterthan1    : ensure failure with too many args
	- fail-greaterthan2    : ensure failure with too few args
	- fail-greaterthan3    : ensure failure with lacking parens
	- fail-lessequal1      : ensure failure with too many args and type mismatch
	- fail-lessequal2      : ensure failure with too few args
	- fail-lessequal3      : ensure failure with lacking parens
	- fail-lessthan1       : ensure failung with too many args
	- fail-lessthan2       : ensure failure with too few args
	- fail-lessthan3       : ensure failure with lacking parens
	- fail-notequal1       : ensure failure with too many args and type mismatch
	- fail-notequal2       : ensure failure with too few args
	- fail-notequal3       : ensure failure with lacking parens
	- test-equalto-var     : ensure that equivalence of vars is possible
	- test-equalto         : ensure correct behavior with constant literals
	- test-greaterequal    : ensure correct behavior
	- test-greaterthan     : ensure correct behavior with constant literals and vars
	- test-lessequal       : ensure correct behavior with constant literals and cars
	- test-lessthan        : ensure correct behavior with constant literals and cars
	- test-notequal        : ensure correct behavior with constant literals and cars


---


Testset: conditionals

	- fail-if1             : ensure failure with too many sub-expressions
	- fail-if2             : ensure failure with inconsitence branch types
	- fail-if3             : ensure failure with bad guard conditional
	- fail-if4             : ensure failure with bad bool literal
	- test-if-constant-nested-guard : l a 'a')
	- test-if              : simple sanity check


---


Testset: inference

	- fail-if0             : ensure failure with incorrect sub expr types
	- fail-if1             : ensure failure with type mismatch across branches
	- fail-if2             : ensure failure with type mismatch across branches
	- fail-if3             : ensure failure with nested conditional with type mismatch across branches
	- fail-lambda0         : ensure failure with too many sub expressions
	- fail-lambda1         : ensure failure with too many sub expressions and bogus function call
	- fail-nlambda2        : partial function application with mixed type free variables ; we expect this to fail due to issues with nested lambdas
	- test-add0            : ensure success of addition
	- test-apply0          : ensure success with application of free var inside closure
	- test-apply1          : ensure success of inline lambda application
	- test-apply2          : assorted application tests; ensure free and bound vars behave
	- test-apply3          : inline lambda application with conditional
	- test-apply4          : use identity function in addition
	- test-argorder0       : simple argument ordering
	- test-if0             : simple conditional; all bools
	- test-if1             : simple conditional, integer branches
	- test-if2             : sanity check for conditional
	- test-if3             : nested conditionals
	- test-lambda0         : identity function; ensure success of polymorphic function
	- test-lambda1         : ensure that guard conditional applies boolean constraint on lambda arg
	- test-lambda2         : ensure correct constraint for addition within lambda
	- test-lambda3         : ensure polymorphic type for unsued param in lambda
	- test-lambda4         : ensure polymorphic type for unused lambda param
	- test-lambda5         : ensure unused polymorphic type for identity function
	- test-lambda7         : ensure success contraint propagation in conditional
	- test-mert0           : typed ids in conditional
	- test-mert1           : lambda application with inferred arg type
	- test-nlambda0        : nested lambda with free vars; this passes with a polymorphism warning about resolution to ints
	- test-nlambda1        : nested lambda to ensure constrain propagation
	- test-nlambda2        : nested lambda application within nested lambda
	- test-nlambda3        : nested lambda within nested lambda, no application
	- test-nlambda4        : partial functional application, different types
	- test-prims0          : ensure correct typing of all prims
	- test-printall0       : ensure correct printing of values form each prim
	- test-printi0         : print an integer
	- test-val0            : simple assignment


---


Testset: lambda

	- fail-lambda1         : lambda, no body
	- fail-lambda2         : lambda, no args
	- fail-lambda3         : improper function application wthin body of lambda
	- test-lambda-apply    : print value of lambda application
	- test-lambda-closure  : l x 42)
	- test-lambda          : lambda stress-test


---


Testset: let

	- fail-let1            : incorrect syntax
	- fail-let2            : incorrect syntax; bind list improper
	- fail-let3            : ensure that local vars are not bound at toplevel
	- test-let             : let stress test


---


Testset: sanity_checks

	- test-hello           : print single character
	- test-print-false     : print false (#t)
	- test-print-true      : print true (#t)
	- test-print42         : print 42
	- test-small           : small stress test of various functions
	- test-smallprint      : small stress test of various functions, with printing
	- test-val             : variable assignment


---


Testset: semantics

	- fail-undefined-var   : reference to undefined var should fails
	- fail-val-not-func    : applying non-function is not allowed
	- test-closure         : ensure that lambda closures maintain static copies of free vars (unchanged when global vars change)
	- test-fun-def-app     : apply one arg lambda function bound to toplevel id
	- test-fun-def         : square an integer! a very useful function!


---


Testset: types

	- fail-bad_boolean1    : bad boolean, should be a lexer error
	- fail-bad_boolean2    : bad boolean, should be a lexer error
	- fail-bad_boolean3    : another bad boolean, should be lexer error
	- fail-bad_boolean4    : another bad boolean, should be lexer error
	- fail-bool_stresstest : type mismatch in arithmetic and comparison operators
	- fail-boolchar        : type mismatch in logical OR
	- fail-char1           : bad char literal, too many chars; should be lexer error
	- fail-char2           : attempt application of char literal
	- fail-int1            : attempt application of integer literal
	- fail-intchar         : type mismatch in addition
	- test-bool-stresstest : boolean stress test; test everything
	- test-boolean         : just lex two boolean literals
	- test-char            : just test three char literals
	- test-integers        : just lex four integer literals


---


Testset: unops

	- fail-NOT1            : too few args and type mismatch 
	- fail-NOT2            : set of parens missing
	- fail-NOT3            : set of parens missing
	- test-NOT             : invert some booleans
	- test-neg1            : negate an integer


---


Testset: val

	- fail-val1            : invalid identifier used for toplevel binding
	- fail-val2            : too many subexpressions
	- fail-val3            : too few subexpressions
	- fail-val4            : too many subexpressions and invalid identifier
	- fail-val5            : no subexpressions
	- test-redefine-var    : reassignment of toplevel variable
	- test-val-var         : simple assignment
	- test-val             : val stress test
