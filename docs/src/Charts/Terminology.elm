module Charts.Terminology exposing (view)

import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Svg as S
import Svg.Attributes as SA
import Chart as C
import Chart.Attributes as CA
import Chart.Events as CE
import Chart.Item as CI
import Chart.Svg as CS



view : H.Html msg
view =
  C.chart
    [ CA.height 400
    , CA.width 1000
    , CA.static
    , CA.margin { top = 10, bottom = 10, left = 10, right = 10 }
    , CA.padding { top = 40, bottom = 30, left = 10, right = 20 }
    ]
    [ C.grid []
    , C.yLabels []
    , C.xAxis [ CA.noArrow ]

    , C.bars
        [ CA.margin 0.2
        , CA.spacing 0.15
        ]
        [ C.stacked
            [ C.bar .a []
            , C.bar .b []
            ]
        , C.bar .c []
        ]
        data

    , C.line [ CA.color "#888", CA.tickLength 7, CA.x1 3.5, CA.x2 4.5, CA.y1 4, CA.moveDown 20 ]
    , C.label [ CA.moveDown 15 ] [ S.text "bin" ] { x = 4, y = 4 }

    , C.line [ CA.color "#888", CA.tickLength 7, CA.x1 3.5, CA.x2 3.7, CA.y1 3, CA.moveUp 15 ]
    , C.label [ CA.moveUp 20 ] [ S.text "bin margin" ] { x = 3.6, y = 3 }

    , C.line [ CA.color "#888", CA.tickLength 7, CA.x1 3.925, CA.x2 4.075, CA.y1 3, CA.moveUp 15 ]
    , C.label [ CA.moveUp 20 ] [ S.text "bin spacing" ] { x = 4, y = 3 }

    , C.line [ CA.color "#888", CA.tickLength 7, CA.tickDirection 360, CA.x1 0.5, CA.y1 0, CA.y2 3, CA.moveRight 26 ]
    , C.label [ CA.rotate 90, CA.moveRight 18 ] [ S.text "stack" ] { x = 0.5, y = 1.5 }

    , C.line [ CA.color "#888", CA.tickLength 7, CA.tickDirection 360, CA.x1 1.5, CA.y1 0, CA.y2 2, CA.moveRight 26 ]
    , C.label [ CA.rotate 90, CA.moveRight 18 ] [ S.text "bar no. 1 in stack" ] { x = 1.5, y = 1 }
    , C.line [ CA.color "#888", CA.tickLength 7, CA.tickDirection 360, CA.x1 1.5, CA.y1 2, CA.y2 4, CA.moveRight 26 ]
    , C.label [ CA.rotate 90, CA.moveRight 18 ] [ S.text "bar no. 2 in stack" ] { x = 1.5, y = 3 }
    , C.line [ CA.color "#888", CA.tickLength 7, CA.tickDirection 360, CA.x1 2, CA.y1 0, CA.y2 1, CA.moveRight 5 ]
    , C.label [ CA.rotate 90 ] [ S.text "bar" ] { x = 2, y = 0.5 }

    , C.line [ CA.color "#888", CA.x1 4, CA.y1 0, CA.x2Svg -20, CA.y2Svg -10, CA.break, CA.flip, CA.moveDown 15 ]
    , C.svgAt (always 4) (always 0) -0.2 16 [ S.circle [ SA.fill "#ddd", SA.r "8" ] [] ]
    , C.label [ CA.moveDown 40, CA.moveLeft 25 ] [ S.text "bin label" ] { x = 4, y = 0 }

    , C.binLabels .label [ CA.moveDown 20 ]
    ]


type alias Data =
  { x : Float
  , y : Float
  , z : Float
  , a : Float
  , b : Float
  , c : Float
  , label : String
  }


data : List Data
data =
  [ Data 1 4 3 2 1 2 "A"
  , Data 2 5 2 2 2 1 "B"
  , Data 3 4 3 2 1 2 "C"
  , Data 4 8 2 1 2 2 "D"
  ]

