(* 
            llgtype.ml

    Creates a context and puts types in it to use in the LLVM code. 
    Converts Ast.gtypes to LLCE types
 *)
module L = Llvm
(* module A = Ast *)
module S = Sast

(* creates the glocal context instance *)
let context = L.global_context ()


(* Add types to the context to use in the LLVM code *)
let int_ty      = L.i32_type  context 
let char_ty       = L.i8_type   context 
let char_ptr_ty = L.pointer_type char_ty
let bool_ty       = L.i1_type   context 
let string_ty   = L.struct_type context [| L.pointer_type char_ty |]
let zero = L.const_int int_ty 0
(* REMOVE VOID later *)
let void_ty    = L.void_type context

(* "tree_struct" will appear as the struct name in llvm code *)
let tree_struct_ty = L.named_struct_type context "tree_struct"
let tree_struct_ptr_ty = L.pointer_type tree_struct_ty 
let () = L.struct_set_body 
            tree_struct_ty 
            [| 
              int_ty; 
              tree_struct_ptr_ty; 
              tree_struct_ptr_ty 
            |]
            false


(* Convert gROOT types to LLVM types *)
(* let ltype_of_gtype = function
    A.IType   -> int_ty
  | A.CType   -> char_ty 
  | A.BType   -> bool_ty
  What is the size of a tree and xtype?
  | A.TType   -> tree_struct_ty
  (* | A.XType of int *)
  | _         -> void_ty *)

(* let rec ltype_of_gtype = function
    S.TYCON ty          -> ltype_of_tycon ty
  | S.TYVAR tp          -> ltype_of_tyvar tp
  | S.CONAPP (ty, _)  -> ltype_of_gtype ty
and ltype_of_tycon = function 
    "int"       -> int_ty
  | "bool"      -> bool_ty
  | "char"      -> char_ty
  | "tree"      -> tree_struct_ty
  | "function"  -> void_ty
  | _           -> void_ty
and ltype_of_tyvar = function 
    TParam _    -> void_ty *)
  (* | _           -> void_ty *)

let rec ltype_of_gtype = function
    S.TYCON ty -> ltype_of_tycon ty
  | S.TYVAR tp -> ltype_of_tyvar tp
  | S.CONAPP con -> ltype_of_conapp con
and ltype_of_tycon = function 
    S.TInt                -> int_ty
  | S.TBool               -> bool_ty
  | S.TChar               -> char_ty
  | S.TArrow (ret, args)  -> 
    (* L.pointer_type ( *)
      L.function_type (ltype_of_gtype ret) (Array.of_list (List.map ltype_of_gtype args))
      (* ) *)
and ltype_of_tyvar = function 
    (* What is this type even? *)
    S.TParam _ -> void_ty
    (* And what types do conapps represent? *)
and ltype_of_conapp (tyc, _) = ltype_of_tycon tyc
