(*
    Notes:

    sdefn contains sexr:
        type sdefn = 
          | SVal of ident * sexpr
          | SExpr of sexpr

    sexpr: 
        type sexpr = gtype * sx
        and sx = 
           SLiteral of svalue
         | SVar     of ident
         | SIf      of sexpr * sexpr * sexpr
         | SApply   of sexpr * sexpr list
         | SLet     of (ident * sexpr) list * sexpr
         | SLambda  of ident list * sexpr


    Format specifiers
      ints      %d 
      char      %c --> will use %s 
      string    %s (bool: #t and #f)
*)

(* module L = Llvm *)
(* module A = Ast *)
open Llgtype
open Sast 


module StringMap = Map.Make(String)

(* translate sdefns - Given an SAST called sdefns, the function returns 
   an LLVM module (llmodule type), which is the code generated from 
   the SAST. Throws exception if something is wrong. 
  
  Note: An sdefn is an SVal or an SExpr, 
  ie (id, (Ast.gtyp, Sast.sx)) or (Ast,gtyp, Sast.sx).
  Remember: we are dealing with a list of sdefn's 
 *)
let translate sdefns = 

  (* Create an LLVM module (container into which we'll 
     generate actual code) *)
  let the_module = L.create_module context "gROOT" in 



  (* Declare each toplevel val variable, i.e. (val x 1). 
     Remember its value in a map.
     global_vars_map is a StringMap mapping key (string name) 
     to value (llvalue)  *)
  let global_vars_map : L.llvalue StringMap.t = 
    let global_var map sdef = 
      match sdef with
          (* sexp is an Sast.sx type. What the the llvm version of sx *)
          SVal(name, (t, sexp)) -> 
          (* 
            in (val x 1), v should be 1
            in (val x (if #t #f #t)), v should be #t or the if??
            in (val add1 (lambda (n) (+ n 1))), v should be the lambda

            DO I NEED A CODE CONSTRUCTOR for exprs???
          *)
            (* let v = eval  in  *)
            let init = match t with 
                A.IType   -> L.const_int (ltype_of_gtype t) 0
              | A.CType   -> L.const_int (ltype_of_gtype t) 0
              | A.BType   -> L.const_int (ltype_of_gtype t) 0
              (* What is the size of a tree and xtype? *)
              (* | A.TType *)
              (* | A.XType of int *)
              | _         -> L.const_int (ltype_of_gtype t) 0
            (* Map Val Variable "name" to llvalue that represents ?????? *)
            in StringMap.add name (L.define_global name init the_module) map 
        | SExpr(_) -> raise (Failure ("TODO - codegen SExpr global_vars"))
    in List.fold_left global_var StringMap.empty sdefns
  in 


  


  (* DECLARE a print function (std::printf in C lib) *)
  let printf_ty : L.lltype = 
      L.var_arg_function_type i32_ty [| L.pointer_type i8_ty |] in
  let printf_func : L.llvalue = 
     L.declare_function "printf" printf_ty the_module in



 (* To test struct type
    Comment these lines in, run.
    Should make the code defining the struct appear in the llvm code. *)
  (* let main_ty = L.function_type void_ty [| tree_struct_ty |] in
  let the_main = L.define_function "the_main" main_ty the_module in *)

  (* To test a simple codegen. Gives an void main, no args. *)
  let main_ty = L.function_type void_ty [|  |] in
  let the_main = L.define_function "the_main" main_ty the_module in


  (* create a builder for the whole program, start it in main block *)
  let builder = L.builder_at_end context (L.entry_block the_main) in


  (* Format strings to use with printf for our literals *)
  let int_format_str  = L.build_global_stringptr "%d\n" "fmt" builder
  and char_format_str = L.build_global_stringptr "%s\n" "fmt" builder
  and bool_format_str = L.build_global_stringptr "%s\n" "fmt" builder in 


  (* Construct constants code for literal values.
     Function takes a Sast.svalue, and returls the constructed 
     llvalue  *)
  let const_val v = 
    match v with 
        SChar c -> L.const_string context (String.make 1 c)
      | SInt  i -> L.const_int i32_ty i 
      (* HAS to be an i1 lltype for the br instructions *)
      | SBool b -> L.const_int i1_ty (if b then 1 else 0)
      | SRoot _ -> raise (Failure ("TODO - codegen SRoot Literal"))
  in

  (* Construct code for expression 
     Function takes a Sast.sexpr, and constructs the llvm where 
     builder is located; returns the llvalue representation of code*)
  let rec build_expr ((t, e) : sexpr) = 
    match e with 
       SLiteral v   -> const_val v
     | SVar     id  -> raise (Failure ("TODO - codegen SVar lookup"))
     | SIf (condition, then_exp, else_exp) -> 
            raise (Failure ("TODO - codegen SIF merge-then-else"))
     | SApply (f, args) -> 
            raise (Failure ("TODO - codegen SAPPLY prints + general"))
     (* L.const_string context (if b then "#t" else "#f") *)
     | SLet (binds, e) -> raise (Failure ("TODO - codegen SLET"))
     | SLambda (formals, e) -> raise (Failure ("TODO - codegen SLambda"))
  in 


  (* Construct the code for a definition *)
  let build_defn sdef = 
    match sdef with 
        SVal (id, e) -> raise (Failure ("TODO - codegen SVal"))
      | SExpr e -> build_expr e
  in 



  (* List.iter build_defn sdefns; *)

  (* Return an llmodule *)
  the_module
