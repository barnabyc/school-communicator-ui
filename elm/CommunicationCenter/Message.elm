module CommunicationCenter.Message exposing (Message)

import CommunicationCenter.Metadata exposing (Metadata)
import CommunicationCenter.ReadReceipt exposing (ReadReceipt)
import CommunicationCenter.Attachment exposing (Attachment)


type alias Message =
    { uuid : String
    , subject : String
    , body : String
    , attachments : List Attachment
    , replies : List String
    , meta : Metadata
    }
