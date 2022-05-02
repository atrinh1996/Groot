
(* Top-level of the groot compiler: scan & parse input, 

   		TODO: generate the resulting AST and generate a SAST from it
   					generate LLVM IR, dump the module
   	*)

(* may not need to use this, but this is how to robustly create unique exception
   types
*)

type action = 
  | Ast 
  | Name_Check
  | Tast 
  | Mast 
  (* | Cast  *)
(* | LLVM_IR *)
(* | Compile *)



let () =
  let action = ref Ast in
  let set_action a () = action := a in
  let speclist = [
    ("-a", Arg.Unit (set_action Ast), 		"Print the AST (default)");
    ("-n", Arg.Unit (set_action Name_Check), 	"Print the AST (name-checking)");
    ("-t", Arg.Unit (set_action Tast), 		"Print the TAST");
    ("-m", Arg.Unit (set_action Mast), 	"Print the MAST");
    (* ("-v", Arg.Unit (set_action Cast), 	"Print the CAST"); *)
    (* ("-l", Arg.Unit (set_action LLVM_IR), 	"Print the generated LLVM IR"); *)
    (* ("-c", Arg.Unit (set_action Compile), *)
    (* "Check and print the generated LLVM IR"); *)
  ] in


  let usage_msg = "usage: ./toplevel.native [-a|-n|-t|-m|-v|-l|-c] [file.gt]" in
  let channel = ref stdin in
  Arg.parse speclist (fun filename -> channel := open_in filename) usage_msg;

  let lexbuf = Lexing.from_channel !channel in
  let ast = Parser.prog Scanner.tokenize lexbuf in 
  match !action with
  (* Default action - print the AST using ast *)
  | Ast -> print_string (Ast.string_of_prog ast)
  (* All other action needs to generate an SAST, store in variable sast *)
  | _ -> 
    let ast' = Scope.check ast in 
    (* let tast = Semant.semantic_check ast' in *)
    let tast = Infer.type_infer ast' in
    (* let mast = Mono.monomorphize tast in  *)
    (* let cast = Conversion.conversion tast in  *)
    match !action with 
    (* This option doesn't do anything, just need it to satisfy 
       					     the pattern matching for type action. *)
      Ast -> ()
    | Name_Check -> print_string (Ast.string_of_prog ast')
    (* action - prints the SAST using sast.
       					     Here is the RHS code: 
       					     print_string (Sast.string_of_sprog sast) *)
    | Tast -> print_string (Tast.string_of_tprog tast)
    (* print_endline ("Tast was generated, no pretty print") *)
    (* print_string (Tast.string_of_tprog tast) *)
    | Mast -> let mast = Mono.monomorphize tast in
      print_string (Mast.string_of_mprog mast)
(* | Cast -> print_string (Cast.string_of_cprog cast) *)
(* action - print the llvm module. Codegen.translate produces the llmodule
   					     from the given SAST called sast and then Llvm.string_of_llmodule converts it to string.
   					     Here is the RHS code: 
   					     print_string (Llvm.string_of_llmodule (Codegen.translate sast)) 
   					  *)
(* | LLVM_IR -> print_string (Llvm.string_of_llmodule (Codegen.translate cast)) *)
(* action - print the llvm module. See above. *)
(* | Compile -> let the_module = Codegen.translate cast in 
   										Llvm_analysis.assert_valid_module the_module;
   										print_string (Llvm.string_of_llmodule the_module) *)
