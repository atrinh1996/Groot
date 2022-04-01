(* Closure conversion for groot compiler *)

(* open Ast *)
open Sast
open Cast 

let emptyEnv = StringMap.empty

(* partial cprog to return from this module *)
let res = 
{
  main      = []; 
  functions = emptyEnv; 
  rho       = emptyEnv;
}


(* puts the given cdefn into the main list *)
let addMain d = d :: res.main 

(* puts the given function name (id) mapping to its definition (f) in the 
   functions StringMap *)
let addFunctions id f = StringMap.add id f res.functions 

(* Returns true if the given name id is already bound in the given 
   StringMap env. False otherwise *)
let isBound id env = StringMap.mem id env 

(* Adds a binding of k to v in the given StringMap env *)
let bind k v env = StringMap.add k v env 

(* Returns the value id is bound to in the given StringMap env. If the 
   binding doesn't exist, Not_Found exception is raised. *)
let find id env = StringMap.find id env 


(* Converts given sexpr to cexpr, and returns the cexpr *)
let rec sexprToCexpr ((t, e) : sexpr) = match e with 
  | SLiteral v              -> raise (Failure ("TODO: conversion"))
  | SVar s                  -> raise (Failure ("TODO: conversion"))
  | SIf (s1, s2, s3)        -> raise (Failure ("TODO: conversion"))
  | SApply (fname, args)    -> raise (Failure ("TODO: conversion"))
  | SLet (bs, body)         -> raise (Failure ("TODO: conversion"))
  | SLambda (formals, body) -> raise (Failure ("TODO: conversion"))
and value = function 
  | SChar c                 -> CChar c 
  | SInt  i                 -> CInt  i 
  | SBool b                 -> CBool b 
  | SRoot t                 -> CRoot (tree t)
and tree = function 
  | SLeaf -> CLeaf 
  | SBranch (v, t1, t2)     -> CBranch (value v, tree t1, tree t2)

(* Converts given SVal to CVal, and returns the CVal *)
let svalToCval ((id, (ty, e)) as s) = match e with 
  | SLiteral v              -> raise (Failure ("TODO: check for id dup, put in rho, put in main"))
  | SVar s                  -> raise (Failure ("TODO: check for id dup, put in rho, put in main"))
  | SIf (s1, s2, s3)        -> raise (Failure ("TODO: check for id dup, put in rho, put in main"))
  | SApply (fname, args)    -> raise (Failure ("TODO: check for id dup, put in rho, put in main"))
  | SLet (bs, body)         -> raise (Failure ("TODO: check for id dup, put in rho, put in main"))
  | SLambda (formals, body) -> raise (Failure ("TODO: check for id dup, put in rho, put in functions"))

(* Given an sprog (which is an sdefn list), convert returns a 
   cprog version. *)
let conversion sdefns = (* ignore sdefns; raise (Failure ("TODO: conversion")) *)

  (* With a given sdefn, function converts it to the appropriate CAST type
     and sorts it to the appropriate list in a cprog type. *)
  let convert = function 
    | SVal (id, (ty, sexp)) -> 
        let def = svalToCval (id, (ty, sexp)) in 
        (match def with 
            | None -> () 
            | Some cval -> let _ = addMain cval in ())
    | SExpr e -> let _ = addMain (CExpr (sexprToCexpr e)) in ()
  in 
    
  let _ = List.iter convert sdefns in 

  {
    main = List.rev res.main;
    functions = res.functions;
    rho = res.rho
  }
