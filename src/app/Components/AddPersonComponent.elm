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
                , div []
                    [ Dropdown.dropdown
                        model.myDrop1State
                        { options = [ ]
                        , toggleMsg = MyDrop1Msg
                        , toggleButton =
                            Dropdown.toggle [ Button.primary ] [ text "My dropdown" ]
                        , items =
                            [ Dropdown.buttonItem [ onClick (AddTaskPersonDropdown 1) ] [ text "Peter 1" ]
                            , Dropdown.buttonItem [ onClick (AddTaskPersonDropdown 2) ] [ text "Pan 2" ]
                            ]
                        }

                    -- etc
                    ]
            ]
        ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
  input [ type_ t, placeholder p, value v, onInput toMsg ] []