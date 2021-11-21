let jqapi_uri = Uri.of_string "https://dataapi.joinquant.com/apis"

let get_data req =
  let open Async in
  (* let open Cohttp in *)
  Thread_safe.block_on_async_exn (fun () ->
      let req_body = Cohttp_async.Body.of_string req in
      try_with (fun () ->
          Cohttp_async.Client.post ~body:req_body jqapi_uri
          >>= fun (resp, body) ->
          resp |> ignore;
          Cohttp_async.Body.to_string body >>| fun body -> body)
      >>| function
      | Ok data -> data
      | Error _exn ->
          Owl.Log.warn "%s" @@ Printexc.to_string _exn;
          ""
      (* | Error _ -> "" *))

let get_token username password =
  Format.sprintf {|{"method":"get_token","mob":"%s","pwd":"%s"}|} username
    password
  |> get_data

let get_security_info token code =
  Format.sprintf {|{"method":"get_security_info","token":"%s","code":"%s"}|}
    token code
  |> get_data |> Owl.Dataframe.of_csv_str

let get_price token code count date_unit end_date =
  let req =
    Format.sprintf
      {|{"method": "get_price","token": "%s","code": "%s","count": %d,"unit": "%s","end_date": "%s"}|}
      token code count date_unit end_date
  in
  (* get_data req |> DataframeUtils.of_csv_str;; *)
  get_data req |> Owl.Dataframe.of_csv_str

(* begin_date,end_date : 2018-12-04 09:45:00 *)
let get_price_period token code date_unit begin_date end_date =
  let req =
    Format.sprintf
      {|{"method":"get_price_period","token":"%s","code":"%s","unit":"%s","date":"%s","end_date":"%s"}|}
      token code date_unit begin_date end_date
  in
  get_data req |> Owl.Dataframe.of_csv_str

let get_current_price token code =
  let req =
    Format.sprintf {|{"method":"get_current_price","token":"%s","code":"%s"}|}
      token code
  in
  get_data req |> Owl.Dataframe.of_csv_str

let get_fq_factor token code fq begin_date end_date =
  let req =
    Format.sprintf
      {|{"method":"get_fq_factor","token":"%s","code":"%s","fq":"%s","date":"%s","end_date":"%s"}|}
      token code fq begin_date end_date
  in
  get_data req |> Owl.Dataframe.of_csv_str

let get_pause_stocks token date =
  let req =
    Format.sprintf {|{"method":"get_pause_stocks","token":"%s","date":"%s"}|}
      token date
  in
  get_data req |> Owl.Dataframe.of_csv_str

let get_call_auction token code begin_date end_date =
  let req =
    Format.sprintf
      {|{"method":"get_call_auction","token":"%s","code":"%s","date":"%s","end_date":"%s"}|}
      token code begin_date end_date
  in
  get_data req |> Owl.Dataframe.of_csv_str

let get_ticks token code count end_date =
  let req =
    Format.sprintf
      {|{"method":"get_ticks","token":"%s","code":"%s","count":%d,"end_date":"%s"}|}
      token code count end_date
  in
  get_data req |> Owl.Dataframe.of_csv_str

let get_ticks_period token code begin_date end_date =
  let req =
    Format.sprintf
      {|{"method":"get_ticks_period","token":"%s","code":"%s","date":"%s","end_date":"%s"}|}
      token code begin_date end_date
  in
  get_data req |> Owl.Dataframe.of_csv_str
