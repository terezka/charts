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


data : List { x : Float, y : Float, label : String }
data =
  [ { x = 0, y = 4, label = "DK" }
  , { x = 4, y = 2, label = "NO" }
  , { x = 6, y = 4, label = "SE" }
  , { x = 8, y = 3, label = "FI" }
  , { x = 10, y = 4, label = "UK" }
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

      barLabel i m d =
        if i == 1 && m.color == C.blue
          then Just (String.fromFloat (m.value d))
          else Nothing
  in
  C.chart
    [ C.width 600
    , C.height 300
    , C.marginTop 30
    , C.marginBottom 40
    , C.marginLeft 40
    , C.marginRight 15
    , C.responsive
    , C.range [.x]
    , C.domain [.y]
    , C.rangeEdit (C.endMin 12)
    , C.topped 6
    , C.id "some-id"
    , C.htmlAttrs
        [ HA.style "font-size" "12px"
        , HA.style "font-family" "monospace"
        , HA.style "margin" "20px 40px"
        , HA.style "max-width" "700px"
        ]
    --, C.events
    --    [ C.event "mousemove" (C.getNearestX OnHover)
    --    , C.event "mouseleave" (\_ _ -> OnLeave)
    --    ]
    ]
    [ C.grid [ C.width 0.4, C.color "rgb(220,220,220)" ]

    , C.histogram .x (String.fromFloat << .x)
        [ C.Metric C.blue .y, C.Metric C.pink .y ]
        [ C.rounded 0.2, C.roundBottom, C.binWidth (always 2), C.barLabel barLabel ]

    , C.xAxis   [ C.pinned C.zero ]
    , C.yAxis   [ C.pinned .min ]
    , C.yLabels [ C.pinned .min, C.amount 5 ]
    , C.yTicks [  C.pinned .min, C.amount 5 ]


    --, C.bars
    --    [ C.Metric C.blue .y, C.Metric C.pink .y, C.Metric C.orange .y ]
    --    [ C.margin 0.05, C.spacing 0.015, C.rounded 0.2, C.binLabel .label
        --, C.barLabel barLabel
    --    ]

    --, C.tooltip model.hovered
    --    [ C.attrs [ background ]
    --    , C.title <| \d ->
    --    , C.each <| \m d ->
    --    ]


    --, C.tooltipMany model.hovered
    --    [ C.attrs [ background ]
    --    , C.title <| \d ->
    --    , C.each <| \m d ->
    --    ]

    ]
    data





