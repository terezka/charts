module FromCoords exposing (..)

import Svg exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes exposing (width, height, stroke, fill, r, transform)
import Svg.Coordinates as Coordinates exposing (Point, Plane)
import Svg.Plot exposing (line, area, Interpolation(..))


planeFromPoints : List Point -> Plane
planeFromPoints coordinates =
  { x =
    { marginLower = 10
    , marginUpper = 10
    , length = 300
    , min = Coordinates.min .x coordinates
    , max = Coordinates.max .x coordinates
    }
  , y =
    { marginLower = 10
    , marginUpper = 10
    , length = 300
    , min = Coordinates.min .y coordinates
    , max = Coordinates.max .y coordinates
    }
  }


data : List Coordinates.Point
data =
  [ { x = -4, y = 4 }
  , { x = -2, y = 3 }
  , { x = 4, y = -4 }
  ]


main : Svg msg
main =
  let
    plane =
      planeFromPoints data
  in
    svg
      [ width (toString plane.x.length)
      , height (toString plane.x.length)
      ]
      [ area [] Monotone plane data
      , viewPoint plane "hotpink" { x = 0, y = 0 }
      , viewPoint plane "pink" { x = -1, y = 1 }
      , viewPoint plane "pink" { x = 3, y = 3 }
      , viewPoint plane "pink" { x = -2, y = -1 }
      ]


viewPoint : Coordinates.Plane -> String -> Coordinates.Point -> Svg msg
viewPoint plane color point =
  g [ Coordinates.place plane point ]
    [ circle [ stroke color, fill color, r "5" ] []
    , text_
      [ transform "translate(10, 5)" ]
      [ text ("(" ++ toString point.x ++ ", " ++ toString point.y ++ ")") ]
    ]
