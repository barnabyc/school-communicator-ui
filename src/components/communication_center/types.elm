module Types exposing (..)

import Date
import Http

type Msg
  = Fetch
  | FetchSucceed (List Message)
  | FetchFail Http.Error
  | Post --String
  | PostSucceed (List Message)
  | PostFail Http.Error
  --| BodyChange String

type alias Model =
  { messages : List Message
  , user : User }

type alias Message =
  { subject : String
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
