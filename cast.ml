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
  | Tyvar of tyvar
  | Conapp of conapp 
and tycon =  
    Intty  
  | Charty 
  | Boolty
  | Tarrow of ctype * ctype list
(* a closure to represent a struct, 
   field 0: function pointer requires the result and args type (Function type) 
   field 1 - n: other fields need types to represent the frees *)
  (* | Clo of ctype * ctype list * ctype list *)
  | Clo of cname * ctype * ctype list
and tyvar = 
    Tparam of int
and conapp = (tycon * ctype list)


let intty = Tycon Intty 
let charty = Tycon Charty
let boolty = Tycon Boolty
(* let treetype ty = CONAPP () *)

(* function type, res is a tycon, args is gtype list *)
(* let funtype (args, res) = CONAPP (res, args) *)

(* Alt function type: res is a gtype, args is a gtype list*)
(* let funtype (res, args) = TYCON (TArrow (res, args)) *)


(* int StringMap.t - for our rho/variable environment 
   (DOES NOT MAP TO VALUES) *)
type var_env = (int * ctype) StringMap.t
let emptyEnv = StringMap.empty
let emptyList = []




type cexpr = ctype * cx
and cx =
  | CLiteral  of cvalue 
  | CVar      of cname 
  | CIf       of cexpr * cexpr * cexpr
  | CApply    of cexpr * cexpr list 
  (* | CApply    of cname * cexpr list  *)
  | CLet      of (cname * cexpr) list * cexpr 
  (* May not need the last two members of the triple *)
  (* | CLambda   of cname * (ctype * cname) list * cexpr *)
  | CLambda   of cname 
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

(* funciton definition table used to handle multiple definitons of a function *)
(* type func_env = fdef StringMap.t *)

(* closure is specifically a Tycon (Clo (struct name, function type field, frees field)) *)
type closure = ctype

(* a CAST *)
type cprog = 
{
  mutable main        : cdefn list; (* list for main instruction *)
  mutable functions   : fdef list;   (* table of function definitions *)
  mutable rho         : var_env;    (* variable declaration table *)
  mutable structures  : closure list;
  (* mutable phi         : cname list; fname list to deal with dup defs of functions *)
}





(* Pretty Print *)
let rec string_of_ctype = function 
    Tycon ty -> string_of_tycon ty
  | Tyvar tp -> string_of_tyvar tp
  | Conapp con -> string_of_conapp con
and string_of_tycon = function
    Intty  -> "int"
  | Charty -> "char"
  | Boolty -> "bool"
  | Tarrow (retty, argsty) -> string_of_ctype retty ^ " (" ^ String.concat " " (List.map string_of_ctype argsty) ^ ")" 
  | Clo (sname, funty, freetys) -> 
        sname ^ " {\n" 
            ^ string_of_ctype funty ^ "\n"
            (* ^ "("  ^ String.concat " " (List.map string_of_ctype argstys) ^  ")\n" *)
            ^ String.concat "\n" (List.map string_of_ctype freetys)
        ^ "\n} ;; "
and string_of_tyvar = function 
    Tparam n -> string_of_int n
and string_of_conapp (tyc, tys) = 
  string_of_tycon tyc ^ " " ^ String.concat " " (List.map string_of_ctype tys)



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
    | CApply (f, args) -> 
      "(" ^ string_of_cexpr f ^ " " 
          ^ String.concat " " (List.map string_of_cexpr args) ^ ")"
    | CLet (binds, body) -> 
        let string_of_binding (id, e) = 
              "[" ^ id ^ " " ^ (string_of_cexpr e) ^ "]"
        in "(let ("  ^ String.concat " " (List.map string_of_binding binds) 
                     ^ ") " ^ string_of_cexpr body ^ ")"
    | CLambda id -> "(" ^ id ^ ")"
        (* let (tys, names) = List.split formals in 
        "(" ^ id ^ " (" ^ String.concat ", " 
                            (List.map (fun (ty, name) -> 
                                        string_of_ctype ty ^ " " ^ name) 
                                      formals)
                    ^ ") " 
                    ^ string_of_cexpr body ^ ")" *)
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
      (* let string_of_free    (ty, nm) = string_of_ctype ty ^ " " ^ nm in *)
      (* let listfrees id (num, ty) l = (ty, id ^ string_of_int num) :: l in  *)
      (* let args = formals @ List.rev (StringMap.fold listfrees frees []) in *)
      let args = formals @ frees in
      let def = string_of_ctype return ^ " " ^ fname ^ " (" 
        ^ String.concat ", " (List.map string_of_formal args)
        ^ ")\n{\n" 
        (* ^ String.concat "\n" (List.map string_of_free frees) ^ "\n" *)
        ^ string_of_cexpr body  ^ "\n}\n"
      in ret_string ^ def ^ "\n"
  in List.fold_left string_of_fdef "" funcs

let string_of_rho rho = 
  StringMap.fold (fun id (num, ty) s -> 
                    s ^ id ^ ": " ^ string_of_ctype ty ^ " " ^ id ^ string_of_int num ^ "\n") 
                 rho ""

let string_of_structures structss = 
    let string_of_struct tyc = "struct " ^ string_of_ctype tyc 
in String.concat "\n" (List.map string_of_struct structss)


let string_of_cprog { main = main; functions = functions; 
                      rho = rho;   structures = structures } = 
    print_endline "Main:";
    print_endline (string_of_main main);
    print_endline "Functions:";
    print_endline (string_of_functions functions);
    print_endline "Rho:";
    print_endline (string_of_rho rho);
    print_endline "Structures:";
    print_endline (string_of_structures structures);
