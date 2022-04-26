# Makefile for (g)ROOT project team
# Inspired by Richard/CS107 who was inspired by one provided by 
# Stephen Edwards for his Compilers course at Columbia University.

DEPENDS=toplevel.ml ast.ml tast.ml parser.mly scanner.mll diagnostic.ml infer.ml
# cast.ml conversion.ml semant.ml

# IMPORTANT Note from Zach:
#	the _tags file contains arguments that are ingested by ocamlbuild
#   and alter it's behavior
toplevel.native: $(DEPENDS)
	OPAMCLI=2.0; opam exec -- ocamlbuild -use-ocamlfind toplevel.native

hello: 
	make toLLVM
	make toAssem
	make toExe

%.exe: %.gt
	./toplevel.native -c $< > tmp.ll && llc -relocation-model=pic tmp.ll > tmp.s && cc -o $@ tmp.s

parser: parser.mly
	ocamlyacc parser.mly

lexer: ast.ml parser.mly scanner.mll
	ocamllex scanner.mll

# Compile and run hello.gt
toLLVM: 
	./toplevel.native -c hello.gt > hello.ll 

toAssem: 
	llc -relocation-model=pic hello.ll > hello.s 

toExe:
	cc -o hello.exe hello.s

toRun:
	./hello.exe 

clean:
	ocamlbuild -clean
	rm -rf parser.ml parser.mli scanner.ml toplevel.native groot.native
