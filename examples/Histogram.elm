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
        []
        [ C.bar (C.just .x) []
        , C.bar .z []
        , C.bar .y []
        ] data

    , C.yAxis []
    , C.xAxis []
    , C.yTicks []
    , C.yLabels []
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
            C.map OnHover (C.getNearestX (C.withoutUnknowns >> C.getBars))
        ]
    ]
    [ C.grid []

    , C.bars
        [ C.tick [ C.height 4, C.color "black" ] -- TODO
        ]
        [ C.bar (C.just .x)
            [ C.name "area"
            , C.unit "m2"
            , C.label []
            ]
        , C.bar .y
            [ C.name "speed"
            , C.unit "km/h"
            , C.label []
            ]
        , C.bar .z
            [ C.name "volume"
            , C.unit "m3"
            , C.label []
            ]
        ]
        data

    , C.yAxis []
    , C.yTicks []
    , C.xAxis []
    , C.yLabels []
    , C.xLabels []

    , C.when model.hovering <| \item rest ->
        C.tooltipOnTop (always item.center.x) (always item.position.y) []
          [ tooltipRow item ]
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
