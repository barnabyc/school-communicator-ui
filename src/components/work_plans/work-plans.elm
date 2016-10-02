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


subjects : List Subject
subjects =
    [ Subject 1 "Reading"
    , Subject 2 "Writing"
    , Subject 3 "Mathematics"
    , Subject 4 "Science"
    , Subject 5 "Social Studies"
    , Subject 6 "Foreign Languages"
    , Subject 7 "The Arts"
    , Subject 8 "Personal Care"
    , Subject 99 "Other"
    ]


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
      , subject = Subject 1 "Reading"
      }
    , { id = "pqr789"
      , complete = False
      , day = Date.Tue
      , name = "Chapter Two"
      , description = ""
      , subject = Subject 1 "Reading"
      }
    , { id = "stu012"
      , complete = False
      , day = Date.Tue
      , name = "Chapter Two"
      , description = ""
      , subject = Subject 2 "Writing"
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


subjectChoices : Html Msg
subjectChoices =
    div []
        [ text "[subjects]" ]



-- helpers


getAssignmentsForSubject : Subject -> List Assignment -> List Assignment
getAssignmentsForSubject subject assignments =
    List.filter (\assignment -> assignment.subject.id == subject.id) assignments
