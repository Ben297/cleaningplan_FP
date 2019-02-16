port module Ports exposing (..)

import Bootstrap.Dropdown as Dropdown
import Model exposing (Model)
import Msg exposing (Msg(..))

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Dropdown.subscriptions model.myDrop1State MyDrop1Msg ]