module Formatters exposing (getFormatedStringFromDate, monthToInt, toJapaneseWeekday,intToMonth,boolToString)

import Time exposing (Month(..), Weekday(..), Posix)

getFormatedStringFromDate: Time.Zone -> Posix -> String
getFormatedStringFromDate timeZone date =
        let
            year   = String.fromInt (Time.toYear timeZone date)
            month  = String.fromInt (monthToInt (Time.toMonth timeZone date))
            day    = String.fromInt (Time.toDay timeZone date)
            hour   = String.fromInt (Time.toHour timeZone date)
            minute = String.fromInt (Time.toMinute timeZone date)
            second = String.fromInt (Time.toSecond timeZone date)
        in
            (day ++ "." ++ month ++ "." ++ year ++ "; " ++ hour ++ ":" ++ minute ++ ":" ++ second)


monthToInt: Time.Month -> Int
monthToInt month = case month of
    Jan -> 1
    Feb -> 2
    Mar -> 3
    Apr -> 4
    May -> 5
    Jun -> 6
    Jul -> 7
    Aug -> 8
    Sep -> 9
    Oct -> 10
    Nov -> 11
    Dec -> 12

toJapaneseWeekday : Weekday -> String
toJapaneseWeekday weekday =
  case weekday of
    Mon -> "月"
    Tue -> "火"
    Wed -> "水"
    Thu -> "木"
    Fri -> "金"
    Sat -> "土"
    Sun -> "日"

intToMonth: Int -> Time.Month
intToMonth int = case int of
    1 -> Jan
    2 -> Feb
    3 -> Mar
    4 -> Apr
    5 -> May
    6 -> Jun
    7 -> Jul
    8 -> Aug
    9 -> Sep
    10 -> Oct
    11 -> Nov
    12 -> Dec
    _ -> Jan
boolToString: Bool -> String
boolToString bool = case bool of
    True -> "True"
    False -> "False"
