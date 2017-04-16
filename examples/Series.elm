module FromData exposing (..)

import Svg exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes exposing (width, height, stroke, fill, r, transform)
import Svg.Coordinates as Coordinates
import Svg.Plot exposing (..)


planeFromPoints : List Coordinates.Point -> Coordinates.Plane
planeFromPoints points =
  { x =
    { marginLower = 10
    , marginUpper = 10
    , length = 300
    , min = Coordinates.min .x points
    , max = Coordinates.max .x points
    }
  , y =
    { marginLower = 10
    , marginUpper = 10
    , length = 300
    , min = Coordinates.min .y points
    , max = Coordinates.max .y points
    }
  }


data1 : List Coordinates.Point
data1 =
  [ { x = -2, y = 5 }
  , { x = 1, y = 1.5 }
  , { x = 3, y = 5 }
  ]


data2 : List Coordinates.Point
data2 =
  [ { x = -4, y = 4 }
  , { x = -2, y = 3 }
  , { x = 4, y = -4 }
  ]


data3 : List Coordinates.Point
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
      [ linear plane [ fill "rgba(127, 178, 212, 0.3)", stroke "#7fb2d4" ] (List.map clear data1)
      , monotone plane [ stroke "#e67bd6" ] (List.map (dot (viewCircle "#e67bd6")) data2)
      , scatter plane (List.map (dot (viewCircle "#f9c3b0")) data3)
      ]


viewCircle : String -> Svg msg
viewCircle color =
  circle [ stroke color, fill color, r "5" ] []
