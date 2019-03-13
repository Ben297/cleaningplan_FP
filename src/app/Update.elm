module Update exposing (update, decodeTaskValue, tasklistdecoder)

import Time exposing (Posix)

import Msg exposing (..)
import Model exposing (Model)
import Maybe exposing (..)
import HouseTask as Task exposing (Task)
import Person exposing (Person)
import List.Extra exposing (find)
import Time exposing (Posix, utc, Month(..))
import Time.Extra exposing (Parts, partsToPosix)
import Formatters exposing (intToMonth)
import Bootstrap.Modal as Modal

import Ports exposing (..)
import Json.Encode as E
import Json.Decode as D exposing (field, Decoder, int, string, bool)
import Json.Decode.Extra exposing (datetime, andMap)
import HouseTaskTransfer as Transfertask exposing (TransferTask)
import BlameLogic exposing (getNewTasksAndPeople)
import Debug exposing (log)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Increment ->
            ({ model | count = model.count ++ "1" }, Cmd.none)

        Decrement ->
            ({ model | count = model.count ++ "1" }, Cmd.none)

        Tick newTime ->
            let
                peopleAndTasks = getNewTasksAndPeople model.timeZone newTime model.people model.tasks
                newPeople = peopleAndTasks.people
                newTasks = peopleAndTasks.tasks
            in
                ( { model | time = newTime, tasks = newTasks }
                    , Cmd.none
                )

        AdjustTimeZone newTimezone ->
            ( { model | timeZone = newTimezone }
                , Cmd.none
            )

        ChangeViewTo displayType ->
            ( {model | view = displayType}
                , Cmd.none
            )

        TaskDone id ->
            let
                tasks = List.map (findAndUpdateLastDone id model.time) model.tasks
            in
                ( {model | tasks = tasks}
                    , Cmd.none
                )

        AddPersonName name ->
            let
                tmp = model.tmpPerson
                newPerson = {tmp | name = name}
            in
                ( {model | tmpPerson = newPerson}
                    , Cmd.none
                )

        SubmitPerson ->
            let
                newPerson = model.tmpPerson
                tmpNewPerson = {newPerson | id = getNextIdPerson model.people}
                persons = List.append model.people [tmpNewPerson]
            in
            ( {model | people = persons, tmpPerson = (Person 0 "" 0)}
                , saveperson tmpNewPerson
            )

        MyDrop1Msg state ->
            ( { model | myDrop1State = state }
            , Cmd.none
            )

        AddTaskPersonDropdown id ->
            let
                maybeID = String.toInt id
            in
                case maybeID of
                    Just id2 ->
                        let
                            maybePerson = find (\ln-> ln.id == id2 ) model.people
                        in
                            case maybePerson of
                                 Just person ->
                                  let
                                      newTask = model.tmpTask
                                      tmpNewTask = {newTask | currentlyResponsible = person }
                                  in
                                     ( { model | tmpTask = tmpNewTask  }
                                        , Cmd.none
                                     )
                                 Nothing ->
                                    ( model
                                      ,Cmd.none
                                    )
                    Nothing ->
                        ( model
                          ,Cmd.none
                        )

        SubmitTask ->
            let
                newTask = model.tmpTask
                tmpNewTask = {newTask | id = getNextIdTask model.tasks, creationDate = model.time}
                tasks = List.append model.tasks [tmpNewTask]
            in
            ( {model | tasks = tasks, tmpTask = (Task 0 "" (Person 0 "" 0) "" mockupExampleDueDate1 model.time mockupExampleLastDoneDate1 (Person 0 "" 0) False False)}
                , savetask (preparetask tmpNewTask)
            )

        AddTaskName displayName ->
            let
                tmp = model.tmpTask
                newTask = {tmp | displayName = displayName}
            in
                ({model | tmpTask = newTask}
                    ,Cmd.none
                )

        AddTaskDescription description ->
            let
                tmp = model.tmpTask
                newTask = {tmp | description = description}
            in
                ({model | tmpTask = newTask}
                    ,Cmd.none
                )

        AddTaskDueDate time ->
            let
                stringList = String.split "-" time
                intList = List.map stringElmToInt stringList
                firstElm = List.Extra.getAt 0 intList
                secondElm = List.Extra.getAt 1 intList
                thirdElm = List.Extra.getAt 2 intList
                tmpDueDateParts = Time.Extra.posixToParts model.timeZone model.tmpTask.dueDate
            in
                case firstElm of
                    Just year ->
                        case secondElm of
                            Just month ->
                                case thirdElm of
                                    Just day ->
                                        let
                                            newDueDateParts = {tmpDueDateParts | year = year, month = intToMonth month, day = day }
                                            dueDate = Time.Extra.partsToPosix model.timeZone newDueDateParts
                                            newTask = model.tmpTask
                                            tmpNewTask = {newTask | dueDate = dueDate}
                                        in
                                            ({model | tmpTask = tmpNewTask}
                                                ,Cmd.none
                                            )
                                    Nothing ->
                                        ( model
                                          ,Cmd.none
                                        )
                            Nothing ->
                                ( model
                                ,Cmd.none
                                )
                    Nothing ->
                        ( model
                          ,Cmd.none
                        )

        AddTaskDueTime time ->
            let
                stringList = String.split ":" time
                intList = List.map stringElmToInt stringList
                firstElm = List.Extra.getAt 0 intList
                secondElm = List.Extra.getAt 1 intList
                tmpDueDateParts = Time.Extra.posixToParts model.timeZone model.tmpTask.dueDate
            in
                case firstElm of
                    Just hour ->
                        case secondElm of
                            Just minute ->
                                let
                                    newDueDateParts = {tmpDueDateParts | hour = hour, minute = minute}
                                    dueDate = Time.Extra.partsToPosix model.timeZone newDueDateParts
                                    newTask = model.tmpTask
                                    tmpNewTask = {newTask | dueDate = dueDate}
                                in
                                    ({model | tmpTask = tmpNewTask}
                                        ,Cmd.none
                                    )
                            Nothing ->
                                ( model
                                ,Cmd.none
                                )
                    Nothing ->
                        ( model
                          ,Cmd.none
                        )

        AddTaskIsRepetitiveTask isRepetitiveTask ->
            let
                tmp = model.tmpTask
                newTask = {tmp | isRepetitiveTask = isRepetitiveTask}
            in
                ({model | tmpTask = newTask}
                    ,Cmd.none
                )

        NavbarMsg state ->
            ( { model | navbarState = state }, Cmd.none )

        ShowModalAddTask ->
            ( { model | modalAddTask = Modal.shown }
            , Cmd.none
            )

        CloseModalAddTask ->
            ( { model | modalAddTask = Modal.hidden }
            , Cmd.none
            )

        ShowModalAddPerson ->
            ( { model | modalAddPerson = Modal.shown }
            , Cmd.none
            )

        CloseModalAddPerson ->
            ( { model | modalAddPerson = Modal.hidden }
            , Cmd.none
            )

        ShowModalBlamelist ->
            ( { model | modalShowBlamelist = Modal.shown }
            , Cmd.none
            )

        CloseModalBlamelist ->
            ( { model | modalShowBlamelist = Modal.hidden }
            , Cmd.none
            )

        UpdatePeople p ->
          ( {model | people = p }
          , Cmd.none
          )

        UpdateTask t ->
            ( {model | tasks = t } --, debug = (Debug.toString t) }
            , Cmd.none
            )

        TaskErr s ->
          ( {model | debug = s }
          , Cmd.none
          )

