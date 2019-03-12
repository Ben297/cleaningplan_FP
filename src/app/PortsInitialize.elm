port module PortsInitialize exposing (..)

import Msg exposing (Msg(..))

--outgoing ports
port initialFetch: () -> Cmd msg

--incoming ports

