module HighLevel exposing (..)

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
    , C.responsive
    , C.range (C.fromData .x data)
    , C.domain (C.fromData .y data)
    , C.id "some-id"
    ]
    [ C.grid identity identity [] [0, 1, 2, 3] [0, 1, 2, 3]
    , C.xAxis [ C.pinned (always 0) ]
    , C.yAxis [ C.pinned (always 0) ]
    , C.xLabels identity String.fromFloat [] [0, 1, 2, 3]
    , C.xTicks identity [] [0, 1, 3]
    , C.monotone .x .y (\_ -> SC.full 6 SC.circle "blue") [ C.color "blue", C.width 1 ] data
    ]




