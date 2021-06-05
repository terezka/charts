module Section.LineChart exposing (..)


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
import Internal.Item as CI
import Chart.Svg as CS

import Element as E
import Element.Font as F
import Element.Border as B
import Element.Input as I
import Element.Background as BG

import Ui.Section as Section


section : Section.Section msg
section =
  let frame props =
        H.div
          [ HA.style "width" "760px"
          , HA.style "height" "300px"
          ]
          [ C.chart
              [ CA.height 300
              , CA.width 760
              ]
              [ C.grid []
              , C.xLabels []
              , C.yLabels []
              , C.series .x props data
              ]
          ]
  in
  { title = "Line charts"
  , template =
      """
      C.chart
        [ CA.height 300
        , CA.width 760
        ]
        [ C.grid []
        , C.xLabels []
        , C.yLabels []
        , C.series .x
            {{1}}
            data
        ]
      """
  , configs =
      Tuple.pair
      { title = "Basic"
      , edits =
          [ """
            [ C.property .y [ CA.linear ] []
            , C.property .z [ CA.linear ] []
            ]
            """
          ]
      , chart = \_ ->
          frame
            [ C.property .y [ CA.linear ] []
            , C.property .z [ CA.linear ] []
            ]
      }
      [ { title = "Stacked"
        , edits =
            [ """
              [ C.stacked
                [ C.property .y [ CA.linear ] []
                , C.property .z [ CA.linear ] []
                ]
              ]
              """
            ]
        , chart = \_ ->
            frame
              [ C.stacked
                [ C.property .y [ CA.linear ] []
                , C.property .z [ CA.linear ] []
                ]
              ]
        }
      , { title = "Montone"
        , edits =
            [ """
              [ C.property .y [ CA.monotone ] []
              , C.property .z [ CA.monotone ] []
              ]
              """
            ]
        , chart = \_ ->
            frame
              [ C.property .y [ CA.monotone ] []
              , C.property .z [ CA.monotone ] []
              ]
        }
      , { title = "Color"
        , edits =
            [ """
              [ C.property .y [ CA.linear, CA.color "purple" ] []
              , C.property .z [ CA.linear ] []
              ]
              """
            ]
        , chart = \_ ->
            frame
              [ C.property .y [ CA.linear, CA.color "purple" ] []
              , C.property .z [ CA.linear ] []
              ]
        }
      , { title = "Width"
        , edits =
            [ """
              [ C.property .y [ CA.linear, CA.width 3 ] []
              , C.property .z [ CA.linear ] []
              ]
              """
            ]
        , chart = \_ ->
            frame
              [ C.property .y [ CA.linear, CA.width 3 ] []
              , C.property .z [ CA.linear ] []
              ]
        }
      , { title = "Area"
        , edits =
            [ """
              [ C.property .y [ CA.linear, CA.opacity 0.2 ] []
              , C.property .z [ CA.linear, CA.opacity 0.2 ] []
              ]
              """
            ]
        , chart = \_ ->
            frame
              [ C.property .y [ CA.linear, CA.opacity 0.2 ] []
              , C.property .z [ CA.linear, CA.opacity 0.2 ] []
              ]
        }
      , { title = "Pattern"
        , edits =
            [ """
              [ C.stacked
                [ C.property .y [ CA.linear, CA.striped [ CA.width 3, CA.space 4, CA.rotate 90 ] ] []
                , C.property .z [ CA.linear, CA.dotted [ CA.width 3, CA.space 4 ] ] []
                ]
              ]
              """
            ]
        , chart = \_ ->
            frame
              [ C.stacked
                [ C.property .y [ CA.linear, CA.striped [ CA.width 3, CA.space 4, CA.rotate 90 ] ] []
                , C.property .z [ CA.linear, CA.dotted [ CA.width 3, CA.space 4 ] ] []
                ]
              ]
        }
      , { title = "Gradient"
        , edits =
            [ """
              [ C.property .y [ CA.linear, CA.opacity 0.6, CA.gradient [ CA.bottom "lightblue" ] ] []
              ]
              """
            ]
        , chart = \_ ->
            frame
              [ C.property .y [ CA.linear, CA.opacity 0.6, CA.gradient [ CA.bottom "lightblue" ] ] []
              ]
        }
      , { title = "Dashed"
        , edits =
            [ """
              [ C.property .y [ CA.linear, CA.dashed [ 2, 2 ] ] []
              , C.property .z [ CA.linear, CA.dashed [ 5, 2 ] ] []
              ]
              """
            ]
        , chart = \_ ->
            frame
              [ C.property .y [ CA.linear, CA.dashed [ 2, 2 ] ] []
              , C.property .z [ CA.linear, CA.dashed [ 5, 2 ] ] []
              ]
        }
      , { title = "Dots"
        , edits =
            [ """
              [ C.property .y [ CA.linear ] [ CA.circle ] ]
              """
            ]
        , chart = \_ ->
            frame
              [ C.property .y [ CA.linear ] [ CA.circle ]
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
  [ toDatum 1  2 1 4.6 6.9 7.3 8.0
  , toDatum 2  3 2 5.2 6.2 7.0 8.7
  , toDatum 3  4 3 5.5 5.2 7.2 8.1
  , toDatum 4  3 4 5.3 5.7 6.2 7.8
  , toDatum 5  2 3 4.9 5.9 6.7 8.2
  , toDatum 6  4 1 4.8 5.4 7.2 8.3
  , toDatum 7  5 2 5.3 5.1 7.8 7.1
  , toDatum 8  6 3 5.4 3.9 7.6 8.5
  , toDatum 9  5 4 5.8 4.6 6.5 6.9
  , toDatum 10 4 3 4.5 5.3 6.3 7.0
  ]

