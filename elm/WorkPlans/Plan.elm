module WorkPlans.Plan exposing (..)

import Date as Date exposing (..)
import WorkPlans.Work exposing (..)


type alias Plan =
    { id : String
    , student : String
    , week : Date
    , work : List Work
    }
