module View exposing (view)

import Html exposing (Html, button, div, text)
import Html.Attributes as Attr exposing (id, class, classList)
import Html.Events exposing (onClick)
import Msg exposing (..)
import Model exposing (Model)

view : Model -> Html Msg
view model =
    div [Attr.id "MainDiv"]
        [ button [ onClick Increment ] [ text "+1" ]
        , div [] [ text <| String.fromInt model.count ]
        , button [ onClick Decrement ] [ text "-1" ]
        ]