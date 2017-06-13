module CommunicationCenter exposing (..)

import Http
import Date exposing (Date)
import Debug exposing (log)
import Html exposing (Html, ul, ol, li, header, span, div, input, button, section, text)
import Html.Attributes exposing (id, class, placeholder, classList, type_)
import Html.Events exposing (onClick)
import AuthenticatedHttp exposing (get, post)
import CommunicationCenter.Message exposing (Message)
import CommunicationCenter.User exposing (User)
import CommunicationCenter.MessagesDecoder exposing (decodeMessages)
import CommunicationCenter.DummyData as DummyData


type alias Model =
    { messages : List Message
    , user : User
    }


type Msg
    = Fetch
    | FetchMessages (Result Http.Error (List Message))
    | Post
    | PostMessage (Result Http.Error (List Message))


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


dummyModel : Model
dummyModel =
    Model [ DummyData.dummyMessage, DummyData.dummyMessage, DummyData.dummyMessage ] DummyData.dummyUser


model : Model
model =
    dummyModel



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Fetch ->
            ( model, getMessages )

        Post ->
            ( model, postMessage "foo" )

        FetchMessages (Err err) ->
            --( { model | inquiries = Just [] }, Cmd.none )
            log (toString err)
                ( model, Cmd.none )

        FetchMessages (Ok messages) ->
            --( { model | inquiries = Just inquiries }, Cmd.none )
            ( model, Cmd.none )

        PostMessage (Err err) ->
            log (toString err)
                ( model, Cmd.none )

        PostMessage (Ok message) ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- HTTP


getMessages : Cmd Msg
getMessages =
    get
        "fake-get-token-lalala"
        "/v1/messages"
        FetchMessages
        decodeMessages


postMessage : String -> Cmd Msg
postMessage body =
    post
        "fake-post-token-lalala"
        "/v1/message"
        """{ "body": "foo" }"""
        PostMessage
        decodeMessages



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ class "communication-center wrapper" ]
        [ section
            [ id "content" ]
            [ button [ onClick Fetch ] [ text "Fetch" ]
            , messageList model.messages
            , messageEntry
            ]
        ]


messageList : List Message -> Html Msg
messageList messages =
    --let
    --  weeksOfMessages = groupWhile (\x y -> snd (isoWeek x.meta.created) == snd (isoWeek y.meta.created)) messages
    --in
    ol
        [ class "messages" ]
        --(List.map messageView weeksOfMessages)
        (List.map messageView messages)


messageView : Message -> Html Msg
messageView message =
    li
        [ classList [ ( "unread", True ), ( "message", True ) ] ]
        -- todo: unread should be a message property
        [ header []
            [ span [ class "author" ]
                [ text message.meta.author.name ]
            , span []
                [ text " wrote on " ]
            , span [ class "created" ]
                [ text (formatDate message.meta.created) ]
            , span []
                [ text " to " ]
            , ul [ class "recipients" ]
                (formatRecipients messageRecipient message.meta.recipients)
            , div [ class "body" ]
                [ text message.body ]
            ]
        , ol [ class "replies" ]
            (formatReplies repliesView message.replies)
        ]


repliesView : String -> Html Msg
repliesView uuid =
    li [] [ span [] [ text uuid ] ]


messageRecipient : User -> Html Msg
messageRecipient recipient =
    li
        [ class "recipient" ]
        [ text recipient.name ]


messageEntry : Html Msg
messageEntry =
    div
        [ class "message-entry" ]
        [ input [ type_ "text", placeholder "Something to say?" ] []
        , button [ onClick Post ] [ text "Post" ]
        ]



-- formatters


formatDate : Date -> String
formatDate date =
    let
        year =
            toString (Date.year date)

        month =
            toString (Date.month date)

        day =
            toString (Date.day date)

        hour =
            toString (Date.hour date)

        minute =
            toString (Date.minute date)

        time =
            hour ++ ":" ++ minute
    in
        month ++ "/" ++ day ++ "/" ++ year ++ " at " ++ time


formatRecipients : (User -> Html Msg) -> List User -> List (Html Msg)
formatRecipients messageRecipient recipients =
    let
        count =
            List.length recipients
    in
        if count == 0 then
            [ messageRecipient (User "" "everyone") ]
        else
            (List.map messageRecipient recipients)


formatReplies : (String -> Html Msg) -> List String -> List (Html Msg)
formatReplies repliesView replies =
    List.map repliesView replies



-- main


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
