module Section.ScatterChart exposing (..)


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
              , CA.marginLeft 10
              ]
              [ C.grid []
              , C.xLabels []
              , C.yLabels []
              , C.series .x props data
              ]
          ]
  in
  { title = "Scatter charts"
  , template =
      """
      C.chart
        [ CA.height 300
        , CA.width 300
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
            [ C.property .y [] []
            , C.property .z [] []
            ]
            """
          ]
      , chart = \_ ->
          frame
            [ C.property .y [] []
            , C.property .z [] []
            ]
      }
      [ { title = "Shapes"
        , edits =
            [ """
            [ C.property .y [] [ CA.circle ]
            , C.property .z [] [ CA.square ]
            , C.property .w [] [ CA.cross ]
            ]
            """
            ]
        , chart = \_ ->
            frame
              [ C.property .y [] [ CA.circle ]
              , C.property .z [] [ CA.square ]
              , C.property .w [] [ CA.triangle ]
              ]
        }
      , { title = "Colors"
        , edits =
            [ """
            [ C.property .y [] [ CA.color "red" ]
            , C.property .z [] [ CA.color "blue" ]
            ]
            """
            ]
        , chart = \_ ->
            frame
              [ C.property .y [] [ CA.color "red" ]
              , C.property .z [] [ CA.color "blue" ]
              ]
        }
      , { title = "Sizes"
        , edits =
            [ """
            [ C.property .y [] [ CA.size 12 ]
            , C.property .z [] [ CA.size 3 ]
            ]
            """
            ]
        , chart = \_ ->
            frame
              [ C.property .y [] [ CA.size 12 ]
              , C.property .z [] [ CA.size 3 ]
              ]
        }
      , { title = "Opacity"
        , edits =
            [ """
            [ C.property .y [] [ CA.opacity 0.5 ]
            , C.property .z [] [ CA.opacity 0.5 ]
            ]
              """
            ]
        , chart = \_ ->
            frame
              [ C.property .y [] [ CA.opacity 0.5 ]
              , C.property .z [] [ CA.opacity 0.5 ]
              ]
        }
      , { title = "Borders"
        , edits =
            [ """
            [ C.property .y [] [ CA.borderWidth 2, CA.border "red" ]
            , C.property .z [] []
            ]
              """
            ]
        , chart = \_ ->
            frame
              [ C.property .y [] [ CA.borderWidth 2, CA.border "red" ]
              , C.property .z [] []
              ]
        }
      , { title = "Highlight"
        , edits =
            [ """
            [ C.property .y [] []
            , C.property .z [] [ CA.aura 0.5  ]
            ]
              """
            ]
        , chart = \_ ->
            frame
              [ C.property .y [] []
              , C.property .z [] [ CA.aura 0.5 ]
              ]
        }
      , { title = "Data dependent"
        , edits =
            [ """
            [ C.property .y [] []
                |> C.variation (\\d -> [ CA.aura (if d.x == 3 then 0.5 else 0) ])
            , C.property .z [] []
                |> C.variation (\\d -> [ CA.size (d.x * 2 + 2) ])
            ]
              """
            ]
        , chart = \_ ->
            frame
              [ C.property .y [] []
                  |> C.variation (\d -> [ CA.aura (if d.x == 3 then 0.5 else 0) ])
              , C.property .z [] []
                  |> C.variation (\d -> [ CA.size (d.x * 2 + 2) ])
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

