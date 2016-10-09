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
    , work = [ dummyWork ]
    }


dummyWork : Work
dummyWork =
    { id = "xyz987"
    , source = dummySource
    , assignments = dummyAssignments
    }


dummySource : Source
dummySource =
    { id = "xyz987"
    , title = "Bunnicula"
    , author = "Foo Bar"
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
            , works plan.work
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


works : List Work -> Html Msg
works works =
    ol [ class "works" ]
        (List.map work works)


work : Work -> Html Msg
work work =
    li [ class "work" ]
        [ text work.source.title ]



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


getAssignmentsForSubject : Subject -> List Assignment -> List Assignment
getAssignmentsForSubject subject assignments =
    List.filter (\assignment -> assignment.subject.id == subject.id) assignments
