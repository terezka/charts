module Series exposing (..)

import Svg exposing (Svg, svg, g, text_, text)
import Svg.Attributes exposing (width, height, stroke, fill, r, transform)
import Svg.Coordinates exposing (..)
import Svg.Chart exposing (..)
import Internal.Colors exposing (..)


planeFromPoints : List Point -> Plane
planeFromPoints points =
  { x =
    { marginLower = 10
    , marginUpper = 10
    , length = 300
    , min = minimum .x points
    , max = maximum .x points
    }
  , y =
    { marginLower = 10
    , marginUpper = 10
    , length = 300
    , min = minimum .y points
    , max = maximum .y points
    }
  }


type alias Point =
  { x : Float
  , y : Float
  }


data1 : List Point
data1 =
  [ { x = -2, y = 5 }
  , { x = 1, y = 1.5 }
  , { x = 3, y = 5 }
  ]


data2 : List Point
data2 =
  [ { x = -4, y = 4 }
  , { x = -2, y = 3 }
  , { x = 4, y = -4 }
  , { x = 6, y = 4 }
  , { x = 8, y = 3 }
  , { x = 10, y = -4 }
  ]


data3 : List Point
data3 =
  [ { x = 1.0, y = 2 }
  , { x = 1.2, y = 1 }
  , { x = 1.8, y = 6 }
  ]


main : Svg msg
main =
  let
    plane =
      planeFromPoints (data1 ++ data2 ++ data3)
  in
    svg
      [ width (String.fromFloat plane.x.length)
      , height (String.fromFloat plane.x.length)
      ]
      [ linearArea plane .x .y [ stroke "transparent", fill blueFill ] clear data1
      , linear plane .x .y [ stroke blueStroke ] clear data1
      , monotone plane .x .y [ stroke pinkStroke ] (aura 3 6 0.3 diamond "blue") data2
      , scatter plane .x .y (full 5 triangle "pink") data3
      , fullHorizontal plane [] 0
      , fullVertical plane [] 0
      , xTicks plane 5 [] 0 [ 1, 2, 3 ]
      , yTicks plane 5 [] 0 [ 1, 2, 3, 5, 6 ]
      , xLabels plane (xLabel "blue" String.fromFloat) 0 [ 1, 2, 3, 5, 10 ]
      , yLabels plane (yLabel "green" String.fromFloat) 0 [ 1, 2, 3, 5, 6 ]
      ]


