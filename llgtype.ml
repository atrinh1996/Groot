(* 
            llgtype.ml

    Creates a context and puts types in it to use in the LLVM code. 
    Converts Ast.gtypes to LLCE types
 *)
module L = Llvm
module A = Ast

(* creates the glocal context instance *)
let context = L.global_context ()


(* Add types to the context to use in the LLVM code *)
let i32_ty      = L.i32_type  context 
let i8_ty       = L.i8_type   context 
let i1_ty       = L.i1_type   context 

(* REMOVE VOID later *)
let void_ty    = L.void_type context

(* "tree_struct" will appear as the struct name in llvm code *)
let tree_struct_ty = L.named_struct_type context "tree_struct"
let tree_struct_ptr_ty = L.pointer_type tree_struct_ty 
let () = L.struct_set_body 
            tree_struct_ty 
            [| 
              i32_ty; 
              tree_struct_ptr_ty; 
              tree_struct_ptr_ty 
            |]
            false


(* Convert gROOT types to LLVM types *)
let ltype_of_gtype = function
    A.IType   -> i32_ty
  | A.CType   -> i8_ty 
  | A.BType   -> i1_ty
  (* What is the size of a tree and xtype? *)
  | A.TType   -> tree_struct_ty
  (* | A.XType of int *)
  | _         -> void_ty

