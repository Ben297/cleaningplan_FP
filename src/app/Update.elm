module Update exposing (update)

import Time exposing (Posix)

import Msg exposing (..)
import Model exposing (Model)
import Maybe exposing (..)
import HouseTask as Task exposing (Task)
import Person exposing (Person)
import List.Extra exposing (find)
import Time exposing (Posix, utc, Month(..))
import Time.Extra exposing (Parts, partsToPosix)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Increment ->
            ({ model | count = model.count + 1 }, Cmd.none)

        Decrement ->
            ({ model | count = model.count - 1 }, Cmd.none)

        Tick newTime ->
            ( { model | time = newTime }
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
                , Cmd.none
            )

        MyDrop1Msg state ->
            ( { model | myDrop1State = state }
            , Cmd.none
            )

        AddTaskPersonDropdown id ->
            let
                maybePerson = find (\ln-> ln.id == id ) model.people
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
        SubmitTask ->
            let
                newTask = model.tmpTask
                tmpNewTask = {newTask | id = getNextIdTask model.tasks}
                tasks = List.append model.tasks [tmpNewTask]
            in
            ( {model | tasks = tasks, tmpTask = (Task 0 "" (Person 0 "" 0) "" mockupExampleDueDate1 mockupExampleCreationDate1 mockupExampleLastDoneDate1 (Person 0 "" 0) True False)}
                , Cmd.none
            )

        AddTaskName displayName ->
            let
                tmp = model.tmpTask
                newTask = {tmp | displayName = displayName}
            in
                ({model | tmpTask = newTask}
                    ,Cmd.none
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
mockupExampleLastDoneDate1 = partsToPosix utc (Parts 2019 Feb 12 10 17 0 0)
