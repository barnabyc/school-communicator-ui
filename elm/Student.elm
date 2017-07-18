module Student exposing (..)

import Html exposing (Html, div, text)
import GraphQL.Request.Builder exposing (..)
import GraphQL.Request.Builder.Arg as Arg
import GraphQL.Request.Builder.Variable as Var
import GraphQL.Client.Http as GraphQLClient
import Task exposing (Task)


type alias Assignment =
    { title : String }


type alias Student =
    { name : String
    , assignments : List Assignment
    }


studentQuery : Document Query Student { vars | studentId : String }
studentQuery =
    let
        studentId =
            Var.required "studentId" .studentId Var.id

        pageSize =
            Var.optional "pageSize" .pageSize (Var.nullable Var.int) (Just 3)

        assignment =
            object Assignment
                |> with (field "title" [] string)

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


view : Model -> Html Msg
view model =
    div []
        [ model |> toString |> text ]


update : Msg -> Model -> ( Model, Cmd Msg )
update (ReceiveQueryResponse response) model =
    ( Just response, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
