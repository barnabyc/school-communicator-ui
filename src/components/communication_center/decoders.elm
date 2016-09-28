module Decoders exposing (..)

import Types exposing (Message, Replies, User, Metadata, ReadReceipt, Attachment, Image)
import Json.Decode as Json exposing ((:=))
import Json.Decode.Extra as JsonExtra


decodeUser : Json.Decoder User
decodeUser =
    Json.object2
        User
        ("uuid" := Json.string)
        ("name" := Json.string)


decodeReplies : Json.Decoder Replies
decodeReplies =
    Json.object1
        Types.Replies
        decodeMessages


decodeReadreceipts : Json.Decoder (List ReadReceipt)
decodeReadreceipts =
    Json.list
        (Json.object2
            ReadReceipt
            ("author" := decodeUser)
            ("created" := JsonExtra.date)
        )


decodeRecipients : Json.Decoder (List User)
decodeRecipients =
    Json.list decodeUser


decodeMetadata : Json.Decoder Metadata
decodeMetadata =
    Json.object5
        Metadata
        ("readReceipts" := decodeReadreceipts)
        ("author" := decodeUser)
        ("recipients" := decodeRecipients)
        ("created" := JsonExtra.date)
        (Json.maybe ("updated" := JsonExtra.date))


decodeImage : Json.Decoder Image
decodeImage =
    Json.object2
        Image
        ("url" := Json.string)
        ("description" := Json.string)


decodeMessages : Json.Decoder (List Message)
decodeMessages =
    Json.list
        (Json.object5
            Message
            ("subject" := Json.string)
            ("body" := Json.string)
            ("attachments"
                := Json.list
                    (Json.object2
                        Attachment
                        ("image" := decodeImage)
                        ("meta" := decodeMetadata)
                    )
            )
            ("replies" := decodeReplies)
            ("meta" := decodeMetadata)
        )
