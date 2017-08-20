module WorkPlans.Types exposing (..)


type Msg
    = Fetch
    | FetchSucceed
    | FetchFail
    | Manage
    | CompleteAssignment String String Bool
