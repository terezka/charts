module Bars exposing (..)

import Svg exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes exposing (width, height, stroke, fill, r, transform)
import Svg.Coordinates exposing (..)
import Svg.Chart exposing (..)
import Internal.Colors exposing (..)


plane : Plane
plane =
  { x =
    { marginLower = 20
    , marginUpper = 20
    , length = 300
    , min = 0
    , max = toFloat (List.length data) + 0.5
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
  { passed : Float
  , failed : Float
  }


data : List Point
data =
  [ { passed = 4, failed = 4 }
  , { passed = 2, failed = 3 }
  , { passed = 4, failed = 4 }
  , { passed = 6, failed = 4 }
  , { passed = 8, failed = 3 }
  , { passed = 10, failed = 4 }
  ]



main : Svg msg
main =
  svg
    [ width (String.fromFloat plane.x.length)
    , height (String.fromFloat plane.y.length)
    ]
    [ bars plane 0.8
        [ bar [ stroke blueStroke, fill blueFill ] << .passed
        , bar [ stroke pinkStroke, fill pinkFill ] << .failed
        ]
        data
    , fullHorizontal plane [] 0
    , fullVertical plane [] 0
    , xTicks plane 5 [] 0 [ 1, 2, 3 ]
    , yTicks plane 5 [] 0 [ 1, 2, 3 ]
    , xLabels plane (xLabel [] identity String.fromFloat) 0 [ 1, 2, 3 ]
    , yLabels plane (yLabel [] identity String.fromFloat) 0 [ 1, 2, 3 ]
    ]
