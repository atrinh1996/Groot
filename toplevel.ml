(* Top-level of the groot compiler: scan & parse input, 

		TODO: generate the resulting AST and generate a SAST from it
					generate LLVM IR, dump the module
	*)

(* may not need to use this, but this is how to robustly create unique exception
   types
 *)

type action = Ast | Sast 
(* | Compile *)

let () =
	let action = ref Ast in
	let set_action a () = action := a in
	let speclist = [
		(* ("-c", Arg.Unit (set_action Compile),
			"Check and print the generated LLVM IR"); *)
		("-a", Arg.Unit (set_action Ast), "Print the AST");
    ("-s", Arg.Unit (set_action Sast), "Print the SAST");
	] in  
	let usage_msg = "usage: ./toplevel.native [-a|-c] [file.gt]" in
	let channel = ref stdin in
	Arg.parse speclist (fun filename -> channel := open_in filename) usage_msg;
	
	let lexbuf = Lexing.from_channel !channel in
		let ast = Parser.prog Scanner.tokenize lexbuf in 
			match !action with
				Ast     -> print_string (Ast.string_of_prog ast)
			| Sast    -> let sast = Semant.semantic_check ast in print_string "sast"
			(* (print_string  "Error: Compilation not yet implemented\n") *)
			(* | Compile -> Diagnostic.error(Diagnostic.Unimplemented "compilation") *)