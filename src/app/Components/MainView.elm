module MainView exposing (mainView)

import Html exposing (..)
import Html.Events exposing (onClick)
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid

import Model exposing (Model)
import Msg exposing (Msg(..), DisplayType(..))
import ListPeopleComponent exposing (listPeople)
import ListTasksComponent exposing (listTasks)
import DayTasksComponent exposing (dayTasks)

mainView : Model -> Html Msg
mainView model =
    Grid.container []
    [
        CDN.stylesheet -- creates an inline style node with the Bootstrap CSS
        , Grid.row []
        [
            Grid.col []
            [
                button [ onClick (ChangeViewTo NextWeekView) ] [ text "to Next Week" ]
                , button [ onClick (ChangeViewTo PreviousWeekView) ] [ text "to Previous Week" ]
                , button [ onClick (ChangeViewTo AddPersonView) ] [ text "add Person" ]
                , button [ onClick (ChangeViewTo AddTaskView) ] [ text "add Task" ]
            ]
            , listPeople model.people
            , listTasks model
            , Grid.col []
            [
                text ( "Number of people: " ++ (String.fromInt (List.length model.people)) ++ "\nNumber of Tasks: " ++ (String.fromInt (List.length model.tasks)) )
            ]
            , Grid.col[]
            [
                button [ onClick Increment ] [ text "+1" ]
                , div [] [ text <|  model.count ]
                , button [ onClick Decrement ] [ text "-1" ]
            ]
        ]
        , dayTasks model 0
    ]
