module Model exposing (Model, init, Flags)
import Basics exposing (Order(..))
import Json.Encode as E
import Msg exposing (Msg)
import Person exposing (Person)
import HouseTask as MyTask exposing (Task)
import List.Extra as LiEx exposing (getAt)
import Bootstrap.Dropdown as Dropdown
import Bootstrap.Navbar as Navbar
import Bootstrap.Modal as Modal
import Maybe
import Json.Decode as D exposing (field, Decoder, int, string, bool)
import Json.Decode.Extra exposing (datetime, andMap)
--import Time exposing (Posix)
import Time exposing (Month(..), utc, Posix, millisToPosix)
import Time.Extra exposing (Parts, partsToPosix)
import Task as SystemTask
import Msg exposing (..)
import Debug exposing (log)

type alias Model =
    {
        count : String
        , people : List Person
        , tasks : List Task
        , time : Posix
        , timeZone : Time.Zone
        , view : DisplayType
        , tmpPerson : Person
        , tmpTask : Task
        , tmpDueDate : Parts
        , myDrop1State : Dropdown.State
        , navbarState : Navbar.State
        , modalAddTask : Modal.Visibility
        , modalAddPerson : Modal.Visibility
        , modalShowBlamelist : Modal.Visibility
        , debug: String
    }

type alias Flags =
  {
  tasks: E.Value,
  people: List Person
  }

init : Flags -> (Model, Cmd Msg)
init flags =
    let
        initNavTup = Navbar.initialState NavbarMsg
        initNav = Tuple.first initNavTup
        initCmd = Cmd.batch [(Tuple.second initNavTup), SystemTask.perform Msg.AdjustTimeZone Time.here]
        result = (D.decodeValue tasklistdecoder flags.tasks)
        initPeople = List.sortWith sortPeople flags.people
        --debugPeople = log "people: " initPeople
    in
        case result of
        Ok tasks ->
            let
                sortedTasks = List.sortWith sortTasks tasks
                computedTasks = sortedTasks
                computedPeople = initPeople
                -- Debug:
                debugComputedTasks = log "" tasks
                debugComputedPeople = log "" initPeople
            in
                (Model "0" computedPeople computedTasks (Time.millisToPosix 0) Time.utc MainView (Person 0 "" 0) (Task 0 "" (Person 0 "" 0) "" mockupExampleDueDate1 mockupExampleCreationDate1 mockupExampleLastDoneDate1 (Person 0 "" 0) False False) (Parts 2019 Feb 12 14 30 0 0) Dropdown.initialState initNav Modal.hidden Modal.hidden Modal.hidden "", initCmd)
        Err err ->
            (Model "0" initPeople [] (Time.millisToPosix 0) Time.utc MainView (Person 0 "" 0) (Task 0 "" (Person 0 "" 0) "" mockupExampleDueDate1 mockupExampleCreationDate1 mockupExampleLastDoneDate1 (Person 0 "" 0) False False) (Parts 2019 Feb 12 14 30 0 0) Dropdown.initialState initNav Modal.hidden Modal.hidden Modal.hidden "", initCmd)

setBlamecounterOnPeople: List Person -> List Task -> List Person
setBlamecounterOnPeople people tasks = List.map (mapPerson tasks) people

mapPerson: List Task -> Person -> Person
mapPerson tasks person =
    let
        relevantTasks = List.filter (filterRelevantTasks person) tasks
        blameCount = person.blameCounter + (blameCountAddForPerson tasks person)
    in
        {person | blameCounter = blameCount}

blameCountAddForPerson: List Task -> Person -> Int
blameCountAddForPerson tasks person = 0

filterRelevantTasks: Person -> Task -> Bool
filterRelevantTasks person task = task.currentlyResponsible.id == person.id

sortTasks: Task -> Task -> Order
sortTasks task1 task2 = if task1.id >= task2.id
    then
         GT
    else
         LT

sortPeople: Person -> Person -> Order
sortPeople person1 person2 = if person1.id >= person2.id
    then
        GT
    else
        LT


mockupPeople: List Person
mockupPeople =
    [
        Person 1 "Peter2" 0
        , Person 2 "Paul" 0
        , Person 3 "Marry" 0
    ]

mockupTasks: List Task
mockupTasks =
    let
        defaultPerson = Person 0 "Default" 0
        firstPerson = (Maybe.withDefault defaultPerson (getAt 0 mockupPeople))
        secondPerson = (Maybe.withDefault defaultPerson (getAt 1 mockupPeople))
        thirdPerson = (Maybe.withDefault defaultPerson (getAt 2 mockupPeople))
    in
    [
        Task 1 "clean the floor" firstPerson "just clean the damn floor!" mockupExampleDueDate1 mockupExampleCreationDate1 mockupExampleLastDoneDate1 firstPerson True False
        , Task 2 "dispose garbage" secondPerson "dispose all unnecessary garbage in the provided containers!" mockupExampleDueDate2 mockupExampleCreationDate2 mockupExampleLastDoneDate2 secondPerson True False
        , Task 3 "kill roaches in the cellar" thirdPerson "kill all the roaches!!!" mockupExampleDueDate3 mockupExampleCreationDate3 mockupExampleLastDoneDate3 thirdPerson True False
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

--dueDate: "2019-03-08T06:00:00Z",
mockupExampleDueDate1: Posix
mockupExampleDueDate1 = partsToPosix utc (Parts 2019 Mar 8 6 0 0 0)

--creationDate: "2019-03-05T06:00:00Z",
mockupExampleCreationDate1: Posix
mockupExampleCreationDate1 = partsToPosix utc (Parts 2019 Mar 5 6 0 0 0)

--lastDone: "2019-03-06T06:00:00Z",
mockupExampleLastDoneDate1: Posix
mockupExampleLastDoneDate1 = partsToPosix utc (Parts 3900 Jan 0 0 0 0 0)

mockupExampleDueDate2: Posix
mockupExampleDueDate2 = partsToPosix utc (Parts 2019 Sep 26 14 30 0 0)

mockupExampleCreationDate2: Posix
mockupExampleCreationDate2 = partsToPosix utc (Parts 2019 Feb 10 16 17 0 0)

mockupExampleLastDoneDate2: Posix
mockupExampleLastDoneDate2 = partsToPosix utc (Parts 2019 Sep 26 14 30 0 0)

mockupExampleDueDate3: Posix
mockupExampleDueDate3 = partsToPosix utc (Parts 2019 Sep 26 14 30 0 0)

mockupExampleCreationDate3: Posix
mockupExampleCreationDate3 = partsToPosix utc (Parts 2019 Feb 12 16 17 0 0)

mockupExampleLastDoneDate3: Posix
mockupExampleLastDoneDate3 = partsToPosix utc (Parts 2019 Sep 26 14 30 0 0)

tasklistdecoder: Decoder (List Task)
tasklistdecoder =
    D.list taskdecoder


taskdecoder: Decoder Task
taskdecoder =
  D.succeed Task
    |> andMap (field "id" int)
    |> andMap (field "displayName" string)
    |> andMap (field "currentlyResponsible" persondecoder)
    |> andMap (field "description" string)
    |> andMap (field "dueDate" datetime)
    |> andMap (field "creationDate" datetime)
    |> andMap (field "lastDone" datetime)
    |> andMap (field "lastDoneBy" persondecoder)
    |> andMap (field "isRepetitiveTask" bool)
    |> andMap (field "isDeleted" bool)


persondecoder: Decoder Person
persondecoder =
    D.map3 Person
      (D.field "id" D.int)
      (D.field "name" D.string)
      (D.field "blameCounter" D.int)
