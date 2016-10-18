module WorkPlans exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Date
import Date.Extra.Create exposing (..)


-- types


type Msg
    = Fetch
    | FetchSucceed
    | FetchFail
    | Manage


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
    { id : Int
    , name : String
    }



-- data


reading : Subject
reading =
    Subject 1 "Reading"


writing : Subject
writing =
    Subject 2 "Writing"


mathematics : Subject
mathematics =
    Subject 3 "Mathematics"


science : Subject
science =
    Subject 4 "Science"


socialStudies : Subject
socialStudies =
    Subject 5 "Social Studies"


foreignLanguages : Subject
foreignLanguages =
    Subject 6 "Foreign Languages"


arts : Subject
arts =
    Subject 7 "The Arts"


personalCare : Subject
personalCare =
    Subject 8 "Personal Care"


other : Subject
other =
    Subject 99 "Other"


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
    , assignments = dummyAssignments
    }


dummyWork2 : Work
dummyWork2 =
    -- Great Expectations
    { id = "foo111"
    , source = dummySource2
    , assignments = dummyAssignments
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


dummyAssignments : List Assignment
dummyAssignments =
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
    , { id = "stu012"
      , complete = False
      , day = Date.Tue
      , name = "Chapter Two"
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
            [ picker
            , weekHeader
            , subjectsGroupings plan.work
            , subjectChoices
            ]
        ]


picker : Html Msg
picker =
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
    ol [ class "subject-groupings" ]
        -- todo get list of subjects from actual work assignments
        (List.map (workItems works) subjects)


workItems : List Work -> Subject -> Html Msg
workItems works subject =
    li [ class "subject" ]
        [ text subject.name
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
        [ text assignment.name
        , text ", "
        , text assignment.subject.name
        ]



-- modals


subjectChoices : Html Msg
subjectChoices =
    ol [ class "subject-choices" ]
        (List.map subjectChoice subjects)


subjectChoice : Subject -> Html Msg
subjectChoice subject =
    li [ class "subject" ]
        [ text subject.name ]



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
    List.filter (\assignment -> assignment.subject.id == subject.id) assignments
