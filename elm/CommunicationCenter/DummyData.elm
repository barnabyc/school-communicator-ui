module CommunicationCenter.DummyData exposing (..)

import CommunicationCenter.Message exposing (Message)
import CommunicationCenter.User exposing (User)
import Date


-- DUMMY DATA


dummyUser : User
dummyUser =
    User "f8b3541ae8c0439cb31100ad49c4673f" "Johnny Chow"


dummyMessage : Message
dummyMessage =
    { uuid = "xyz321cba987"
    , subject = "Birthdays"
    , body = "It's my birthday!"
    , attachments =
        []
    , replies =
        [ "abc" ]
        --, replies =
        --    Just
        --        ([ "abc" ])
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
    { uuid = "abc"
    , subject = ""
    , body = "Happy Birthday, Mom!"
    , attachments =
        []
        --, replies = Nothing
    , replies = []
    , meta =
        { readReceipts = []
        , author = User "987zyx654wvu" "Bibs"
        , recipients = []
        , created = Date.fromTime 1468125229591
        , updated = Nothing
        }
    }
