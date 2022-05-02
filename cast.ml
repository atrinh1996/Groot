(*
    Closure converted Abstract Syntax tree
    Assumes name-check and type-check have already happened
*)

(* open Ast *)
(* open Sast  *)
module StringMap = Map.Make(String)

type cname = string

type ctype =
    Tycon of tycon
  (* | Tyvar of tyvar *)
  | Conapp of conapp
and tycon =
    Intty
  | Charty
  | Boolty
  | Tarrow of ctype
  | Clo of cname * ctype * ctype list
  (* and tyvar =
      Tparam of int *)
and conapp = (tycon * ctype list)


let intty = Tycon Intty
let charty = Tycon Charty
let boolty = Tycon Boolty
(* let treetype ty = CONAPP () *)
(* let funty (ret, args) = Tycon (Tarrow (ret, args)) *)
let funty (ret, args) =
  Conapp (Tarrow ret, args)
let closurety (id, functy, freetys) =
  Tycon (Clo (id, functy, freetys))

(* int StringMap.t - for our rho/variable environment
   (DOES NOT MAP TO VALUES) *)
type var_env = ((int * ctype) list) StringMap.t
let emptyEnv = StringMap.empty
let emptyList = []




type cexpr = ctype * cx
and cx =
  | CLiteral  of cvalue
  | CVar      of cname
  | CIf       of cexpr * cexpr * cexpr
  | CApply    of cexpr * cexpr list * int
  | CLet      of (cname * cexpr) list * cexpr
  | CLambda   of cname * cexpr list
and cvalue =
  | CChar     of char
  | CInt      of int
  | CBool     of bool
  | CRoot     of ctree
and ctree =
  | CLeaf
  | CBranch   of cvalue * ctree * ctree

type cdefn =
  | CVal      of cname * cexpr
  | CExpr     of cexpr


(* function definiton record type (imperative style to record information) *)
type fdef =
  {
    body    : cexpr;
    rettyp  : ctype;
    fname   : cname;
    formals : (ctype * cname) list;
    frees   : (ctype * cname) list;
  }


(* closure is specifically a Tycon (Clo (struct name, function type field, frees field)) *)
type closure = ctype

(* a CAST *)
type cprog =
  {
    mutable main        : cdefn list; (* list for main instruction *)
    mutable functions   : fdef list;   (* table of function definitions *)
    mutable rho         : var_env;    (* variable declaration table *)
    mutable structures  : closure list;
  }





(* Pretty Print *)
let rec string_of_ctype = function
    Tycon ty -> string_of_tycon ty
  (* | Tyvar tp -> string_of_tyvar tp *)
  | Conapp con -> string_of_conapp con
and string_of_tycon = function
    Intty  -> "int"
  | Charty -> "char"
  | Boolty -> "bool"
  | Tarrow (retty) -> string_of_ctype retty
  (* ^ " (" ^ String.concat " " (List.map string_of_ctype argsty) ^ ")"  *)
  | Clo (sname, funty, freetys) ->
    sname ^ " {\n"
    ^ string_of_ctype funty ^ "\n"
    ^ String.concat "\n" (List.map string_of_ctype freetys)
    ^ "\n} ;; "
(* and string_of_tyvar = function
    Tparam n -> string_of_int n *)
and string_of_conapp (tyc, tys) =
  string_of_tycon tyc ^ " (" ^ String.concat " " (List.map string_of_ctype tys) ^ ")"



let rec string_of_cexpr (_, e) =
  (* "["  *)
  (* ^ string_of_ctype ty ^ " : "  *)
  (* ^  *)
  string_of_cx e
(* ^ "]" *)
and string_of_cx = function
  | CLiteral v -> string_of_cvalue v
  | CVar n -> n
  | CIf (e1, e2, e3) ->
    "(if "  ^ string_of_cexpr e1 ^ " "
    ^ string_of_cexpr e2 ^ " "
    ^ string_of_cexpr e3 ^ ")"
  | CApply (f, args, _) ->
    "(" ^ string_of_cexpr f ^ " "
    ^ String.concat " " (List.map string_of_cexpr args) ^ ")"
  | CLet (binds, body) ->
    let string_of_binding (id, e) =
      "[" ^ id ^ " " ^ (string_of_cexpr e) ^ "]"
    in "(let ("  ^ String.concat " " (List.map string_of_binding binds)
       ^ ") " ^ string_of_cexpr body ^ ")"
  | CLambda (id, frees) ->
    "(" ^ id ^ " "
    ^ String.concat " " (List.map string_of_cexpr frees)
    ^ ")"
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

let string_of_functions (funcs : fdef list) =
  let string_of_fdef ret_string {
      rettyp = return;
      fname = fname;
      formals = formals;
      frees = frees;
      body = body;
    } =
    let string_of_formal  (ty, para) = string_of_ctype ty ^ " " ^ para in
    let args = formals @ frees in
    let def = string_of_ctype return ^ " " ^ fname ^ " ("
              ^ String.concat ", " (List.map string_of_formal args)
              ^ ")\n{\n"
              ^ string_of_cexpr body  ^ "\n}\n"
    in ret_string ^ def ^ "\n"
  in List.fold_left string_of_fdef "" funcs

let string_of_rho rho =
  StringMap.fold (fun id occursList s ->
      let (num, ty) = List.nth occursList 0 in
      s ^ id ^ ": " ^ string_of_ctype ty ^ " "
      ^ id ^ string_of_int num ^ "\n")
    rho ""

let string_of_structures structss =
  let string_of_struct tyc = "struct " ^ string_of_ctype tyc
  in String.concat "\n" (List.map string_of_struct structss)


let string_of_cprog { main = main; functions = functions;
                      rho = rho;   structures = structures } =
  "Main:\n" ^
  string_of_main main ^ "\n\n" ^
  "Functions:\n" ^
  string_of_functions functions ^ "\n\n" ^
  "Rho:\n" ^
  string_of_rho rho ^ "\n\n" ^
  "Structures:\n" ^
  string_of_structures structures ^ "\n\n"
