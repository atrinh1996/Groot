(* Monopmorphizes a typed (incl poly) program *)

open Tast 
open Mast


(* Function takes a tprog (list of typed definitions), 
   and monomorphizes it. to produce a mprog *)
let monomorphize (tdefns : tprog) = 

  (* Takes a Tast.gtype and returns the equivalent Mast.mtype *)
  let rec ofGtype = function
      TYCON ty    -> Mtycon  (ofTycon ty)
    | TYVAR tp    -> Tyvar   (ofTyvar tp)
    | CONAPP con  -> Mconapp (ofConapp con)
  and ofTycon = function 
      TInt        -> MIntty
    | TBool       -> MBoolty
    | TChar       -> MCharty
    | TArrow rety -> MTarrow (ofGtype rety)
  and ofTyvar = function 
      TVariable n -> n
  and ofConapp (tyc, tys) = (ofTycon tyc, List.map ofGtype tys)


  (* Takes a type environment and a string key "id". Returns the 
     value (mtype) that the key mapts to. *)
  let lookup (id : mname) (gamma : polyty_env) = 
    StringMap.find id gamma
  in


  (* Takes a texpr and returns a LIST of the the equivalent mexpr *)
  let expr (gamma : polyty_env) ((ty, ex) : texpr) = match ex with 
    | TLiteral l -> (ofGtype ty, MLiteral (value l))
    | TypedVar v -> (ofGtype ty, MVar v)
        (* let vartyp = (try lookup v gamma with Not_found -> ofGtype ty) in  *)
    | TypedIf  (t1, t2, t3) -> 
        let mexp1 = expr t1 
        and mexp2 = expr t2
        and mexp3 = expr t3 in 
        (fst cexp2, CIf (mexp1, mexp2, mexp3))
    | TypedApply (f, args) -> raise (Failure "TODO: Mono - ")
        (* 1. Get the (ty, mx) of f *)

        (* 2. Check if it is polymorphic,  *)

          (* 2a. If not poly, proceed *)

          (* 2b. If it is poly,  *)

    | TypedLet (bs, body) -> raise (Failure "TODO: Mono - ")
    | TypedLambda (formals, body) -> raise (Failure "TODO: Mono - ")
  and value = function 
    | TChar c -> MChar c
    | TInt  i -> MInt i
    | TBool b -> MBool b
    | TRoot t -> MRoot (tree t)
  and tree = function 
    | TLeaf               -> MLeaf
    | TBranch (v, t1, t2) -> MBranch (value v, tree t1, tree t2)
  in 

  (* Takes the current mprog built so far, and one tdefn, and adds 
     the monomorphized version to the mprog. Returns a new mprog 
     with the new definition added in.  *)
  let mono (gamma, defn) : polyty_env * mprog = match defn with  
      TVal (id, (ty, texp)) -> raise (Failure "TODO: Mono - Val")
        (* 1. Using the TEXPR, get the MEXPR *)

        (* 2. Check it is is Polymorphic *)

          (* 2a. if yes, set_aside *)

          (* 2b. if not, add to the prog, return the prog *)

    | TExpr (ty, texp) -> raise (Failure "TODO: Mono - Expr")
        (* 1. Using the TEXPR, get the MEXPR *)

        (* 2. Check it is is Polymorphic *)

          (* 2a. if yes, toss it *)

          (* 2b. if not, add to the prog, return the prog *)
  in 

  let (_, program) = List.fold_left mono (StringMap.empty, []) tdefns 
  in List.rev program