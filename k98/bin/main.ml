open Core
(** Main entry point for our application. *)

(* let () = print_endline @@ K98.greet "World" *)
(* let () = print_endline @@ K98.JQ.get_token "15011272962" "u123456A" *)

let print_df df = Owl_pretty.pp_dataframe Format.std_formatter df

let code = "600000.XSHG"

let test df = 
  let open Owl.Dataframe in
  print_df df;
  df.%(0, "date") |> unpack_string |> print_endline

let () =
  let open Or_error.Monad_infix in
  let data =
    K98.JQ.get_token "15011272962" "u123456A" >>= fun token ->
    K98.JQ.get_price token code 20 "1d" "2021-11-26" >>| fun df -> 
      test df
  in
  match data with
  | Ok _ -> print_endline "----------------end---------------"
  | Error e -> Owl.Log.error "%s" @@ Error.to_string_hum e
