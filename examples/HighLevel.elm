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
  { hoveringBars : List (C.Single Float BarPoint)
  , hoveringDots : List (C.Single Float BarPoint)
  }


type Msg
  = OnHover
      (List (C.Single Float BarPoint))
      (List (C.Single Float BarPoint))
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
              --(C.noUnknowns C.getBars >> C.getNearestX)
              --(C.noUnknowns C.getDots >> C.getWithin 20)
              (C.getNearestX (C.withoutUnknowns >> C.getBars))
              (C.getNearest (C.withoutUnknowns >> C.getDots))
        ]
    ]
    [ C.grid []

    , C.histogram .x
        [ C.tickLength 4
        , C.spacing 0
        , C.margin 0
        , C.bin
            [ C.name .label
            , C.width (always 2)
            , C.label [ C.color "gray", C.fontSize 10, C.yOffset -2 ]
            ]
        ]
        [ C.bar .z [ C.barColor (\d -> C.pink), C.name "area", C.unit "m2", C.topLabel (.z >> Maybe.map String.fromFloat) ]
        , C.bar .y [ C.barColor (\d -> C.blue), C.name "speed", C.unit "ms" ]
        ]
        data

    , C.yAxis []
    , C.yTicks []
    , C.xAxis []
    , C.yLabels []

    , C.series .x
        [ C.linear .y [ C.color C.blue, C.width 0.5, C.name "vel", C.unit "m/s" ]
        , C.linear .z []
        ]
        data

    , C.when model.hoveringDots <| \item rest ->
        C.tooltipOnTop (always item.position.x) (always item.position.y) []
          [ tooltipRow item ]

    , C.when model.hoveringBars <| \item rest ->
        C.tooltipOnTop (always item.position.x) (always item.position.y) []
          [ tooltipRow item ]

    --, C.when model.hovering <| \group rest ->
    --    C.tooltipOnTop (\_ -> group.position.x) (\_ -> group.position.y) [] <|
    --      List.map tooltipRow group.bars
    ]


tooltipRow : C.Single Float BarPoint -> Html.Html msg
tooltipRow hovered =
  Html.div [ HA.style "color" hovered.metric.color ]
    [ Html.span [] [ Html.text hovered.datum.label ]
    , Html.text " "
    , Html.text hovered.metric.name
    , Html.text " : "
    , Html.text (String.fromFloat hovered.values.y)
    --, Html.text <|
    --    case hovered.values.y of
    --      Just y -> String.fromFloat y
    --      Nothing -> "unknown"
    , Html.text " "
    , Html.text hovered.metric.unit
    ]

