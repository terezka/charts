module Charts.Basics exposing (Example, empty, scatter, lines, areas, bars)


import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Svg as S exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes as SA exposing (width, height, stroke, fill, r, transform)

import Chart as C
import Chart.Attributes as CA
import Internal.Item as CI
import Chart.Svg as CS

import Element as E
import Element.Font as F
import Element.Border as B
import Element.Input as I
import Element.Background as BG



type alias Example msg =
  { title : String
  , code : String
  , chart : () -> H.Html msg
  }


empty : Example msg
empty =
  { title = "Empty chart example"
  , code =
      """
import Html exposing (Html)
import Chart as C
import Chart.Attributes as CA

view : Html msg
view =
  C.chart
    [ CA.height 300
    , CA.width 300
    ]
    [ C.grid []
    , C.xAxis []
    , C.xTicks []
    , C.xLabels []
    , C.yAxis []
    , C.yTicks []
    , C.yLabels []
    ]
      """
  , chart = \_ ->
      H.div
        [ HA.style "width" "300px"
        , HA.style "height" "300px"
        ]
        [ C.chart
            [ CA.height 300
            , CA.width 300
            , CA.marginBottom 20
            ]
            [ C.grid []
            , C.xAxis []
            , C.xTicks []
            , C.xLabels []
            , C.yAxis []
            , C.yTicks []
            , C.yLabels []
            ]
        ]
  }


scatter : Example msg
scatter =
  { title = "Scatter chart example"
  , code =
      """
      C.chart
        [ CA.height 300
        , CA.width 300
        , CA.paddingLeft 10
        , CA.paddingBottom 5
        ]
        [ C.grid []
        , C.xLabels []
        , C.yLabels []
        , C.series .x
            [ C.scatter .y [ CA.circle ]
            , C.scatter .z [ CA.square ]
            ]
            [ { x = 1, y = Just 2, z = Just 3 }
            , { x = 2, y = Just 3, z = Just 5 }
            , { x = 3, y = Just 4, z = Just 2 }
            , { x = 4, y = Just 1, z = Just 3 }
            , { x = 5, y = Just 4, z = Just 1 }
            ]
        ]
      """
  , chart = \_ ->
      H.div
        [ HA.style "width" "300px"
        , HA.style "height" "300px"
        ]
        [ C.chart
            [ CA.height 300
            , CA.width 300
            , CA.marginBottom 20
            , CA.paddingLeft 10
            , CA.paddingBottom 5
            ]
            [ C.grid []
            , C.xLabels []
            , C.yLabels []
            , C.series .x
                [ C.scatter .y [ CA.circle ]
                , C.scatter .z [ CA.square ]
                ]
                [ { x = 1, y = Just 2, z = Just 3 }
                , { x = 2, y = Just 3, z = Just 5 }
                , { x = 3, y = Just 4, z = Just 2 }
                , { x = 4, y = Just 1, z = Just 3 }
                , { x = 5, y = Just 4, z = Just 1 }
                ]
            ]
        ]
  }


lines : Example msg
lines =
  { title = "Line chart example"
  , code =
      """
      C.chart
        [ CA.height 300
        , CA.width 300
        , CA.paddingLeft 10
        , CA.paddingBottom 10
        ]
        [ C.grid []
        , C.xLabels []
        , C.yLabels []
        , C.series .x
            [ C.interpolated .y [ CA.monotone ] [ CA.circle ]
            , C.interpolated .z [ CA.monotone ] [ CA.square ]
            ]
            [ { x = 1, y = Just 2, z = Just 3 }
            , { x = 5, y = Just 4, z = Just 1 }
            , { x = 10, y = Just 2, z = Just 4 }
            ]
        ]
      """
  , chart = \_ ->
      H.div
        [ HA.style "width" "300px"
        , HA.style "height" "300px"
        ]
        [ C.chart
            [ CA.height 300
            , CA.width 300
            , CA.marginBottom 20
            , CA.paddingLeft 10
            , CA.paddingBottom 5
            ]
            [ C.grid []
            , C.xLabels []
            , C.yLabels []
            , C.series .x
                [ C.interpolated .y [ CA.monotone ] [ CA.circle ]
                , C.interpolated .z [ CA.monotone ] [ CA.square ]
                ]
                [ { x = 1, y = Just 2, z = Just 3 }
                , { x = 5, y = Just 4, z = Just 1 }
                , { x = 10, y = Just 2, z = Just 4 }
                ]
            ]
        ]
  }


areas : Example msg
areas =
  { title = "Area chart example"
  , code =
      """
      C.chart
        [ CA.height 300
        , CA.width 300
        ]
        [ C.grid []
        , C.xLabels []
        , C.yLabels []
        , C.series .x
            [ C.stacked
                [ C.interpolated .y [ CA.dotted [] ] []
                , C.interpolated .z [] []
                ]
            ]
            [ { x = 1, y = Just 1, z = Just 3 }
            , { x = 5, y = Just 2, z = Just 1 }
            , { x = 10, y = Just 2, z = Just 4 }
            ]
        ]
      """
  , chart = \_ ->
      H.div
        [ HA.style "width" "300px"
        , HA.style "height" "300px"
        ]
        [ C.chart
            [ CA.height 300
            , CA.width 300
            , CA.marginBottom 20
            ]
            [ C.grid []
            , C.xLabels []
            , C.yLabels []
            , C.series .x
                [ C.stacked
                    [ C.interpolated .y [ CA.color purple, CA.dotted [] ] []
                    , C.interpolated .z [ CA.color pink ] []
                    ]
                ]
                [ { x = 1, y = Just 1, z = Just 3 }
                , { x = 5, y = Just 2, z = Just 1 }
                , { x = 10, y = Just 2, z = Just 4 }
                ]
            ]
        ]
  }


bars : Example msg
bars =
  { title = "Bar chart example"
  , code =
      """
      C.chart
        [ CA.height 300
        , CA.width 300
        ]
        [ C.grid []
        , C.xLabels [ CA.ints ]
        , C.yLabels []
        , C.bars
            [ CA.x1 .x ]
            [ C.bar .z [ CA.striped [] ]
            , C.bar .y []
            ]
            [ { x = 1, y = Just 3, z = Just 1 }
            , { x = 2, y = Just 2, z = Just 3 }
            , { x = 3, y = Just 4, z = Just 2 }
            ]
        ]
      """
  , chart = \_ ->
      H.div
        [ HA.style "width" "300px"
        , HA.style "height" "300px"
        ]
        [ C.chart
            [ CA.height 300
            , CA.width 300
            , CA.marginBottom 20
            ]
            [ C.grid []
            , C.xLabels [ CA.ints ]
            , C.yLabels []
            , C.bars
                [ CA.x1 .x ]
                [ C.bar .z [ CA.color purple, CA.striped [] ]
                , C.bar .y [ CA.color pink ]
                ]
                [ { x = 1, y = Just 3, z = Just 1 }
                , { x = 2, y = Just 2, z = Just 3 }
                , { x = 3, y = Just 4, z = Just 2 }
                ]
            ]
        ]
  }



pink : String
pink =
  "#f56dbc"


purple : String
purple =
  "#7c29ed"
