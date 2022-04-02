(*
    Closure converted Abstract Syntax tree 
    Assumes name-check and type-check have already happened
*)

open Ast
open Sast 
module StringMap = Map.Make(String)

(* int StringMap.t - for our rho/variable environment 
   (DOES NOT MAP TO VALUES) *)
type var_env = (int * gtype) StringMap.t
let emptyEnv = StringMap.empty

type cname = string


type cexpr = gtype * cx
and cx =
    | CLiteral  of cvalue 
    | CVar      of cname 
    | CIf       of cexpr * cexpr * cexpr
    | CApply    of cname * cexpr list 
    | CLet      of (cname * cexpr) list * cexpr 
    | CLambda   of (gtype * cname) list * cexpr
and cvalue = 
    | CChar     of char
    | CInt      of int
    | CBool     of bool
    | CRoot     of ctree
and ctree = 
    | CLeaf 
    | CBranch   of cvalue * ctree * ctree


type fdef = 
{
    rettyp  : gtype; 
    fname   : cname; 
    formals : (gtype * cname) list;
    frees   : var_env; 
    body    : cexpr;
}
type func_env = fdef StringMap.t


type cdefn = 
    | CVal      of cname * cexpr
    | CExpr     of cexpr


type cprog = 
{
    main        : cdefn list;
    functions   : func_env;
    rho         : var_env; 
}


(***********************************************************************)
(* Returns true if the given name id is already bound in the given 
   StringMap env. False otherwise *)
let isBound id env = StringMap.mem id env 

(* Adds a binding of k to v in the given StringMap env *)
let bind k v env = StringMap.add k v env 

