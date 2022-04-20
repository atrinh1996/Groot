(*
    Notes:

    Format specifiers
      ints      %d 
      char      %c --> will use %s 
      string    %s (bool: #t and #f)
*)

open Cast
open Sast
open Llgtype
(* open Fcodegen *)


(* translate sdefns - Given an CAST (type cprog, a record type), the function 
   returns an LLVM module (llmodule type), which is the code generated from 
   the CAST. Throws exception if something is wrong. *)
let translate { main = main; functions = functions; rho = rho; phi = _ } = 
  (* let () = print_endline "entered Codegen" in  *)

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

  (* Lookup table of function names (lambdas) to (function block, function def) *)
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
     Function takes a Sast.svalue, and returns the constructed 
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


  (* creates a global pointer to some variable's value *)
  let create_global id ty = 
    let lltyp = ltype_of_gtype ty in 
    let rec const_gtyp = function 
        S.TYCON ty    -> const_tycon ty
      | S.TYVAR tp    -> const_tyvar tp
      | S.CONAPP con  -> const_conapp con
    and const_tycon = function 
        S.TInt            -> L.const_int  lltyp 0
      | S.TBool           -> L.const_int  lltyp 0
      | S.TChar           -> L.const_int  lltyp 0
      | S.TArrow (_, _)   -> L.const_pointer_null lltyp
    and const_tyvar = function 
        S.TParam _ -> raise (Failure ("TODO: lltype of TParam"))
    and const_conapp (tyc, _) = const_tycon tyc
    in 
    let init = const_gtyp ty in 
    L.define_global id init the_module
  in 

  let globals : L.llvalue StringMap.t = 
    let rec global_var k (num, typ) map = 
      if num = 0 then map 
      else 
        let id = "_" ^ k ^ "_" ^ string_of_int num in 
        let map' = StringMap.add id (create_global id typ) map in 
        global_var k (num - 1, typ) map'
    in 
    StringMap.fold global_var rho StringMap.empty
  in 

  let lookup id locals = 
    (* try fst (StringMap.find id function_decls)
    with Not_found -> *)
      try StringMap.find id locals 
      with Not_found -> StringMap.find id globals
  in 

  (* Construct code for expression 
     Function takes a Cast.cexpr, and constructs the llvm where 
     builder is located; returns the llvalue representation of code. 

      Note: style - consider currying the function params *)
  let rec expr (_, e) builder lenv = 
    match e with 
       CLiteral v   -> const_val v builder
     | CVar     s  -> 
        (* let () = print_endline ("looking for " ^ s) in  *)
        (try L.build_load (lookup s lenv) s builder
                with Not_found -> 
                    (* let () = print_endline ("failed looking for " ^ s)  *)
                    raise(Failure "not found"))
     | CIf _ -> raise (Failure ("TODO - codegen CIF merge-then-else"))
     | CApply ((_, CVar "printi"), [arg]) -> 
          L.build_call printf_func [| int_format_str ; (expr arg builder lenv) |] "printi" builder
     | CApply ((_, CVar"printc"), [arg]) -> 
        (* L.build_call printf_func [| char_format_str ; (expr arg builder) |] "printc" builder *)
        let () = print_endline "codegen: capply" in 
        L.build_call puts_func [| expr arg builder lenv |] "printc" builder
     | CApply ((_, CVar "printb"), [arg]) -> 
        let bool_stringptr = if expr arg builder lenv = (L.const_int bool_ty 1) then print_true else print_false
        in L.build_call puts_func [| bool_stringptr |] "printb" builder
     | CApply (f, args) -> (* raise (Failure ("TODO - codegen CApply")) *)
        (* let () = print_endline "starting capply" in  *)
        (* let s = (match f with 
                  (_, CVar s) -> s 
                  | _ -> raise (Failure "non fname applied")) in *) 
        (* let () = print_endline ("fname is " ^ s) in  *)
        let llargs = List.map (fun cexp -> expr cexp builder lenv) args in 
        let fblock = expr f builder lenv in
        (* let () = print_endline "got an fblock" in  *)
        L.build_call  fblock 
                      (Array.of_list llargs) 
                      "fun_name"
                      builder 

     | CLet _ -> raise (Failure ("TODO - codegen CLET"))
     | CLambda (id, args, bod) -> (* store function pointer to function here *)
        let (fblock, _) = StringMap.find id function_decls in fblock
        (* L.build_load (lookup id lenv) id builder *)
  in 

  (* construct the code for each instruction in main (which is a cdefn list) *)
  let build_main_body = function 
    | CVal (id, (ty, e)) -> 
        (* create a global define of a variable *)
        (* let _ = create_global id ty in  *)
        let e' = expr (ty, e) main_builder StringMap.empty in 
        (* raise (Failure "TODO") *)
        let _ = L.build_store e' (lookup id StringMap.empty) main_builder  in 
        ()
    | CExpr e -> let _ = expr e main_builder StringMap.empty in 
        ()
  in 
  let _ = List.map build_main_body main in 

  (* Every function definition needs to end in a ret. Puts a return at end of main *)
  let _ = L.build_ret (L.const_int int_ty 0) main_builder in

  (* Build function block bodies *)
  let build_function_body fdef = 
    let (function_block, _) = StringMap.find fdef.fname function_decls in
    let fbuilder = L.builder_at_end context (L.entry_block function_block) in
    
    (* For each param, load them into the function body. 
        locals : llvalue StringMap.t*)
    let locals =  
      let add_formal map (ty, nm) p = 
        (* let () = print_endline ("set val name: " ^ nm) in *)
        let () = L.set_value_name nm p in 
        let local = L.build_alloca (ltype_of_gtype ty) nm fbuilder in
        let _ = L.build_store p local fbuilder in 
        (* let () = print_endline ("putting " ^ nm ^ " in fblocks locals") in  *)
        (* let () = print_endline ("type of " ^ nm ^": " ^ string_of_typ ty) in  *)
        StringMap.add nm local map
      in
      List.fold_left2 add_formal 
                      StringMap.empty 
                      (fdef.formals @ fdef.frees) 
                      (Array.to_list (L.params function_block))

    in 


    (* Build the return  *)
    let (ty, exp) = fdef.body in 
    let result = expr fdef.body fbuilder locals in 
    (* let () = print_endline ("built fbody") in  *)

    let add_terminal builder instr = 
      match L.block_terminator (L.insertion_block builder) with 
          Some _ -> ()
        | None -> ignore (instr builder) in

    let build_ret t = 
      let rec ret_of_gtyp = function
          S.TYCON ty -> ret_of_tycon ty
        | S.TYVAR tp -> ret_of_tyvar tp
        | S.CONAPP con -> ret_of_conapp con
      and ret_of_tycon = function 
          S.TInt            -> L.build_ret result
        | S.TBool           -> L.build_ret result
        | S.TChar           -> L.build_ret result
        | S.TArrow (_, _) -> L.build_ret result
      and ret_of_tyvar = function 
          S.TParam _ -> raise (Failure ("TODO: ret of TParam"))
      and ret_of_conapp (tyc, _) = ret_of_tycon tyc
      in ret_of_gtyp t
    in 

    add_terminal fbuilder (build_ret fdef.rettyp)



  in let _ = List.iter build_function_body functions in 

  (* Return an llmodule *)
  the_module
