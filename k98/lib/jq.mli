(* open Owl *)

val get_token: string -> string -> string
val get_token_or_erorr : string -> string -> string Core_kernel.Or_error.t
(** param: username password*)

val get_security_info: string -> string -> Owl_dataframe.t
val get_security_info_or_erorr : string -> string -> (Owl_dataframe.t, Base.Error.t) result
(** param: token code*)

val get_price: string -> string -> int -> string -> string -> Owl_dataframe.t
val get_price_or_erorr : string -> string -> int -> string -> string -> (Owl_dataframe.t, Base.Error.t) result
(** param: token code count date_unit end_date*)

val get_price_period: string -> string -> string -> string -> string -> Owl_dataframe.t
val get_price_period_or_erorr: string -> string -> string -> string -> string -> (Owl_dataframe.t, Base.Error.t) result
(** param: token code date_unit begin_date end_date*)

val get_current_price: string -> string -> Owl_dataframe.t
val get_current_price_or_erorr: string -> string -> (Owl_dataframe.t, Base.Error.t) result
(** param: token code*)

val get_fq_factor: string -> string -> string -> string -> string -> Owl_dataframe.t
val get_fq_factor_or_erorr : string -> string -> string -> string -> string -> (Owl_dataframe.t, Base.Error.t) result
(** param: token code fq begin_date end_date*)

val get_pause_stocks: string -> string -> Owl_dataframe.t
val get_pause_stocks_or_erorr : string -> string -> (Owl_dataframe.t, Base.Error.t) result
(** param: token date*)

val get_call_auction: string -> string -> string -> string -> Owl_dataframe.t
val get_call_auction_or_erorr : string -> string -> string -> string -> (Owl_dataframe.t, Base.Error.t) result
(** param: token code begin_date end_date*)

val get_ticks: string -> string -> int -> string -> Owl_dataframe.t
val get_ticks_or_erorr : string -> string -> int -> string -> (Owl_dataframe.t, Base.Error.t) result
(**param: token code count end_date *)

val get_ticks_period: string -> string -> string -> string -> Owl_dataframe.t
val get_ticks_period_or_erorr : string -> string -> string -> string -> (Owl_dataframe.t, Base.Error.t) result
(** param: token code begin_date end_date*)
