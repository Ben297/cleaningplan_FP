module ListPeopleComponent exposing (listPeople)

import List
import Html exposing (Html, button, div, text)
import Html.Attributes as Attr exposing (id, class, classList)
import Bootstrap.Grid as Grid

import Person exposing (Person)
import Msg exposing (Msg)
import Html exposing (..)


listPeople: List Person ->  Grid.Column Msg
listPeople people = Grid.col [] (List.map getTextFromPerson people)


getTextFromPerson : Person -> Html Msg
getTextFromPerson person = div [] [text person.name]

