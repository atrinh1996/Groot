

module L = Llvm
module A = Ast
open Sast 

module StringMap = Map.Make(String)

(* translate sdefns - Given an SAST called sdefns, the function returns 
   and LLVM module (llmodule type), which is the code generated from 
   the SAST. Throws exception if something is wrong. *)


(* make context, add types to it, then convert groot types to LLVM types*)

(*declare globals and add them to the stringmap*)


(*when declaring functions: define arguments and return types, make ocaml functions to 
	fill in body, construct locals and allocate on the stack, check and return local and global values*)


(*expression stuff - construct code for it and return its value*)

(*simple expressions - very straightforward*)

(*block expressions are much more complicated - see 174-267 in microc's codegen*)