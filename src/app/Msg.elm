module Msg exposing (Msg(..), DisplayType(..))
import Time

type Msg
    = Increment
    | Decrement
    | TaskDone Int
    | AdjustTimeZone Time.Zone
    | Tick Time.Posix
    | ChangeViewTo DisplayType
    | AddPersonName String
    | SubmitPerson

type DisplayType =
    MainView
    | NextWeekView
    | PreviousWeekView
    | AddPersonView
    | AddTaskView