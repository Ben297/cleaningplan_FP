module AddTaskComponent exposing (..)

import Model exposing (Model)
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
import Person exposing (Person)
import Formatters exposing (getFormatedStringFromDate)

addTask : Model -> Html Msg
addTask model =
    Grid.row []
        [
            Grid.col []
            [
                Form.form []
                    [ Form.group []
                        [ label [for "displayName"] [ text "Name:"]
                        , Input.text [ Input.id "displayName", Input.value model.tmpTask.displayName, Input.onInput AddTaskName ]
                        ]
                    , Form.group []
                        [ label [ for "description"] [ text "Description:"]
                        , Textarea.textarea
                            [ Textarea.id "description"
                            , Textarea.rows 3
                            , Textarea.value model.tmpTask.description
                            , Textarea.onInput AddTaskDescription
                            ]
                        ]
                    , Form.group []
                        [ Form.label [ for "responsible" ] [ text "Person responsible for the Task:" ]
                        , Select.select [ Select.id "responsible", Select.onChange AddTaskPersonDropdown ] (List.map peopleToItems model.people )
                        ]
                    , Form.group []
                        [ Form.label [for "dueDate"] [ text "Due Date"]
                        , Input.date [Input.id "dueDate", Input.onInput AddTaskDueDate ]
                        ]
                    , Form.group []
                        [ Form.label [for "dueTime"] [ text "Due Time"]
                        , Input.time [Input.id "dueTime", Input.onInput AddTaskDueTime ]
                        ]
                    , Form.group []
                        [Checkbox.checkbox [Checkbox.id "isRepetitiveTask", Checkbox.checked model.tmpTask.isRepetitiveTask ,Checkbox.onCheck AddTaskIsRepetitiveTask ] "weekly repeatable? "]
                    ]
                ,Button.button [ Button.primary, Button.attrs [onClick SubmitTask] ] [ text "Submit" ]
            ]
        ]

viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
  input [ type_ t, placeholder p, value v, onInput toMsg ] []

peopleToItems : Person -> Item Msg
peopleToItems person =  Select.item [value (String.fromInt person.id)] [ text person.name]

