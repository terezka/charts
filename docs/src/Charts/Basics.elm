module Charts.Basics exposing (Example, empty, scatter, lines, areas, bars, bubbles)


import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Svg as S
import Svg.Attributes as SA

import Chart as C
import Chart.Attributes as CA
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
            , CA.margin { top = 0, bottom = 20, left = 0, right = 0 }
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
        , CA.margin { top = 0, bottom = 20, left = 0, right = 0 }
        , CA.padding { top = 0, bottom = 5, left = 10, right = 10 }
        ]
        [ C.grid []
        , C.xLabels []
        , C.yLabels []
        , C.series .x
            [ C.scatter .y [ CA.circle ]
            , C.scatter .z [ CA.square ]
            ]
            [ { x = 1, y = 2, z = 3 }
            , { x = 2, y = 3, z = 5 }
            , { x = 3, y = 4, z = 2 }
            , { x = 4, y = 1, z = 3 }
            , { x = 5, y = 4, z = 1 }
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
            , CA.margin { top = 0, bottom = 20, left = 0, right = 0 }
            , CA.padding { top = 0, bottom = 5, left = 10, right = 10 }
            ]
            [ C.grid []
            , C.xLabels []
            , C.yLabels []
            , C.series .x
                [ C.scatter .y [ CA.circle ]
                , C.scatter .z [ CA.square ]
                ]
                [ { x = 1, y = 2, z = 3 }
                , { x = 2, y = 3, z = 5 }
                , { x = 3, y = 4, z = 2 }
                , { x = 4, y = 1, z = 3 }
                , { x = 5, y = 4, z = 1 }
                ]
            ]
        ]
  }


bubbles : Example msg
bubbles =
  { title = "Scatter chart example"
  , code =
      """
      C.chart
        [ CA.height 300
        , CA.width 300
        , CA.margin { top = 0, bottom = 20, left = 0, right = 0 }
        , CA.padding { top = 30, bottom = 5, left = 40, right = 40 }
        ]
        [ C.grid []
        , C.xLabels []
        , C.yLabels []
        , C.series .x
            [ C.scatter .y [ CA.opacity 0.3, CA.borderWidth 1 ]
                |> C.variation (\\_ data -> [ CA.size data.size ])
            , C.scatter .z [ CA.opacity 0.3, CA.borderWidth 1 ]
                |> C.variation (\\_ data -> [ CA.size data.size ])
            ]
            [ { x = 1, y = 2, z = 3, size = 450 }
            , { x = 2, y = 3, z = 5, size = 350 }
            , { x = 3, y = 4, z = 2, size = 150 }
            , { x = 4, y = 1, z = 3, size = 550 }
            , { x = 5, y = 4, z = 1, size = 450 }
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
            , CA.margin { top = 0, bottom = 20, left = 0, right = 0 }
            , CA.padding { top = 30, bottom = 5, left = 40, right = 40 }
            ]
            [ C.grid []
            , C.xLabels []
            , C.yLabels []
            , C.series .x
                [ C.scatter .y [ CA.opacity 0.3, CA.borderWidth 1 ]
                    |> C.variation (\_ data -> [ CA.size data.size ])
                , C.scatter .z [ CA.opacity 0.3, CA.borderWidth 1 ]
                    |> C.variation (\_ data -> [ CA.size data.size ])
                ]
                [ { x = 1, y = 2, z = 3, size = 450 }
                , { x = 2, y = 3, z = 5, size = 350 }
                , { x = 3, y = 4, z = 2, size = 150 }
                , { x = 4, y = 1, z = 3, size = 550 }
                , { x = 5, y = 4, z = 1, size = 450 }
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
        , CA.margin { top = 0, bottom = 20, left = 0, right = 0 }
        , CA.padding { top = 10, bottom = 5, left = 10, right = 10 }
        ]
        [ C.grid []
        , C.xLabels []
        , C.yLabels []
        , C.series .x
            [ C.interpolated .y [ CA.monotone ] [ CA.circle ]
            , C.interpolated .z [ CA.monotone ] [ CA.square ]
            ]
            [ { x = 1, y = 2, z = 3 }
            , { x = 5, y = 4, z = 1 }
            , { x = 10, y = 2, z = 4 }
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
            , CA.margin { top = 0, bottom = 20, left = 0, right = 0 }
            , CA.padding { top = 10, bottom = 5, left = 10, right = 10 }
            ]
            [ C.grid []
            , C.xLabels []
            , C.yLabels []
            , C.series .x
                [ C.interpolated .y [ CA.monotone ] [ CA.circle ]
                , C.interpolated .z [ CA.monotone ] [ CA.square ]
                ]
                [ { x = 1, y = 2, z = 3 }
                , { x = 5, y = 4, z = 1 }
                , { x = 10, y = 2, z = 4 }
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
        , CA.margin { top = 0, bottom = 20, left = 0, right = 0 }
        ]
        [ C.grid []
        , C.xLabels []
        , C.yLabels []
        , C.series .x
            [ C.stacked
                [ C.interpolated .y [ CA.opacity 0.2 ] []
                , C.interpolated .z [ CA.opacity 1, CA.dotted [] ] []
                ]
            ]
            [ { x = 1, y = 1, z = 3 }
            , { x = 5, y = 2, z = 1 }
            , { x = 10, y = 2, z = 4 }
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
            , CA.margin { top = 0, bottom = 20, left = 0, right = 0 }
            ]
            [ C.grid []
            , C.xLabels []
            , C.yLabels []
            , C.series .x
                [ C.stacked
                    [ C.interpolated .y [ CA.opacity 0.2 ] []
                    , C.interpolated .z [ CA.opacity 1, CA.dotted [] ] []
                    ]
                ]
                [ { x = 1, y = 1, z = 3 }
                , { x = 5, y = 2, z = 1 }
                , { x = 10, y = 2, z = 4 }
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
        , CA.margin { top = 0, bottom = 20, left = 0, right = 0 }
        ]
        [ C.grid []
        , C.xLabels [ CA.ints ]
        , C.yLabels []
        , C.bars
            [ CA.x1 .x ]
            [ C.bar .z [ CA.striped [] ]
            , C.bar .y []
            ]
            [ { x = 1, y = 3, z = 1 }
            , { x = 2, y = 2, z = 3 }
            , { x = 3, y = 4, z = 2 }
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
            , CA.margin { top = 0, bottom = 20, left = 0, right = 0 }
            ]
            [ C.grid []
            , C.xLabels [ CA.ints ]
            , C.yLabels []
            , C.bars
                [ CA.x1 .x ]
                [ C.bar .z [ CA.color purple, CA.striped [] ]
                , C.bar .y [ CA.color pink ]
                ]
                [ { x = 1, y = 3, z = 1 }
                , { x = 2, y = 2, z = 3 }
                , { x = 3, y = 4, z = 2 }
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
