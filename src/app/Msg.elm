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
    | AddTaskPersonDropdown String
    | MyDrop1Msg Dropdown.State
    | AddTaskName String
    | SubmitTask
    | AddTaskDescription String
    | AddTaskDueDate String
    | AddTaskDueTime String
    | AddTaskIsRepetitiveTask Bool



type DisplayType =
    MainView
    | NextWeekView
    | PreviousWeekView
    | AddPersonView
    | AddTaskView