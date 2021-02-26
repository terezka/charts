module Histogram exposing (..)

import Svg exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes exposing (width, height, stroke, fill, r, transform)
import Svg.Coordinates exposing (..)
import Svg.Chart exposing (..)
import Internal.Colors exposing (..)


plane : Plane
plane =
  { x =
    { marginLower = 40
    , marginUpper = 20
    , length = 400
    , min = 0
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
  [ { timestamp = 0, score = 4 }
  , { timestamp = 10, score = 4 }
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
  let toSimpleBars _ curr _ =
        [ Bar [] 10 curr.timestamp curr.score ]

      -- Optional: Adjust width based on previous and next data point
      toBars prev curr next =
        case ( prev, next ) of
          ( Nothing, Just next_ ) ->
            [ Bar [] ((next_.timestamp - curr.timestamp) / 2) curr.timestamp curr.score
            , Bar [ fill blueFill ] ((next_.timestamp - curr.timestamp) / 2) curr.timestamp curr.score
            ]

          ( Just prev_, Just next_ ) ->
            [ Bar [] ((curr.timestamp - prev_.timestamp) / 2) curr.timestamp curr.score
            , Bar [ fill blueFill ] ((curr.timestamp - prev_.timestamp) / 2) curr.timestamp curr.score
            ]

          ( Just prev_, Nothing ) ->
            [ Bar [] ((plane.x.max - curr.timestamp) / 2) curr.timestamp curr.score
            , Bar [ fill blueFill ] ((plane.x.max - curr.timestamp) / 2) curr.timestamp curr.score
            ]

          ( Nothing, Nothing ) ->
            []
  in
  svg (static plane)
    [ histogram plane toBars data
    , xAxis plane [] 0
    , yAxis plane [] 0
    , xTicks plane 5 [] 0 (List.map .timestamp data)
    , yTicks plane 5 [] 0 [ 1, 2, 3 ]
    , xLabels plane (xLabel [] (.timestamp >> (+) 5) (.timestamp >> String.fromFloat)) 0 data
    ]
