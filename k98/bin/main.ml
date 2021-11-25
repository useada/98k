(** Main entry point for our application. *)

(* let () = print_endline @@ K98.greet "World" *)


(* let () = print_endline @@ K98.JQ.get_token "15011272962" "u123456A" *)


(* let token = K98.JQ.get_token "15011272962" "u123456A" *)

let code = "002407.sz"

(* let ticks = K98.JQ.get_ticks token code 100 "2021/11/23 00:00:00" *)


(* let () = *)
open Core.Result.Let_syntax;;

let%bind token = K98.JQ.get_token "15011272962" "u123456A" in
let ticks = K98.JQ.get_ticks token code 100 "2021/11/23 00:00:00" in
print_endline token;
match ticks with
| Ok df -> Owl_pretty.pp_dataframe Format.std_formatter df |> Core.Or_error.return
| Error e -> print_endline e |> Core.Or_error.return
(* print_endline token |> Core.Or_error.return *)


(* let () = match  ticks with
| Ok df-> Owl_pretty.pp_dataframe Format.std_formatter df
| Error e -> print_endline e *)

(* let () = Owl_pretty.pp_dataframe Format.std_formatter ticks *)

