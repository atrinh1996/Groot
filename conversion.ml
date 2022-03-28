(* Closure conversion for groot compiler *)

open Ast
open Sast
open Cast 

module StringMap = Map.Make(String)

let convert sdefns =  

  (*  *)
  let rec tree = function 
    | SLeaf -> CLeaf
    | SBranch (v, t1, t2) -> CBranch (value v, tree t1, tree t2) 
  and value = function  
    | SChar c -> CChar c
    | SInt  i -> CInt i 
    | SBool b -> CBool b
    | SRoot t -> CRoot (tree t)
  in

  (*  *)
  let rec to_cexpr (_, e) = match e with 
    | SLiteral v -> CLiteral (value v)
    | SVar s -> CVar s
    | SIf (s1, s2, s3) -> CIf (to_cexpr s1, to_cexpr s2, to_cexpr s3)
    | SApply (f, params) -> CApply (f, List.map to_cexpr params)
    | SLet (bs, body) -> CLet (List.map (fun (id, sx) -> (id, to_cexpr sx)) bs, to_cexpr body)
    | SLambda (formals, body)  -> CLambda (formals, to_cexpr body)
  in 

  (*  *)
  let to_cval rho (_, e) = (* match e with  *)
    let rec cval = function 
      | SLiteral v -> value v
      | SVar s -> StringMap.find s rho
      | SIf (s1, s2, s3) -> raise (Failure ("TODO: Closure-SIf"))
      | SApply (f, params) -> raise (Failure ("TODO: Closure-SApply"))
      | SLet (bs, body) -> 
          let rho' = List.fold_left 
                      (fun map (id, (_, sx)) -> StringMap.add id (cval sx) map) 
                      rho 
                      bs
          in CClosure (([], to_cexpr body), rho')
      | SLambda (formals, body)  -> CClosure ((formals, to_cexpr body), rho)
    in cval e
  in

  (*  *)
  let rho = 
    let rec conv_def rho d = match d with 
      | SVal (id, sexp) -> StringMap.add id (to_cval rho sexp) rho
      | SExpr (sexp) -> rho
    in List.fold_left conv_def StringMap.empty sdefns 
  in rho