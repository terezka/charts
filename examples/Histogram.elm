module Histogram exposing (..)

import Svg exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes exposing (width, height, stroke, fill, r, transform)
import Svg.Coordinates exposing (..)
import Svg.Chart exposing (..)
import Internal.Colors exposing (..)


plane : Plane
plane =
  { x =
    { marginLower = 10
    , marginUpper = 10
    , length = 300
    , min = 23
    , max = 44
    }
  , y =
    { marginLower = 10
    , marginUpper = 10
    , length = 300
    , min = 0
    , max = 10
    }
  }


testScores : List Int
testScores =
  [ 1, 2, 3, 6, 8, 9, 6, 4, 2, 1 ]


main : Svg msg
main =
  svg
    [ width (String.fromFloat plane.x.length)
    , height (String.fromFloat plane.y.length)
    ]
    [ histogram plane 23 2.1 (bar [ stroke blueStroke, fill blueFill ] << toFloat) testScores
    , fullHorizontal plane [] 0
    , fullVertical plane [] 23
    , xTicks plane 5 [] 0 [ 24, 26, 30 ]
    , yTicks plane 5 [] 23 [ 1, 2, 3 ]
    ]
