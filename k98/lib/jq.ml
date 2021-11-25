let jqapi_uri = Uri.of_string "https://dataapi.joinquant.com/apis"

exception JQExn of string

let err_check str =
  let n = String.length str in
  if n < 6 || String.sub str 0 6 == "error:" then true else false

let get_data req =
  let open Core in
  let open Async in
  let open Cohttp in
  let open Cohttp_async in
  Thread_safe.block_on_async_exn (fun () ->
      let req_body = Body.of_string req in
      try_with (fun () ->
          Client.post ~body:req_body jqapi_uri >>= fun (resp, body) ->
          (* resp |> ignore; *)
          let code = resp |> Response.status |> Code.code_of_status in
          match code with
          | 200 ->
              Body.to_string body >>| fun body ->
              if err_check body then raise (JQExn body) else body
          | _ -> raise (JQExn (sprintf "response code: %d" code)))
      >>| function
      | Ok data -> data
      | Error _exn ->
          let msg = Exn.to_string _exn in
          Owl.Log.error "call jq api error: %s" msg;
          failwith msg)

let get_data_or_erorr req =
  (* let open Printf in *)
  let open Core in
  let open Async in
  let open Cohttp in
  let open Cohttp_async in
  Thread_safe.block_on_async_exn (fun () ->
      let req_body = Body.of_string req in
      try_with (fun () ->
          Client.post ~body:req_body jqapi_uri >>= fun (resp, body) ->
          (* resp |> ignore; *)
          let code = resp |> Response.status |> Code.code_of_status in
          match code with
          | 200 ->
              Body.to_string body >>| fun body ->
              if err_check body then raise (JQExn body) else body
          | _ -> raise (JQExn (sprintf "response code: %d" code)))
      >>| fun x -> Or_error.of_exn_result x)
(* >>| function | Ok data -> Ok data | Error _exn -> Error "error") *)

let get_dataframe_or_erorr req =
  let data = get_data_or_erorr req in
  match data with
  | Ok data -> Ok (Owl.Dataframe.of_csv_str data)
  | Error e -> Error e

let get_token_or_erorr username password =
  Format.sprintf {|{"method":"get_token","mob":"%s","pwd":"%s"}|} username
    password
  |> get_data_or_erorr

let get_security_info_or_erorr token code =
  Format.sprintf {|{"method":"get_security_info","token":"%s","code":"%s"}|}
    token code
  |> get_dataframe_or_erorr

let get_price_or_erorr token code count date_unit end_date =
  Format.sprintf
    {|{"method": "get_price","token": "%s","code": "%s","count": %d,"unit": "%s","end_date": "%s"}|}
    token code count date_unit end_date
  |> get_dataframe_or_erorr

(* begin_date,end_date : 2018-12-04 09:45:00 *)
let get_price_period_or_erorr token code date_unit begin_date end_date =
  Format.sprintf
    {|{"method":"get_price_period","token":"%s","code":"%s","unit":"%s","date":"%s","end_date":"%s"}|}
    token code date_unit begin_date end_date
  |> get_dataframe_or_erorr

let get_current_price_or_erorr token code =
  Format.sprintf {|{"method":"get_current_price","token":"%s","code":"%s"}|}
    token code
  |> get_dataframe_or_erorr

let get_fq_factor_or_erorr token code fq begin_date end_date =
  Format.sprintf
    {|{"method":"get_fq_factor","token":"%s","code":"%s","fq":"%s","date":"%s","end_date":"%s"}|}
    token code fq begin_date end_date
  |> get_dataframe_or_erorr

let get_pause_stocks_or_erorr token date =
  Format.sprintf {|{"method":"get_pause_stocks","token":"%s","date":"%s"}|}
    token date
  |> get_dataframe_or_erorr

let get_call_auction_or_erorr token code begin_date end_date =
  Format.sprintf
    {|{"method":"get_call_auction","token":"%s","code":"%s","date":"%s","end_date":"%s"}|}
    token code begin_date end_date
  |> get_dataframe_or_erorr

let get_ticks_or_erorr token code count end_date =
  Format.sprintf
    {|{"method":"get_ticks","token":"%s","code":"%s","count":%d,"end_date":"%s"}|}
    token code count end_date
  |> get_dataframe_or_erorr

let get_ticks_period_or_erorr token code begin_date end_date =
  Format.sprintf
    {|{"method":"get_ticks_period","token":"%s","code":"%s","date":"%s","end_date":"%s"}|}
    token code begin_date end_date
  |> get_dataframe_or_erorr
