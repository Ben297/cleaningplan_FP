module AddTaskComponent exposing (..)

import Model exposing (Model)
import Msg exposing (Msg(..))

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Dropdown as Dropdown exposing (DropdownItem)
import Bootstrap.Button as Button
import Person exposing (Person)


addTask : Model -> Html Msg
addTask model =
    Grid.row []
        [
            Grid.col []
            [
                viewInput "text" "Task-Description" model.tmpTask.displayName AddTaskName
                ,div []
                [ Dropdown.dropdown
                     model.myDrop1State
                     { options = [ ]
                     , toggleMsg = MyDrop1Msg
                     , toggleButton =
                         Dropdown.toggle [ Button.primary ] [ text "person responsible" ]
                     , items = List.map peopleToItems model.people


                     }

                 -- etc
                ]
                ,Button.button [ Button.primary, Button.attrs [onClick SubmitTask] ] [ text "Submit" ]

            ]

        ]

viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
  input [ type_ t, placeholder p, value v, onInput toMsg ] []

peopleToItems : Person -> DropdownItem Msg
peopleToItems person =  Dropdown.buttonItem [ onClick (AddTaskPersonDropdown person.id) ] [ text person.name ]

