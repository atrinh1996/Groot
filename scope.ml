(* Name (scope) checks variable names *)
open Ast
exception Unbound of string

(* toplevel naming environment, preloaded with built-ins *)
let nameEnv = List.fold_right List.cons [ "printi"; "printb"; "printc";
                                          "+"; "-"; "*"; "/"; "mod";
                                          "<"; ">"; ">="; "<="; "~";
                                          "!=i"; "=i"; "&&"; "||"; "not"  ] []

(* let nameEnv = ref []
   let () =
   nameEnv := List.fold_right List.cons ["printi"; "printc"; "printb"] !nameEnv *)

(* Takes and AST and checks if variables are bound in scope.
   Returns same AST if so, otherwise raises Unbound variable error
   if a variable is unbound. *)
let check defns =

  (* Recursively checks the scope of variables names used in an expression *)
  let rec checkExpr expression rho =
    let rec exp e = match e with
        Literal _ -> ()
      | Var id -> if List.mem id rho then ()
        else raise (Unbound ("Unbound variable " ^ id))
      | If (e1, e2, e3) ->
        let (_, _, _) = (exp e1, exp e2, exp e3) in ()
      | Apply (f, args) ->
        let _ = exp f in List.iter exp args
      | Let (bs, body) ->
        let (xs, es) = List.split bs in
        let () = List.iter exp es in
        checkExpr body (List.fold_right List.cons xs rho)
      | Lambda (formals, body) ->
        checkExpr body (List.fold_right List.cons formals rho)
    in exp expression
  in

  (* (* Checks the scope of variable names used in a defintion *)
     let checkDef def = match def with
      Val (id, exp) ->
        let () = checkExpr exp !nameEnv in
        nameEnv := id :: !nameEnv
     | Expr exp -> checkExpr exp !nameEnv
     in

     (* Iterate through each node/defn of the AST and check expressions for
     scope of variable names. *)
     let () = List.iter checkDef defns in  *)

  let rec checkDef ds env =
    match ds with
      [] -> env
    | f :: rest ->
      let env' =
        (match f with
           Val (id, exp) ->
           let () = checkExpr exp env in
           id :: env
         | Expr exp -> let () = checkExpr exp env in env)
      in checkDef rest env'
  in
  let _ = checkDef defns nameEnv in

  (* Returns the AST if no error raised *)
  defns
