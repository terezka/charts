module Section.CustomLabels exposing (..)


import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Svg as S exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes as SA exposing (width, height, stroke, fill, r, transform)
import Svg.Coordinates as Coordinates
import Browser
import Time
import Data.Iris as Iris
import Data.Salary as Salary
import Data.Education as Education
import Dict

import Chart as C
import Chart.Attributes as CA
import Chart.Item as CI
import Chart.Svg as CS

import Element as E
import Element.Font as F
import Element.Border as B
import Element.Input as I
import Element.Background as BG

import Ui.Section as Section


view : (String -> Int -> msg) -> Dict.Dict String Int -> E.Element msg
view onSelect selected =
  let frame props =
        H.div
          [ HA.style "width" "300px"
          , HA.style "height" "300px"
          ]
          [ C.chart
              [ CA.height 300
              , CA.width 300
              , C.marginTop 15
              ] <|
              [ C.grid [] ] ++ props
          ]
  in
  Section.view
    { title = "Custom axes"
    , onSelect = onSelect
    , selected = selected
    , frame =
        """
        C.chart
          [ CA.height 300
          , CA.width 300
          ]
          [ C.grid []
          {{CONFIG}}
          ]
        """
    , configs =
        [ { title = "Basic"
          , code =
              """
          , C.xAxis []
          , C.xTicks []
          , C.xLabels []
              """
          , chart = \_ ->
              frame
                [ C.xAxis []
                , C.xTicks []
                , C.xLabels []
                ]
          }
        , { title = "Color"
          , code =
              """
          , C.xAxis [ CA.color "blue" ]
          , C.xTicks [ CA.color "blue" ]
          , C.xLabels [ CA.color "blue" ]
              """
          , chart = \_ ->
              frame
                [ C.xAxis [ CA.color "blue" ]
                , C.xTicks [ CA.color "blue" ]
                , C.xLabels [ CA.color "blue" ]
                ]
          }
        , { title = "Position"
          , code =
              """
          , C.xAxis [ C.pinned .max ]
          , C.xTicks [ C.pinned .max, CA.flip  ]
          , C.xLabels [ C.pinned .max, CA.flip ]
              """
          , chart = \_ ->
              frame
                [ C.xAxis [ C.pinned .max ]
                , C.xTicks [ C.pinned .max, CA.flip ]
                , C.xLabels [ C.pinned .max, CA.flip ]
                ]
          }
        , { title = "Offset"
          , code =
              """
          , C.xLabels [ CA.xOff 5, CA.yOff 0, CA.alignRight ]
              """
          , chart = \_ ->
              frame
                [ C.xLabels [ CA.xOff 5, CA.yOff -20, CA.alignRight ]
                ]
          }
        , { title = "No arrow"
          , code =
              """
          , C.xAxis [ C.noArrow ]
          , C.xTicks []
          , C.xLabels []
              """
          , chart = \_ ->
              frame
                [ C.xAxis [ C.noArrow ]
                , C.xTicks []
                , C.xLabels []
                ]
          }
        , { title = "Amount"
          , code =
              """
          , C.xAxis []
          , C.xTicks [ C.amount 4 ]
          , C.xLabels [ C.amount 4 ]
              """
          , chart = \_ ->
              frame
                [ C.xAxis []
                , C.xTicks [ C.amount 4 ]
                , C.xLabels [ C.amount 4 ]
                ]
          }
        , { title = "Only ints"
          , code =
              """
          , C.xAxis []
          , C.xTicks [ C.amount 4, C.ints ]
          , C.xLabels [ C.amount 4, C.ints ]
              """
          , chart = \_ ->
              frame
                [ C.xAxis []
                , C.xTicks [ C.amount 4, C.ints ]
                , C.xLabels [ C.amount 4, C.ints ]
                ]
          }
        , { title = "Custom"
          , code =
              """
          , C.xAxis []
          , C.each (CS.produce 12 CS.ints << .x) <| \\p num ->
              [ C.xTick [ CA.x (toFloat num) ]
              , C.xLabel [ CA.x (toFloat num) ]
                  [ S.text (String.fromInt num), S.text "°" ]
              ]
              """
          , chart = \_ ->
              frame
                [ C.xAxis []
                , C.each (CS.produce 12 CS.ints << .x) <| \p num ->
                    [ C.xTick [ CA.x (toFloat num) ]
                    , C.xLabel [ CA.x (toFloat num) ]
                        [ S.text (String.fromInt num), S.text "°" ]
                    ]
                ]
          }
        ]
    }


type alias Datum =
  { x : Float
  , y : Maybe Float
  , z : Maybe Float
  , v : Maybe Float
  , w : Maybe Float
  , p : Maybe Float
  , q : Maybe Float
  }


data : List Datum
data =
  let toDatum x y z v w p q =
        Datum x (Just y) (Just z) (Just v) (Just w) (Just p) (Just q)
  in
  [ toDatum 0.0 2.0 4.0 4.6 6.9 7.3 8.0
  , toDatum 0.2 3.0 4.2 5.2 6.2 7.0 8.7
  , toDatum 0.8 4.0 4.6 5.5 5.2 7.2 8.1
  , toDatum 1.0 2.0 4.2 5.3 5.7 6.2 7.8
  , toDatum 1.2 5.0 3.5 4.9 5.9 6.7 8.2
  , toDatum 2.0 2.0 3.2 4.8 5.4 7.2 8.3
  , toDatum 2.3 1.0 4.3 5.3 5.1 7.8 7.1
  , toDatum 2.8 3.0 2.9 5.4 3.9 7.6 8.5
  , toDatum 3.0 2.0 3.6 5.8 4.6 6.5 6.9
  , toDatum 4.0 1.0 4.2 4.5 5.3 6.3 7.0
  ]

