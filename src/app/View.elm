module View exposing (view)

import Html exposing (Html, button, div, text)
-- import Html.Attributes as Attr exposing (id, class, classList)
import Msg exposing (..)
import Model exposing (Model)

import MainView exposing (mainView)
import NextWeekView exposing (nextWeekView)
import PreviousWeekView exposing (previousWeekView)
import AddPersonView exposing (addPersonView)
import AddTaskView exposing (addTaskView)

view : Model -> Html Msg
view model = case model.view of
    MainView ->
        mainView model
    NextWeekView ->
        nextWeekView model
    PreviousWeekView ->
        previousWeekView model
    AddPersonView ->
        addPersonView model
    AddTaskView ->
        addTaskView model