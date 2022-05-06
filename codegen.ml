(* Code Generation : Create a llmodule with llvm code from CAST *)
open Llgtype
open Cast


(* translate sdefns - Given an CAST (type cprog, a record type), the function
   returns an LLVM module (llmodule type), which is the code generated from
   the CAST. Throws exception if something is wrong. *)
let translate { main = main;  functions = functions;
                rho = rho;    structures = structures } =


  (* Convert Cast.ctype types to LLVM types *)
  let ltype_of_type (struct_table : L.lltype StringMap.t) (ty : ctype) =
    let rec ltype_of_ctype = function
        Tycon ty -> ltype_of_tycon ty
      | Conapp con -> ltype_of_conapp con
    and ltype_of_tycon = function
        Intty                -> int_ty
      | Boolty               -> bool_ty
      | Charty               -> char_ptr_ty 
      | Tarrow ret           -> ltype_of_ctype ret
      | Clo (sname, _, _)    ->
          L.pointer_type (StringMap.find sname struct_table)
    and ltype_of_conapp (tyc, ctys) =
          let llretty = ltype_of_tycon tyc in
          let llargtys = List.map ltype_of_ctype ctys in
          L.pointer_type (L.function_type llretty (Array.of_list llargtys))
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

  (* Create a "main" function that takes nothing, and returns an int. *)
  let main_ty = L.function_type int_ty [|  |] in
  let the_main = L.define_function "main" main_ty the_module in


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
  let create_struct (name : cname) (membertys : ctype list)
      (map : L.lltype StringMap.t) =
    let new_struct_ty = L.named_struct_type context name in
    let () =
      L.struct_set_body
        new_struct_ty
        (Array.of_list (List.map (ltype_of_type map) membertys))
        false
    in new_struct_ty
  in


  (* Declare the NAMED struct definitions *)
  let struct_table : L.lltype StringMap.t =
    let gen_struct_def map closure = match closure with
        Tycon (Clo (name, anonFunTy, freetys)) ->
          let v = create_struct name (anonFunTy :: freetys) map
          in StringMap.add name v map
      | _ -> Diagnostic.error 
              (Diagnostic.GenerationError "lambda is non-closure type")
    in
    let structs = List.rev structures in
    List.fold_left gen_struct_def StringMap.empty structs
  in

  (* Lookup table of function names (lambdas) to
     (function block, function def) *)
  let function_decls : (L.llvalue * fdef) StringMap.t =
    let define_func map def =
      let name = def.fname
      and formal_types =
        Array.of_list (List.map (fun (t, _) -> ltype_of_type struct_table t)
                         (def.formals @ def.frees))
      in
      let ftype = L.function_type 
                    (ltype_of_type struct_table def.rettyp) 
                    formal_types
      in StringMap.add name (L.define_function name ftype the_module, def) map
    in List.fold_left define_func StringMap.empty functions
  in


  (* creates a global pointer to some variable's value *)
  let create_global id ty =
    let lltyp = ltype_of_type struct_table ty in
    let rec const_typ = function
        Tycon ty    -> const_tycon ty
      (* | Tyvar tp    -> const_tyvar tp *)
      | Conapp con  -> const_conapp con
    and const_tycon = function
        Intty            -> L.const_int  lltyp 0
      | Boolty           -> L.const_int  lltyp 0
      | Charty           -> L.const_pointer_null  lltyp 
      | Tarrow _         -> L.const_pointer_null lltyp
      | Clo _            -> L.const_pointer_null lltyp
    and const_conapp (_, _) = L.const_pointer_null lltyp
    in
    let init = const_typ ty in
    L.define_global id init the_module
  in

  (* A lookup table of named globals to represent named values *)
  let globals : L.llvalue StringMap.t =
    let global_vars k occursList map =
      let glo_var map' (num, typ) =
        if num = 0
        then map'
        else  let id = "_" ^ k ^ "_" ^ string_of_int num in
          StringMap.add id (create_global id typ) map'
      in List.fold_left glo_var map occursList
    in
    StringMap.fold global_vars rho StringMap.empty
  in


  (* Looks for variable named id in the local or global environment *)
  let lookup id locals =
    try StringMap.find id locals
    with Not_found -> StringMap.find id globals
  in

  (* Add terminal instruction to a block *)
  let add_terminal builder instr =
    match L.block_terminator (L.insertion_block builder) with
      Some _ -> ()
    | None -> ignore (instr builder) in


  (* Construct constants code for literal values.
     Function takes a builder and Sast.svalue, and returns the constructed
     llvalue  *)
  let const_val builder = function
    (* create the "string" constant in the code for the char *)
      CChar c ->
        let spc = L.build_alloca char_ptr_ty "spc" builder in
        let globalChar = 
          L.build_global_string (String.make 1 c) "globalChar" builder in
        let newStr = L.build_bitcast globalChar char_ptr_ty "newStr" builder in
        let loc = L.build_gep spc [| zero |] "loc" builder in
        let _ = L.build_store newStr loc builder in
        L.build_load spc "character_ptr" builder
    | CInt  i -> L.const_int int_ty i
    (* HAS to be an i1 lltype for the br instructions *)
    | CBool b -> L.const_int bool_ty (if b then 1 else 0)
    | CRoot _ -> Diagnostic.error 
                  (Diagnostic.Unimplemented "codegen SRoot Literal")

  in



  (* Construct code for expressions
     Arguments: llbuilder, lookup table of local variables,
     current llblock, and Cast.cexpr.
     Constructs the llvm where builder is located;
     Returns an llbuilder and the llvalue representation of code. *)
  let rec expr builder lenv block (etyp, e) =
    match e with
      CLiteral v   -> (builder, const_val builder v)
    | CVar     s  ->
        let varValue =
          (try L.build_load (lookup s lenv) s builder
           with Not_found -> Diagnostic.error 
                              (Diagnostic.Unbound ("name \"" ^ s 
                                ^ "\" not found in codegen")))
        in (builder, varValue)
    | CIf (e1, (t2, e2), e3) ->
        (* allocate space for result of the if statement *)
        let result =
          L.build_alloca (ltype_of_type struct_table t2) "if-res-ptr" builder
        in

        (* set aside the result of the condition expr *)
        let (newbuilder, bool_val) = expr builder lenv block e1 in

        (* Create the merge block for after exec of then or the else block *)
        let merge_bb = L.append_block context "merge" block in
        let branch_instr = L.build_br merge_bb in

        (* Create the "then" block *)
        let then_bb = L.append_block context "then" block in
        let (then_builder, then_res) =
          expr (L.builder_at_end context then_bb) lenv block (t2, e2) in
        let _ = L.build_store then_res result then_builder in
        let () = add_terminal then_builder branch_instr in

        (* Create the "else" block *)
        let else_bb = L.append_block context "else" block in
        let (else_builder, else_res) =
          expr (L.builder_at_end context else_bb) lenv block e3 in
        let _ = L.build_store else_res result else_builder in
        let () = add_terminal else_builder branch_instr in

        (* Complete the if-then-else block, return should be llvalue *)
        (* let _ = L.build_cond_br bool_val then_bb else_bb builder in *)
        let _ = L.build_cond_br bool_val then_bb else_bb newbuilder in
        (* Get the result of either the the or the else block *)
        let merge_builder = L.builder_at_end context merge_bb in
        let result_value = L.build_load result "if-res-val" merge_builder in
        (merge_builder, result_value)
    | CApply ((_, CVar "printi"), [arg], _) ->
        let (builder', argument) = expr builder lenv block arg in
        let instruction = L.build_call  printf_func
            [| int_format_str ; argument |]
            "printi" builder'
        in (builder', instruction)
    | CApply ((_, CVar "printc"), [arg], _) ->
        let (builder', argument) = expr builder lenv block arg in
        let instruction = L.build_call  puts_func
            [| argument |]
            "printc" builder'
        in (builder', instruction)
    | CApply ((_, CVar "printb"), [arg], _) ->
        let (builder', condition) = expr builder lenv block arg in
        let bool_stringptr =
          if condition = lltrue then print_true
          else print_false in
        let instruction = L.build_call  puts_func
            [| bool_stringptr |]
            "printb" builder'
        in (builder', instruction)
    | CApply ((_, CVar "~"), [arg], _) ->
        let (builder', e) = expr builder lenv block arg in
        let instruction = L.build_neg e "~" builder'
        in (builder', instruction)
    | CApply ((_, CVar "not"), [arg], _) ->
        let (builder', e) = expr builder lenv block arg in
        let instruction = L.build_not e "not" builder'
        in (builder', instruction)
    (* BINOP PRIMITIVES - Int and Boolean Algebra *)
    | CApply ((_, CVar "+"), arg1::[arg2], _) ->
        let (builder', e1) = expr builder lenv block arg1 in
        let (builder'', e2) = expr builder' lenv block arg2 in
        let instruction = L.build_add e1 e2 "addition" builder''
        in (builder'', instruction)
    | CApply ((_, CVar "-"), arg1::[arg2], _) ->
        let (builder', e1) = expr builder lenv block arg1 in
        let (builder'', e2) = expr builder' lenv block arg2 in
        let instruction = L.build_sub e1 e2 "subtraction" builder''
        in (builder'', instruction)
    | CApply ((_, CVar "/"), arg1::[arg2], _) ->
        let (builder', e1) = expr builder lenv block arg1 in
        let (builder'', e2) = expr builder' lenv block arg2 in
        let instruction = L.build_sdiv e1 e2 "division" builder''
        in (builder'', instruction)
    | CApply ((_, CVar "*"), arg1::[arg2], _) ->
        let (builder', e1) = expr builder lenv block arg1 in
        let (builder'', e2) = expr builder' lenv block arg2 in
        let instruction = L.build_mul e1 e2 "multiply" builder''
        in (builder'', instruction)
    | CApply ((_, CVar "mod"), arg1::[arg2], _) ->
        let (builder', e1) = expr builder lenv block arg1 in
        let (builder'', e2) = expr builder' lenv block arg2 in
        let instruction = L.build_srem e1 e2 "modulus" builder''
        in (builder'', instruction)
    | CApply ((_, CVar "&&"), arg1::[arg2], _) ->
        let (builder', e1) = expr builder lenv block arg1 in
        let (builder'', e2) = expr builder' lenv block arg2 in
        let instruction = L.build_and e1 e2 "logAND" builder''
        in (builder'', instruction)
    | CApply ((_, CVar "||"), arg1::[arg2], _) ->
        let (builder', e1) = expr builder lenv block arg1 in
        let (builder'', e2) = expr builder' lenv block arg2 in
        let instruction = L.build_or e1 e2 "logOR" builder''
        in (builder'', instruction)
    (* BINOP PRIMITIVES - Comparisons *)
    | CApply ((_, CVar "<"), arg1::[arg2], _) ->
        let (builder', e1) = expr builder lenv block arg1 in
        let (builder'', e2) = expr builder' lenv block arg2 in
        let instruction = L.build_icmp L.Icmp.Slt e1 e2 "lt" builder''
        in (builder'', instruction)
    | CApply ((_, CVar ">"), arg1::[arg2], _) ->
        let (builder', e1) = expr builder lenv block arg1 in
        let (builder'', e2) = expr builder' lenv block arg2 in
        let instruction = L.build_icmp L.Icmp.Sgt e1 e2 "gt" builder''
        in (builder'', instruction)
    | CApply ((_, CVar "<="), arg1::[arg2], _) ->
        let (builder', e1) = expr builder lenv block arg1 in
        let (builder'', e2) = expr builder' lenv block arg2 in
        let instruction = L.build_icmp L.Icmp.Sle e1 e2 "leq" builder''
        in (builder'', instruction)
    | CApply ((_, CVar ">="), arg1::[arg2], _) ->
        let (builder', e1) = expr builder lenv block arg1 in
        let (builder'', e2) = expr builder' lenv block arg2 in
        let instruction = L.build_icmp L.Icmp.Sge e1 e2 "geq" builder''
        in (builder'', instruction)
    | CApply ((_, CVar "=i"), arg1::[arg2], _) ->
        let (builder', e1) = expr builder lenv block arg1 in
        let (builder'', e2) = expr builder' lenv block arg2 in
        let instruction = L.build_icmp L.Icmp.Eq e1 e2 "eqI" builder''
        in (builder'', instruction)
    | CApply ((_, CVar "!=i"), arg1::[arg2], _) ->
        let (builder', e1) = expr builder lenv block arg1 in
        let (builder'', e2) = expr builder' lenv block arg2 in
        let instruction = L.build_icmp L.Icmp.Ne e1 e2 "neqI" builder''
        in (builder'', instruction)
    | CApply (f, args, numFrees) ->
        (* Since all normal function application is as struct value, 
          call to the function at member index 0 of the struct *)
        let (builder', applyClosure) = expr builder lenv block f in
        (* List of llvalues representing the actual arguments *)
        let (builder'', llargs) =
          List.fold_left  (fun (bld, arglist) arg ->
              let (bld', llarg) = expr bld lenv block arg in
              (bld', llarg :: arglist))
            (builder', []) args
        in let llargs = List.rev llargs in
        (* List of llvalues representing the hidden frees to be
          passed as arguments *)
        let llfrees =
          let rec get_free idx frees =
            if idx > numFrees then List.rev frees
            else
              let struct_freeMemPtr =
                L.build_struct_gep applyClosure idx "freePtr" builder'' in
              let struct_freeMem =
                L.build_load struct_freeMemPtr "freeVal" builder'' in
              let frees' = struct_freeMem :: frees
              in get_free (idx + 1) frees'
          in get_free 1 []
        in
        (* Get the struct member at index 0, which is the function, call it *)
        let ptrFuncPtr =
          L.build_struct_gep applyClosure 0 "function_access" builder'' in
        let funcPtr = L.build_load ptrFuncPtr "function_call" builder'' in
        let instruction = L.build_call  funcPtr
            (Array.of_list (llargs @ llfrees))
            "function_result" builder''
        in (builder'', instruction)
    | CLet (bs, body) ->
        (* create each value in bs, and bind it to the name *)
        let (builder', local_env) =
          List.fold_left  
            (fun (bld, map) (name, (ty, cexp)) ->
                let loc = L.build_alloca 
                            (ltype_of_type struct_table ty) name bld in
                let (bld', llcexp) = expr bld lenv block (ty, cexp) in
                let _ = L.build_store llcexp loc bld' in
                let map' = StringMap.add name loc map in
                (bld', map'))
            (builder, StringMap.empty) bs
            (* Evaulate the body *)
        in expr builder' local_env block body
    | CLambda (id, freeargs)->
      (match etyp with
         Tycon (Clo (clo_name, _, _)) ->
            (* alloc and declare a new struct object *)
            let struct_ty = StringMap.find clo_name struct_table in
            let struct_obj = L.build_alloca struct_ty "gstruct" builder in
            (* Set the function field of the closure *)
            let struct_fmem =
              L.build_struct_gep struct_obj 0 "funcField" builder in
            let (fblock, _) = StringMap.find id function_decls in
            let _ = L.build_store fblock struct_fmem builder in
            (* Set each subsequent field of the frees *)
            let (builder', llFreeArgs) =
              List.fold_left  
                (fun (bld, arglist) arg ->
                    let (bld', llarg) = expr bld lenv block arg in
                    (bld', llarg :: arglist))
                (builder, []) freeargs in 
            let llFreeArgs = List.rev llFreeArgs in
            let numFrees = List.length freeargs in
            let structFields =
              (* Create pointers to struct members 1 to n *)
              let rec generate_field_access idx fields =
                if idx > numFrees then List.rev fields
                else
                  let struct_freeMem =
                    L.build_struct_gep struct_obj idx "freeField" builder' in
                  let fields' = struct_freeMem :: fields in
                  generate_field_access (idx + 1) fields'
              in generate_field_access 1 []
            in
            let _ = 
              let set_free arg field = L.build_store arg field builder'
              in List.map2 set_free llFreeArgs structFields
            in
            (builder', struct_obj)
       | _ -> Diagnostic.error 
                (Diagnostic.GenerationError "lambda is non-closure type"))
  in


  (* generate code for a particular definition; returns an llbuilder. *)
  let build_def builder = function
    | CVal (id, (ty, e)) ->
        (* assign a global define of a variable to a value *)
        let (builder', e') = expr builder StringMap.empty the_main (ty, e) in
        let _ = L.build_store e' (lookup id StringMap.empty) builder' in
        builder'
    | CExpr e ->
        let (builder', _) = expr builder StringMap.empty the_main e in
        builder'
  in

  (* procedure to generate code for each definition in main block.
     Takes a current llbuilder where to put instructions, and a
     list of definitions. Returns a builder of the last location
     to put final instruction. *)
  let rec build_main builder = function
      [] -> builder
    | front :: rest ->
        let builder' = build_def builder front in
        build_main builder' rest
  in

  let main_builder' = build_main main_builder main in
  (* Every function definition needs to end in a ret. 
     Puts a return at end of main *)
  let _ = L.build_ret (L.const_int int_ty 0) main_builder' in



  (* Build function block bodies *)
  let build_function_body fdef =
    let (function_block, _) = StringMap.find fdef.fname function_decls in
    let fbuilder = L.builder_at_end context (L.entry_block function_block) in

    (* For each param, load them into the function body.
        locals : llvalue StringMap.t*)
    let locals =
      let add_formal map (ty, nm) p =
        let () = L.set_value_name nm p in
        let local = L.build_alloca 
                      (ltype_of_type struct_table ty) nm fbuilder in
        let _ = L.build_store p local fbuilder in
        StringMap.add nm local map
      in
      List.fold_left2 
        add_formal
        StringMap.empty
        (fdef.formals @ fdef.frees)
        (Array.to_list (L.params function_block))
    in

    (* Build the return  *)
    let (fbuilder', result) = expr fbuilder locals function_block fdef.body in

    (* Build instructions for returns based on the rettype *)
    let build_ret t =
      let rec ret_of_typ = function
          Tycon ty    -> ret_of_tycon ty
        (* | Tyvar tp    -> ret_of_tyvar tp *)
        | Conapp con  -> ret_of_conapp con
      and ret_of_tycon = function
          Intty       -> L.build_ret result
        | Boolty      -> L.build_ret result
        | Charty      -> L.build_ret result
        | Tarrow _    -> L.build_ret result
        | Clo _       -> L.build_ret result
      and ret_of_conapp (tyc, _) = ret_of_tycon tyc
      in ret_of_typ t
    in
    add_terminal fbuilder' (build_ret fdef.rettyp)
  in

  (* iterate through each function def we need to build and build it *)
  let _ = List.iter build_function_body functions in

  (* Return an llmodule *)
  the_module
