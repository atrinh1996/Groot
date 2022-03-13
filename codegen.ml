

module L = Llvm
module A = Ast
open Sast 

module StringMap = Map.Make(String)

(* translate sdefns - Given an SAST called sdefns, the function returns 
   and LLVM module (llmodule type), which is the code generated from 
   the SAST. Throws exception if something is wrong. *)
let translate sdefns = 

    let context = L.global_context () in  

    (* Add types to the context to use in the LLVM code *)
    let i32_ty      = L.i32_type context 
    and i1_ty       = L.i1_type context 
    (* REMOVE VOID later *)
    and void_tmp    = L.void_type context

    (* Create an LLVM module (container into which we'll 
       generate actual code) *)
    and the_module = L.create_module context "gROOT" in 

    (* Convert gROOT types to LLVM types *)
    let ltype_of_gtype = function
          A.IType   -> i32_ty
        | A.CType   -> i1_ty 
        | A.BType   -> i1_ty
        (* What is the size of a tree and xtype? *)
        (* | A.TType *)
        (* | A.XType of int *)
        | _         -> void_tmp




    

    (* Return an llmodule *)
    the_module




(*declare globals and add them to the stringmap*)


(*when declaring functions: define arguments and return types, make ocaml functions to 
	fill in body, construct locals and allocate on the stack, check and return local and global values*)


(*expression stuff - construct code for it and return its value*)

(*simple expressions - very straightforward*)

(*block expressions are much more complicated - see 174-267 in microc's codegen*)