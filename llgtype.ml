(* 
            llgtype.ml

    Creates a context and puts types in it to use in the LLVM code. 
    Converts Ast.gtypes to LLCE types
 *)
module L = Llvm
(* module A = Ast *)
(* module S = Sast *)
module C = Cast
module StringMap = Map.Make(String)

(* let struct_count = ref 0 *)


(* creates the glocal context instance *)
let context = L.global_context ()


(* Add types to the context to use in the LLVM code *)
let int_ty      = L.i32_type  context 
let char_ty       = L.i8_type   context 
let char_ptr_ty = L.pointer_type char_ty
let bool_ty       = L.i1_type   context 
let string_ty   = L.struct_type context [| L.pointer_type char_ty |]
let zero = L.const_int int_ty 0
(* REMOVE VOID later *)
let void_ty    = L.void_type context

(* "tree_struct" will appear as the struct name in llvm code *)
let tree_struct_ty = L.named_struct_type context "tree_struct"
let tree_struct_ptr_ty = L.pointer_type tree_struct_ty 
let () = L.struct_set_body 
            tree_struct_ty 
            [| 
              int_ty; 
              tree_struct_ptr_ty; 
              tree_struct_ptr_ty 
            |]
            false


(* Convert Cast.ctype types to LLVM types *)
let ltype_of_type (struct_table : L.lltype StringMap.t) (ty : C.ctype) = 
    let rec ltype_of_ctype = function
        C.Tycon ty -> ltype_of_tycon ty
      | C.Tyvar tp -> ltype_of_tyvar tp
      | C.Conapp con -> ltype_of_conapp con
    and ltype_of_tycon = function 
        C.Intty                -> int_ty
      | C.Boolty               -> bool_ty
      | C.Charty               -> char_ty
      | C.Tarrow (ret, args)  -> 
        (* let () = print_endline "function pointer type:" in  *)
        (* let () = print_string "return type: " in  *)
        let llretty = ltype_of_ctype ret in 
        (* let () = print_string "\narg types: " in *)
        let llargtys = List.map ltype_of_ctype args in 
        (* let () = print_string "\n" in *)
        L.pointer_type (
          L.function_type llretty (Array.of_list llargtys)
        )
      | Clo (sname, _, _) -> StringMap.find sname struct_table
      (* | Clo (_, _) -> raise (Failure "TODO: struct types") *)
    and ltype_of_tyvar = function 
        (* What is this type even? *)
        C.Tparam _ -> void_ty
        (* And what types do conapps represent? *)
    and ltype_of_conapp (tyc, _) = ltype_of_tycon tyc
in  ltype_of_ctype ty 


(* helper to construct named structs  *)
let create_struct (name : C.cname) (membertys : C.ctype list) = 
    (* let () = print_endline ("struct name: " ^ name) in  *)
    (* let () = print_endline ("number of members: " ^ string_of_int (List.length membertys)) in  *)
    let new_struct_ty = 
        L.named_struct_type context name
    in  
    (* let () = struct_count := !struct_count + 1 in  *)
    let () = 
    L.struct_set_body 
        new_struct_ty
        (Array.of_list (List.map (ltype_of_type StringMap.empty) membertys))
        false
    in L.pointer_type new_struct_ty
