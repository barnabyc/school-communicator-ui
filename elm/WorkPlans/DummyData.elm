module WorkPlans.DummyData exposing (..)

import Date as Date exposing (..)
import Date.Extra.Create exposing (..)
import WorkPlans.Subjects as Subjects exposing (..)
import WorkPlans.Plan exposing (..)
import WorkPlans.Assignment exposing (..)
import WorkPlans.Work exposing (..)
import WorkPlans.Source exposing (..)


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
      , subject = Subjects.reading
      }
    , { id = "pqr789"
      , complete = False
      , day = Date.Tue
      , name = "Chapter Two"
      , description = ""
      , subject = Subjects.reading
      }
    , { id = "pqr789"
      , complete = False
      , day = Date.Wed
      , name = "Chapter Three"
      , description = ""
      , subject = Subjects.reading
      }
    , { id = "pqr789"
      , complete = False
      , day = Date.Thu
      , name = "Chapter Four"
      , description = ""
      , subject = Subjects.reading
      }
    , { id = "stu012"
      , complete = False
      , day = Date.Tue
      , name = "Chapter Two"
      , description = ""
      , subject = Subjects.writing
      }
    , { id = "fjg123"
      , complete = False
      , day = Date.Wed
      , name = "Chapter Three"
      , description = ""
      , subject = Subjects.writing
      }
    ]


dummyAssignments2 : List Assignment
dummyAssignments2 =
    [ { id = "pqr789"
      , complete = False
      , day = Date.Tue
      , name = "Chapter Two"
      , description = ""
      , subject = Subjects.reading
      }
    , { id = "stu012"
      , complete = False
      , day = Date.Tue
      , name = "Chapter Two"
      , description = ""
      , subject = Subjects.writing
      }
    , { id = "fjg123"
      , complete = False
      , day = Date.Wed
      , name = "Chapter Three"
      , description = ""
      , subject = Subjects.writing
      }
    , { id = "zzz123"
      , complete = False
      , day = Date.Sat
      , name = "Chapter Seventeen"
      , description = ""
      , subject = Subjects.writing
      }
    ]
