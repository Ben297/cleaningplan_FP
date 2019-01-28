module Model exposing (Model, init)

import Msg exposing (Msg)

type alias Model =
    { count : Int }


init : Int -> (Model, Cmd Msg)
init flags = (Model 0, Cmd.none)

