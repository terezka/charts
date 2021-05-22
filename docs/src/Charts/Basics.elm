module Charts.Basics exposing (Example, scatter, lines, areas, bars)


import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Svg as S exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes as SA exposing (width, height, stroke, fill, r, transform)
import Svg.Coordinates as Coordinates

import Chart as C
import Chart.Attributes as CA
import Chart.Item as CI
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



scatter : Example msg
scatter =
  { title = "Scatter charts"
  , code =
      """
      C.chart
        [ CA.height 300
        , CA.width 300
        , C.marginBottom 20
        ]
        [ C.grid []
        , C.xLabels []
        , C.yLabels []
        , C.series .x
            [ C.property .y "y" [ CA.color pink ] [ CA.circle ]
            , C.property .z "z" [ CA.color purple ] [ CA.square ]
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
            , C.marginBottom 20
            ]
            [ C.grid []
            , C.xLabels []
            , C.yLabels []
            , C.series .x
                [ C.property .y "y" [ CA.color pink ] [ CA.circle ]
                , C.property .z "z" [ CA.color purple ] [ CA.square ]
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
  { title = "Line charts"
  , code =
      """
      C.chart
        [ CA.height 300
        , CA.width 300
        , C.marginBottom 20
        ]
        [ C.grid []
        , C.xLabels []
        , C.yLabels []
        , C.series .x
            [ C.property .y "y" [ CA.linear, CA.color pink ] [ CA.circle ]
            , C.property .z "z" [ CA.linear, CA.color purple ] [ CA.square ]
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
            , C.marginBottom 20
            ]
            [ C.grid []
            , C.xLabels []
            , C.yLabels []
            , C.series .x
                [ C.property .y "y" [ CA.linear, CA.color pink ] [ CA.circle ]
                , C.property .z "z" [ CA.linear, CA.color purple ] [ CA.square ]
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
  { title = "Area charts"
  , code =
      """
      C.chart
        [ CA.height 300
        , CA.width 300
        , C.marginBottom 20
        ]
        [ C.grid []
        , C.xLabels []
        , C.yLabels []
        , C.series .x
            [ C.stacked
                [ C.property .y "y"
                    [ CA.linear, CA.color pink, CA.opacity 0.4 ] []
                , C.property .z "z"
                    [ CA.linear, CA.color purple, CA.opacity 0.4 ] []
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
            , C.marginBottom 20
            ]
            [ C.grid []
            , C.xLabels []
            , C.yLabels []
            , C.series .x
                [ C.stacked
                    [ C.property .y "y" [ CA.linear, CA.color pink, CA.opacity 0.4 ] []
                    , C.property .z "z" [ CA.linear, CA.color purple, CA.opacity 0.4 ] []
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
  { title = "Bar charts"
  , code =
      """
          C.chart
            [ CA.height 300
            , CA.width 300
            , C.marginBottom 20
            ]
            [ C.grid []
            , C.xLabels [ C.ints ]
            , C.yLabels []
            , C.bars
                [ CA.x1 .x
                , CA.margin 0.2
                ]
                [ C.stacked
                    [ C.bar .z "z" [ CA.color purple, CA.striped [] ]
                    , C.bar .y "y" [ CA.color pink ]
                    ]
                ]
                [ { x = 1, y = Just 2, z = Just 3 }
                , { x = 2, y = Just 4, z = Just 1 }
                , { x = 3, y = Just 2, z = Just 3 }
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
            , C.marginBottom 20
            ]
            [ C.grid []
            , C.xLabels [ C.ints ]
            , C.yLabels []
            , C.bars
                [ CA.x1 .x
                , CA.margin 0.2
                ]
                [ C.stacked
                    [ C.bar .z "z" [ CA.color purple, CA.striped [] ]
                    , C.bar .y "y" [ CA.color pink ]
                    ]
                ]
                [ { x = 1, y = Just 2, z = Just 0.5 }
                , { x = 2, y = Just 1, z = Just 2 }
                , { x = 3, y = Just 3, z = Just 1 }
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
