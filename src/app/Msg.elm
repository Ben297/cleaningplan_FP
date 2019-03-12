module Msg exposing (Msg(..), DisplayType(..))
import Time
import Bootstrap.Dropdown as Dropdown
import Bootstrap.Navbar as Navbar

import Person exposing (Person)
import HouseTask as MyTask exposing (Task)

import Json.Encode as E

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
    | NavbarMsg Navbar.State
    | ShowModalAddTask
    | CloseModalAddTask
    | ShowModalBlamelist
    | CloseModalBlamelist
    | UpdatePeople (List Person)
    | UpdateTask (List Task)
    | TaskErr String

type DisplayType =
    MainView
    | NextWeekView
    | PreviousWeekView
    | AddPersonView
    | AddTaskView
