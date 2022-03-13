(*
    Notes:

    sdefn is contains sexr:
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
  let i32_ty      = L.i32_type  context 
  and i8_ty       = L.i8_type   context 
  and i1_ty       = L.i1_type   context 
  (* REMOVE VOID later *)
  and void_tmp    = L.void_type context

  (* Create an LLVM module (container into which we'll 
     generate actual code) *)
  and the_module = L.create_module context "gROOT" in 

  (* Convert gROOT types to LLVM types *)
  let ltype_of_gtype = function
        A.IType   -> i32_ty
      | A.CType   -> i8_ty 
      | A.BType   -> i1_ty
      (* What is the size of a tree and xtype? *)
      (* | A.TType *)
      (* | A.XType of int *)
      | _         -> void_tmp
  in 



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
