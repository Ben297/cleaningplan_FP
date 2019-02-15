module Update exposing (update)

import Time exposing (Posix)

import Msg exposing (..)
import Model exposing (Model)
import Maybe exposing (..)
import HouseTask as Task exposing (Task)

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

        TaskDone id->
            let
                tasks = List.map (findAndUpdateLastDone id model.time) model.tasks
            in
                ( {model | tasks = tasks}
                    , Cmd.none
                )

findAndUpdateLastDone: String -> Posix -> Task -> Task
findAndUpdateLastDone id time task =
    if task.id == id
    then
        {task | lastDone = time}
    else
        task