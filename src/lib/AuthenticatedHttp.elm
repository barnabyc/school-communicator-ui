-- Author: Simon Hojberg

module AuthenticatedHttp exposing (get, delete, post, put)

import Json.Decode as Json exposing (..)
import Http
import Task

authTokenHeader : String -> (String, String)
authTokenHeader token = ("X-API-TOKEN", token)

urlWithApiBaseUrl : String -> String
urlWithApiBaseUrl path =
  let
    baseUrl =
      "http://localhost:5000"
  in
    baseUrl ++ path

request : String -> String -> String -> Http.Body -> (Http.Error -> msg) -> (b -> msg) -> Json.Decoder b -> Cmd msg
request authToken verb url body onFail onSuccess decoder =
  let
    request =
      { verb = verb
      , headers =
          [ (authTokenHeader authToken)
          , ("Content-Type", "application/json")
          , ("Accept", "application/json")
          ]
      , url = urlWithApiBaseUrl url
      , body = body
      }
  in
    Http.send Http.defaultSettings request
      |> Http.fromJson decoder
      |> Task.perform onFail onSuccess

get : String -> String -> (Http.Error -> msg) -> (b -> msg) -> Json.Decoder b -> Cmd msg
get authToken url onFail onSuccess decoder =
  request
    authToken
    "GET"
    url
    Http.empty
    onFail
    onSuccess
    decoder

post : String -> String -> String -> (Http.Error -> msg) -> (b -> msg) -> Json.Decoder b -> Cmd msg
post authToken url body onFail onSuccess decoder =
  request
    authToken
    "POST"
    url
    (Http.string body)
    onFail
    onSuccess
    decoder

put : String -> String -> String -> (Http.Error -> msg) -> (b -> msg) -> Json.Decoder b -> Cmd msg
put authToken url body onFail onSuccess decoder =
  request
    authToken
    "PUT"
    url
    (Http.string body)
    onFail
    onSuccess
    decoder

delete : String -> String -> (Http.Error -> msg) -> (b -> msg) -> Json.Decoder b -> Cmd msg
delete authToken url onFail onSuccess decoder =
  request
    authToken
    "DELETE"
    url
    Http.empty
    onFail
    onSuccess
    decoder
