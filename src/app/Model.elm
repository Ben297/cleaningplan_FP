module Model exposing (Model, init, initMockup)

import Msg exposing (Msg)
import Person exposing (Person)
import HouseTask as MyTask exposing (Task)
import List.Extra as LiEx exposing (getAt)
import Maybe
--import Time exposing (Posix)
import Time exposing (Month(..), utc, Posix)
import Time.Extra exposing (Parts, partsToPosix)
import Task as SystemTask
import Msg exposing (DisplayType(..))

type alias Model =
    {
        count : Int
        , people : List Person
        , tasks : List Task
        , time : Posix
        , timeZone : Time.Zone
        , view : DisplayType
    }

init : Int -> (Model, Cmd Msg)
init flags = (Model 0 [] [] (Time.millisToPosix 0) Time.utc MainView, Cmd.none)

initMockup : Int -> (Model, Cmd Msg)
initMockup flags = (Model 0 mockupPeople mockupTasks (Time.millisToPosix 0) Time.utc MainView, SystemTask.perform Msg.AdjustTimeZone Time.here)

mockupPeople : List Person
mockupPeople = [
        Person "1" "Peter" 0
        , Person "2" "Paul" 0
        , Person "3" "Marry" 0
    ]

mockupTasks : List Task
mockupTasks =
    let
        defaultPerson = Person "" "Default" 0
        firstPerson = (Maybe.withDefault defaultPerson (getAt 0 mockupPeople))
        secondPerson = (Maybe.withDefault defaultPerson (getAt 1 mockupPeople))
        thirdPerson = (Maybe.withDefault defaultPerson (getAt 2 mockupPeople))
    in
    [
        Task "id1" "clean the floor" firstPerson "just clean the damn floor!" mockupExampleDueDate1 mockupExampleCreationDate1 mockupExampleLastDoneDate1 firstPerson True False
        , Task "id2" "dispose garbage" secondPerson "dispose all unnecessary garbage in the provided containers!" mockupExampleDueDate2 mockupExampleCreationDate2 mockupExampleLastDoneDate2 secondPerson True False
        , Task "id3" "kill roaches in the cellar" thirdPerson "kill all the roaches!!!" mockupExampleDueDate3 mockupExampleCreationDate3 mockupExampleLastDoneDate3 thirdPerson True False
        -- , Task id : String , displayName : String , currentlyResponsible : Person , description : String , dueDate : Posix , creationDate : Posix , lastDone : Posix , lastDoneBy : Person , isRepetitiveTask : Bool , isDeleted :Bool
    ]

    -- HouseTask:
    -- id : String
    -- , displayName : String
    -- , currentlyResponsible : Person
    -- , description : String
    -- , dueDate : Posix
    -- , creationDate : Posix
    -- , lastDone : Posix
    -- , lastDoneBy : Person
    -- , isRepetitiveTask : Bool
    -- , isDeleted : Bool
--Mockup dates for use in mockup tasks
mockupExampleDueDate1 : Posix
mockupExampleDueDate1 = partsToPosix utc (Parts 2019 Feb 12 14 30 0 0)

mockupExampleCreationDate1 : Posix
mockupExampleCreationDate1 = partsToPosix utc (Parts 2018 Feb 11 10 17 0 0)

mockupExampleLastDoneDate1 : Posix
mockupExampleLastDoneDate1 = partsToPosix utc (Parts 2019 Feb 12 10 17 0 0)

mockupExampleDueDate2 : Posix
mockupExampleDueDate2 = partsToPosix utc (Parts 2019 Sep 26 14 30 0 0)

mockupExampleCreationDate2 : Posix
mockupExampleCreationDate2 = partsToPosix utc (Parts 2019 Feb 10 16 17 0 0)

mockupExampleLastDoneDate2 : Posix
mockupExampleLastDoneDate2 = partsToPosix utc (Parts 2019 Sep 26 14 30 0 0)

mockupExampleDueDate3 : Posix
mockupExampleDueDate3 = partsToPosix utc (Parts 2019 Sep 26 14 30 0 0)

mockupExampleCreationDate3 : Posix
mockupExampleCreationDate3 = partsToPosix utc (Parts 2019 Feb 12 16 17 0 0)

mockupExampleLastDoneDate3 : Posix
mockupExampleLastDoneDate3 = partsToPosix utc (Parts 2019 Sep 26 14 30 0 0)
