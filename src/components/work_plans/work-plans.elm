module WorkPlans exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Date
import Date.Extra.Create exposing (..)
import Set


-- types


type Msg
    = Fetch
    | FetchSucceed
    | FetchFail
    | Manage
    | CompleteAssignment String Bool


type alias Plan =
    { id : String
    , student : String
    , week : Date.Date
    , work : List Work
    }


type alias Work =
    { id : String
    , source : Source
    , assignments : List Assignment
    }


type alias Source =
    { id : String
    , title : String
    , author : String
    , description : String
    }


type alias Assignment =
    { id : String
    , complete : Bool
    , day : Date.Day
    , name : String
    , description : String
    , subject : Subject
    }


type alias Subject =
    ( Int, String )



-- data


reading : Subject
reading =
    ( 1, "Reading" )


writing : Subject
writing =
    ( 2, "Writing" )


mathematics : Subject
mathematics =
    ( 3, "Mathematics" )


science : Subject
science =
    ( 4, "Science" )


socialStudies : Subject
socialStudies =
    ( 5, "Social Studies" )


foreignLanguages : Subject
foreignLanguages =
    ( 6, "Foreign Languages" )


arts : Subject
arts =
    ( 7, "The Arts" )


personalCare : Subject
personalCare =
    ( 8, "Personal Care" )


other : Subject
other =
    ( 99, "Other" )


subjects : List Subject
subjects =
    [ reading
    , writing
    , mathematics
    , science
    , socialStudies
    , foreignLanguages
    , arts
    , personalCare
    , other
    ]



-- dummy data


dummyPlan : Plan
dummyPlan =
    { id = "abc123"
    , student =
        "Stephen"
    , week =
        dateFromFields 2016 Date.Jan 1 1 1 1 1
    , work = [ dummyWork, dummyWork2 ]
    }


dummyWork : Work
dummyWork =
    -- Bunnicula
    { id = "xyz987"
    , source = dummySource
    , assignments = dummyAssignments1
    }


dummyWork2 : Work
dummyWork2 =
    -- Great Expectations
    { id = "foo111"
    , source = dummySource2
    , assignments = dummyAssignments2
    }


dummySource : Source
dummySource =
    { id = "xyz987"
    , title = "Bunnicula"
    , author = "Foo Bar"
    , description = ""
    }


dummySource2 : Source
dummySource2 =
    { id = "xyz987"
    , title = "Great Expectations"
    , author = "Tinkles McGee"
    , description = ""
    }


dummyAssignments1 : List Assignment
dummyAssignments1 =
    [ { id = "mno456"
      , complete = True
      , day = Date.Mon
      , name = "Chapter One"
      , description = ""
      , subject = reading
      }
    , { id = "pqr789"
      , complete = False
      , day = Date.Tue
      , name = "Chapter Two"
      , description = ""
      , subject = reading
      }
    , { id = "pqr789"
      , complete = False
      , day = Date.Wed
      , name = "Chapter Three"
      , description = ""
      , subject = reading
      }
    , { id = "pqr789"
      , complete = False
      , day = Date.Thu
      , name = "Chapter Four"
      , description = ""
      , subject = reading
      }
    , { id = "stu012"
      , complete = False
      , day = Date.Tue
      , name = "Chapter Two"
      , description = ""
      , subject = writing
      }
    , { id = "fjg123"
      , complete = False
      , day = Date.Wed
      , name = "Chapter Three"
      , description = ""
      , subject = writing
      }
    ]


dummyAssignments2 : List Assignment
dummyAssignments2 =
    [ { id = "pqr789"
      , complete = False
      , day = Date.Tue
      , name = "Chapter Two"
      , description = ""
      , subject = reading
      }
    , { id = "stu012"
      , complete = False
      , day = Date.Tue
      , name = "Chapter Two"
      , description = ""
      , subject = writing
      }
    , { id = "fjg123"
      , complete = False
      , day = Date.Wed
      , name = "Chapter Three"
      , description = ""
      , subject = writing
      }
    , { id = "zzz123"
      , complete = False
      , day = Date.Sat
      , name = "Chapter Seventeen"
      , description = ""
      , subject = writing
      }
    ]



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
        [ a [] [ text "&lt; Last week" ]
        , span [] [ text "Week of {foo} {calendar}" ]
        , a [] [ text "&gt; Next week" ]
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
        [ text (snd subject)
        , ul [ class "works" ]
            (List.map (work subject) works)
        ]


work : Subject -> Work -> Html Msg
work subject work =
    li [ class "work" ]
        [ text work.source.title
        , assignments (getAssignmentsForSubject subject work.assignments)
        ]


assignments : List Assignment -> Html Msg
assignments assignments =
    ol [ class "assignments" ]
        (List.map assignment assignments)


assignment : Assignment -> Html Msg
assignment assignment =
    li [ class "assignment" ]
        [ input
            [ type' "checkbox"
            , checked assignment.complete
            , onClick (CompleteAssignment assignment.id (not assignment.complete))
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
        (List.map subjectChoice subjects)


subjectChoice : Subject -> Html Msg
subjectChoice subject =
    li [ class "subject" ]
        [ text (snd subject) ]



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
    List.filter (\assignment -> (fst assignment.subject) == (fst subject)) assignments


dayOfWeek : Date.Day -> String
dayOfWeek day =
    case day of
        Date.Mon ->
            "Monday"

        Date.Tue ->
            "Tuesday"

        Date.Wed ->
            "Wednesday"

        Date.Thu ->
            "Thursday"

        Date.Fri ->
            "Friday"

        Date.Sat ->
            "Saturday"

        Date.Sun ->
            "Sunday"
