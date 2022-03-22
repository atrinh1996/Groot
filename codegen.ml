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


    Format specifiers
      ints      %d 
      char      %c --> will use %s 
      string    %s (bool: #t and #f)
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

  (* Create an LLVM module (container into which we'll 
     generate actual code) *)
  let the_module = L.create_module context "gROOT" in 


  (* DECLARE a print function (std::printf in C lib) *)
  let printf_ty : L.lltype = 
      L.var_arg_function_type int_ty [| L.pointer_type char_ty |] in
  let printf_func : L.llvalue = 
     L.declare_function "printf" printf_ty the_module in

  let puts_ty : L.lltype = 
      L.function_type int_ty [| L.pointer_type char_ty |] in
  let puts_func : L.llvalue = 
     L.declare_function "puts" puts_ty the_module in



 (* To test struct type
    Comment these lines in, run.
    Should make the code defining the struct appear in the llvm code. *)
  let main_ty = L.function_type void_ty [| tree_struct_ty |] in
  let the_main = L.define_function "main" main_ty the_module in

  (* To test a simple codegen. Gives an void main, no args. *)
  (* let main_ty = L.function_type void_ty [|  |] in
  let the_main = L.define_function "main" main_ty the_module in *)


  (* create a builder for the whole program, start it in main block *)
  let builder = L.builder_at_end context (L.entry_block the_main) in


  (* Format strings to use with printf for our literals *)
  let int_format_str  = L.build_global_stringptr "%d\n" "fmt"   builder
  and char_format_str = L.build_global_stringptr "%s\n" "fmt"   builder
  and bool_format_str = L.build_global_stringptr "%s\n" "fmt"   builder 

  (* string constants for printing booleans *)
  and boolT           = L.build_global_stringptr "#t"   "boolT" builder
  and boolF           = L.build_global_stringptr "#f"   "boolF" builder
  in 


  let zero = L.const_int int_ty 0 in
  let print_true = L.build_in_bounds_gep boolT [| zero |] "" builder in
  let print_false = L.build_in_bounds_gep boolF [| zero |] "" builder in


  (* Construct constants code for literal values.
     Function takes a Sast.svalue, and returls the constructed 
     llvalue  *)
  let const_val v = 
    match v with 
        (* create the "string" constant in the code for the char *)
        SChar c -> (* L.const_string context (String.make 1 c) *)
            let spc = L.build_alloca char_ptr_ty "spc" builder in 
            let globalChar = L.build_global_string (String.make 1 c) "globalChar" builder in 
            let newStr = L.build_bitcast globalChar char_ptr_ty "newStr" builder in 
            let loc = L.build_gep spc [| zero |] "loc" builder in 
            let _ = L.build_store newStr loc builder in 
            L.build_load spc "character_ptr" builder
      | SInt  i -> L.const_int int_ty i 
      (* HAS to be an i1 lltype for the br instructions *)
      | SBool b -> L.const_int bool_ty (if b then 1 else 0)
      | SRoot _ -> raise (Failure ("TODO - codegen SRoot Literal"))
  in

  (* Construct code for expression 
     Function takes a Sast.sexpr, and constructs the llvm where 
     builder is located; returns the llvalue representation of code*)
  let rec build_expr ((t, e) : sexpr) = 
    match e with 
       SLiteral v   -> const_val v
     | SVar     id  -> raise (Failure ("TODO - codegen SVar lookup"))
     | SIf (condition, then_exp, else_exp) -> 
            raise (Failure ("TODO - codegen SIF merge-then-else"))
     | SApply ("printi", [arg]) -> 
          L.build_call printf_func [| int_format_str ; (build_expr arg) |] "printi" builder
     | SApply ("printc", [arg]) -> 
        (* L.build_call printf_func [| char_format_str ; (build_expr arg) |] "printc" builder *)
        L.build_call puts_func [| build_expr arg |] "printc" builder
     | SApply ("printb", [arg]) -> 
        let bool_stringptr = if build_expr arg = (L.const_int bool_ty 1) then print_true else print_false
        in L.build_call puts_func [| bool_stringptr |] "printb" builder
     | SApply (f, args) -> 
        raise (Failure ("TODO - codegen SAPPLY general"))
     | SLet (binds, e) -> raise (Failure ("TODO - codegen SLET"))
     | SLambda (formals, e) -> raise (Failure ("TODO - codegen SLambda"))
  in 


  (* Construct the code for a definition *)
  let build_defn sdef = 
    match sdef with 
        SVal (id, e) -> raise (Failure ("TODO - codegen SVal"))
      | SExpr e -> build_expr e
  in 


  (* Iterate over the sdefns list to construct the code for them *)
  let _ = List.map build_defn sdefns in

  (* Every function definition needs to end in a ret *)
  let _ = L.build_ret_void builder in

  (* Return an llmodule *)
  the_module
