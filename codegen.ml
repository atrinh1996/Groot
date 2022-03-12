(* Adapted from MicroC's codegen *)

(* make LLVM and AST modules, open sast, make stringmap module *)

(* make context, add types to it, then convert groot types to LLVM types*)

(*declare globals and add them to the stringmap*)


(*when declaring functions: define arguments and return types, make ocaml functions to 
	fill in body, construct locals and allocate on the stack, check and return local and global values*)


(*expression stuff - construct code for it and return its value*)

(*simple expressions - very straightforward*)

(*block expressions are much more complicated - see 174-267 in microc's codegen*)