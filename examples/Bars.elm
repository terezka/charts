module Bars exposing (..)

import Svg exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes exposing (width, height, stroke, fill, r, transform)
import Svg.Coordinates exposing (..)
import Svg.Plot exposing (..)
import Internal.Colors exposing (..)


plane : Plane
plane =
  { x =
    { marginLower = 20
    , marginUpper = 20
    , length = 300
    , min = 0
    , max = 5
    }
  , y =
    { marginLower = 20
    , marginUpper = 20
    , length = 300
    , min = -5
    , max = 10
    }
  }


group : List Float -> List (Bar msg)
group =
  List.map (Bar [ stroke blueStroke, fill blueFill ])


groups : Groups msg
groups =
   { groups = List.map group [ [ 2, 3, 1 ], [ 5, 1, 4 ], [ 1, 5, 3 ] ]
   , width = 0.8
   }


main : Svg msg
main =
  svg
    [ width (String.fromFloat plane.x.length)
    , height (String.fromFloat plane.y.length)
    ]
    [ grouped plane groups
    , fullHorizontal plane [] 0
    , fullVertical plane [] 0
    , xTicks plane 5 [] 0 [ 1, 2, 3 ]
    , yTicks plane 5 [] 0 [ 1, 2, 3 ]
    , xLabels plane (xLabel "blue" String.fromFloat) 0 [ 1, 2, 3 ]
    , yLabels plane (yLabel "green" String.fromFloat) 0 [ 1, 2, 3 ]
    ]
