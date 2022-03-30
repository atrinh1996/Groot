(* Top-level of the groot compiler: scan & parse input, 

		TODO: generate the resulting AST and generate a SAST from it
					generate LLVM IR, dump the module
	*)

(* may not need to use this, but this is how to robustly create unique exception
   types
 *)

type action = 
	  Ast 
	| Sast 
	(* | LLVM_IR *)
(* | Compile *)

let () =
	let action = ref Ast in
	let set_action a () = action := a in
	let speclist = [
		("-a", Arg.Unit (set_action Ast), "Print the AST (default)");
    ("-s", Arg.Unit (set_action Sast), "Print the SAST");
    	(* ("-l", Arg.Unit (set_action LLVM_IR), "Print the generated LLVM IR"); *)
    	(* ("-c", Arg.Unit (set_action Compile),
			"Check and print the generated LLVM IR"); *)
	] in

	let usage_msg = "usage: ./toplevel.native [-a|-s] [file.gt]" in
	let channel = ref stdin in
	Arg.parse speclist (fun filename -> channel := open_in filename) usage_msg;
	
	let lexbuf = Lexing.from_channel !channel in
	let ast = Parser.prog Scanner.tokenize lexbuf in 
		match !action with
			(* Default action - print the AST using ast *)
			| Ast     -> print_string (Ast.string_of_prog ast)
			(* All other action needs to generate an SAST, store in variable sast *)
			| _ -> 
				let sast = Infer.type_infer ast in
					  print_string "TODO: Finish Infer.type_infer"
					(* match !action with  *)
				(* in sast *)
					  (* This option doesn't do anything, just need it to satisfy 
					     the pattern matching for type action. *)
						(* Ast -> () *)
					  (* action - prints the SAST using sast.
					     Here is the RHS code: 
					     print_string (Sast.string_of_sprog sast) 
					  *)
					  (* Diagnostic.error(Diagnostic.Unimplemented "SAST printing") *)
					(* | Sast -> print_string (Sast.string_of_sprog sast) *)

					  (* action - print the llvm module. Codegen.translate produces the llmodule
					     from the given SAST called sast and then Llvm.string_of_llmodule converts it to string.
					     Here is the RHS code: 
					     print_string (Llvm.string_of_llmodule (Codegen.translate sast)) 
					  *)
					(* | LLVM_IR -> Diagnostic.error(Diagnostic.Unimplemented "CODEGEN translate") *)

					  (* action - print the llvm module. See above. *)
					(* | Compile -> let the_module = Codegen.translate sast in 
										Llvm_analysis.assert_valid_module the_module;
										print_string (Llvm.string_of_llmodule the_module) *)

