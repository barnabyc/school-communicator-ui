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

        -- todo restructure all this so it's actually usable...
        --Record { -- Plan
        --  List : [ -- Works
        --    Record { -- Work
        --      List : [ -- Assignments
        --        Record { -- Assignment
        --          Bool -- completed
        --        }
        --      ]
        --    }
        --  ]
        --}
        CompleteAssignment id isComplete ->
            let
                updateAssignment assignment =
                    if assignment.id == id then
                        { assignment | complete = isComplete }
                    else
                        assignment
            in
                { model | assignments = List.map updateAssignment model.assignments }
                    ! []


subscriptions : Plan -> Sub Msg
subscriptions model =
    Sub.none
