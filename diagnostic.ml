(* exception definition and pretty printing *)
(* maybe rename module to Diagnostic *)



(* character formatting functions *)
(* uses the \027 (ESC) ANSI escape codes *)

(*let red  s = "\027[0m\027[31m" ^ s ^ "\027[0m"
let bold s = "\027[0m\027[1"   ^ s ^ "\027[0m"*)
let red_bold s = "\027[0m\027[5;1;31m" ^ s ^ "\027[0m"

let purple_bold s = "\027[0m\027[1;35m" ^ s ^ "\027[0m"


(* Codes and explanations taken from:
	https://stackoverflow.com/questions/4842424/list-of-ansi-color-escape-sequences
 *)
let reset       = "0" (* all attributes off *)
let bold        = "1" (* bold or increased intensity	*)
let faint       = "2" (* faint (decreased intensity) Not widely supported. *)
let italic      = "3" (* italic. Not widely supported. Sometimes treated as inverse.*)
let underline   = "4" (* underline text *)	
let blink       = "5" (* Slow Blink	less than 150 per minute *)
let reverse = "7"
(*7	[[reverse video]]	swap foreground and background colors
8	Conceal	Not widely supported.
9	Crossed-out	Characters legible, but marked for deletion. Not widely supported.
10	Primary(default) font	
11–19	Alternate font	Select alternate font n-10
20	Fraktur	hardly ever supported
21	Bold off or Double Underline	Bold off not widely supported; double underline hardly ever supported.
22	Normal color or intensity	Neither bold nor faint
23	Not italic, not Fraktur	
24	Underline off	Not singly or doubly underlined
25	Blink off	
27	Inverse off	
28	Reveal	conceal off
29	Not crossed out	*)
let fg_black   = "30"
let fg_red     = "31"
let fg_green   = "32"
let fg_yellow  = "33"
let fg_blue    = "34"
let fg_magenta = "35"
let fg_cyan    = "36"
let fg_white   = "37"

let bg_black   = "40"
let bg_red     = "41"
let bg_green   = "42"
let bg_yellow  = "43"
let bg_blue    = "44"
let bg_magenta = "45"
let bg_cyan    = "46"
let bg_white   = "47"

(*30–37	Set foreground color	See color table below
38	Set foreground color	Next arguments are 5;<n> or 2;<r>;<g>;<b>, see below
39	Default foreground color	implementation defined (according to standard)
40–47	Set background color	See color table below
48	Set background color	Next arguments are 5;<n> or 2;<r>;<g>;<b>, see below
49	Default background color	implementation defined (according to standard)
51	Framed	
52	Encircled	
53	Overlined	
54	Not framed or encircled	
55	Not overlined	
60	ideogram underline	hardly ever supported
61	ideogram double underline	hardly ever supported
62	ideogram overline	hardly ever supported
63	ideogram double overline	hardly ever supported
64	ideogram stress marking	hardly ever supported
65	ideogram attributes off	reset the effects of all of 60-64
90–97	Set bright foreground color	aixterm (not in standard)
100–107	Set bright background color	aixterm (not in standard)*)

(* preset effects lists for particular message types *)
let error_fx   = [fg_red;bold]
let warning_fx = [fg_magenta;bold]

let strfx fx str =
	"\027[" ^ String.concat ";" fx ^ "m" ^ str ^ "\027[0m"

(* allowing for an exception to propogate will cause that pesky phrase
 * "Fatal error: exception" to be printed; this avoids that
 *)
let warning exn = try raise(exn) with _ -> prerr_endline (Printexc.to_string exn)
let error   exn = try raise(exn) with _ -> prerr_endline (Printexc.to_string exn); exit 1


exception LexingError    of string
exception ParsingError   of string
exception ParsingWarning of string

(* errors with positions, used while scanning and parsing *)
(* Courtesy of:
	https://stackoverflow.com/questions/14046392/verbose-error-with-ocamlyacc
*)
let pos_fault msg (start: Lexing.position) (finish: Lexing.position)  = 
    Printf.sprintf "(line %d, col %d-%d): %s" start.pos_lnum 
          (start.pos_cnum - start.pos_bol) (finish.pos_cnum - finish.pos_bol) msg

let lex_error msg lexbuf = 
    LexingError ((pos_fault ("(" ^ (Lexing.lexeme lexbuf) ^ ")") (Lexing.lexeme_start_p lexbuf) (Lexing.lexeme_end_p lexbuf)) ^ " " ^ msg)

let parse_error msg nterm =
    ParsingError (pos_fault msg (Parsing.rhs_start_pos nterm) (Parsing.rhs_end_pos nterm))

let parse_warning msg nterm =
    ParsingWarning (pos_fault msg (Parsing.rhs_start_pos nterm) (Parsing.rhs_end_pos nterm))
(* end courtesy of *)

exception Unimplemented of string
exception EmptyLetBinding
let () =
    Printexc.register_printer (function
        | Unimplemented s  -> Some ((strfx error_fx  "Unimplemented Error: ") ^ s)
        | ParsingWarning s -> Some ((strfx warning_fx "Parsing Warning: "   ) ^ s)
        | LexingError s    -> Some ((strfx error_fx  "Lexing Error: "       ) ^ s)
        | ParsingError s   -> Some ((strfx error_fx  "Parsing Error: "      ) ^ s)
        | _ -> None)



(*let () = (strfx) : string list * string -> string*)
(*let () = print_string ((strfx [bg_black;fg_white;blink] " hello ") ^ "\n")*)
(*let () =
    Printexc.register_printer (function
        | Unimplemented s -> Some ("\027[1;31mUnimplemented:\027[0m " ^ s)
        
        | _ -> None)
        *)