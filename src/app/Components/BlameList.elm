module BlameList exposing (..)

import Model exposing (Model)
import Msg exposing (Msg(..))
import Bootstrap.Table as Table
import Html exposing (..)

import Bootstrap.Grid as Grid

import Bootstrap.Button as Button

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
                        , Table.th [] [ text "Task not done"]
                        ]

                    , tbody =
                        Table.tbody []
                            [ Table.tr []
                                [ Table.td [] [ text "Eintrag1" ]
                                , Table.td [] [ text "Eintrag2"]
                                ]

                            ]

                    }


            ]


        ]