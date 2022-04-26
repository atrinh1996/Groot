(*
fun canonicalize; seems to generate the type variable names;
	'a through 'z
	once those are exhausted, then v1 and up, to infinity

*)

open Ast
open Tast

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
    in List.fold_left add_prints !gamma [("printi", funtype inttype []); 
                                         ("printc", funtype chartype []); 
                                         ("printb", funtype booltype []) ]

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
            TInt _  -> inttype
          | TChar _ -> chartype
          | TBool _ -> booltype
          | TRoot _ -> raise (Failure "TODO treetype"))
        , TLiteral s)
    | Var(x) -> (try (StringMap.find x gamma, TypedVar x) with Not_found -> raise (Failure ("not found var " ^ x)))
    | If(e1, e2, e3)           -> 
        let (t1, e1') = expr id e1 gamma in 
        let (t2, e2') = expr id e2 gamma in 
        let (t3, e3') = expr id e3 gamma in 
        (t2, TypedIf ((t1, e1'), (t2, e2'), (t3, e3')))
    | Apply(f, args)        -> 
        (* let (fty, app) = f in  *)
        (* t is a TArrow  *)
        let (t, f') = expr "" f gamma in 
        (* let () = print_endline ("type of apply expr: " ^ string_of_typ t) in  *)
        let t' = (match t with 
                    CONAPP (TArrow res, _) -> res
                  | _ -> raise (Failure "Tast: applied non-function type")
                  ) in 
        let args' = List.map (fun e -> expr "" e gamma) args in 
        (t', TypedApply ((t', f'), args'))
    | Let(bs, body)             -> 
      let bs' = List.map (fun (x, ex) -> (x, expr x ex gamma)) bs in
      let gamma' = List.fold_left (fun map (x, (t, _)) -> StringMap.add x t map) 
                                  gamma bs'  in 
      let (ty, sbody) = expr id body gamma' in 
      (ty, TypedLet (bs', (ty, sbody)))

    (* Forces labda to be int type. *)
    | Lambda(formals, body) -> 
        let formal_list = List.fold_left (fun (tys, idents) x -> ((TVariable 1) :: tys, x :: idents)) ([], []) formals in 
        (* let (argsty, _) = List.split formal_list in *)
        let gamma' = List.fold_left (fun map x -> StringMap.add x inttype map) gamma formals in 
        let (retty, ex) = expr "" body gamma' in 
        let gtys = (List.map (fun elem -> TYVAR elem) (fst formal_list)) in 
        let fty = funtype retty gtys in 
        let _ = if (id = "") then () 
          else functions := StringMap.add id 
                                          { 
                                            rettyp = inttype;
                                            fname = id;
                                            formals = List.combine gtys (snd formal_list);
                                          } 
                                          !functions in 
        (fty, TypedLambda (formal_list, (retty, ex)))
  (* Returns the Sast.svalue version fo the given Ast.value *)
  and value = function 
  	| Char(c)     -> TChar c
    | Int(i)      -> TInt i
    | Bool(b)     -> TBool b
    | Root(_)     -> raise (Failure ("TODO - value to tvalue of Root"))
  in

  (* For the given Ast.defn, returns an Sast.sdefn, eventually should call 
  		constraint-generation for type inferencing*)
	let check_defn d = match d with
		| Val (name, e) -> 
				let e' = expr name e !gamma in
        let () = gamma := StringMap.add name (fst e') !gamma in 
				TVal(name, e')
		| Expr e      -> TExpr (expr "" e !gamma)


in List.map check_defn defns 

(* Probably will map a check-function over the defns (defn list : defs) *)
(* check-function will take a defn and return an sdefn *)
