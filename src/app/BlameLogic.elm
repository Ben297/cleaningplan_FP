module BlameLogic exposing (..)

import List.Extra
import Time exposing (Month(..), Weekday(..), Posix)
import Time.Extra exposing (Interval(..), partsToPosix, Parts)

import Person exposing (..)
import HouseTask as Task exposing (..)
import Debug exposing (log)

type alias PeopleAndTasks = {
        people: List Person,
        tasks: List Task
    }

getNewTasksAndPeople: Time.Zone -> Posix -> List Person -> List Task -> PeopleAndTasks
getNewTasksAndPeople timeZone currentTime people tasks =
    let
        tuple = iterateOverTasks timeZone currentTime people tasks
        newTasks = Tuple.second tuple
        newPeople = Tuple.first tuple
    in
        PeopleAndTasks newPeople newTasks

iterateOverTasks: Time.Zone -> Posix -> List Person -> List Task -> (List Person, List Task)
iterateOverTasks timeZone currentTime people tasks =
    let
        workToDo = isWorkToDo timeZone currentTime tasks
    in
        if workToDo
        then
            let
                tuple = forEachTask timeZone currentTime 0 (List.length tasks) tasks people
                newTasks = Tuple.second tuple
                newPeople = Tuple.first tuple
            in
                iterateOverTasks timeZone currentTime newPeople newTasks
        else
            (people, tasks)

forEachTask: Time.Zone -> Posix -> Int -> Int -> List Task -> List Person -> (List Person, List Task)
forEachTask timeZone currentTime index length tasks people =
    if (index < length)
    then
        let
            maybeTask = List.Extra.getAt index tasks
        in
            case maybeTask of
                Just task ->
                    let
                        newTask = mainLogic timeZone currentTime people task
                        newPeople = updatePeopleFromTask people newTask
                        newMaybeTasks = List.Extra.setAt index newTask tasks
                    in
                        forEachTask timeZone currentTime (index + 1) length newMaybeTasks newPeople
--                        case newMaybeTasks of
--                            Just newTasks ->
--                                forEachTask timeZone currentTime (index + 1) length newTasks newPeople
--                            Nothing ->
--                                forEachTask timeZone currentTime (index + 1) length tasks newPeople
                Nothing ->
                    (people, tasks)
    else
        (people, tasks)

--  Algorithm:
--  1. Check if lastDone is not the emptyValue-Date
--  2. Check if currentTime is not between lastDone and DueDate
--  3. Add one Week to dueDate if Task is repetitive
--  4. Set lastDone to old dueDate
--  5. Add one to the BlameCounter of the currentlyResponsible and set new responsible Person
mainLogic: Time.Zone -> Posix -> List Person -> Task -> Task
mainLogic timeZone currentTime people task =
    let
        dueDate = task.dueDate
        lastDone = task.lastDone
    in
        if (timeIsEqual timeZone Minute lastDone (emptyDate timeZone))
        then
            task
        else
            --  not the emptyDate
            if (isBefore timeZone currentTime dueDate) && (not (isBefore timeZone currentTime lastDone))
            then
                task
            else
                let
                    nextResponsiblePerson = getNextPersonResponsible people task.currentlyResponsible
                    updatedLastDoneBy = findPersonByIdAndIncrementBlame people task.currentlyResponsible.id
                    nextDueDate = if task.isRepetitiveTask then Time.Extra.add Week 1 timeZone task.dueDate else task.dueDate
                    newTask = {task | currentlyResponsible = nextResponsiblePerson, lastDoneBy = updatedLastDoneBy, lastDone = task.dueDate, dueDate = nextDueDate}
                in
                    newTask

updatePeopleFromTask: List Person -> Task -> List Person
updatePeopleFromTask people task =
    let
        mapFunction = \person -> if person.id == task.lastDoneBy.id then task.currentlyResponsible else person
    in
        List.map mapFunction people

getNewTasks: Time.Zone -> Posix -> List Task -> List Person -> List Task
getNewTasks timeZone currentTime tasks people =
    let
        updatedTasks = List.map (updateTasks people) tasks
    in
        []

