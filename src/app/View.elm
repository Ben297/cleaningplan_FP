module View exposing (view)

import Html exposing (Html, button, div, text)
import Html.Attributes as Attr exposing (id, class, classList)
import Html.Events exposing (onClick)
import Msg exposing (..)
import Model exposing (Model)
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import List
import Person exposing (Person)
import HouseTask exposing (Task)
import Task
import Time exposing (Month(..), Weekday(..), now, Posix)
import Time.Extra exposing (Interval(..), Parts, partsToPosix)

view : Model -> Html Msg
view model =
    Grid.container []
    [
        CDN.stylesheet -- creates an inline style node with the Bootstrap CSS
        , Grid.row []
        [
            Grid.col []
            [
                button [ onClick Increment ] [ text "+1" ]
                , div [] [ text <| String.fromInt model.count ]
                , button [ onClick Decrement ] [ text "-1" ]
            ]
            , Grid.col [] (List.map getTextFromPerson model.people)
            , Grid.col [] (List.map getTextFromTasks model.tasks)
            , Grid.col []
            [
                text ( "Number of people: " ++ (String.fromInt (List.length model.people)) ++ "\nNumber of Tasks: " ++ (String.fromInt (List.length model.tasks)) )
            ]
            , Grid.col[]
            [
                button [ onClick Increment ] [ text "+1" ]
                , div [] [ text <| String.fromInt model.count ]
                , button [ onClick Decrement ] [ text "-1" ]
            ]
        ]
        , Grid.row []
        [
            Grid.col [] (List.map (getTaskCardFromTasks model.timeZone) model.tasks)
            , Grid.col [] (List.map (getTaskCardFromTasks model.timeZone) (List.filter (taskIsStillValid model.timeZone model.time) model.tasks))
            , Grid.col []
            [
                div []
                [
                    text "time: "
                ]
                , div []
                [
                    text (getFormatedStringFromDate model.timeZone model.time)
                ]
            ]
        ]
    ]

taskIsStillValid: Time.Zone -> Posix -> Task -> Bool
taskIsStillValid timeZone currentTime task =
    let
        diffBeforeNow = Time.Extra.diff Minute timeZone task.dueDate currentTime
    in
        diffBeforeNow < 0

getTaskCardFromTasks: Time.Zone -> Task -> Html Msg
getTaskCardFromTasks timeZone task =
    Grid.row []
    [
        Grid.col []
        [
            div []
            [
                text "Task: "
            ]
            , div []
            [
                text task.displayName
            ]
            , div []
            [
                text "Responsible: "
            ]
            , div []
            [
                text task.currentlyResponsible.name
            ]
            , div []
            [
                text "To-Do until: "
            ]
            , div []
            [
                text (getFormatedStringFromDate timeZone task.dueDate)
            ]
        ]
    ]

getFormatedStringFromDate: Time.Zone -> Posix -> String
getFormatedStringFromDate timeZone date =
        let
            year   = String.fromInt (Time.toYear timeZone date)
            month  = String.fromInt (monthToInt (Time.toMonth timeZone date))
            day    = String.fromInt (Time.toDay timeZone date)
            hour   = String.fromInt (Time.toHour timeZone date)
            minute = String.fromInt (Time.toMinute timeZone date)
            second = String.fromInt (Time.toSecond timeZone date)
        in
            (day ++ "." ++ month ++ "." ++ year ++ "; " ++ hour ++ ":" ++ minute ++ ":" ++ second)

getTextFromPerson : Person -> Html Msg
getTextFromPerson person = div [] [text person.name]

getTextFromTasks : Task -> Html Msg
getTextFromTasks task = div [] [text task.displayName]

toJapaneseWeekday : Weekday -> String
toJapaneseWeekday weekday =
  case weekday of
    Mon -> "月"
    Tue -> "火"
    Wed -> "水"
    Thu -> "木"
    Fri -> "金"
    Sat -> "土"
    Sun -> "日"

monthToInt: Time.Month -> Int
monthToInt month = case month of
    Jan -> 1
    Feb -> 2
    Mar -> 3
    Apr -> 4
    May -> 5
    Jun -> 6
    Jul -> 7
    Aug -> 8
    Sep -> 9
    Oct -> 10
    Nov -> 11
    Dec -> 12