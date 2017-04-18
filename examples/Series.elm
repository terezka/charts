module Series exposing (..)

import Svg exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes exposing (width, height, stroke, fill, r, transform)
import Svg.Coordinates exposing (..)
import Svg.Plot exposing (..)
import Colors exposing (..)


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
      [ width (toString plane.x.length)
      , height (toString plane.x.length)
      ]
      [ linear plane [ stroke blueStroke, fill blueFill ] (List.map clear data1)
      , monotone plane [ stroke pinkStroke ] (List.map (dot (viewCircle pinkStroke)) data2)
      , scatter plane (List.map (dot (viewCircle "#f9c3b0")) data3)
      , fullHorizontal plane [] 0
      , fullVertical plane [] 0
      , xTicks plane 5 [] 0 [ 1, 2, 3 ]
      , yTicks plane 5 [] 0 [ 1, 2, 3 ]
      ]


viewCircle : String -> Svg msg
viewCircle color =
  circle [ stroke color, fill color, r "5" ] []
