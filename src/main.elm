module Main exposing (..)

import WorkPlans exposing (..)
import Html.App as Html


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Plan, Cmd WorkPlans.Msg )
init =
    ( model, Cmd.none )


model : Plan
model =
    dummyPlan


update : Msg -> Plan -> ( Plan, Cmd Msg )
update msg model =
    case msg of
        Fetch ->
            ( model, Cmd.none )

        FetchSucceed ->
            ( model, Cmd.none )

        FetchFail ->
            ( model, Cmd.none )

        Manage ->
            ( model, Cmd.none )


subscriptions : Plan -> Sub Msg
subscriptions model =
    Sub.none
