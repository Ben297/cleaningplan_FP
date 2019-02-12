module Main exposing (main)

import Browser
import Msg exposing (..)
import Model exposing (init, Model, initMockup)
import View exposing (view)
import Update exposing (update)


main : Program Int Model Msg
main =
    Browser.element
        { init = initMockup
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none