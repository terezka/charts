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
    { init = Model [] []
    , update = \msg model ->
        case msg of
          OnHover bs ds -> { model | hoveringBars = bs, hoveringDots = ds }
          OnLeave -> { model | hoveringBars = [], hoveringDots = [] }

    , view = view
    }


type alias Model =
  { hoveringBars : List (C.BarItem (Maybe Float) BarPoint)
  , hoveringDots : List (C.DotItem (Maybe Float) BarPoint)
  }


type Msg
  = OnHover
      (List (C.BarItem (Maybe Float) BarPoint))
      (List (C.DotItem (Maybe Float) BarPoint))
  | OnLeave


type alias Point =
  { x : Float
  , y : Float
  , z : Float
  }


type alias BarPoint =
  { x : Float
  , y : Maybe Float
  , z : Maybe Float
  , label : String
  }


data : List BarPoint
data =
  [ { x = 0, y = Just 4, z = Just 5, label = "DK" }
  , { x = 4, y = Just 2, z = Just 3, label = "NO" }
  , { x = 6, y = Just 4, z = Nothing, label = "SE" }
  , { x = 8, y = Just 3, z = Just 7, label = "FI" }
  , { x = 10, y = Just 4, z = Just 3, label = "IS" }
  ]


data2 : List Point
data2 =
  [ { x = 1546300800000, y = 1, z = 4 }
  , { x = 1577840461000, y = 1, z = 5 }
  , { x = 1609462861000, y = 1, z = 3 }
  ]


view : Model -> Html.Html Msg
view model =
  C.chart
    [ C.width 600
    , C.height 300
    , C.marginTop 40
    , C.htmlAttrs
        [ HA.style "font-size" "12px"
        , HA.style "font-family" "monospace"
        , HA.style "margin" "20px 40px"
        , HA.style "max-width" "700px"
        ]
    , C.paddingLeft 10
    , C.events
        [ C.event "mousemove" <|
            C.map2 OnHover
              (C.getNearestX (C.barItem C.withUnknowns))
              (C.getNearest (C.dotItem C.withUnknowns))
        ]
    ]
    [ C.grid []

    , C.histogram .x
        [ C.tickLength 4
        , C.spacing 0.05
        , C.margin 0.1
        , C.binLabel .label
        ]
        [ C.bar .z [ C.barColor (\d -> C.pink), C.label "area", C.unit "m2" ]
        , C.bar .y [ C.barColor (\d -> C.blue), C.label "speed", C.unit "ms" ]
        ]
        data

    , C.yAxis []
    , C.yTicks []
    , C.xAxis []
    , C.yLabels []

    , C.series .x
        [ C.linear .y [ C.color C.blue ]
        , C.linear .z []
        ]
        data

    , C.whenNotEmpty model.hoveringDots <| \dot rest ->
        C.tooltipOnTop (always dot.position.x) (always dot.position.y)
          []
          [ tooltipRow dot.datum dot.metric dot.values ]

    , C.whenNotEmpty model.hoveringBars <| \bar rest ->
        C.tooltipOnTop (always bar.position.x) (always bar.position.y)
          []
          [ tooltipRow bar.datum bar.metric bar.values ]

    --, C.whenNotEmpty model.hovering <| \group rest ->
    --    C.tooltipOnTop (\_ -> group.position.x) (\_ -> group.position.y) [] <|
    --      List.map tooltipRow group.bars
    ]


tooltipRow : BarPoint -> C.Metric -> { x : Float, y : Maybe Float } -> Html.Html msg
tooltipRow datum metric values =
  Html.div [ HA.style "color" metric.color ]
    [ Html.span [] [ Html.text datum.label ]
    , Html.text " "
    , Html.text metric.label
    , Html.text " : "
    --, Html.text (String.fromFloat values.y)
    , Html.text <|
        case values.y of
          Just y -> String.fromFloat y
          Nothing -> "unknown"
    , Html.text " "
    , Html.text metric.unit
    ]
