module CommunicationCenter.MessagesDecoder exposing (decodeMessages)

import CommunicationCenter.Message exposing (Message)
import CommunicationCenter.User exposing (User)
import CommunicationCenter.Metadata exposing (Metadata)
import CommunicationCenter.ReadReceipt exposing (ReadReceipt)
import CommunicationCenter.Attachment exposing (Attachment)
import CommunicationCenter.Image exposing (Image)
import Json.Decode as Json
import Json.Decode.Extra as JsonExtra


-- todo: replace (:=) with `field` in 0.18 and removing Json.Helpers

import Json.Helpers exposing ((:=))


decodeUser : Json.Decoder User
decodeUser =
    Json.map2
        User
        ("uuid" := Json.string)
        ("name" := Json.string)


decodeReadreceipts : Json.Decoder (List ReadReceipt)
decodeReadreceipts =
    Json.list
        (Json.map2
            ReadReceipt
            ("author" := decodeUser)
            ("created" := JsonExtra.date)
        )


decodeRecipients : Json.Decoder (List User)
decodeRecipients =
    Json.list decodeUser


decodeMetadata : Json.Decoder Metadata
decodeMetadata =
    Json.map5
        Metadata
        ("readReceipts" := decodeReadreceipts)
        ("author" := decodeUser)
        ("recipients" := decodeRecipients)
        ("created" := JsonExtra.date)
        (Json.maybe ("updated" := JsonExtra.date))


decodeImage : Json.Decoder Image
decodeImage =
    Json.map2
        Image
        ("url" := Json.string)
        ("description" := Json.string)


decodeMessages : Json.Decoder (List Message)
decodeMessages =
    Json.list
        (Json.map6
            Message
            ("uuid" := Json.string)
            ("subject" := Json.string)
            ("body" := Json.string)
            ("attachments"
                := Json.list
                    (Json.map2
                        Attachment
                        ("image" := decodeImage)
                        ("meta" := decodeMetadata)
                    )
            )
            ("replies" := Json.list Json.string)
            ("meta" := decodeMetadata)
        )
