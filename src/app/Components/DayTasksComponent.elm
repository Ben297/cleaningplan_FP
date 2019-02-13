module DayTasksComponent exposing (dayTasks)

import Time exposing (Posix)
import Time.Extra exposing (Interval(..))
import Html exposing (..)
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import List

import HouseTask as Task exposing (Task)
import Person exposing (Person)
import Msg exposing (Msg)
import Model exposing (Model)
import Formatters exposing (getFormatedStringFromDate)


--  floor : Interval -> Zone -> Posix -> Posix
dayTasks: Model -> Html Msg
dayTasks model =
    let
        timeZone = model.timeZone
        time = model.time
        tasks = model.tasks
        beginningOfWeekAtNow = Time.Extra.posixToParts timeZone (Time.Extra.floor Week timeZone time)
        beginningOfWeekAtNowBeginning = {beginningOfWeekAtNow | hour = 23, minute = 59}
        mondayTime      =   Time.Extra.add Day 0 timeZone (Time.Extra.partsToPosix timeZone beginningOfWeekAtNowBeginning)
        tuesdayTime     =   Time.Extra.add Day 1 timeZone (Time.Extra.partsToPosix timeZone beginningOfWeekAtNowBeginning)
        wednesdayTime   =   Time.Extra.add Day 2 timeZone (Time.Extra.partsToPosix timeZone beginningOfWeekAtNowBeginning)
        thursdayTime    =   Time.Extra.add Day 3 timeZone (Time.Extra.partsToPosix timeZone beginningOfWeekAtNowBeginning)
        fridayTime      =   Time.Extra.add Day 4 timeZone (Time.Extra.partsToPosix timeZone beginningOfWeekAtNowBeginning)
        saturdayTime    =   Time.Extra.add Day 5 timeZone (Time.Extra.partsToPosix timeZone beginningOfWeekAtNowBeginning)
        sundayTime      =   Time.Extra.add Day 6 timeZone (Time.Extra.partsToPosix timeZone beginningOfWeekAtNowBeginning)
    in
    Grid.row []
    [
        Grid.col []
        ( [
           div []
           [
                h1 []
                [
                    text ("Monday: " ++ (getFormatedStringFromDate timeZone mondayTime))
                ]
           ]
        ] ++ (List.map (getTaskCardFromTasks timeZone) (List.filter (taskIsStillValid timeZone mondayTime) tasks)) )
        , Grid.col []
        ( [
            div []
            [
                h1 []
                [
                    text ("Tuesday: " ++ (getFormatedStringFromDate timeZone tuesdayTime))
                ]
            ]
        ] ++ (List.map (getTaskCardFromTasks timeZone) (List.filter (taskIsStillValid timeZone tuesdayTime) tasks)) )
        , Grid.col []
        ( [
            div []
            [
                h1 []
                [
                    text ("Wednesday: " ++ (getFormatedStringFromDate timeZone wednesdayTime))
                ]
            ]
        ] ++ (List.map (getTaskCardFromTasks timeZone) (List.filter (taskIsStillValid timeZone wednesdayTime) tasks)) )
        , Grid.col []
        ( [
            div []
            [
                h1 []
                [
                    text ("Thursday: " ++ (getFormatedStringFromDate timeZone thursdayTime))
                ]
            ]
        ] ++ (List.map (getTaskCardFromTasks timeZone) (List.filter (taskIsStillValid timeZone thursdayTime) tasks)) )
        , Grid.col []
        ( [
            div []
            [
                h1 []
                [
                    text ("Friday: " ++ (getFormatedStringFromDate timeZone fridayTime))
                ]
            ]
        ] ++ (List.map (getTaskCardFromTasks timeZone) (List.filter (taskIsStillValid timeZone fridayTime) tasks)) )
        , Grid.col []
        ( [
            div []
            [
                h1 []
                [
                    text ("Saturday: " ++ (getFormatedStringFromDate timeZone saturdayTime))
                ]
            ]
        ] ++ (List.map (getTaskCardFromTasks timeZone) (List.filter (taskIsStillValid timeZone saturdayTime) tasks)) )
        , Grid.col []
        ( [
            div []
            [
                h1 []
                [
                    text ("Sunday: " ++ (getFormatedStringFromDate timeZone sundayTime))
                ]
            ]
        ] ++ (List.map (getTaskCardFromTasks timeZone) (List.filter (taskIsStillValid timeZone sundayTime) tasks)) )
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

