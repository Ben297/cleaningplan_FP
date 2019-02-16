module ListTasksComponent exposing (..)

import Html exposing (..)
import Bootstrap.Grid as Grid

import HouseTask exposing (Task)
import Msg exposing (Msg)
import Formatters exposing (getFormatedStringFromDate, boolToString)
import Time
import Model exposing (Model)

listTasks: Model -> Grid.Column Msg
listTasks model = Grid.col [] (List.map (getTextFromTasks model.timeZone ) model.tasks)


getTextFromTasks : Time.Zone -> Task -> Html Msg
getTextFromTasks timeZone task = div [] [text ("\n Displayname:" ++ task.displayName ++ "\n Description:" ++ task.description ++
                                               "\n currently resposible:" ++ task.currentlyResponsible.name ++
                                               "\n DueDate:" ++ getFormatedStringFromDate timeZone task.dueDate ++ "\n isRepetitiveTask?:" ++ (boolToString task.isRepetitiveTask))]
