module View exposing (view)

import Html exposing (Html, button, div, text)
import Html.Attributes as Attr exposing (id, class, classList)
import Html.Events exposing (onClick)
import Msg exposing (..)
import Model exposing (Model)
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import List
import Person exposing (Person)
import HouseTask exposing (Task)
import Task
import Time exposing (Posix)
import Time.Extra exposing (Interval(..))
import Formatters exposing (getFormatedStringFromDate)
import DayTasksComponent exposing (dayTasks)
import ListPeopleComponent exposing (listPeople)
import ListTasksComponent exposing (listTasks)

view : Model -> Html Msg
view model =
    Grid.container []
    [
        CDN.stylesheet -- creates an inline style node with the Bootstrap CSS
        , Grid.row []
        [
            Grid.col []
            [
                button [ onClick Increment ] [ text "+1" ]
                , div [] [ text <| String.fromInt model.count ]
                , button [ onClick Decrement ] [ text "-1" ]
            ]
            , listPeople model.people
            , listTasks model.tasks
            , Grid.col []
            [
                text ( "Number of people: " ++ (String.fromInt (List.length model.people)) ++ "\nNumber of Tasks: " ++ (String.fromInt (List.length model.tasks)) )
            ]
            , Grid.col[]
            [
                button [ onClick Increment ] [ text "+1" ]
                , div [] [ text <| String.fromInt model.count ]
                , button [ onClick Decrement ] [ text "-1" ]
            ]
        ]
        , dayTasks model
    ]
