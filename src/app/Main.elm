module Main exposing (main)

import Browser
import MainView exposing (mainView)
import Msg exposing (..)
import Model exposing (init, Model, Flags)
import Update exposing (update, decodeTaskValue)
import Time
import Ports exposing (..)

main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = mainView
        , update = update 
        , subscriptions = subscriptions
        }

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every 1000 Tick, loadpeople UpdatePeople, loadtasks (decodeTaskValue)]
