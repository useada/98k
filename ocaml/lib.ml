
-- 同步使用Async
let get_token username password =
  Thread_safe.block_on_async_exn (fun () ->
      let%bind token = JQData.get_token "15011272962" "u123456A" in
      print_endline @@ "hi" ^ token;
      Writer.flushed (force Writer.stdout);token
return token
    );;


-- cohttp
let code = resp |> Response.status |> Code.code_of_status in
print_endline @@ "Response code: %d\n" ^ (string_of_int code);
Printf.printf "Headers: %s\n" (resp |> Response.headers |> Header.to_string);