isWorkToDo:  Time.Zone -> Posix -> List Task -> Bool
isWorkToDo  timeZone currentTime tasks = List.any (isWorkToDoHelp timeZone currentTime) tasks

isWorkToDoHelp: Time.Zone -> Posix -> Task -> Bool
isWorkToDoHelp timeZone currentTime task =
    let
        isBetween = (isBefore timeZone currentTime task.dueDate) && (not (isBefore timeZone currentTime task.lastDone))
        isNotBetween = not isBetween
        hasBeenDoneBefore = timeIsEqual timeZone Minute task.lastDone (emptyDate timeZone)
        isRepetable = task.isRepetitiveTask
    in
        isRepetable && hasBeenDoneBefore && isNotBetween

getNextPersonResponsible: List Person -> Person -> Person
getNextPersonResponsible people currentlyResponsible =
    let
        personIndex = List.Extra.findIndex (\elem -> elem.id == currentlyResponsible.id) people
    in
        case personIndex of
            Just val ->
                let
                    length = List.length people
                    index = Basics.modBy length (val + 1)
                    tmp = List.Extra.getAt index people
                in
                    case tmp of
                        Just result ->
                            result
                        Nothing ->
                            currentlyResponsible
            Nothing ->
                currentlyResponsible

updateTasks: List Person -> Task -> Task
updateTasks people task =
    let
        findPersonFunc = \elem -> elem.id == task.currentlyResponsible.id
        responsiblePerson = List.Extra.find findPersonFunc people
    in
        case responsiblePerson of
            Just val ->
                {task | currentlyResponsible = val}
            Nothing ->
                task

timeIsEqual: Time.Zone -> Interval -> Posix -> Posix -> Bool
timeIsEqual timeZone precision time1 time2 = (Time.Extra.diff precision timeZone time1 time2) == 0

findPersonByIdAndIncrementBlame: List Person -> Int -> Person
findPersonByIdAndIncrementBlame people id =
    let
        findPersonFunk = \elem -> elem.id == id
        person = List.Extra.find findPersonFunk people
    in
        case person of
            Just val ->
                {val | blameCounter = val.blameCounter + 1}
            Nothing ->
                nobody

setPersonById: List Person -> Int -> Person -> List Person
setPersonById people id newPerson =
    let
        mapFunc = (\elem -> if elem.id == id
                    then
                        {newPerson | id = elem.id}
                    else
                        elem
                  )
    in
        List.map mapFunc people

--  checks if time1 is before time2
isBefore: Time.Zone -> Posix -> Posix -> Bool
isBefore timeZone time1 time2 =
    let
        timeDiff = Time.Extra.diff Minute timeZone time1 time2
    in
        timeDiff > 0

getBeginningOfDay: Time.Zone -> Posix -> Posix
getBeginningOfDay timeZone date =
        let
            asParts = Time.Extra.posixToParts timeZone date
            newDate = {asParts | hour = 0, minute = 0}
        in
            Time.Extra.partsToPosix timeZone newDate


getEndOfDay: Time.Zone -> Posix -> Posix
getEndOfDay timeZone date =
        let
            asParts = Time.Extra.posixToParts timeZone date
            newDate = {asParts | hour = 23, minute = 59}
        in
            Time.Extra.partsToPosix timeZone newDate

taskIsStillValid: Time.Zone -> Posix -> Task -> Bool
taskIsStillValid timeZone currentTime task =
    let
        diffBeforeNow = Time.Extra.diff Minute timeZone currentTime task.dueDate
        diffBeforeNow2 = Time.Extra.diff Minute timeZone currentTime (getEndOfDay timeZone task.creationDate)
    in
        (diffBeforeNow >= 0 && diffBeforeNow2 <= 0)

emptyDate: Time.Zone -> Posix
emptyDate timeZone = partsToPosix timeZone (Parts 3900 Jan 0 0 0 0 0)

nobody: Person
nobody = Person -1 "" 0