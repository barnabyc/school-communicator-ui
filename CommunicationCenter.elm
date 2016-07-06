port module CommunicationCenter exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (lazy)
import Json.Decode exposing ((:=))
import Json.Encode
import String
import Date

main : Program (Maybe Model)
main =
  App.programWithFlags
    { init = init
    , view = view
    , update = update -- todo: understand this (\msg model -> sendToStorage (update msg model))
    , subscriptions = \_ -> Sub.none
    }


port storage : Json.Encode.Value -> Cmd msg

sendToStorage : Model -> Cmd Msg
sendToStorage model =
  encodeJson model |> storage


-- MODEL
type alias Model =
  { messages : List Message
  , user : User }

type alias Message =
  { subject : String
--  , source : String
--  , assignment : String
  , body : String
  , attachments : List Attachment
  , replies : Replies
  , meta : Metadata }

type Replies = Replies (List Message)

type alias Metadata =
  { readReceipts : List ReadReceipt
  , author : User
  , recipients : List User
  , created : Date.Date
  , updated : Date.Date }

type alias ReadReceipt =
  { author : User
  , created : Date.Date }

type alias Attachment =
  { image : Image
  , meta : Metadata }

type alias Image =
  { url : String
  , description : String }

type alias User =
  { uuid : String
  , name : String }

emptyModel : Model
emptyModel =
  { messages = []
    , user = { name = "", uuid = "" } -- todo: get the current user
   }

newMessage : String -> String -> User -> List User -> Message
newMessage subject body author recipients =
  { subject = subject
  , body = body
  , author = author
  , recipients = recipients
  }

init : Maybe Model -> ( Model, Cmd Msg )
init savedModel =
  Maybe.withDefault emptyModel savedModel ! []

encodeJson : Model -> Json.Encode.Value
encodeJson model =
  Json.Encode.object
    -- todo: enumerate rest of model

encodeReplies : Replies -> Json.Encode.Value
encodeReplies replies =
  Json.Encode.list
    (List.map (encodeMessage) (replies))

encodeMessage : Message -> Json.Encode.Value
encodeMessage message =
  Json.Encode.object
    [ ("subject", Json.Encode.string message.subject)
    , ("body", Json.Encode.string message.body)
    , ("replies", encodeReplies message.replies)
    , ("author", Json.Encode.string message.meta.author.name)
    -- todo: expand encoded fields
    ]

-- UPDATE

{-| Users of our app can trigger messages by clicking and typing. These
messages are fed into the `update` function as they occur, letting us react
to them.
-}
type Msg
    = NoOp
    | UpdateField String
    | UpdateMessage Int String
    | Add
    | Delete Int
    | DeleteComplete
    | Read Int Bool
    | ReadAll Bool

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    NoOp ->
      model ! []

    UpdateField str ->
      { model | field = str }
        ! []

-- VIEW

view : Model -> Html Msg
view model =
  div
    [ class "communication-center wrapper" ]
    [ section
        [ id "content" ]
        [ lazy messageList model.messages
        , messageEntry
        ]
    ]

messageList : List Message -> Html Msg
messageList messages =
  ol
    [ class "messages" ]
    (List.map (messageView) (messages))

messageView : Message -> Html Msg
messageView message =
  li
    [ classList [ ("unread", message.unread), ("message", True)]]
    [ header
      [ span
        [ class "author"
        , text message.meta.author.name ]
      , span
        [ text "wrote on" ]
      , span
        [ class "created"
        , text message.meta.created ] -- todo: date formatter
      , span
        [ text "to" ]
      , ul
        [ class "recipients" ]
        (List.map (messageRecipient) (message.meta.recipients))
      , div
        [ class "body"
        , text message.body ]
      ]
    ]

messageRecipient : List User -> Html Msg
messageRecipient recipient =
  li
    [ class "recipient" ]
    [ text recipient.name ]

messageEntry : Html msg
messageEntry =
  div
    [ class "message-entry"
    , text "New message here" ]