(* Returns the value id is bound to in the given StringMap env. If the 
   binding doesn't exist, Not_Found exception is raised. *)
let find id env = StringMap.find id env 


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

(* Given expression an a string name n, returns true if n is 
   a free variable in the expression *)
let freeIn exp n = 
  let rec free (_, e) = match e with  
    | SLiteral _              -> false
    | SVar s                  -> s = n
    | SIf (s1, s2, s3)        -> free s1 || free s2 || free s3
    | SApply (fname, args)  -> fname = n || 
                               List.fold_left 
                                  (fun a b -> a || free b) 
                                  false args
    | SLet (bs, body) -> List.fold_left (fun a (_, e) -> a || free e) false bs 
                         || (free body && not (List.fold_left 
                                                (fun a (x, _) -> a || x = n) 
                                                false bs))
    | SLambda (formals, body) -> let (_, names) = List.split formals in 
        free body && not (List.fold_left (fun a x -> a || x = n) false names)
  in free (IType, exp)

(* Given the formals list and body of a lambda (xs, e), and a 
   variable environment, the function returns an environment with only 
   the free variables of this lambda. *)
let improve (xs, e) rho = 
  StringMap.filter (fun n _ -> freeIn (SLambda (xs, e)) n) rho

(* Converts given sexpr to cexpr, and returns the cexpr *)
let rec sexprToCexpr ((ty, e) : sexpr) = match e with 
  | SLiteral v              -> (ty, CLiteral (value v))
  | SVar s                  -> (ty, CVar s)
  | SIf (s1, s2, s3)        -> (ty, CIf (sexprToCexpr s1, 
                                         sexprToCexpr s2, 
                                         sexprToCexpr s3))
  | SApply (fname, args)    -> (ty, CApply (fname, List.map sexprToCexpr args))
  | SLet (bs, body) -> 
        (ty, CLet   (List.map (fun (x, e) -> (x, sexprToCexpr e)) bs, 
                     sexprToCexpr body))
  | SLambda (formals, body) -> (ty, CLambda (formals, sexprToCexpr body)) 
and value = function 
  | SChar c                 -> CChar c 
  | SInt  i                 -> CInt  i 
  | SBool b                 -> CBool b 
  | SRoot t                 -> CRoot (tree t)
and tree = function 
  | SLeaf                   -> CLeaf 
  | SBranch (v, t1, t2)     -> CBranch (value v, tree t1, tree t2)

(* Converts given SVal to CVal, and returns the CVal *)
let svalToCval (id, (ty, e)) = 
  (* check if id was already defined in rho *)
  let (occurs, _) = if (isBound id res.rho) then (find id res.rho) else (0, IType) in 
  let _ = bind id (occurs + 1, ty) res.rho in 
  let cval = 
  (match e with 
    | SLambda (fformals, fbody) -> 
        let f_def = 
          {
            rettyp = ty; 
            fname = id; 
            formals = fformals;
            frees = improve (fformals, fbody) res.rho; 
            body = sexprToCexpr fbody;
          } 
        in 
        let _ = StringMap.add   (id ^ string_of_int (fst (find id res.rho))) 
                                f_def res.functions
        in None 
    | _-> Some (CVal (id, sexprToCexpr (ty, e)))
  )
  in cval 

(***********************************************************************)


(* Pretty Print *)
let rec string_of_cexpr (ty, e) = 
    "[" ^ string_of_typ ty ^ " : " ^ string_of_cx e ^ "]"
and string_of_cx = function 
    | CLiteral v -> string_of_cvalue v
    | CVar n -> n  
    | CIf (e1, e2, e3) -> 
        "(if "  ^ string_of_cexpr e1 ^ " " 
                ^ string_of_cexpr e2 ^ " " 
                ^ string_of_cexpr e3 ^ ")"
    | CApply (f, args) -> 
      "(" ^ f ^ " " 
          ^ String.concat " " (List.map string_of_cexpr args) ^ ")"
    | CLet (binds, body) -> 
        let string_of_binding (id, e) = 
              "[" ^ id ^ " " ^ (string_of_cexpr e) ^ "]"
        in "(let ("  ^ String.concat " " (List.map string_of_binding binds) 
                     ^ ") " ^ string_of_cexpr body ^ ")"
    | CLambda (formals, body) -> 
        let (tys, names) = List.split formals in 
        "(lambda (" ^ (List.fold_left2 
                        (fun space ty para -> string_of_typ ty ^ space ^ para) 
                        " " tys names) 
                    ^ ") " 
                    ^ string_of_cexpr body ^ ")"
and string_of_cvalue = function
    | CChar c -> String.make 1 c 
    | CInt  i -> string_of_int i
    | CBool b -> if b then "#t" else "#f"
    | CRoot t -> string_of_ctree t
and string_of_ctree = function
    | CLeaf -> "leaf"
    | CBranch (v, sib, child) -> 
        "(tree " ^ string_of_cvalue v ^ " " 
                 ^ string_of_ctree sib ^ " " 
                 ^ string_of_ctree child ^ ")"


let string_of_cdefn = function 
    | CVal (id, e) -> "(val " ^ id ^ " " ^ string_of_cexpr e ^ ")"
    | CExpr (cexp) -> string_of_cexpr cexp

let string_of_main main = 
    String.concat "\n" (List.map string_of_cdefn main) ^ "\n"

let string_of_functions (funcs : func_env) = 
  let string_of_fdef _ {
        rettyp = return;
        fname = fname; 
        formals = formals;
        frees = frees;
        body = body;
    } ret_string = 
      let string_of_formal (ty, para) = string_of_typ ty ^ para in
      let listfrees id (num, ty) l = (ty, id ^ string_of_int num) :: l in 
      let args = formals @ List.rev (StringMap.fold listfrees frees []) in
      let def = string_of_typ return ^ " " ^ fname ^ " (" 
        ^ String.concat ", " (List.map string_of_formal args)
        ^ ")\n{\n" ^  string_of_cexpr body  ^ "\n}\n"
      in ret_string ^ def
  in StringMap.fold string_of_fdef funcs ""

let string_of_rho rho = 
  StringMap.fold (fun id (num, ty) s -> 
                    s ^ string_of_typ ty ^ " " ^ id ^ string_of_int num ^ "\n") 
                 rho ""

let string_of_cprog { main = main; functions = functions; rho = rho } = 
    print_endline "Main:";
    print_endline (string_of_main main);
    print_endline "Functions:";
    print_endline (string_of_functions functions);
    print_endline "Rho:";
    print_endline (string_of_rho rho);
