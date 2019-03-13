module AddPersonComponent exposing (..)

import Model exposing (Model)
import Msg exposing (Msg(..))

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Dropdown as Dropdown
import Bootstrap.Button as Button

addPerson : Model -> Html Msg
addPerson model =
    Grid.row []
        [
            Grid.col []
            [
                viewInput "text" "Name" model.tmpPerson.name AddPersonName
                , button [onClick SubmitPerson] [text "Submit"]

            ]
        ]

viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
  input [ type_ t, placeholder p, value v, onInput toMsg ] []