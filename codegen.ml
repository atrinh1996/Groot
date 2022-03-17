(*
    Notes:

    sdefn contains sexr:
        type sdefn = 
          | SVal of ident * sexpr
          | SExpr of sexpr

    sexpr: 
        type sexpr = gtype * sx
        and sx = 
           SLiteral of svalue
         | SVar     of ident
         | SIf      of sexpr * sexpr * sexpr
         | SApply   of sexpr * sexpr list
         | SLet     of (ident * sexpr) list * sexpr
         | SLambda  of ident list * sexpr
*)

(* module L = Llvm *)
(* module A = Ast *)
open Llgtype
open Sast 


module StringMap = Map.Make(String)

(* translate sdefns - Given an SAST called sdefns, the function returns 
   an LLVM module (llmodule type), which is the code generated from 
   the SAST. Throws exception if something is wrong. 
  
  Note: An sdefn is an SVal or an SExpr, 
  ie (id, (Ast.gtyp, Sast.sx)) or (Ast,gtyp, Sast.sx).
  Remember: we are dealing with a list of sdefn's 
 *)
let translate sdefns = 

  (* let context = L.global_context () in   *)

  (* Add types to the context to use in the LLVM code *)
  (* let i32_ty      = L.i32_type  context  *)
  (* and i8_ty       = L.i8_type   context  *)
  (* and i1_ty       = L.i1_type   context  *)
  (* REMOVE VOID later *)
  (* and void_tmp    = L.void_type context in  *)
  (* val struct_type : llcontext -> lltype array -> lltype
      struct_type context tys returns the structure type in 
      the context context containing in the types 
      in the array tys.  

     val pointer_type : lltype -> lltype
      pointer_type ty returns the pointer type referencing 
      objects of type ty in the default address space (0).

    val named_struct_type : llcontext -> string -> lltype
      named_struct_type context name returns the named structure 
      type name in the context context. 
    
    https://stackoverflow.com/questions/66912702/define-new-type-in-llvm-ir-using-ocaml-bindings

    *)
  (* and struct_ty   = L.struct_type context [| i32_ty  |] *)
  (* "tree_struct" will appear as the struct name in llvm code *)
  (* let tree_struct_ty = L.named_struct_type context "tree_struct" in
  let tree_struct_ptr_ty = L.pointer_type tree_struct_ty in 
    L.struct_set_body 
      tree_struct_ty 
      [| 
          i32_ty; 
          tree_struct_ptr_ty; 
          tree_struct_ptr_ty 
      |]
      false
  ; *)

  (* Create an LLVM module (container into which we'll 
     generate actual code) *)
  let the_module = L.create_module context "gROOT" in 

  (* Convert gROOT types to LLVM types *)
  (* let ltype_of_gtype = function
        A.IType   -> i32_ty
      | A.CType   -> i8_ty 
      | A.BType   -> i1_ty
      What is the size of a tree and xtype?
      | A.TType   -> tree_struct_ty
      (* | A.XType of int *)
      | _         -> void_tmp
  in  *)

  (* To test struct type
      Comment these lines in, run.
      Should make the code defining the struct appear in the llvm code. *)
  (* let main_t = L.function_type void_tmp [| tree_struct_ty |] in
  let _main = L.declare_function "main" main_t the_module in *)


  (* Llvm.print_module "./main.ll" the_module *)



  (* Declare each toplevel val variable, i.e. (val x 1). 
     Remember its value in a map.
     global_vars_map is a StringMap mapping key (string name) 
     to value (llvalue)  *)
  let global_vars_map : L.llvalue StringMap.t = 
    let global_var map sdef = 
      match sdef with
          (* sexp is an Sast.sx type. What the the llvm version of sx *)
          SVal(name, (t, sexp)) -> 
          (* 
            in (val x 1), v should be 1
            in (val x (if #t #f #t)), v should be #t or the if??
            in (val add1 (lambda (n) (+ n 1))), v should be the lambda

            DO I NEED A CODE CONSTRUCTOR for exprs???
          *)
            (* let v = eval  in  *)
            let init = match t with 
                A.IType   -> L.const_int (ltype_of_gtype t) 0
              | A.CType   -> L.const_int (ltype_of_gtype t) 0
              | A.BType   -> L.const_int (ltype_of_gtype t) 0
              (* What is the size of a tree and xtype? *)
              (* | A.TType *)
              (* | A.XType of int *)
              | _         -> L.const_int (ltype_of_gtype t) 0
            (* Map Val Variable "name" to llvalue that represents ?????? *)
            in StringMap.add name (L.define_global name init the_module) map 
        | SExpr(_) -> raise (Failure ("TODO - codegen SExpr global_vars"))
    in List.fold_left global_var StringMap.empty sdefns
  in 




  (* Return an llmodule *)
  the_module
