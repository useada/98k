open Core
open Async
open Cohttp
open Cohttp_async

let base_url = "https://xtrade.newone.com.cn"

let get_user_info_uri = Uri.of_string @@ base_url ^ "/capi/getUserInfo"

let cookies_str = ""

let headers = [ ("Cookie", cookies_str); ("Referer", base_url) ]

let get_headers () = Header.add_list (Header.init ()) headers

let get_data req =
  Thread_safe.block_on_async_exn (fun () ->
      let headers = get_headers () in
      let req_body = Body.of_string req in
      Client.post ~headers ~body:req_body get_user_info_uri
      >>= fun (resp, body) ->
      let code = resp |> Response.status |> Code.code_of_status in
      match code with
      | 200 -> Body.to_string body >>| fun body -> Or_error.return body
      | _ ->
          Deferred.return @@ Or_error.error_string
          @@ sprintf "response code: %d" code)

(* let get_user_info = Format.sprintf
   {|{"method":"get_token","mob":"%s","pwd":"%s"}|} username password |>
   get_data *)