getNextIdPerson: List Person -> Int
getNextIdPerson people =
    let
        tmpPerson = List.head (List.reverse people)
    in
        case  tmpPerson of
            Just val ->
                val.id + 1
            Nothing -> 0


getNextIdTask: List Task -> Int
getNextIdTask tasks =
    let
        tmpTask = List.head (List.reverse tasks)
    in
        case  tmpTask of
            Just val ->
                val.id + 1
            Nothing -> 0


findAndUpdateLastDone: Int -> Posix -> Task -> Task
findAndUpdateLastDone id time task =
    if task.id == id
    then
        {task | lastDone = time}
    else
        task

mockupExampleDueDate1 : Posix
mockupExampleDueDate1 = partsToPosix utc (Parts 2019 Feb 12 14 30 0 0)

mockupExampleCreationDate1 : Posix
mockupExampleCreationDate1 = partsToPosix utc (Parts 2018 Feb 11 10 17 0 0)

mockupExampleLastDoneDate1 : Posix
mockupExampleLastDoneDate1 = partsToPosix utc (Parts 3900 Jan 0 0 0 0 0)


stringElmToInt : String -> Int
stringElmToInt elm =
    let
        maybeInt = String.toInt elm
    in
        case maybeInt of
            Just int ->
                int
            Nothing ->
                0


preparetask: Task -> TransferTask
preparetask task =
  TransferTask
    task.id
    task.displayName
    task.currentlyResponsible
    task.description
    (Time.posixToMillis task.dueDate)
    (Time.posixToMillis task.creationDate)
    (Time.posixToMillis task.lastDone)
    task.lastDoneBy
    task.isRepetitiveTask
    task.isDeleted

decodeTaskValue: E.Value -> Msg
decodeTaskValue val =
    let
        result = D.decodeValue tasklistdecoder val
    in
        case result of
            Ok tasks ->
                UpdateTask tasks
            Err _ ->
                TaskErr ((Debug.toString result) ++ " " ++  (Debug.toString val) )




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
