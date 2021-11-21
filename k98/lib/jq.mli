open Owl

val get_token : string -> string -> string

val get_security_info : string -> string -> Dataframe.t

val get_price : string -> string -> int -> string -> string -> Dataframe.t

val get_price_period: string -> string -> string -> string -> string -> Owl_dataframe.t

val get_current_price: string -> string -> Owl_dataframe.t

val get_fq_factor : string -> string -> string -> string -> string -> Owl_dataframe.t

val get_pause_stocks : string -> string -> Owl_dataframe.t

val get_call_auction : string -> string -> string -> string -> Owl_dataframe.t

val get_ticks : string -> string -> int -> string -> Owl_dataframe.t

val get_ticks_period : string -> string -> string -> string -> Owl_dataframe.t
