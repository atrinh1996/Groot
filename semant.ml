(*
fun canonicalize; seems to generate the type variable names;
	'a through 'z
	once those are exhausted, then v1 and up, to infinity

*)

open Ast
open Sast

module StringMap = Map.Make(String)


type ty_env = gtype StringMap.t 
let gamma = ref StringMap.empty

type func_decl = {
  rettyp : gtype;
  fname : string;
  formals : (gtype * string) list;
}

let () = gamma := 
    let add_prints map (k, v) = 
      StringMap.add k v map 
    in List.fold_left add_prints !gamma [ ("printi", funtype (inttype, [])); 
                                               ("printc", funtype (chartype, [])); 
                                               ("printb", funtype (booltype, [])) ]

(* Collection function declarations for built in prints *)
let built_in_decls = ref StringMap.empty

let () = built_in_decls := 
  let add_bind map (name, ty) =  
    StringMap.add 
      name 
      { 
        rettyp = inttype;
        fname = name;
        formals = [(ty, "x")];
      }
      map 
  in List.fold_left add_bind !built_in_decls [ ("printi", inttype); 
                                               ("printc", chartype); 
                                               ("printb", booltype) ]

let functions = built_in_decls

(* Returns a function from out symbol table *)
let find_func fname map = 
  try StringMap.find fname map
  with Not_found -> raise (Failure ("unrecognized function " ^ fname))



let semantic_check (defns) =


	(* Returns the Sast.sexpr (Ast.typ, Sast.sx) version of the given Ast.expr *)
	let rec expr id e gamma = match e with 
		| Literal(lit)          -> 
      let s = value lit in 
        ((match s with 
            SInt _  -> inttype
          | SChar _ -> chartype
          | SBool _ -> booltype
          | SRoot _ -> raise (Failure "TODO treetype"))
        , SLiteral s)
    | Var(x) -> (try (StringMap.find x gamma, SVar x) with Not_found -> raise (Failure ("not found var " ^ x)))
    | If(e1, e2, e3)           -> 
        let (t1, e1') = expr id e1 gamma in 
        let (t2, e2') = expr id e2 gamma in 
        let (t3, e3') = expr id e3 gamma in 
        (t2, SIf ((t1, e1'), (t2, e2'), (t3, e3')))
    | Apply(f, args)        -> 
        (* let (fty, app) = f in  *)
        (* t is a TArrow  *)
        let (t, f') = expr "" f gamma in 
        (* let () = print_endline ("type of apply expr: " ^ string_of_typ t) in  *)
        let t' = (match t with 
                    TYCON (TArrow (res, _)) -> res
                  | _ -> raise (Failure "Sast: applied non-function type")
                  ) in 
        let args' = List.map (fun e -> expr "" e gamma) args in 
        (t', SApply ((t', f'), args'))
    | Let(_, _)             -> raise (Failure ("TODO - expr to sexpr of Let"))
    (* Forces labda to be int type. *)
    | Lambda(formals, body) -> 
        let formal_list = List.map (fun x -> (inttype, x)) formals in 
        let (argsty, _) = List.split formal_list in
        let gamma' = List.fold_left (fun map x -> StringMap.add x inttype map) gamma formals in 
        let (retty, ex) = expr "" body gamma' in 
        let fty = funtype (retty, argsty) in 
        let _ = if (id = "") then () 
          else functions := StringMap.add id 
                                          { 
                                            rettyp = inttype;
                                            fname = id;
                                            formals = formal_list;
                                          } 
                                          !functions in 
        (fty, SLambda (formal_list, (retty, ex)))
  (* Returns the Sast.svalue version fo the given Ast.value *)
  and value = function 
  	| Char(c)     -> SChar c
    | Int(i)      -> SInt i
    | Bool(b)     -> SBool b
    | Root(_)     -> raise (Failure ("TODO - value to svalue of Root"))
  in

  (* For the given Ast.defn, returns an Sast.sdefn, eventually should call 
  		constraint-generation for type inferencing*)
	let check_defn d = match d with
		| Val (name, e) -> 
				let e' = expr name e !gamma in
        let () = gamma := StringMap.add name (fst e') !gamma in 
				SVal(name, e')
		| Expr e      -> SExpr (expr "" e !gamma)


in List.map check_defn defns 

(* Probably will map a check-function over the defns (defn list : defs) *)
(* check-function will take a defn and return an sdefn *)
