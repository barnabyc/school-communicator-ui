module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Date

import AuthenticatedHttp exposing (get, post)
import Json.Decode as Json exposing ((:=))
import Json.Decode.Extra as JsonExtra

import Types exposing (Model, Message, Replies, User, Msg(..), Metadata, ReadReceipt, Attachment, Image)
import Formatters exposing (formatDate, formatRecipients, formatReplies)
import DummyData exposing (dummyModel, dummyMessage, dummyReply)

--import Date.Extra.Create exposing ( dateFromFields )
--import Date.Extra.Utils exposing ( isoWeek )
--import List.Extra exposing ( groupWhile )


main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

init : (Model, Cmd Msg)
init =
  (model, Cmd.none)

model : Model
model =
  dummyModel

-- UPDATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Fetch ->
      (model, getMessages)

    FetchSucceed messages ->
      (model, Cmd.none)

    FetchFail _ ->
      (model, Cmd.none)

    Post ->
      (model, postMessage "foo")

    PostSucceed messages ->
      (model, Cmd.none)

    PostFail _ ->
      (model, Cmd.none)

    --BodyChange body ->
    --  { foo | body = body }

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- HTTP


getMessages : Cmd Msg
getMessages =
  get
    "foo"
    "/v1/messages"
    FetchFail
    FetchSucceed
    decodeMessages

postMessage : String -> Cmd Msg
postMessage body =
  post
    "foo"
    "/v1/message"
    """{ "body": "foo" }""" -- todo: proper Json encode
    PostFail
    PostSucceed
    decodeMessages

decodeUser : Json.Decoder User
decodeUser =
  Json.object2
    User
      ("uuid" := Json.string)
      ("name" := Json.string)

decodeReplies : Json.Decoder Replies
decodeReplies =
  Json.object1
    Types.Replies decodeMessages

decodeReadreceipts : Json.Decoder (List ReadReceipt)
decodeReadreceipts =
  Json.list (
    Json.object2
      ReadReceipt
        ("author" := decodeUser)
        ("created" := JsonExtra.date)
  )

decodeRecipients : Json.Decoder (List User)
decodeRecipients =
  Json.list decodeUser

decodeMetadata : Json.Decoder Metadata
decodeMetadata =
  Json.object5
    Metadata
      ("readReceipts" := decodeReadreceipts )
      ("author" := decodeUser)
      ("recipients" := decodeRecipients )
      ("created" := JsonExtra.date)
      (Json.maybe ( "updated" := JsonExtra.date))

decodeImage : Json.Decoder Image
decodeImage =
  Json.object2
    Image
      ("url" := Json.string)
      ("description" := Json.string)

decodeMessages : Json.Decoder (List Message)
decodeMessages =
  Json.list (
    Json.object5
      Message
        ("subject" := Json.string)
        ("body" := Json.string)
        ("attachments" := Json.list (
          Json.object2
            Attachment
              ("image" := decodeImage)
              ("meta" := decodeMetadata)
          )
        )
        ("replies" := decodeReplies)
        ("meta" := decodeMetadata)
  )


-- VIEW

view : Model -> Html Msg
view model =
  div
    [ class "communication-center wrapper" ]
    [ section
        [ id "content" ]
        [ button [ onClick Fetch ] [ text "Fetch" ]
        , messageList model.messages
        , messageEntry
        ]
    ]

messageList : List Message -> Html Msg
messageList messages =
  --let
  --  weeksOfMessages = groupWhile (\x y -> snd (isoWeek x.meta.created) == snd (isoWeek y.meta.created)) messages
  --in
    ol
      [ class "messages" ]
      --(List.map messageView weeksOfMessages)
      (List.map messageView messages)

messageView : Message -> Html Msg
messageView message =
  li
    [ classList [ ("unread", True), ("message", True)]] -- todo: unread should be a message property
    [ header []
      [ span [ class "author" ]
        [ text message.meta.author.name ]
      , span []
        [ text " wrote on " ]
      , span [ class "created" ]
        [ text (formatDate message.meta.created) ]
      , span []
        [ text " to " ]
      , ul [ class "recipients" ]
        (formatRecipients messageRecipient message.meta.recipients)
      , div [ class "body" ]
        [ text message.body ]
      ]
    , ol [ class "replies" ]
      (formatReplies messageView message.replies)
    ]

messageRecipient : User -> Html Msg
messageRecipient recipient =
  li
    [ class "recipient" ]
    [ text recipient.name ]

messageEntry : Html Msg
messageEntry =
  div
    [ class "message-entry" ]
    [ input [ type' "text" , placeholder "Something to say?" ] []
    , button [ onClick Post ] [ text "Post" ]
    ]
