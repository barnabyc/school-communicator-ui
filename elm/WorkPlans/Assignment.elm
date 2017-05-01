module WorkPlans.Assignment exposing (..)

import Date as Date exposing (..)
import WorkPlans.Subjects as Subjects exposing (..)


type alias Assignment =
    { id : String
    , complete : Bool
    , day : Day
    , name : String
    , description : String
    , subject : Subject
    }
