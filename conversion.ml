(* Closure conversion for groot compiler *)

(* open Ast *)
open Sast
open Cast 



(* Given an sprog (which is an sdefn list), convert returns a 
   cprog version. *)
let conversion sdefns =

  (* With a given sdefn, function converts it to the appropriate CAST type
     and sorts it to the appropriate list in a cprog type. *)
  let convert = function 
    | SVal (id, (ty, sexp)) -> 
        let def = svalToCval (id, (ty, sexp)) in 
        (match def with 
            | Some cval -> let _ = addMain cval in ()
            | None -> ())
    | SExpr e -> let _ = addMain (CExpr (sexprToCexpr e)) in ()
  in 
    
  let _ = List.iter convert sdefns in 

  {
    main = List.rev res.main;
    functions = res.functions;
    rho = res.rho
  }
