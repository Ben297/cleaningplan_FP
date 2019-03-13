module AddPersonView exposing (addPersonView)

import Html exposing (..)
import Html.Events exposing (onClick)
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid

import Model exposing (Model)
import Msg exposing (Msg(..), DisplayType(..))
import ListPeopleComponent exposing (listPeople)
import ListTasksComponent exposing (listTasks)
import AddPersonComponent exposing (addPerson)


addPersonView : Model -> Html Msg
addPersonView model =
    Grid.container []
    [
        CDN.stylesheet -- creates an inline style node with the Bootstrap CSS
        , Grid.row []
        [
            Grid.col []
            [
                text "AddPersonView.elm"
                , button [ onClick (ChangeViewTo MainView) ] [ text "return to Main" ]
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
        , addPerson model
    ]