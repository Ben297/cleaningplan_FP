module Msg exposing (Msg(..), DisplayType(..))
import Time

type Msg
    = Increment
    | Decrement
    | TaskDone String
    | AdjustTimeZone Time.Zone
    | Tick Time.Posix
    | ChangeViewTo DisplayType

type DisplayType =
    MainView
    | NextWeekView
    | PreviousWeekView
    | AddPersonView
    | AddTaskView