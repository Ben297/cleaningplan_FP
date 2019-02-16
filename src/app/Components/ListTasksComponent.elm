module ListTasksComponent exposing (..)

import Html exposing (..)
import Bootstrap.Grid as Grid

import HouseTask exposing (Task)
import Msg exposing (Msg)


listTasks: List Task -> Grid.Column Msg
listTasks tasks = Grid.col [] (List.map getTextFromTasks tasks)


getTextFromTasks : Task -> Html Msg
getTextFromTasks task = div [] [text (task.displayName ++ "\n currently resposible:" ++ task.currentlyResponsible.name)]