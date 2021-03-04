module HighLevel exposing (..)

import Html
import Html.Attributes as HA
import Svg exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes exposing (width, height, stroke, fill, r, transform)
import Svg.Coordinates as Coordinates
import Chart as C
import Svg.Chart as SC
import Browser



main =
  Browser.sandbox
    { init = Nothing
    , update = \msg model ->
        case msg of
          OnHover p -> p
          OnLeave -> Nothing

    , view = view
    }


type Msg
  = OnHover (Maybe Point)
  | OnLeave


type alias Point =
  { x : Float
  , y : Float
  }


data : List Point
data =
  [ { x = -4, y = 4 }
  , { x = -2, y = 3 }
  , { x = 0, y = -4 }
  , { x = 4, y = -4 }
  , { x = 6, y = 4 }
  , { x = 8, y = 3 }
  , { x = 10, y = -4 }
  ]


view : Maybe Point -> Html.Html Msg
view hovered =
  C.chart
    [ C.width 500
    , C.height 300
    , C.marginTop 30
    , C.marginRight 10
    , C.responsive
    , C.range (C.fromData .x data)
    , C.domain (C.fromData .y data)
    , C.id "some-id"
    , C.events
        [ C.event "mousemove" (C.getNearest OnHover .x .y data)
        , C.event "mouseleave" (\_ _ -> OnLeave)
        ]
    ]
    [ C.grid [] (C.ints 12 String.fromInt) (C.ints 5 String.fromInt)
    , C.xAxis [ C.pinned (always 0) ]
    , C.xTicks [ C.height 8 ] (C.ints 12 String.fromInt)
    , C.xLabels [] (C.floats 12 String.fromFloat)
    , C.yAxis [ C.pinned (always 0) ]
    , C.yTicks [] (C.ints 5 String.fromInt)
    , C.yLabels [] (C.ints 5 String.fromInt)
    , C.monotone .x .y (\_ -> SC.full 6 SC.circle "blue") [ C.color "blue", C.width 1 ] data
    , C.svgAt 1 1 0 0 [ Svg.text_ [] [ Svg.text "Arbitrary SVG at (1, 1)!" ] ]
    , case hovered of
        Just point ->
          C.tooltip point.x point.y []
            [ Html.text ("( " ++ String.fromFloat point.x ++ ", " ++ String.fromFloat point.y ++ " )") ]

        Nothing ->
          C.none
    ]




