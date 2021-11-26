open Core
(** Main entry point for our application. *)

(* let () = print_endline @@ K98.greet "World" *)
(* let () = print_endline @@ K98.JQ.get_token "15011272962" "u123456A" *)

let print_df df = Owl_pretty.pp_dataframe Format.std_formatter df

let code = "002407.sz"

let () =
  let open Or_error.Monad_infix in
  let data =
    K98.JQ.get_token "15011272962" "u123456A" >>= fun token ->
    K98.JQ.get_price token code 10 "1d" "20211126" >>| fun df -> print_df df
  in
  match data with
  | Ok _ -> print_endline "ok"
  | Error e -> Owl.Log.error "%s" @@ Error.to_string_hum e
