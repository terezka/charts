module Histogram exposing (..)

import Svg exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes exposing (width, height, stroke, fill, r, transform)
import Svg.Coordinates exposing (..)
import Svg.Plot exposing (..)
import Colors exposing (..)


plane : Plane
plane =
  { x =
    { marginLower = 10
    , marginUpper = 10
    , length = 300
    , min = 0
    , max = 21
    }
  , y =
    { marginLower = 10
    , marginUpper = 10
    , length = 300
    , min = 0
    , max = 10
    }
  }


testScores : Histogram msg
testScores =
  { bars = List.map (Bar [ stroke blueStroke, fill blueFill ]) [ 1, 2, 3, 6, 8, 9, 6, 4, 2, 1 ]
  , interval = 2.1
  }


main : Svg msg
main =
  svg
    [ width (toString plane.x.length)
    , height (toString plane.y.length)
    ]
    [ histogram plane testScores
    , fullHorizontal plane [] 0
    , fullVertical plane [] 0
    , xTicks plane 5 [] 0 [ 1, 2, 3 ]
    , yTicks plane 5 [] 0 [ 1, 2, 3 ]
    ]
