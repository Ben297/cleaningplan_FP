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
            , Grid.col [] (List.map getTextFromPerson model.people)
            , Grid.col [] (List.map getTextFromTasks model.tasks)
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
    ]

getTextFromPerson : Person -> Html Msg
getTextFromPerson person = div [] [text person.name]

getTextFromTasks : Task -> Html Msg
getTextFromTasks task = div [] [text task.displayName]