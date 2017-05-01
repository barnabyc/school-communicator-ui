module CommunicationCenter.ReadReceipt exposing (ReadReceipt)

import CommunicationCenter.User exposing (User)
import Date exposing (Date)


type alias ReadReceipt =
    { author : User
    , created : Date
    }
