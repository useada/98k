open Core

val get_token: string -> string -> string Or_error.t
(** param: username password*)

val get_security_info: string -> string -> Owl_dataframe.t Or_error.t
(** param: token code*)

val get_price: string -> string -> int -> string -> string -> Owl_dataframe.t Or_error.t
(** param: token code count date_unit end_date*)

val get_price_period: string -> string -> string -> string -> string -> Owl_dataframe.t Or_error.t
(** param: token code date_unit begin_date end_date*)

val get_current_price: string -> string -> Owl_dataframe.t Or_error.t
(** param: token code*)

val get_fq_factor: string -> string -> string -> string -> string -> Owl_dataframe.t Or_error.t
(** param: token code fq begin_date end_date*)

val get_pause_stocks: string -> string -> Owl_dataframe.t Or_error.t
(** param: token date*)

val get_call_auction: string -> string -> string -> string -> Owl_dataframe.t Or_error.t
(** param: token code begin_date end_date*)

val get_ticks: string -> string -> int -> string -> Owl_dataframe.t Or_error.t
(**param: token code count end_date *)

val get_ticks_period: string -> string -> string -> string -> Owl_dataframe.t Or_error.t
(** param: token code begin_date end_date*)
