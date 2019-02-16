module AddTaskView exposing (addTaskView)

import Html exposing (..)
import Html.Events exposing (onClick)
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid

import Model exposing (Model)
import Msg exposing (Msg(..), DisplayType(..))
import ListPeopleComponent exposing (listPeople)
import ListTasksComponent exposing (listTasks)
import DayTasksComponent exposing (dayTasks)
import  AddTaskComponent exposing (addTask)


addTaskView : Model -> Html Msg
addTaskView model =
    Grid.container []
    [
        CDN.stylesheet -- creates an inline style node with the Bootstrap CSS
        , Grid.row []
        [
            Grid.col []
            [
                text "AddTaskView.elm"
                , button [ onClick (ChangeViewTo MainView) ] [ text "return to Main" ]
            ]
            , listPeople model.people
            , listTasks model
            , Grid.col []
            [
                text ( "Number of people: " ++ (String.fromInt (List.length model.people)) ++ "\nNumber of Tasks: " ++ (String.fromInt (List.length model.tasks)) )
            ]

        ]
        ,addTask model
    ]