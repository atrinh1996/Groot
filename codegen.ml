(*
    Notes:

    Format specifiers
      ints      %d 
      char      %c --> will use %s 
      string    %s (bool: #t and #f)
*)

open Cast
open Llgtype
(* open Fcodegen *)


(* translate sdefns - Given an CAST (type cprog, a record type), the function 
   returns an LLVM module (llmodule type), which is the code generated from 
   the CAST. Throws exception if something is wrong. *)
let translate { main = main; functions = functions; rho = _; phi = _ } = 

  (* Create an LLVM module (container into which we'll 
     generate actual code) *)
  let the_module = L.create_module context "gROOT" in 


  (* DECLARE a print function (std::printf in C lib) *)
  let printf_ty : L.lltype = 
      L.var_arg_function_type int_ty [| char_ptr_ty |] in
  let printf_func : L.llvalue = 
     L.declare_function "printf" printf_ty the_module in

  let puts_ty : L.lltype = 
      L.function_type int_ty [| char_ptr_ty |] in
  let puts_func : L.llvalue = 
     L.declare_function "puts" puts_ty the_module in



 (* To test struct type
    Comment these lines in, run.
    Should make the code defining the struct appear in the llvm code. *)
  let main_ty = L.function_type int_ty [| tree_struct_ty |] in
  let the_main = L.define_function "main" main_ty the_module in

  (* To test a simple codegen. Gives an void main, no args. *)
  (* let main_ty = L.function_type void_ty [|  |] in
  let the_main = L.define_function "main" main_ty the_module in *)


  (* create a builder for the whole program, start it in main block *)
  let main_builder = L.builder_at_end context (L.entry_block the_main) in


  (* Format strings to use with printf for our literals *)
  let int_format_str  = L.build_global_stringptr "%d\n" "fmt"   main_builder

  (* string constants for printing booleans *)
  and boolT           = L.build_global_stringptr "#t"   "boolT" main_builder
  and boolF           = L.build_global_stringptr "#f"   "boolF" main_builder
  in 


  let zero = L.const_int int_ty 0 in
  let print_true = L.build_in_bounds_gep boolT [| zero |] "" main_builder in
  let print_false = L.build_in_bounds_gep boolF [| zero |] "" main_builder in

  (* Lookup table of functin names (lambdas) to (function block, function def) *)
  let function_decls : (L.llvalue * fdef) StringMap.t = 
    let define_func map def =  
      let name = def.fname 
      and formal_types = 
        Array.of_list (List.map (fun (t, _) -> ltype_of_gtype t) 
                      (def.formals @ def.frees)) 
      in 
      let ftype = L.function_type (ltype_of_gtype def.rettyp) formal_types
      in StringMap.add name (L.define_function name ftype the_module, def) map 
    in List.fold_left define_func StringMap.empty functions 
  in 


  (* Construct constants code for literal values.
     Function takes a Sast.svalue, and returls the constructed 
     llvalue  *)
  let const_val v builder = 
    match v with 
        (* create the "string" constant in the code for the char *)
        CChar c -> (* L.const_string context (String.make 1 c) *)
            let spc = L.build_alloca char_ptr_ty "spc" builder in 
            let globalChar = L.build_global_string (String.make 1 c) "globalChar" builder in 
            let newStr = L.build_bitcast globalChar char_ptr_ty "newStr" builder in 
            let loc = L.build_gep spc [| zero |] "loc" builder in 
            let _ = L.build_store newStr loc builder in 
            L.build_load spc "character_ptr" builder
      | CInt  i -> L.const_int int_ty i 
      (* HAS to be an i1 lltype for the br instructions *)
      | CBool b -> L.const_int bool_ty (if b then 1 else 0)
      | CRoot _ -> raise (Failure ("TODO - codegen SRoot Literal"))
  in

  (* Construct code for expression 
     Function takes a Cast.cexpr, and constructs the llvm where 
     builder is located; returns the llvalue representation of code*)
  let rec expr (_, e) builder = 
    match e with 
       CLiteral v   -> const_val v builder
     | CVar     _  -> raise (Failure ("TODO - codegen CVar lookup"))
     | CIf _ -> raise (Failure ("TODO - codegen CIF merge-then-else"))
     | CApply ("printi", [arg]) -> 
          L.build_call printf_func [| int_format_str ; (expr arg builder) |] "printi" builder
     | CApply ("printc", [arg]) -> 
        (* L.build_call printf_func [| char_format_str ; (expr arg builder) |] "printc" builder *)
        L.build_call puts_func [| expr arg builder |] "printc" builder
     | CApply ("printb", [arg]) -> 
        let bool_stringptr = if expr arg builder = (L.const_int bool_ty 1) then print_true else print_false
        in L.build_call puts_func [| bool_stringptr |] "printb" builder
     | CApply _ -> raise (Failure ("TODO - codegen SAPPLY general"))
     | CLet _ -> raise (Failure ("TODO - codegen CLET"))
     | CLambda _ -> raise (Failure ("TODO - codegen CLambda"))
  in 


  (* construct the code for each instruction in main (which is a cdefn list) *)
  (* let build_main_body = function 
    | CVal (_, _) -> raise (Failure ("TODO - codegen CVal"))
    | CExpr e -> expr e main_builder
  in 
  let _ = List.map build_main_body main in *) 


  (* Every function definition needs to end in a ret *)
  let _ = L.build_ret (L.const_int int_ty 0) main_builder in

  (* Return an llmodule *)
  the_module
