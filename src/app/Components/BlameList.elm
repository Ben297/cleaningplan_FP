module BlameList exposing (..)

import Model exposing (Model)
import Msg exposing (Msg(..))
import Bootstrap.Table as Table
import Html exposing (..)

import Bootstrap.Grid as Grid
import Bootstrap.Button as Button
import Person exposing (Person)

import Formatters exposing (getFormatedStringFromDate)

showBlamelist : Model -> Html Msg
showBlamelist model =
    Grid.row []
        [
            Grid.col []
            [
                Table.table
                    { options = [  Table.hover, Table.bordered ]
                    , thead =  Table.simpleThead
                        [ Table.th [] [ text "Person" ]
                        , Table.th [] [ text "#Tasks not done"]
                        ]

                    , tbody =
                        Table.tbody [] (List.map mapPeopleToRows (List.reverse (List.sortBy .blameCounter (List.filter filterFunction model.people))))
                    }
            ]
        ]



mapPeopleToRows: Person -> Table.Row msg
mapPeopleToRows person =
    Table.tr []
    [ Table.td [] [ text person.name ]
    , Table.td [] [ text (String.fromInt person.blameCounter) ]
    ]

filterFunction: Person -> Bool
filterFunction person = person.blameCounter > 0