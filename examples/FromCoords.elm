module FromCoords exposing (..)

import Svg exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes exposing (width, height, stroke, fill, r, transform)
import Svg.Coordinates as Coordinates


planeConfig : Coordinates.PlaneConfig
planeConfig =
  { x =
    { marginLower = 10
    , marginUpper = 10
    , length = 300
    , min = identity
    , max = identity
    }
  , y =
    { marginLower = 10
    , marginUpper = 10
    , length = 300
    , min = identity
    , max = identity
    }
  }


data : List Coordinates.Point
data =
  [ { x = 2, y = 4 }
  , { x = -4, y = 3 }
  , { x = 4, y = -4 }
  ]


main : Svg msg
main =
  let
    plane =
      Coordinates.plane planeConfig data
  in
    svg
      [ width (toString planeConfig.x.length)
      , height (toString planeConfig.x.length)
      ]
      [ viewPoint plane "hotpink" { x = 0, y = 0 }
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
