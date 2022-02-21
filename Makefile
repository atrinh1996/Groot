# Makefile for groot project team
# Inspired by Richard/CS107 who was inspired by one provided by 
# Stephen Edwards for his Compilers course at Columbia University.



parser: parser.mly
	ocamlyacc parser.mly

lexer: ast.ml parser.mly scanner.mll
	ocamllex scanner.mll

toplevel.native: toplevel.ml ast.ml parser.mly scanner.mll
	ocamlbuild toplevel.native

eval.native: ast.ml parser.mly scanner.mll eval.ml
	ocamlbuild eval.native

clean:
	ocamlbuild -clean
	rm parser.ml parser.mli scanner.ml toplevel.native groot.native