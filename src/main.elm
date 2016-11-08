module Main exposing (..)

import WorkPlans exposing (..)
import Html.App as Html
import Dict exposing (..)


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
        CompleteAssignment workId assignmentId isComplete ->
            let
                work =
                    getWorkById model workId

                -- todo map over work's assignments
                updatedAssignment =
                    Maybe.map (\ass -> { ass | complete = isComplete }) assignment

                --complete title postID post =
                --    if post.id == postID then
                --        { post | title = title }
                --    else
                --        post
                --Maybe.map (setTitleAtID title postID) model.posts , Effects.none
            in
                -- todo change this none to a Save
                ( model, Cmd.none )


subscriptions : Plan -> Sub Msg
subscriptions model =
    Sub.none



-- update helpers


getWorkById : Plan -> String -> Maybe Work
getWorkById model id =
    List.head
        (List.filter (\work -> work.id == id) model.work)
