module WorkPlans exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Date exposing (Day(..))


--import Date.Extra.Create exposing (..)

import Set
import Tuple exposing (first, second)
import WorkPlans.Subjects as Subjects exposing (..)
import WorkPlans.Plan exposing (..)
import WorkPlans.Work exposing (..)
import WorkPlans.Assignment exposing (..)
import WorkPlans.DummyData as DummyData exposing (..)


init : ( Plan, Cmd Msg )
init =
    ( model, Cmd.none )


model : Plan
model =
    DummyData.dummyPlan


subscriptions : Plan -> Sub Msg
subscriptions model =
    Sub.none



-- update


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
                --updatedAssignment =
                --    Maybe.map (\ass -> { ass | complete = isComplete }) assignment
                --complete title postID post =
                --    if post.id == postID then
                --        { post | title = title }
                --    else
                --        post
                --Maybe.map (setTitleAtID title postID) model.posts , Effects.none
            in
                -- todo change this none to a Save
                ( model, Cmd.none )



-- update helpers


getWorkById : Plan -> String -> Maybe Work
getWorkById model id =
    List.head
        (List.filter (\work -> work.id == id) model.work)



-- types


type Msg
    = Fetch
    | FetchSucceed
    | FetchFail
    | Manage
    | CompleteAssignment String String Bool



-- views


view : Plan -> Html Msg
view plan =
    div
        [ class "work-plans wrapper" ]
        [ section
            [ id "content" ]
            [ studentPicker
            , weekHeader
            , subjectsGroupings plan.work
            , subjectChoices
            ]
        ]


studentPicker : Html Msg
studentPicker =
    select
        [ class "viewable-plans picker" ]
        [ option [] [ text "View work plan for" ]
        , option [ value "student-a" ] [ text "Test Student A" ]
        , option [ value "student-b" ] [ text "Test Student B" ]
        , option [ value "student-c" ] [ text "Test Student C" ]
        , option [ value "manage" ] [ text "Manage multiple plans" ]
        ]


weekHeader : Html Msg
weekHeader =
    header []
        [ a [] [ text "< Last week" ]
        , span [] [ text "Week of {foo} {calendar}" ]
        , a [] [ text "Next week >" ]
        ]


subjectsGroupings : List Work -> Html Msg
subjectsGroupings works =
    let
        -- todo filter by work assignments actual subjects
        allAssignmentSubjects =
            List.concatMap getSubjects works

        applicableSubjects =
            -- this ensure unique only subjects are iterated over
            -- todo find a better way to do this
            Set.toList (Set.fromList allAssignmentSubjects)
    in
        ol [ class "subject-groupings" ]
            -- todo get list of subjects from actual work assignments
            (List.map (workItems works) applicableSubjects)


getSubjects : Work -> List Subject
getSubjects work =
    List.map (\ass -> ass.subject) work.assignments


workItems : List Work -> Subject -> Html Msg
workItems works subject =
    li [ class "subject" ]
        [ text (second subject)
        , ul [ class "works" ]
            (List.map (work subject) works)
        ]


work : Subject -> Work -> Html Msg
work subject work =
    li [ class "work" ]
        [ text work.source.title
        , assignments work (getAssignmentsForSubject subject work.assignments)
        ]


assignments : Work -> List Assignment -> Html Msg
assignments work assignments =
    ol [ class "assignments" ]
        (List.map (assignment work) assignments)


assignment : Work -> Assignment -> Html Msg
assignment work assignment =
    li [ class "assignment" ]
        [ input
            [ type_ "checkbox"
            , checked assignment.complete
            , onClick (CompleteAssignment work.id assignment.id (not assignment.complete))
            ]
            []
        , text assignment.name
        , text ", "
        , text (dayOfWeek assignment.day)
        , text ", "
        , completed assignment.complete
        ]


completed : Bool -> Html Msg
completed complete =
    case complete of
        True ->
            text "true"

        False ->
            text "false"



-- modals


subjectChoices : Html Msg
subjectChoices =
    ol [ class "subject-choices" ]
        (List.map subjectChoice Subjects.all)


subjectChoice : Subject -> Html Msg
subjectChoice subject =
    li [ class "subject" ]
        [ text (second subject) ]



-- helpers
--getWorksForSubject : Subject -> List Work -> List Work
--getWorksForSubject subject works =
--    List.map (filterWorksBySubject subject) works
--    let
--        assignment =
--            List.head work.assignemnts
--    in
--        case assignment of
--            Just assignment ->
--                List.filter (\work -> assignment.subject.id == subject.id) works
--            Nothing ->
--                []
--filterWorksBySubject : Subject -> Work -> Bool
--filterWorksBySubject subject work =


getAssignmentsForSubject : Subject -> List Assignment -> List Assignment
getAssignmentsForSubject subject assignments =
    List.filter (\assignment -> (first assignment.subject) == (first subject)) assignments


dayOfWeek : Day -> String
dayOfWeek day =
    case day of
        Mon ->
            "Monday"

        Tue ->
            "Tuesday"

        Wed ->
            "Wednesday"

        Thu ->
            "Thursday"

        Fri ->
            "Friday"

        Sat ->
            "Saturday"

        Sun ->
            "Sunday"



-- main


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
