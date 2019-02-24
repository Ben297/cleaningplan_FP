module MainView exposing (mainView)

import Html exposing (..)
import Html.Events exposing (onClick)
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row
import Bootstrap.Grid.Col as Col
import Bootstrap.Navbar as Navbar
import Bootstrap.Button as Button
import Html.Attributes exposing (..)
import Model exposing (Model)
import Msg exposing (Msg(..), DisplayType(..))
import ListPeopleComponent exposing (listPeople)
import ListTasksComponent exposing (listTasks)
import DayTasksComponent exposing (dayTasks)

mainView : Model -> Html Msg
mainView model =
    Grid.containerFluid []
    [
        CDN.stylesheet -- creates an inline style node with the Bootstrap CSS
        , Grid.row [ ]
        [
           Grid.col[]
           [ Navbar.config NavbarMsg
                                    |> Navbar.withAnimation
                                    |> Navbar.brand [ href "#"] [ text "Cleaningplan - Clean your Apartment"]
                                    |> Navbar.dark
                                    |> Navbar.items
                                        [ Navbar.itemLink [ onClick (ChangeViewTo PreviousWeekView) ] [ text "Previous Week" ]
                                        , Navbar.itemLink [ onClick (ChangeViewTo AddTaskView) ] [ text "Add a new Task" ]
                                        , Navbar.itemLink [ onClick (ChangeViewTo AddPersonView) ] [ text "Add a Person" ]
                                        , Navbar.itemLink [ onClick (ChangeViewTo AddPersonView) ] [ text "Blamelist" ]
                                        , Navbar.itemLink [ onClick (ChangeViewTo NextWeekView) ] [ text "Next Week"]
                                        ]
                                    |> Navbar.view model.navbarState
           ]
        ]
        , Grid.row [Row.centerXs]
        [
            Grid.col[]
            [
                h1[]
                [
                text ("DEBUGINFORMATION" )
                ]
            ]
        ]
        , Grid.row []
        [
              listPeople model.people
            , listTasks model
            , Grid.col []
            [
                text ( "Number of people: " ++ (String.fromInt (List.length model.people)) ++ "\nNumber of Tasks: " ++ (String.fromInt (List.length model.tasks)) )
            ]
        ]
        , Grid.row []
        [
             Grid.col []
            [
            dayTasks model 0
            ]
        ]



    ]


