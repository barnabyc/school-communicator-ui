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
        CompleteAssignment id isComplete ->
            let
                assignment =
                    getAssignmentById model id

                work =
                    getWorkByAssignment model.work assignment

                updatedAssignment =
                    Maybe.map (\ass -> { ass | complete = isComplete }) assignment

                --updatedWork =
                --    Maybe.map (\work -> { work | assignments = updatedAssignment :: assignments }) work
                -- todo update the work record too
            in
                -- todo change this none to a Save
                ( model, Cmd.none )


subscriptions : Plan -> Sub Msg
subscriptions model =
    Sub.none



-- update helpers


updateElement : List a -> a -> List a
updateElement list indexToFocusOn =
    let
        toggle index ( id, task ) =
            if index == indexToFocusOn then
                ( id, { task | focus = True } )
            else
                ( id, { task | focus = False } )
    in
        List.indexedMap toggle list


getAssignmentById : Plan -> String -> Maybe Assignment
getAssignmentById model id =
    let
        -- get all assignments
        assignments =
            getAllAssignments model

        -- make them comparable tuples
        tupledAssignments =
            List.map (\ass -> ( ass.id, ass )) assignments

        -- convert them to a dictionary for easy querying
        assignmentsById =
            Dict.fromList tupledAssignments
    in
        -- query for assignment by id
        Dict.get id assignmentsById


getWorkByAssignment : List Work -> Maybe Assignment -> Maybe Work
getWorkByAssignment works assignment =
    let
        filteredWork =
            List.filter (\work -> List.member assignment work.assignments) works
    in
        case assignment of
            Just assignment ->
                List.head filteredWork


getAllAssignments : Plan -> List Assignment
getAllAssignments model =
    List.concatMap (\work -> work.assignments) model.work
