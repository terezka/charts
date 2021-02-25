module Histogram exposing (..)

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
    , length = 400
    , min = 10
    , max = maximum [.timestamp] data + 10
    }
  , y =
    { marginLower = 20
    , marginUpper = 20
    , length = 300
    , min = 0
    , max = maximum [.score] data
    }
  }


type alias Point =
  { timestamp : Float
  , score : Float
  }


data : List Point
data =
  [ { timestamp = 10, score = 4 }
  , { timestamp = 20, score = 2 }
  , { timestamp = 30, score = 4 }
  , { timestamp = 40, score = 6 }
  , { timestamp = 50, score = 8 }
  , { timestamp = 60, score = 10 }
  , { timestamp = 70, score = 9 }
  , { timestamp = 80, score = 7 }
  , { timestamp = 90, score = 5 }
  , { timestamp = 100, score = 2 }
  , { timestamp = 110, score = 3 }
  , { timestamp = 120, score = 1 }
  ]


main : Svg msg
main =
  svg
    [ width (String.fromFloat plane.x.length)
    , height (String.fromFloat plane.y.length)
    ]
    [ histogram plane .timestamp 10 (bar [] << .score) data
    , xAxis plane [] 0
    , yAxis plane [] 10
    , xTicks plane 5 [] 0 (List.map .timestamp data)
    , yTicks plane 5 [] 10 [ 1, 2, 3 ]
    , xLabels plane (xLabel [] (.timestamp >> (+) 5) (.timestamp >> String.fromFloat)) 0 data
    ]
