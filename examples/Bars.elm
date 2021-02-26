module Bars exposing (..)

import Svg exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes exposing (width, height, stroke, fill, r, transform)
import Svg.Coordinates exposing (..)
import Svg.Chart exposing (..)
import Internal.Colors exposing (..)


plane : Plane
plane =
  { x =
    { marginLower = 30
    , marginUpper = 20
    , length = 300
    , min = minimum [.x] data - 0.5
    , max = maximum [.x] data + 0.5
    }
  , y =
    { marginLower = 20
    , marginUpper = 20
    , length = 300
    , min = 0
    , max = maximum [.passed, .failed] data
    }
  }

type alias Point =
  { x : Float
  , passed : Float
  , failed : Float
  }


data : List Point
data =
  [ { x = 1, passed = 4, failed = 4 }
  , { x = 2, passed = 2, failed = 3 }
  , { x = 3, passed = 4, failed = 4 }
  , { x = 4, passed = 6, failed = 4 }
  , { x = 5, passed = 8, failed = 3 }
  , { x = 6, passed = 10, failed = 4 }
  ]


main : Svg msg
main =
  let toBars datum =
        [ GroupBar [ stroke "white", fill blueFill ] 0.2 datum.passed
        , GroupBar [ stroke "white", fill pinkFill ] 0.2 datum.failed
        , GroupBar [ stroke "white", fill blueFill ] 0.2 datum.passed
        ]
  in
  svg
    [ width (String.fromFloat plane.x.length)
    , height (String.fromFloat plane.y.length)
    ]
    [ bars plane toBars data
    , xAxis plane [] plane.y.min
    , yAxis plane [] plane.x.min
    , xTicks plane 5 [] plane.y.min [ 1, 2, 3 ]
    , yTicks plane 5 [] plane.x.min [ 1, 2, 3 ]
    , xLabels plane (xLabel [] identity String.fromFloat) plane.y.min [ 1, 2, 3 ]
    , yLabels plane (yLabel [] identity String.fromFloat) plane.x.min [ 1, 2, 3 ]
    ]
