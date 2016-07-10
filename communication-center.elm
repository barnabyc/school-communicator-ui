import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Date

main =
  Html.beginnerProgram
    { model = model
    , view = view
    , update = update
    }

-- DUMMY DATA

dummyModel : Model
dummyModel =
  Model [ dummyMessage ] user

dummyMessage : Message
dummyMessage =
  { subject = "Birthdays"
  , body = "It's my birthday!"
  , attachments = []
  , replies = Just (Replies [ dummyReply ])
  , meta =
    { readReceipts = []
    , author = User "123abc456def" "Admin"
    , recipients = []
    , created = Date.fromTime 1468124885089
    , updated = Nothing
    }
  }

dummyReply : Message
dummyReply =
  { subject = ""
  , body = "Happy Birthday, Mom!"
  , attachments = []
  , replies = Nothing
  , meta =
    { readReceipts = []
    , author = User "987zyx654wvu" "Bibs"
    , recipients = []
    , created = Date.fromTime 1468125229591
    , updated = Nothing
    }
  }

-- MODEL

model : Model
model =
  dummyModel

user : User
user =
  User "" ""

type alias Model =
  { messages : List Message
  , user : User }

type alias Message =
  { subject : String
  , body : String
  , attachments : List Attachment
  , replies : Maybe Replies
  , meta : Metadata }

type Replies = Replies (List Message)

type alias Metadata =
  { readReceipts : List ReadReceipt
  , author : User
  , recipients : List User
  , created : Date.Date
  , updated : Maybe Date.Date }

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


-- UPDATE

type Msg
    = NoOp
    | UpdateField String
    | UpdateMessage Int String
    | Add
    | Delete Int
    | DeleteComplete
    | Read Int Bool
    | ReadAll Bool

-- todo: have this actually do something
update msg model =
  model

-- VIEW

view : Model -> Html Msg
view model =
  div
    [ class "communication-center wrapper" ]
    [ section
        [ id "content" ]
        [ messageList model.messages
        , messageEntry
        ]
    ]

messageList : List Message -> Html Msg
messageList messages =
  ol
    [ class "messages" ]
    (List.map messageView messages)

messageView : Message -> Html Msg
messageView message =
  li
    [ classList [ ("unread", True), ("message", True)]] -- todo: unread should be a message property
    [ header []
      [ span
        [ class "author" ]
        [ text message.meta.author.name ]
      , span
        []
        [ text " wrote on " ]
      , span
        [ class "created" ]
        [ text (formatDate message.meta.created) ]
      , span
        []
        [ text " to " ]
      , ul
        [ class "recipients" ]
        (formatRecipients message.meta.recipients)
      , div
        [ class "body" ]
        [ text message.body ]
      ]
    ]

messageRecipient : User -> Html Msg
messageRecipient recipient =
  li
    [ class "recipient" ]
    [ text recipient.name ]

messageEntry : Html msg
messageEntry =
  div
    [ class "message-entry" ]
    [ text "New message here"
    , input
      [ type' "text"
      , placeholder "Something to say?"
      ]
      []
    ]

-- FORMATTERS

formatDate : Date.Date -> String
formatDate date =
  let
    year = toString (Date.year date)
    month = toString (Date.month date)
    day = toString (Date.day date)
  in
    month ++ "/" ++ day ++ "/" ++ year

formatRecipients : List User -> List (Html Msg)
formatRecipients recipients =
  let
    count = List.length recipients
  in
    if
      count == 0
    then
      [ messageRecipient (User "" "everyone") ]
    else
      (List.map messageRecipient recipients)



