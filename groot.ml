(* Top-level of the groot compiler: scan & parse input, 

    TODO: generate the resulting AST and generate a SAST from it
          generate LLVM IR, dump the module
  *)

type action = Ast | Compile

let () =
  let action = ref Compile in
  let set_action a () = action := a in
  let speclist = [
    ("-a", Arg.Unit (set_action Ast), "Print the AST");
    ("-c", Arg.Unit (set_action Compile),
      "Check and print the generated LLVM IR (default)");
  ] in  
  let usage_msg = "usage: ./microc.native [-a|-c] [file.mc]" in
  let channel = ref stdin in
  Arg.parse speclist (fun filename -> channel := open_in filename) usage_msg;
  
  let lexbuf = Lexing.from_channel !channel in
  let ast = Parser.expr Scanner.tokenize lexbuf in 
    print_string (Ast.string_of_expr ast) 
  