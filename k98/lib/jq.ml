open Core

let jqapi_uri = Uri.of_string "https://dataapi.joinquant.com/apis"

let err_check str = String.is_prefix str ~prefix:"error:"

(* exception JQExn of string let get_data req = let open Async in let open
   Cohttp in let open Cohttp_async in Thread_safe.block_on_async_exn (fun () ->
   let req_body = Body.of_string req in Client.post ~body:req_body jqapi_uri >>=
   fun (resp, body) -> let code = resp |> Response.status |> Code.code_of_status
   in match code with | 200 -> Body.to_string body >>| fun body -> (*
   Owl.Log.info "body: %s" body; *) if err_check body then ( Owl.Log.error "jq
   error: %s" body; raise (JQExn body)) else body | _ -> raise (JQExn (sprintf
   "response code: %d" code))) *)

let get_data req =
  let open Async in
  let open Cohttp in
  let open Cohttp_async in
  Thread_safe.block_on_async_exn (fun () ->
      let req_body = Body.of_string req in
      Client.post ~body:req_body jqapi_uri >>= fun (resp, body) ->
      let code = resp |> Response.status |> Code.code_of_status in
      match code with
      | 200 ->
          Body.to_string body >>| fun body ->
          if err_check body then Or_error.error_string body
          else Or_error.return body
      | _ ->
          Deferred.return @@ Or_error.error_string
          @@ sprintf "response code: %d" code)

let get_dataframe req =
  let open Or_error.Monad_infix in
  get_data req >>= fun data -> Or_error.return @@ Owl.Dataframe.of_csv_str data

let get_token username password =
  Format.sprintf {|{"method":"get_token","mob":"%s","pwd":"%s"}|} username
    password
  |> get_data

let get_security_info token code =
  Format.sprintf {|{"method":"get_security_info","token":"%s","code":"%s"}|}
    token code
  |> get_dataframe

let get_price token code count date_unit end_date =
  Format.sprintf
    {|{"method": "get_price","token": "%s","code": "%s","count": %d,"unit": "%s","end_date": "%s"}|}
    token code count date_unit end_date
  |> get_dataframe

(* begin_date,end_date : 2018-12-04 09:45:00 *)
let get_price_period token code date_unit begin_date end_date =
  Format.sprintf
    {|{"method":"get_price_period","token":"%s","code":"%s","unit":"%s","date":"%s","end_date":"%s"}|}
    token code date_unit begin_date end_date
  |> get_dataframe

let get_current_price token code =
  Format.sprintf {|{"method":"get_current_price","token":"%s","code":"%s"}|}
    token code
  |> get_dataframe

let get_fq_factor token code fq begin_date end_date =
  Format.sprintf
    {|{"method":"get_fq_factor","token":"%s","code":"%s","fq":"%s","date":"%s","end_date":"%s"}|}
    token code fq begin_date end_date
  |> get_dataframe

let get_pause_stocks token date =
  Format.sprintf {|{"method":"get_pause_stocks","token":"%s","date":"%s"}|}
    token date
  |> get_dataframe

let get_call_auction token code begin_date end_date =
  Format.sprintf
    {|{"method":"get_call_auction","token":"%s","code":"%s","date":"%s","end_date":"%s"}|}
    token code begin_date end_date
  |> get_dataframe

let get_ticks token code count end_date =
  Format.sprintf
    {|{"method":"get_ticks","token":"%s","code":"%s","count":%d,"end_date":"%s"}|}
    token code count end_date
  |> get_dataframe

let get_ticks_period token code begin_date end_date =
  Format.sprintf
    {|{"method":"get_ticks_period","token":"%s","code":"%s","date":"%s","end_date":"%s"}|}
    token code begin_date end_date
  |> get_dataframe
