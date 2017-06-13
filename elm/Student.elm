module Student exposing (..)

import Html exposing (Html, div, text)
import GraphQL.Request.Builder exposing (..)
import GraphQL.Request.Builder.Arg as Arg
import GraphQL.Request.Builder.Variable as Var
import GraphQL.Client.Http as GraphQLClient
import Task exposing (Task)


type alias Student =
    { name : Maybe String
    , assignments : List (Maybe String)
    }


studentRequest : Request Query Student
studentRequest =
    let
        studentId =
            Var.required "studentId" .studentId Var.studentId

        pageSize =
            Var.optional "pageSize" .pageSize (Var.nullable Var.int) (Just 3)

        planetsFragment =
            fragment "assignemnts"
                (onType "Assignment")
                (extract
                    (field "assignmentConnection"
                        [ ( "first", Arg.variable pageSize ) ]
                        (connectionNodes (extract (field "title" [] (nullable string))))
                    )
                )
    in
        extract
            (field "student"
                [ ( "studentId", Arg.variable studentId ) ]
                (object Student
                    |> with (field "name" [] (nullable string))
                    |> with (fragmentSpread assignments)
                )
            )
            |> queryDocument
            |> request
                { studentId = "abc123def456"
                , pageSize = Nothing
                }


connectionNodes : ValueSpec NonNull ObjectType result vars -> ValueSpec NonNull ObjectType (List result) vars
connectionNodes spec =
    extract
        (field "edges"
            []
            (list
                (extract
                    (field "node" [] spec)
                )
            )
        )


type alias StudentResponse =
    Result GraphQLClient.Error Student


type alias Model =
    Maybe StudentResponse


type Msg
    = ReceiveQueryResponse StudentResponse


sendQueryRequest : Request Query a -> Task GraphQLClient.Error a
sendQueryRequest request =
    GraphQLClient.sendQuery "https://api.graph.cool/simple/v1/cj3dsaht20d6o0104tj3dndpp\n" request


sendStudentQuery : Cmd Msg
sendStudentQuery =
    sendQueryRequest studentRequest
        |> Task.attempt ReceiveQueryResponse


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscription = subscription
        }


init : ( Model, Cmd Msg )
init =
    ( Nothing, sendStudentQuery )


view : Model -> Html Msg
view mode =
    div []
        [ model |> toString |> text ]


update : Msg -> Model -> ( Model, Cmd Msg )
update (ReceiveQueryResponse response) model =
    ( Just response, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
