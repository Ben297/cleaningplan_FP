module PreviousWeekView exposing (previousWeekView)

import Html exposing (..)
import Html.Events exposing (onClick)
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid

import Model exposing (Model)
import Msg exposing (Msg(..), DisplayType(..))
import ListPeopleComponent exposing (listPeople)
import ListTasksComponent exposing (listTasks)
import DayTasksComponent exposing (dayTasks)


previousWeekView : Model -> Html Msg
previousWeekView model =
    Grid.container []
    [
        CDN.stylesheet -- creates an inline style node with the Bootstrap CSS
        , Grid.row []
        [
            Grid.col []
            [
                text "PreviousWeekView"
                , button [ onClick (ChangeViewTo MainView) ] [ text "return to Main" ]
            ]
        ]
        , dayTasks model -1
    ]