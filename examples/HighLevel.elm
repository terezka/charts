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
  [ { x = 0, y = 4 }
  , { x = 4, y = 2 }
  , { x = 6, y = 4 }
  , { x = 8, y = 3 }
  , { x = 10, y = 4 }
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
    , C.marginBottom 40
    , C.marginLeft 40
    , C.marginRight 15
    , C.responsive
    , C.range (C.fromData [.x] data |> C.startMin 0 |> C.startPad 2 |> C.endPad 2)
    , C.domain (C.fromData [.y] data |> C.startMin 0)
    , C.topped 6
    , C.id "some-id"
    , C.htmlAttrs
        [ HA.style "font-size" "12px"
        , HA.style "font-family" "monospace"
        , HA.style "margin" "20px 40px"
        , HA.style "max-width" "700px"
        ]
    --, C.events
    --    [ C.event "mousemove" (C.getNearestX OnHover .x [.y] data)
    --    , C.event "mouseleave" (\_ _ -> OnLeave)
    --    ]
    ]
    [ C.grid [ C.width 0.4, C.color "rgb(220,220,220)" ]
    , C.histogram .x (String.fromFloat << .x)
        [ C.Metric C.blue .y, C.Metric C.pink .y ]
        [ C.rounded 0.2, C.roundBottom, C.binWidth (always 2) ]
        data

    , C.xAxis   [ C.pinned C.zero ]
    , C.yAxis   [ C.pinned .min ]
    , C.yLabels [ C.pinned .min, C.amount 7 ]
    , C.yTicks [  C.pinned .min, C.amount 7 ]

    --, C.monotone .x .y [ C.dot specialDot, C.area "rgba(5, 142, 218, 0.25)" ] data

    --, C.bars [ C.Metric C.blue .y, C.Metric C.pink .y ] [ C.margin 0.05, C.spacing 0.015, C.rounded 0.2, C.label (.x >> String.fromFloat) ] data

    --, case hovered of
    --    point :: _ ->
    --      C.tooltip (always point.x) (always point.y) []
    --        [ Html.text (C.formatTimestamp Time.utc point.x ++ ", " ++ String.fromFloat point.y) ]

    --    [] ->
    --      C.none
    ]




