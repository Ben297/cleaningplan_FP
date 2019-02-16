module HouseTask exposing (Task)

import Person exposing (Person)
import Time exposing (Posix)

type alias Task = {
        id : Int
        , displayName : String
        , currentlyResponsible : Person
        , description : String
        , dueDate : Posix
        , creationDate : Posix
        , lastDone : Posix
        , lastDoneBy : Person
        , isRepetitiveTask : Bool
        , isDeleted : Bool
    }