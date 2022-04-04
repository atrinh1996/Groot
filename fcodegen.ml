(* Code Generation helpers for function definitions *)

open Cast
module StringMap = Map.Make(String)


let define_function_blocks_table (fdefs : fdef list) = 
  let define_func map def =  
    let formal_types = 
      Array.of_list (List.map (fun (t, _) -> ltype_of_gtype t) 
                    (def.formals @ def.frees)) 
    in 
    let ftype = L.function_type (ltype_of_gtype def.rettyp) formal_types
    in StringMap.add def.fname (L.define_function ftype the_module, def) map 
  in 


  List.fold_left define_func StringMap.empty fdefs 