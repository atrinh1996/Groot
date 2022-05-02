(* MAST -- monomorphized AST where pholymorphism is removed *)
module StringMap = Map.Make(String)

type mname = string

type mtype =
    Mtycon of mtycon
  | Mtyvar of int
  | Mconapp of mconapp
and mtycon =
    MIntty
  | MCharty
  | MBoolty
  | MTarrow of mtype
and mconapp = (mtycon * mtype list)

let integerTy  = Mtycon MIntty
let characterTy = Mtycon MCharty
let booleanTy = Mtycon MBoolty
let functionTy (ret, args) = Mconapp (MTarrow ret, args)



type mexpr = mtype * mx
and mx =
  | MLiteral  of mvalue
  | MVar      of mname
  | MIf       of mexpr * mexpr * mexpr
  | MApply    of mexpr * mexpr list
  | MLet      of (mname * mexpr) list * mexpr
  | MLambda   of (mtype * mname) list * mexpr
and mvalue =
  | MChar     of char
  | MInt      of int
  | MBool     of bool
  | MRoot     of mtree
and mtree =
  | MLeaf
  | MBranch   of mvalue * mtree * mtree

type mdefn =
  | MVal      of mname * mexpr
  | MExpr     of mexpr


(* type polyty_env = (mexpr * mtype list) StringMap.t *)
type polyty_env = mexpr StringMap.t

type mprog = mdefn list




(* Pretty printer *)

(* String of gtypes *)
let rec string_of_mtype = function
  | Mtycon ty -> string_of_mtycon ty
  | Mconapp con -> string_of_mconapp con
  | Mtyvar i -> "'" ^ string_of_int i
and string_of_mtycon = function
  | MIntty -> "int"
  | MBoolty -> "bool"
  | MCharty -> "char"
  | MTarrow (retty) -> string_of_mtype retty
and string_of_mconapp (tyc, tys) =
  string_of_mtycon tyc ^ " (" ^ String.concat " " (List.map string_of_mtype tys) ^ ")"


(* String of a typed expression (mexpr) == (type, m-expression) *)
let rec string_of_mexpr (typ, exp) =
  "[" ^ string_of_mtype typ ^ "] " ^ string_of_mx exp
and string_of_mx = function
  | MLiteral v -> string_of_mvalue v
  | MVar id -> id
  | MIf (te1, te2, te3) ->
    "(if "  ^ string_of_mexpr te1 ^ " "
    ^ string_of_mexpr te2 ^ " "
    ^ string_of_mexpr te3 ^ ")"
  | MApply (f, args) ->
    "(" ^ string_of_mexpr f ^ " "
    ^ String.concat " " (List.map string_of_mexpr args) ^ ")"
  | MLet (binds, body) ->
    let string_of_binding (id, e) =
      "[" ^ id ^ " " ^ (string_of_mexpr e) ^ "]"
    in
    "(let ("  ^ String.concat " " (List.map string_of_binding binds) ^ ") "
    ^ string_of_mexpr body ^ ")"
  | MLambda (formals, body) ->
    let formalStringlist = List.map (fun (ty, x) -> string_of_mtype ty ^ " " ^ x) formals in
    "(lambda (" ^ String.concat ", "  formalStringlist
    ^ ") " ^ string_of_mexpr body ^ ")"
(* toString for Sast.svalue *)
and string_of_mvalue = function
  | MChar c -> String.make 1 c
  | MInt i -> string_of_int i
  | MBool b -> if b then "#t" else "#f"
  | MRoot tr -> string_of_mtree tr
(* toString for Sast.stree *)
and string_of_mtree = function
  | MLeaf -> "leaf"
  | MBranch (v, sib, child) ->
    "(tree " ^ string_of_mvalue v ^ " "
    ^ string_of_mtree sib ^ " "
    ^ string_of_mtree child ^ ")"



(* String of a typed defn (tdefn) *)
let string_of_mdefn = function
  | MVal (id, me) -> "(val " ^ id ^ " " ^ string_of_mexpr me ^ ")"
  | MExpr me    -> string_of_mexpr me


(* String of the tprog == tdefn list *)
let string_of_mprog mdefns =
  String.concat "\n" (List.map string_of_mdefn mdefns) ^ "\n"