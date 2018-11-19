module Student exposing (..)

import Html exposing (Html, div, text, ul, ol, li, span)
import GraphQL.Request.Builder exposing (..)
import GraphQL.Request.Builder.Arg as Arg
import GraphQL.Request.Builder.Variable as Var
import GraphQL.Client.Http as GraphQLClient
import Task exposing (Task)
import WorkPlans.Subjects as Subjects exposing (choices)
import WorkPlans.Types exposing (..)
import List exposing (sortWith, head)
import List.Extra exposing (groupWhile)


type alias Subject =
    { name : String }


type alias Assignment =
    { title : String
    , subject : Subject
    }


type alias Student =
    { name : String
    , assignments : List Assignment
    }


studentQuery : Document Query Student { vars | studentId : String }
studentQuery =
    let
        studentId =
            Var.required "studentId" .studentId Var.id

        subject =
            object Subject
                |> with (field "name" [] string)

        assignment =
            object Assignment
                |> with (field "title" [] string)
                |> with (field "subject" [] subject)

        student =
            object Student
                |> with (field "name" [] string)
                |> with (field "assignments" [] (list assignment))

        queryRoot =
            extract
                (field "Student"
                    [ ( "id", Arg.variable studentId ) ]
                    student
                )
    in
        queryDocument queryRoot


studentQueryRequest : Request Query Student
studentQueryRequest =
    studentQuery
        |> request
            { studentId = "cj58zq2x32o5y0129fzxjc101"
            }


type alias StudentResponse =
    Result GraphQLClient.Error Student


type alias Model =
    Maybe StudentResponse


type Msg
    = ReceiveQueryResponse StudentResponse
    | WorkPlansViews WorkPlans.Types.Msg


sendQueryRequest : Request Query a -> Task GraphQLClient.Error a
sendQueryRequest request =
    GraphQLClient.sendQuery "https://api.graph.cool/simple/v1/cj3dsaht20d6o0104tj3dndpp" request


sendStudentQuery : Cmd Msg
sendStudentQuery =
    sendQueryRequest studentQueryRequest
        |> Task.attempt ReceiveQueryResponse


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    ( Nothing, sendStudentQuery )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceiveQueryResponse response ->
            ( Just response, Cmd.none )

        WorkPlansViews _ ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    let
        content =
            case model of
                Nothing ->
                    span [] [ text "Loading..." ]

                Just resp ->
                    case resp of
                        Err err ->
                            span [] [ text "Error loading!" ]

                        Ok student ->
                            work student
    in
        div []
            [ content
            , div
                []
                [ text "Subjects:"
                , Subjects.choices |> Html.map WorkPlansViews
                ]
            ]


subjectOrdering : Assignment -> Assignment -> Order
subjectOrdering a b =
    case compare a.subject.name b.subject.name of
        LT ->
            GT

        EQ ->
            EQ

        GT ->
            LT


getGroupName : List Assignment -> Html Msg
getGroupName assignmentGroup =
    let
        subjectName =
            head assignmentGroup
    in
        case subjectName of
            Nothing ->
                text "<no assignments in group>"

            Just assignment ->
                text assignment.subject.name


work : Student -> Html Msg
work student =
    let
        sortedAssignments =
            sortWith subjectOrdering student.assignments

        assignmentsBySubject =
            -- groupWhile requires the list to be sorted as it only considers adjacent members
            groupWhile (\x y -> x.subject.name == y.subject.name) sortedAssignments

        assignments =
            List.concatMap
                (\subjectGrouping ->
                    [ li []
                        [ (getGroupName subjectGrouping)
                        , ul []
                            (List.map
                                (\assignment ->
                                    li []
                                        [ text assignment.title
                                        ]
                                )
                                subjectGrouping
                            )
                        ]
                    ]
                )
                assignmentsBySubject

        items =
            (text student.name) :: assignments
    in
        ul [] items



-- assignmentsBySubject =
--     [ [ { title = "1,000 words on Turnips", subject = { name = "Writing" } } ]
--     , [ { title = "Draw a diagram of a water molecule", subject = { name = "The Arts" } } ]
--     , [ { title = "Great Expectations", subject = { name = "Reading" } }
--       , { title = "Pride and Prejudice", subject = { name = "Reading" } }
--       ]
--     ]
