module Points exposing (..)

import Svg exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes exposing (width, height, stroke, fill, r, transform)
import Svg.Coordinates as Coordinates


type alias Point =
  { x : Float
  , y : Float
  }


plane : Coordinates.Plane
plane =
  { x =
    { marginLower = 10
    , marginUpper = 10
    , length = 300
    , min = -4
    , max = 4
    }
  , y =
    { marginLower = 10
    , marginUpper = 10
    , length = 300
    , min = -4
    , max = 4
    }
  }


main : Svg msg
main =
  svg
      [ width (String.fromFloat plane.x.length)
      , height (String.fromFloat plane.y.length)
      ]
      [ viewPoint plane "hotpink" { x = 0, y = 0 }
      , viewPoint plane "pink" { x = -4, y = 4 }
      , viewPoint plane "pink" { x = 3, y = 3 }
      , viewPoint plane "pink" { x = -2, y = -1 }
      ]


viewPoint : Coordinates.Plane -> String -> Point -> Svg msg
viewPoint plane_ color point =
  g [ Coordinates.place plane_ point.x point.y ]
    [ circle [ stroke color, fill color, r "5" ] []
    , text_
      [ transform "translate(10, 5)" ]
      [ text ("(" ++ String.fromFloat point.x ++ ", " ++ String.fromFloat point.y ++ ")") ]
    ]
