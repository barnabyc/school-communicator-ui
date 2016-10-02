module DummyData exposing (..)

import Date
import Types exposing (Model, Message, Replies, User, Msg)


-- DUMMY DATA


dummyUser : User
dummyUser =
    User "f8b3541ae8c0439cb31100ad49c4673f" "Johnny Chow"


dummyModel : Model
dummyModel =
    Model [ dummyMessage, dummyMessage, dummyMessage ] dummyUser


dummyMessage : Message
dummyMessage =
    { subject = "Birthdays"
    , body = "It's my birthday!"
    , attachments = []
    , replies = Types.Replies [ dummyReply, dummyReply, dummyReply ]
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
    , replies = Types.Replies []
    , meta =
        { readReceipts = []
        , author = User "987zyx654wvu" "Bibs"
        , recipients = []
        , created = Date.fromTime 1468125229591
        , updated = Nothing
        }
    }
