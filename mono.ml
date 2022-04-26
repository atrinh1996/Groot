(* Monopmorphizes a typed (incl poly) program *)

open Tast 
open Mast


(* Function takes a tprog (list of typed definitions), 
   and monomorphizes it. to produce a mprog *)
let monomorphize (tdefns : tprog) = 

  (* Takes the current mprog built so far, and one tdefn, and adds 
     the monomorphized version to the mprog. Returns a new mprog 
     with the new definition added in.  *)
  let mono prog = function 
      TVal (id, (ty, texp)) ->
    | TExpr (ty, texp) -> 
  in 

  let program = List.fold_left mono [] tdefns 
  in List.rev program