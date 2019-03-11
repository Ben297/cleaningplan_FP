module HouseTaskTransfer exposing (TransferTask)

import Person exposing (Person)
import Time exposing (Posix)

type alias TransferTask = {
        id : Int
        , displayName : String
        , currentlyResponsible : Person
        , description : String
        , dueDate : Int
        , creationDate : Int
        , lastDone : Int
        , lastDoneBy : Person
        , isRepetitiveTask : Bool
        , isDeleted : Bool
    }
