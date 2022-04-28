

type gtype =
  | TYCON of tycon
  | TYVAR of tyvar
  | CONAPP of conapp
and tycon =
  | TInt                    								 			(** integers [int] *)
  | TBool                  							  				(** booleans [bool] *)
  | TChar           								 							(** chars    [char] *)
  (* How do functions work? A function is encoded as a conapp of TArrow 
     where the TArrow's gtype is the return type and the gtype list 
     associated with the conapp is the types of the arguments *)
  | TArrow of gtype           										(** Function type [s -> t] *)
  (* | TTree of gtype * gscheme * gscheme       	(** Trees *) *)
and tyvar =
	| TVar of int          (** parameter *)
and conapp = (tycon * gtype list)

type tyscheme = (tyvar list * gtype)