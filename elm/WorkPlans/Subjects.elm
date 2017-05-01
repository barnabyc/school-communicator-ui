module WorkPlans.Subjects exposing (..)


type alias Subject =
    ( Int, String )


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


all : List Subject
all =
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
