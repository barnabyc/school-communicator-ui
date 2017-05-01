module CommunicationCenter.Attachment exposing (Attachment)

import CommunicationCenter.Metadata exposing (Metadata)
import CommunicationCenter.Image exposing (Image)


type alias Attachment =
    { image : Image
    , meta : Metadata
    }
