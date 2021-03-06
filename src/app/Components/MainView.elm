module MainView exposing (mainView)

import AddPersonComponent exposing (addPerson)
import Html exposing (..)
import Html.Events exposing (onClick)
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row
import Bootstrap.Grid.Col as Col
import Bootstrap.Navbar as Navbar
import Bootstrap.Button as Button
import Bootstrap.Modal as Modal
import Html.Attributes exposing (..)
import Model exposing (Model)
import Msg exposing (Msg(..), DisplayType(..))
import ListPeopleComponent exposing (listPeople)
import ListTasksComponent exposing (listTasks)
import DayTasksComponent exposing (dayTasks)
import AddTaskComponent exposing (addTask)
import BlameList exposing (showBlamelist)

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
                , Navbar.itemLink [ onClick (ChangeViewTo MainView) ] [ text "This Week" ]
                , Navbar.itemLink [ onClick (ChangeViewTo NextWeekView) ] [ text "Next Week"]
                ]

            |> Navbar.view model.navbarState
           ]
        ]
        , Grid.row [Row.centerXs]
        [
            Grid.col[]
                [ Button.button
                     [ Button.attrs [ onClick ShowModalAddPerson ] ]
                    [ text "Add a Person" ]
                , Modal.config CloseModalAddPerson
                    |> Modal.small
                    |> Modal.h5 [] [ text "Add a Person" ]
                    |> Modal.body []
                        [
                            addPerson model
                        ]
                    |> Modal.footer []
                        [ Button.button
                            [ Button.outlinePrimary
                            , Button.attrs [ onClick CloseModalAddPerson ]
                            ]
                            [ text "Close" ]
                        ]
                    |> Modal.view model.modalAddPerson
                ]
        ]
        , Grid.row [Row.centerXs]
        [
             Grid.col[]
            [ Button.button
                [ Button.attrs [ onClick ShowModalAddTask ] ]
                [ text "Add a Task" ]
            , Modal.config CloseModalAddTask
                |> Modal.small
                |> Modal.h5 [] [ text "Add a Task" ]
                |> Modal.body []
                    [
                    addTask model
                    ]
                |> Modal.footer []
                    [ Button.button
                        [ Button.outlinePrimary
                        , Button.attrs [ onClick CloseModalAddTask ]
                        ]
                        [ text "Close" ]
                    ]
                |> Modal.view model.modalAddTask
            ]
        ]
        , Grid.row [Row.centerXs]
        [
            Grid.col[]
            [ Button.button
                [ Button.attrs [ onClick ShowModalBlamelist ] ]
                [ text "Blamelist" ]
            , Modal.config CloseModalBlamelist
                |> Modal.small
                |> Modal.h5 [] [ text "Blamelist" ]
                |> Modal.body []
                    [
                    showBlamelist model
                    ]
                |> Modal.footer []
                    [ Button.button
                        [ Button.outlinePrimary
                        , Button.attrs [ onClick CloseModalBlamelist ]
                        ]
                        [ text "Close" ]
                    ]
                |> Modal.view model.modalShowBlamelist
            ]
        ]
        , Grid.row []
        [

            Grid.col []
            [
                case model.view of
                    MainView ->
                        dayTasks model 0
                    NextWeekView ->
                        dayTasks model 1
                    PreviousWeekView ->
                        dayTasks model -1
                    _ ->
                        dayTasks model 0
            ]
        ]
    ]
