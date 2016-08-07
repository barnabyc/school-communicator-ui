module Formatters exposing (..)

import Types exposing (Model, Message, Replies, User, Msg)

import Html exposing (..)
import Date

formatDate : Date.Date -> String
formatDate date =
  let
    year = toString (Date.year date)
    month = toString (Date.month date)
    day = toString (Date.day date)

    hour = toString (Date.hour date)
    minute = toString (Date.minute date)

    time = hour ++ ":" ++ minute
  in
    month ++ "/" ++ day ++ "/" ++ year ++ " at " ++ time

formatRecipients : (User -> Html Msg) -> List User -> List (Html Msg)
formatRecipients messageRecipient recipients =
  let
    count = List.length recipients
  in
    if
      count == 0
    then
      [ messageRecipient (User "" "everyone") ]
    else
      (List.map messageRecipient recipients)

formatReplies : (Message -> Html Msg) -> Replies -> List (Html Msg)
formatReplies messageView (Types.Replies replies) =
  List.map messageView replies


