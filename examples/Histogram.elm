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


-- TODO
-- labels + ticks + grid automation?
-- clean up Item / Items


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
  , { x = 6, y = Just 4, z = Nothing, label = "SE" }
  , { x = 8, y = Just 3, z = Just 7, label = "FI" }
  , { x = 10, y = Just 4, z = Just 3, label = "IS" }
  ]


view : Model -> H.Html Msg
view model =
  H.div []
    [ H.text "" -- viewBasic
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
    , C.events
        [ C.event "mouseleave" (C.map (\_ -> OnHover []) C.getCoords)
        , C.event "mousemove" <|
            C.map OnHover (C.getNearestX (C.withoutUnknowns >> C.getBars))
        ]
    ]
    [ C.grid []
    , C.histogram .x
        [ C.name "bars" ]
        [ C.bar (C.just .x) [ C.name "area", C.unit "m2" ]
        , C.bar .y [ C.name "speed", C.unit "km/h" ]
        , C.bar .z [ C.name "volume", C.unit "m3" ]
        ]
        data

    , C.yAxis []
    --, C.yTicks [ ] --  C.withGrid
    , C.xAxis []
    , C.yLabels [] --  C.withGrid
    --, C.xLabels [] --  C.withGrid

    , C.with C.getGroups <| \plane items ->
        let byItem i = [ i.position.x1, i.position.x2 ]
            values = List.concatMap byItem items
        in
        [ C.xTicks [ C.values identity values ]
        , C.xLabels
            [ C.yOffset -5
            , C.values (.center >> .x >> identity) items
            , C.format (.datum >> .label)
            ]
        ]

    , C.with C.getBars <| \plane items ->
        [ C.xLabels
            [ C.yOffset -25
            , C.values (.center >> .x) items
            , C.format (.position >> .y >> String.fromFloat)
            , C.at (.center >> .y)
            ]
        ]

    , C.when model.hovering <| \item rest ->
        C.tooltipOnTop (always item.center.x) (always item.position.y) [] [ tooltipRow item ]

    --, C.when model.hovering <| \item rest ->
    --    C.line [ C.horizontal 4, C.vertical 5 ]
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
