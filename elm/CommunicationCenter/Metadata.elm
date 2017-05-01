module CommunicationCenter.Metadata exposing (Metadata)

import CommunicationCenter.ReadReceipt exposing (ReadReceipt)
import CommunicationCenter.User exposing (User)
import Date exposing (Date)


type alias Metadata =
    { readReceipts : List ReadReceipt
    , author : User
    , recipients : List User
    , created : Date
    , updated : Maybe Date
    }
