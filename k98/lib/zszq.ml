open Core


let base_url = "https://xtrade.newone.com.cn"
let get_user_info_url = base_url ^ "/capi/getUserInfo"
let get_user_info_uri = Uri.of_string get_user_info_url

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

(* let get_user_info =
  Format.sprintf {|{"method":"get_token","mob":"%s","pwd":"%s"}|} username
    password
  |> get_data *)
