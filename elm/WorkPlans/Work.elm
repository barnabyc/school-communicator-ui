module WorkPlans.Work exposing (..)

import Date as Date exposing (..)
import WorkPlans.Source exposing (..)
import WorkPlans.Assignment exposing (..)


type alias Work =
    { id : String
    , source : Source
    , assignments : List Assignment
    }
