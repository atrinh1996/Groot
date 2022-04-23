(*
    Notes:

    Format specifiers
      ints      %d 
      char      %c --> will use %s 
      string    %s (bool: #t and #f)
*)

open Llgtype
open Cast
(* module StringMap = Map.Make(String) *)


(* translate sdefns - Given an CAST (type cprog, a record type), the function 
   returns an LLVM module (llmodule type), which is the code generated from 
   the CAST. Throws exception if something is wrong. *)
let translate { main = main;  functions = functions; 
                rho = rho;    structures = structures } = 


  (* Convert Cast.ctype types to LLVM types *)
  let ltype_of_type (struct_table : L.lltype StringMap.t) (ty : ctype) = 
    let rec ltype_of_ctype = function
        Tycon ty -> ltype_of_tycon ty
      | Tyvar tp -> ltype_of_tyvar tp
      | Conapp con -> ltype_of_conapp con
    and ltype_of_tycon = function 
        Intty                -> int_ty
      | Boolty               -> bool_ty
      | Charty               -> char_ty
      | Tarrow (ret, args)  -> 
        (* let () = print_endline "function pointer type:" in  *)
        (* let () = print_string "return type: " in  *)
        let llretty = ltype_of_ctype ret in 
        (* let () = print_string "\narg types: " in *)
        let llargtys = List.map ltype_of_ctype args in 
        (* let () = print_string "\n" in *)
        L.pointer_type (
          L.function_type llretty (Array.of_list llargtys)
        )
      | Clo (sname, _, _) -> 
          (* let () = print_endline ("Create struct type: " ^ sname) in   *)
          L.pointer_type (StringMap.find sname struct_table)
      (* | Clo (_, _) -> raise (Failure "TODO: struct types") *)
    and ltype_of_tyvar = function 
        (* What is this type even? *)
        Tparam _ -> void_ty
        (* And what types do conapps represent? *)
    and ltype_of_conapp (tyc, _) = ltype_of_tycon tyc
    in  ltype_of_ctype ty 
  in



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

  (* helper to construct named structs  *)
  let create_struct (name : cname) (membertys : ctype list) (map : L.lltype StringMap.t) = 
    (* let () = print_endline ("New struct: " ^ name) in *)
    let new_struct_ty = 
        L.named_struct_type context name
    in 
(*     let funty = (match membertys with 
                    first :: _ -> first 
                    | _ -> raise (Failure "No function field")) in 
    let llfunty = ltype_of_type map funty in *)
    let () = 
    L.struct_set_body 
        new_struct_ty
        (Array.of_list (List.map (ltype_of_type map) membertys))
        false
    (* in L.pointer_type new_struct_ty  *)
    in new_struct_ty 
  in 


  (* Declare the NAMED struct definitions *)
  let struct_table : L.lltype StringMap.t = 
    let gen_struct_def map closure = match closure with 
        Tycon (Clo (name, anonFunTy, freetys)) -> 
          (* let () = print_endline (string_of_ctype anonFunTy) in  *)
          let v = create_struct name (anonFunTy :: freetys) map
          in StringMap.add name v map
      | _ -> raise (Failure ("Error: Codegeneration - lambda a non closure type"))
    in 
    let structs = List.rev structures in 
    List.fold_left gen_struct_def StringMap.empty structs
  in 

  (* Lookup table of function names (lambdas) to (function block, function def) *)
  let function_decls : (L.llvalue * fdef) StringMap.t = 
    (* let () = print_endline "declaring functions" in  *)
    let define_func map def =  
      let name = def.fname 
      and formal_types = 
        Array.of_list (List.map (fun (t, _) -> ltype_of_type struct_table t) 
                      (def.formals @ def.frees)) 
      in 
      let ftype = L.function_type (ltype_of_type struct_table def.rettyp) formal_types
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
    let lltyp = ltype_of_type struct_table ty in 
    let rec const_typ = function 
        Tycon ty    -> const_tycon ty
      | Tyvar tp    -> const_tyvar tp
      | Conapp con  -> const_conapp con
    and const_tycon = function 
        Intty            -> L.const_int  lltyp 0
      | Boolty           -> L.const_int  lltyp 0
      | Charty           -> L.const_int  lltyp 0
      | Tarrow (_, _)    -> L.const_pointer_null lltyp
      | Clo _            -> L.const_pointer_null lltyp
    and const_tyvar = function 
        Tparam _ -> raise (Failure ("TODO: lltype of TParam"))
    and const_conapp (tyc, _) = const_tycon tyc
    in 
    let init = const_typ ty in 
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


(* example of a global struct variable (pointer to struct) *)
  (* let globals = StringMap.add "tree_test" (L.define_global "tree_test" (L.const_pointer_null tree_struct_ty) the_module) globals in *)

  let lookup id locals = 
    (* try fst (StringMap.find id function_decls)
    with Not_found -> *)
      try StringMap.find id locals 
      with Not_found -> StringMap.find id globals
  in 

  (* Add terminal instruction to a block *)
    let add_terminal builder instr = 
      match L.block_terminator (L.insertion_block builder) with 
          Some _ -> ()
        | None -> ignore (instr builder) in

  (* Construct code for expression 
     Function takes a Cast.cexpr, and constructs the llvm where 
     builder is located; returns the llvalue representation of code. 

     builder is llbuilder 
     lenv is StringMap 
     block is llvalue 
     (_, e) is cexpr

      Note: style - consider currying the function params 
      Note: make it also return the builder?
      (llvalue, llbuilder)
    *)
  let rec expr builder lenv block (etyp, e) = 
    match e with 
       CLiteral v   -> const_val v builder
     | CVar     s  -> 
        (* let () = print_endline ("looking for " ^ s) in  *)
        (try L.build_load (lookup s lenv) s builder
                with Not_found -> 
                    (* let () = print_endline ("failed looking for " ^ s)  *)
                    raise(Failure ("name not found: " ^ s)))
     (* | CIf (e1, e2, e3) ->  *)
     | CIf (_, _, _) -> 
          raise (Failure ("TODO - codegen CIF merge-then-else"))

          (* let deal_with_cond_block nbuilder exp = 
            let ret = expr nbuilder lenv block exp in 
            nbuilder
          in

          (* set aside the result of the condition expr *)
          let bool_val = expr builder lenv block e1 in 

          (* Create the merge block for after exec of then or the else block *)
          let merge_bb = L.append_block context "merge" block in 
          let branch_instr = L.build_br merge_bb in (* curried! needs an llbuilder *)

          (* Create the "then" block *)
          let then_bb = L.append_block context "then" block in
          (* problem: this returns a llvalue, but needs llbuilder *)
          (* let then_builder = expr (L.builder_at_end context then_bb) lenv then_bb e2 in *)
          let then_builder = deal_with_cond_block (L.builder_at_end context then_bb) e2 in
          let () = add_terminal then_builder branch_instr in 

          (* Create the "else" block *)
          let else_bb = L.append_block context "else" block in
          (* problem: this returns a llvalue, but needs llbuilder *)
          let else_builder = deal_with_cond_block (L.builder_at_end context else_bb) e3 in
          let () = add_terminal else_builder branch_instr in 

          (* Complete the if-then-else block, return should be llvalue *)
          (* let _ =  *)
          L.build_cond_br bool_val then_bb else_bb builder 
          (* problem: this returns a llbuilder, but needs llvalue *)
          (* in L.builder_at_end context merge_bb *)
           *)

     | CApply ((_, CVar "printi"), [arg], _) -> 
          L.build_call printf_func [| int_format_str ; (expr builder lenv block arg) |] "printi" builder
     | CApply ((_, CVar"printc"), [arg], _) -> 
        (* L.build_call printf_func [| char_format_str ; (expr arg builder) |] "printc" builder *)
        (* let () = print_endline "codegen: capply" in  *)
        L.build_call puts_func [| expr builder lenv block arg |] "printc" builder
     | CApply ((_, CVar "printb"), [arg], _) -> 
        let bool_stringptr = if expr builder lenv block arg = (L.const_int bool_ty 1) then print_true else print_false
        in L.build_call puts_func [| bool_stringptr |] "printb" builder
     | CApply (f, args, numFrees) -> 
        (* Since all normal function application is as struct value, call to the 
           function at member index 0 of the struct *)
        let applyClosure = expr builder lenv block f in
        (* List of llvalues representing the actual arguments *)
        let llargs = List.map (fun cexp -> expr builder lenv block cexp) args in 
        (* List of llvalues representing the hidden frees to be passed as arguments *)
        let llfrees = 
          let rec get_free idx frees = 
            if idx > numFrees 
              then List.rev frees
            else 
              let struct_freeMemPtr = L.build_struct_gep applyClosure idx "freePtr" builder in
              let struct_freeMem = L.build_load struct_freeMemPtr "freeVal" builder in
              let frees' = struct_freeMem :: frees in
              get_free (idx + 1) frees'
          in get_free 1 []
        in
        (* Access the struct member at index 0, which is the function *)
        let ptrFuncPtr = L.build_struct_gep applyClosure 0 "function_access" builder in 
        let funcPtr = L.build_load ptrFuncPtr "function_call" builder in 
        L.build_call  funcPtr 
                      (Array.of_list (llargs @ llfrees)) 
                      "function_result"
                      builder 
        (* No longer making a direct call *)
        (* let fblock = expr builder lenv block f in *)
        (* let () = print_endline "got an fblock" in  *)
        (* L.build_call  fblock 
                      (Array.of_list llargs) 
                      "fun_name"
                      builder  *)
     | CLet _ -> raise (Failure ("TODO - codegen CLET"))
     | CLambda (id, freeargs)-> (* store function pointer to function here *)
        (* let () = print_endline ("Clambda: " ^ id) in  *)
        let res = 
          (match etyp with 
              Tycon (Clo (clo_name, _, _)) -> 
                (* alloc and declare a new struct object *)
                let struct_ty = StringMap.find clo_name struct_table in
                let struct_obj = L.build_alloca struct_ty "gstruct" builder in 
                (* Set the function field of the closure *)
                let struct_fmem = L.build_struct_gep struct_obj 0 "funcField" builder in 
                let (fblock, _) = StringMap.find id function_decls in
                let _ = L.build_store fblock struct_fmem builder in 
                (* Set each subsequent field of the frees *)
                let llFreeArgs = List.map (expr builder lenv block) freeargs in 
                let numFrees = List.length freeargs in 
                let structFields = 
                  let rec generate_field_access idx fields =
                    if idx > numFrees 
                      then List.rev fields 
                    else 
                      let struct_freeMem = L.build_struct_gep struct_obj idx "freeField" builder in 
                      let fields' = struct_freeMem :: fields in 
                      generate_field_access (idx + 1) fields'
                  in generate_field_access 1 []
                in
                (* let structFields = List.rev structFields in  *)
                let _ = 
                  let set_free arg field = L.build_store arg field builder
                  in List.map2 set_free llFreeArgs structFields
                in 
                struct_obj
                (* raise (Failure ("fname: " ^ id ^ "\tstruct name: " ^ clo_name)) *)
            | _ -> raise (Failure ("Error: Codegeneration - lambda a non closure type"))
          ) in res
        (* let (fblock, _) = StringMap.find id function_decls in fblock *)
        (* L.build_load (lookup id lenv) id builder *)
  in 

  (* construct the code for each instruction in main (which is a cdefn list) *)
  let build_main_body = function 
    | CVal (id, (ty, e)) -> 
        (* create a global define of a variable *)
        (* let _ = create_global id ty in  *)
        let e' = expr main_builder StringMap.empty the_main (ty, e) in 
        (* raise (Failure "TODO") *)
        let _ = L.build_store e' (lookup id StringMap.empty) main_builder  in 
        ()
    | CExpr e -> let _ = expr main_builder StringMap.empty the_main e in 
        ()
  in 
  let _ = List.map build_main_body main in 

  (* Every function definition needs to end in a ret. Puts a return at end of main *)
  let _ = L.build_ret (L.const_int int_ty 0) main_builder in
  (* let _ = add_terminal main_builder (L.build_ret (L.const_int int_ty 0)) in *)

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
        let local = L.build_alloca (ltype_of_type struct_table ty) nm fbuilder in
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
    (* let (ty, exp) = fdef.body in  *)
    let result = expr fbuilder locals function_block fdef.body in 
    (* let () = print_endline ("built fbody") in  *)

    (* Add terminal instruction to a block *)
    (* let add_terminal builder instr = 
      match L.block_terminator (L.insertion_block builder) with 
          Some _ -> ()
        | None -> ignore (instr builder) in *)

    (* Build instructions for returns based on the rettype *)
    let build_ret t = 
      let rec ret_of_typ = function
          Tycon ty    -> ret_of_tycon ty
        | Tyvar tp    -> ret_of_tyvar tp
        | Conapp con  -> ret_of_conapp con
      and ret_of_tycon = function 
          Intty       -> L.build_ret result
        | Boolty      -> L.build_ret result
        | Charty      -> L.build_ret result
        | Tarrow _    -> L.build_ret result
        | Clo _       -> L.build_ret result
      and ret_of_tyvar = function 
          Tparam _ -> raise (Failure ("TODO: ret of TParam"))
      and ret_of_conapp (tyc, _) = ret_of_tycon tyc
      in ret_of_typ t
    in 

    add_terminal fbuilder (build_ret fdef.rettyp)

  in 

  (* iterate through each function def we need to build and build it *)
  let _ = List.iter build_function_body functions in 

  (* Return an llmodule *)
  the_module
