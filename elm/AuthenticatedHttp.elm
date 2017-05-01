-- author: Simon Hojberg


module AuthenticatedHttp exposing (get, delete, post, put)

import Json.Decode as Json exposing (..)
import Http exposing (Error, header)


urlWithApiBaseUrl : String -> String
urlWithApiBaseUrl path =
    let
        baseUrl =
            --"https://api.athenaeumlearning.org"
            "http://localhost:8000"
    in
        baseUrl ++ path


request : String -> String -> String -> Http.Body -> (Result Error a -> msg) -> Json.Decoder a -> Cmd msg
request authToken verb url body handler decoder =
    Http.send handler
        (Http.request
            { method = verb
            , headers =
                [ (header "X-API-TOKEN" authToken)
                , (header "Content-Type" "application/json")
                , (header "Accept" "application/json")
                ]
            , url = urlWithApiBaseUrl url
            , expect = Http.expectJson decoder
            , body = body
            , timeout = Nothing
            , withCredentials = False
            }
        )


get : String -> String -> (Result Error a -> msg) -> Json.Decoder a -> Cmd msg
get authToken url handler decoder =
    request
        authToken
        "GET"
        url
        Http.emptyBody
        handler
        decoder


post : String -> String -> String -> (Result Error a -> msg) -> Json.Decoder a -> Cmd msg
post authToken url body handler decoder =
    request
        authToken
        "POST"
        url
        (Http.stringBody "" body)
        handler
        decoder


put : String -> String -> String -> (Result Error a -> msg) -> Json.Decoder a -> Cmd msg
put authToken url body handler decoder =
    request
        authToken
        "PUT"
        url
        (Http.stringBody "" body)
        handler
        decoder


delete : String -> String -> (Result Error a -> msg) -> Json.Decoder a -> Cmd msg
delete authToken url handler decoder =
    request
        authToken
        "DELETE"
        url
        Http.emptyBody
        handler
        decoder
