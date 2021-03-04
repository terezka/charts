module HighLevel exposing (..)

import Html
import Html.Attributes as HA
import Svg exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes exposing (width, height, stroke, fill, r, transform)
import Svg.Coordinates as Coordinates
import Chart as C
import Svg.Chart as SC


type alias Point =
  { x : Float
  , y : Float
  }


data : List Point
data =
  [ { x = -4, y = 4 }
  , { x = -2, y = 3 }
  , { x = 0, y = -4 }
  , { x = 4, y = -4 }
  , { x = 6, y = 4 }
  , { x = 8, y = 3 }
  , { x = 10, y = -4 }
  ]


main : Svg msg
main =
  C.chart
    [ C.width 300
    , C.height 300
    , C.marginTop 30
    , C.marginRight 10
    , C.responsive
    , C.range (C.fromData .x data)
    , C.domain (C.fromData .y data)
    , C.id "some-id"
    ]
    [ C.grid [] (C.ints 12 String.fromInt) (C.ints 12 String.fromInt)
    , C.xAxis [ C.pinned (always 0) ]
    , C.yAxis [ C.pinned (always 0) ]
    , C.xTicks [ C.height 8 ] (C.ints 12 String.fromInt)
    , C.yTicks [] (C.ints 12 String.fromInt)
    , C.yLabels [] (C.ints 12 String.fromInt)
    , C.xLabels [] (C.floats 12 String.fromFloat)
    , C.monotone .x .y (\_ -> SC.full 6 SC.circle "blue") [ C.color "blue", C.width 1 ] data
    , C.svgAt 1 1 0 0 [ Svg.text_ [] [ Svg.text "Arbitrary SVG at (1, 1)!" ] ]
    , C.htmlAt 3 4 0 0 [ HA.style "border" "1px solid green" ] [ Html.text "Arbitrary HTML at (3, 4)!" ]
    ]




