module Msg exposing (Msg(..), DisplayType(..))
import Time
import Bootstrap.Dropdown as Dropdown

type Msg
    = Increment
    | Decrement
    | TaskDone Int
    | AdjustTimeZone Time.Zone
    | Tick Time.Posix
    | ChangeViewTo DisplayType
    | AddPersonName String
    | SubmitPerson
    | AddTaskPersonDropdown Int
    | MyDrop1Msg Dropdown.State

type DisplayType =
    MainView
    | NextWeekView
    | PreviousWeekView
    | AddPersonView
    | AddTaskView