(* HAST - resolves function types involved in the uses of HOFs *)

module StringMap = Map.Make(String)

type hname = string 

type htype =
    HTycon of htycon
  | HConapp of hconapp
and htycon =
    HIntty
  | HCharty
  | HBoolty
  | HTarrow of htype
  (* H-closures come with return type, formal types, free types *)
  | HCls of hname * htype * htype list * htype list 
and hconapp = (htycon * htype list)

let intTy  = HTycon HIntty
let charTy = HTycon HCharty
let boolTy = HTycon HBoolty

let partialClosurety (id, retty, formaltys, freetys) =
  HTycon (HCls (id, retty, formaltys, freetys))


type hexpr = htype * hx
and hx =
  | HLiteral  of hvalue
  | HVar      of hname
  | HIf       of hexpr * hexpr * hexpr
  | HApply    of hexpr * hexpr list 
  | HLet      of (hname * hexpr) list * hexpr
  | HLambda   of (htype * hname) list * hexpr
and hvalue =
  | HChar     of char
  | HInt      of int
  | HBool     of bool
  | HRoot     of htree
and htree =
  | HLeaf
  | HBranch   of hvalue * htree * htree

type hdefn =
  | HVal      of hname * hexpr
  | HExpr     of hexpr


type ty_env = ((int * htype) list) StringMap.t
type hof_env = (hname * hexpr) StringMap.t
let emptyEnvironment = StringMap.empty
let emptyListEnv = []


type hrec = 
  {
    mutable program : hdefn list;
    mutable gamma   : ty_env; 
    mutable hofs   : hof_env;
  }

type hprog = hdefn list 



(* Pretty printer *)
let rec string_of_htype = function 
    HTycon tyc -> string_of_htycon tyc 
  | HConapp con -> string_of_hconapp con 
and string_of_htycon = function 
    HIntty -> "int"
  | HCharty -> "char"
  | HBoolty -> "bool"
  | HTarrow retty -> string_of_htype retty
  | HCls (id, retty, formaltys, freetys) -> 
      let string_of_list tys = 
          String.concat ", " (List.map string_of_htype tys) in 
      id ^ "{ " ^
      string_of_htype retty 
      ^ " (" ^  
      string_of_list formaltys ^ " :: " ^
      string_of_list freetys
      ^ ") }"
and string_of_hconapp (tyc, tys) = 
      string_of_htycon tyc ^ " (" 
      ^ String.concat " " (List.map string_of_htype tys) ^ ")"


(* String of a h-expression *)
let rec string_of_hexpr (typ,exp) =
  "[" ^ string_of_htype typ ^ "] " ^ string_of_hx exp
and string_of_hx = function
  | HLiteral v -> string_of_hvalue v
  | HVar id -> id
  | HIf (e1, e2, e3) ->
    "(if "  ^ string_of_hexpr e1 ^ " "
    ^ string_of_hexpr e2 ^ " "
    ^ string_of_hexpr e3 ^ ")"
  | HApply (f, args) ->
    "(" ^ string_of_hexpr f ^ " "
    ^ String.concat " " (List.map string_of_hexpr args) ^ ")"
  | HLet (binds, body) ->
    let string_of_binding (id, e) =
      "[" ^ id ^ " " ^ (string_of_hexpr e) ^ "]"
    in
    "(let ("  ^ String.concat " " (List.map string_of_binding binds) ^ ") "
    ^ string_of_hexpr body ^ ")"
  | HLambda (formals, body) ->
    let formalStringlist = List.map (fun (ty, x) -> 
                                      string_of_htype ty ^ " " ^ x) 
                                    formals in
    "(lambda (" ^ String.concat ", "  formalStringlist
    ^ ") " ^ string_of_hexpr body ^ ")"
(* toString for Hast.hvalue *)
and string_of_hvalue = function
  | HChar c -> String.make 1 c
  | HInt i -> string_of_int i
  | HBool b -> if b then "#t" else "#f"
  | HRoot tr -> string_of_htree tr
(* toString for Hast.htree *)
and string_of_htree = function
  | HLeaf -> "leaf"
  | HBranch (v, sib, child) ->
    "(tree " ^ string_of_hvalue v ^ " "
    ^ string_of_htree sib ^ " "
    ^ string_of_htree child ^ ")"



(* String of a hdefn *)
let string_of_hdefn = function
  | HVal (id, e) -> "(val " ^ id ^ " " ^ string_of_hexpr e ^ ")"
  | HExpr e    -> string_of_hexpr e

(* Returns the string of an hprog *)
let string_of_hprog hdefns =
  String.concat "\n" (List.map string_of_hdefn hdefns) ^ "\n"