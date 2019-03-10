port module Ports exposing (..)

import Bootstrap.Dropdown as Dropdown
import Model exposing (Model)
import Msg exposing (Msg(..))

import Person exposing (Person)
import HouseTask as MyTask exposing (Task)
import Json.Encode as E

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Dropdown.subscriptions model.myDrop1State MyDrop1Msg ]

--outgoing ports
port saveperson : Person -> Cmd msg
port savetask: E.Value -> Cmd msg 

--incoming ports
port loadpeople : (List Person -> msg) -> Sub msg
port loadtasks : (E.Value -> msg) -> Sub msg
