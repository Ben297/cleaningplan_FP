module AddPersonComponent exposing (..)

import Model exposing (Model)
import Msg exposing (Msg(..))

import Html.Events exposing (onClick, onInput)
import Msg exposing (Msg(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Select as Select exposing (Item)
import Bootstrap.Form.Checkbox as Checkbox
import Bootstrap.Card as Card
import Bootstrap.Form.Textarea as Textarea
import Bootstrap.Form.Fieldset as Fieldset
import Bootstrap.Button as Button
import Bootstrap.Dropdown as Dropdown exposing (DropdownItem)
import Bootstrap.Button as Button

addPerson : Model -> Html Msg
addPerson model =
    Grid.row []
        [
            Grid.col []
            [
                Form.form []
                    [ Form.group []
                        [ label [for "name"] [ text "Name:"]
                        , Input.text [ Input.id "name", Input.value model.tmpPerson.name, Input.onInput AddPersonName ]
                        ]
                    ]
                ,Button.button [ Button.primary, Button.attrs [onClick SubmitPerson] ] [ text "Submit" ]
            ]
        ]
--
--    Grid.row []
--        [
--            Grid.col []
--            [
--                viewInput "text" "Name" model.tmpPerson.name AddPersonName
--                , button [onClick SubmitPerson] [text "Submit"]
--
--            ]
--        ]
--
--viewInput : String -> String -> String -> (String -> msg) -> Html msg
--viewInput t p v toMsg =
--  input [ type_ t, placeholder p, value v, onInput toMsg ] []

