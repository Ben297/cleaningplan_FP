module Msg exposing (..)
import Time

type Msg
    = Increment
    | Decrement
    | AdjustTimeZone Time.Zone
    | Tick Time.Posix