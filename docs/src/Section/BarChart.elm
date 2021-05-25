module Section.BarChart exposing (..)


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
  let frame attrs props =
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
              , C.bars attrs props data
              ]
          ]
  in
    { title = "Bar charts"
    , template =
        """
        C.chart
          [ CA.height 300
          , CA.width 760
          ]
          [ C.grid []
          , C.xLabels []
          , C.yLabels []
          , C.bars
              {{1}}
              data
          ]
        """
    , configs =
        Tuple.pair
        { title = "Basic"
        , edits =
            ["""
            []
            [ C.bar .y "y" []
            , C.bar .z "z" []
            ]
            """]
        , chart = \_ ->
            frame
              []
              [ C.bar .y "y" []
              , C.bar .z "z" []
              ]
        }
        [ { title = "Margin"
          , edits =
              ["""
              [ CA.margin 0.2 ] -- Number is percentage of bin width
              [ C.bar .y "y" []
              , C.bar .z "z" []
              ]
              """]
          , chart = \_ ->
              frame
                [ CA.margin 0.2 ]
                [ C.bar .y "y" []
                , C.bar .z "z" []
                ]
          }
        , { title = "Spacing"
          , edits =
              ["""
              [ CA.spacing 0.1 ] -- Number is percentage of bin width
              [ C.bar .y "y" []
              , C.bar .z "z" []
              ]
              """]
          , chart = \_ ->
              frame
                [ CA.spacing 0.1 ]
                [ C.bar .y "y" []
                , C.bar .z "z" []
                ]
          }
        , { title = "Stacked"
          , edits =
              ["""
              []
              [ C.stacked
                  [ C.bar .y "y" []
                  , C.bar .z "z" []
                  ]
              ]
              """]
          , chart = \_ ->
              frame
                []
                [ C.stacked
                    [ C.bar .y "y" []
                    , C.bar .z "z" []
                    ]
                ]

          }
        , { title = "Ungroup"
          , edits =
              ["""
              [ CA.ungroup ]
              [ C.bar .y "y" []
              , C.bar .z "z" []
              ]
              """]
          , chart = \_ ->
              frame
                [ CA.ungroup ]
                [ C.bar .z "z" []
                , C.bar .y "y" []
                ]
          }
        , { title = "Corners"
          , edits =
              ["""
              [ CA.roundTop 0.5 ]
              [ C.bar .y "y" []
              , C.bar .z "z" [ CA.roundBottom 0.5 ]
              ]
              """]
          , chart = \_ ->
              frame
                [ CA.roundTop 0.5 ]
                [ C.bar .y "y" []
                , C.bar .z "z" [ CA.roundBottom 0.5 ]
                ]
          }
        , { title = "Set x1/x2"
          , edits =
              ["""
              [ CA.x1 .x1
              , CA.x2 (\\d -> d.x1 + 0.2)
              ]
              [ C.bar .y "y" []
              , C.bar .z "z" []
              ]
              """]
          , chart = \_ ->
              frame
                [ CA.x1 .x1
                , CA.x2 (\d -> d.x1 + 0.2)
                ]
                [ C.bar .y "y" []
                , C.bar .z "z" []
                ]
          }
        , { title = "Borders"
          , edits =
              ["""
              []
              [ C.bar .y "y" [ CA.border "red", CA.borderWidth 2 ]
              , C.bar .z "z" []
              ]
              """]
          , chart = \_ ->
              frame
                []
                [ C.bar .y "y" [ CA.border "red", CA.borderWidth 2 ]
                , C.bar .z "z" []
                ]
          }
        , { title = "Color"
          , edits =
              ["""
              []
              [ C.bar .y "y" [ CA.color "pink" ]
              , C.bar .z "z" []
              ]
              """]
          , chart = \_ ->
              frame
                []
                [ C.bar .y "y" [ CA.color "pink" ]
                , C.bar .z "z" []
                ]
          }
        , { title = "Opacity"
          , edits =
              ["""
              []
              [ C.bar .y "y" [ CA.opacity 0.25 ]
              , C.bar .z "z" []
              ]
              """]
          , chart = \_ ->
              frame
                []
                [ C.bar .y "y" [ CA.opacity 0.25 ]
                , C.bar .z "z" []
                ]
          }
        , { title = "Pattern"
          , edits =
              ["""
              []
              [ C.bar .y "y" [ CA.striped [] ]
              , C.bar .z "z" [ CA.dotted [] ]
              ]
              """]
          , chart = \_ ->
              frame
                []
                [ C.bar .y "y" [ CA.striped [] ]
                , C.bar .z "z" [ CA.dotted [] ]
                ]
          }
        , { title = "Data dependent"
          , edits =
              ["""
              []
              [ C.bar .y "y" []
                  |> C.variation (\\d -> if d.x == 3 then [ CA.color "red" ] else [])
              , C.bar .z "z" []
              ]
              """]
          , chart = \_ ->
              frame
                []
                [ C.bar .y "y" []
                    |> C.variation (\d -> if d.x == 3 then [ CA.color "red" ] else [])
                , C.bar .z "z" []
                ]
          }
        ]
    }


type alias Datum =
  { x : Float
  , x1 : Float
  , x2 : Float
  , y : Maybe Float
  , z : Maybe Float
  , v : Maybe Float
  , w : Maybe Float
  , p : Maybe Float
  , q : Maybe Float
  }


data : List Datum
data =
  let toDatum x x1 y z v w p q =
        Datum x x1 x1 (Just y) (Just z) (Just v) (Just w) (Just p) (Just q)
  in
  [ toDatum 0.0 0.0 1.2 4.0 4.6 6.9 7.3 8.0
  , toDatum 1.0 0.4 2.2 4.2 5.3 5.7 6.2 7.8
  , toDatum 2.0 0.6 1.0 3.2 4.8 5.4 7.2 8.3
  , toDatum 3.0 0.8 2.3 3.6 5.8 4.6 6.5 6.9
  , toDatum 4.0 1.1 1.0 4.2 4.5 5.3 6.3 7.0
  ]

