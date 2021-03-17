module Histogram exposing (..)

import Html as H
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
    { init = init
    , update = update
    , view = view
    }


type alias Model =
  { hovering : List (C.Single Float Datum)
  }


init : Model
init =
  Model []


type Msg
  = OnHover (List (C.Single Float Datum))


update : Msg -> Model -> Model
update msg model =
  case msg of
    OnHover bs -> { model | hovering = bs }


type alias Datum =
  { x : Float
  , y : Maybe Float
  , z : Maybe Float
  , label : String
  }


data : List Datum
data =
  [ { x = 2, y = Just 4, z = Just 5, label = "DK" }
  , { x = 4, y = Just 2, z = Just 3, label = "NO" }
  , { x = 6, y = Just 4, z = Just 0, label = "SE" }
  , { x = 8, y = Just 3, z = Just 7, label = "FI" }
  , { x = 10, y = Just 4, z = Just 3, label = "IS" }
  ]


view : Model -> H.Html Msg
view model =
  H.div []
    [ viewBasic
    , viewHover model
    ]

viewBasic : H.Html Msg
viewBasic =
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
    ]
    [ C.grid []
    , C.bars
        [ C.tickLength 4, C.binLabel .label ]
        [ C.bar (C.just .x) [ C.barColor (always C.pink) ]
        , C.bar .z [ C.barColor (always C.blue) ]
        , C.bar .y [ C.barColor (always C.orange) ]
        ] data

    , C.yAxis []
    , C.yTicks []

    , C.xAxis []
    --, C.xTicks []

    , C.yLabels []
    --, C.xLabels []
    ]



viewHover : Model -> H.Html Msg
viewHover model =
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
        [ C.event "mouseleave" (C.map (\_ -> OnHover []) C.getCoords)
        , C.event "mousemove" <|
            C.map OnHover
              --(C.noUnknowns C.getBars >> C.getNearestX)
              --(C.noUnknowns C.getDots >> C.getWithin 20)
              (C.getNearestX (C.withoutUnknowns >> C.getBars))
              --(C.getNearest (C.withoutUnknowns >> C.getDots))
        ]
    ]
    [ C.grid []

    , C.bars
        [ C.tickLength 4
        , C.spacing 0
        , C.margin 0
        --, C.binWidth (always 2)
        --, C.binLabel .label
        ]
        [ C.bar .z
            [ C.barColor (\d -> C.pink)
            , C.label "area"
            , C.unit "m2"
            , C.topLabel (.z >> Maybe.map String.fromFloat)
            ]
        --, C.bar .y [ C.barColor (\d -> C.blue), C.label "speed", C.unit "ms" ]
        ]
        data

    , C.yAxis []
    , C.yTicks []
    , C.xAxis []
    , C.yLabels []
    --, C.xTicks [ C.amount 10 ]
    , C.xLabels []

    --, C.series .x
    --    [ C.linear .y [ C.color C.blue ]
    --    , C.linear .z []
    --    ]
    --    data

    --, C.when model.hoveringDots <| \item rest ->
    --    C.tooltipOnTop (always item.position.x1) (always item.position.y) []
    --      [ tooltipRow item ]

    , C.when model.hovering <| \item rest ->
        C.tooltipOnTop (always item.center.x) (always item.position.y) []
          [ tooltipRow item ]

    --, C.when model.hovering <| \group rest ->
    --    C.tooltipOnTop (\_ -> group.position.x) (\_ -> group.position.y) [] <|
    --      List.map tooltipRow group.bars
    ]


tooltipRow : C.Single Float Datum -> H.Html msg
tooltipRow hovered =
  H.div [ HA.style "color" hovered.metric.color ]
    [ H.span [] [ H.text hovered.datum.label ]
    , H.text " "
    , H.text hovered.metric.label
    , H.text " : "
    , H.text (String.fromFloat hovered.values.y)
    --, H.text <|
    --    case hovered.values.y of
    --      Just y -> String.fromFloat y
    --      Nothing -> "unknown"
    , H.text " "
    , H.text hovered.metric.unit
    ]
