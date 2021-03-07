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


type alias BarPoint =
  { x : Float
  , y : Float
  , z : Float
  , label : String
  }


data : List BarPoint
data =
  [ { x = 0, y = 6, z = 3, label = "DK" }
  , { x = 4, y = 2, z = 2, label = "NO" }
  , { x = 6, y = 4, z = 5, label = "SE" }
  , { x = 8, y = 3, z = 7, label = "FI" }
  , { x = 10, y = 4, z = 3, label = "UK" }
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
          then SC.aura 2 8 0.2 SC.circle C.blue
          else SC.disconnected 2 1 SC.circle C.blue

      specialDot2 p =
        if Maybe.map .x (List.head hovered) == Just p.x
          then SC.aura 2 8 0.2 SC.circle C.orange
          else SC.disconnected 2 1 SC.circle C.orange

      barLabel i m d =
        if i == 1 && m.label == "speed"
          then Just (String.fromFloat (m.value d))
          else Nothing
  in
  C.chart
    [ C.width 600
    , C.height 300
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
    [ C.grid []

    --, C.histogram .x
    --    [ C.binWidth (always 2) ]
    --    [ C.bar .y [ C.label "speed", C.unit "m/s", C.color C.blue, C.rounded 0.2, C.roundBottom ]
    --    , C.bar .y [ C.label "weight", C.unit "kg", C.color C.pink, C.label label  ]
    --    ]

    --, C.xAxis []
        --[ C.ticks
        --, C.labels []
        --]


    , C.xAxis []
    , C.xLabels []
    , C.xTicks []
    , C.yAxis []
    , C.yLabels []
    , C.yTicks []

    , C.series .x
        [ C.monotone .y [] -- [ C.label "speed", C.unit "m/s", C.color C.blue, C.shape C.circle ]
        , C.linear (.z >> (+) 1) [] -- [ C.label "weight", C.unit "kg", C.color C.pink, C.shape C.circle ]
        , C.scatter (.z >> (+) 2) [] -- [ C.label "weight", C.unit "kg", C.color C.pink, C.shape C.circle ]
        , C.scatter (.z >> (+) 3) [] -- [ C.label "weight", C.unit "kg", C.color C.pink, C.shape C.circle ]
        , C.scatter (.z >> (+) 4) [] -- [ C.label "weight", C.unit "kg", C.color C.pink, C.shape C.circle ]
        , C.scatter (.z >> (+) 6) [] -- [ C.label "weight", C.unit "kg", C.color C.pink, C.shape C.circle ]
        , C.scatter (.z >> (+) 7) [] -- [ C.label "weight", C.unit "kg", C.color C.pink, C.shape C.circle ]
        , C.scatter (.z >> (+) 8) [] -- [ C.label "weight", C.unit "kg", C.color C.pink, C.shape C.circle ]
        , C.scatter .z [] -- [ C.label "weight", C.unit "kg", C.color C.pink, C.shape C.circle ]
        ]

    --, C.monotone .x .z [ C.dot specialDot2, C.color C.orange, C.area "rgba(244, 149, 69, 0.3)" ]

    --, C.bars
    --    [ C.Metric "speed" "m/s" C.blue .y
    --    , C.Metric "width" "m" C.pink .y
    --    , C.Metric "weight" "kg" C.orange .y
    --    ]
    --    [ C.margin 0.02, C.spacing 0.015, C.rounded 0.2, C.binLabel .label
    --    , C.barLabel barLabel
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

