module Update exposing (update)

import Time exposing (Posix)

import Msg exposing (..)
import Model exposing (Model)
import Maybe exposing (..)
import HouseTask as Task exposing (Task)
import Person exposing (Person)

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


getNextIdPerson: List Person -> Int
getNextIdPerson people =
    let
        tmpPerson = List.head (List.reverse people)
    in
        case  tmpPerson of
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