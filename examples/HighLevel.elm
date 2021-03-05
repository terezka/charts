module HighLevel exposing (..)

import Html
import Html.Attributes as HA
import Svg exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes exposing (width, height, stroke, fill, r, transform)
import Svg.Coordinates as Coordinates
import Chart as C
import Svg.Chart as SC
import Browser
import Time



main =
  Browser.sandbox
    { init = []
    , update = \msg model ->
        case msg of
          OnHover p -> p
          OnLeave -> []

    , view = view
    }


type Msg
  = OnHover (List Point)
  | OnLeave


type alias Point =
  { x : Float
  , y : Float
  , z : Float
  }


data : List { x : Float, y : Float }
data =
  [ { x = -4, y = 4 }
  , { x = -2, y = 3 }
  , { x = 0, y = -4 }
  , { x = 4, y = -4 }
  , { x = 6, y = 4 }
  , { x = 8, y = 3 }
  , { x = 10, y = -4 }
  ]


data2 : List Point
data2 =
  [ { x = 1546300800000, y = 1, z = 4 }
  , { x = 1577840461000, y = 1, z = 5 }
  , { x = 1609462861000, y = 1, z = 3 }
  ]


view : List Point -> Html.Html Msg
view hovered =
  let specialDot p =
        if Maybe.map .x (List.head hovered) == Just p.x
          then SC.aura 2 8 0.2 SC.circle "rgb(5,142,218)"
          else SC.disconnected 2 1 SC.circle "rgb(5,142,218)"
  in
  C.chart
    [ C.width 600
    , C.height 300
    , C.marginTop 30
    , C.marginLeft 40
    , C.marginRight 15
    , C.responsive
    , C.range (C.fromData [.x] data2)
    , C.domain (C.fromData [.y] data2 |> C.startMin 0)
    , C.paddingY 0 10
    , C.topped 6
    , C.id "some-id"
    , C.htmlAttrs
        [ HA.style "font-size" "12px"
        , HA.style "font-family" "monospace"
        , HA.style "margin" "20px 40px"
        , HA.style "max-width" "700px"
        ]
    , C.events
        [ C.event "mousemove" (C.getNearestX OnHover .x [.y] data2)
        , C.event "mouseleave" (\_ _ -> OnLeave)
        ]
    ]
    [ C.grid [ C.width 0.4, C.color "rgb(220,220,220)" ]
    --, C.histogram .x
    --    [ C.Metric C.blue .y, C.Metric C.pink .z ]
    --    [ C.rounded 0.2, C.roundBottom, C.width (1000 * 60 * 60 * 24 * 365), C.margin 0.1 ]
    --    data2

    , C.xAxis   [ C.pinned C.zero ]
    , C.yAxis   [ C.pinned C.zero ]
    , C.xLabels [ C.pinned C.zero, C.times Time.utc ]
    , C.xTicks  [ C.pinned C.zero, C.times Time.utc ]
    , C.yLabels [ C.pinned C.zero, C.amount 7 ]
    , C.yTicks [  C.pinned C.zero, C.amount 7 ]

    , C.monotone .x .y [ C.dot specialDot, C.area "rgba(5, 142, 218, 0.25)" ] data2

    --, C.bars [ C.Metric C.blue .y, C.Metric C.orange .y ] [ C.width 0.9 ] data2

    , C.htmlAt (always 3) C.middle 0 0 [] [ Html.text "hello"]

    , case hovered of
        point :: _ ->
          C.tooltip (always point.x) (always point.y) []
            [ Html.text (C.formatTimestamp Time.utc point.x ++ ", " ++ String.fromFloat point.y) ]

        [] ->
          C.none
    ]




