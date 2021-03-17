module Series exposing (..)

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
  }


data : List Datum
data =
  [ { x = 2, y = Just 4, z = Just 5 }
  , { x = 4, y = Just 2, z = Just 3 }
  , { x = 6, y = Just 4, z = Nothing }
  , { x = 8, y = Just 3, z = Just 7 }
  , { x = 10, y = Just 4, z = Just 3 }
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
    , C.paddingLeft 10
    , C.htmlAttrs
        [ HA.style "font-size" "12px"
        , HA.style "font-family" "monospace"
        , HA.style "margin" "20px 40px"
        , HA.style "max-width" "700px"
        ]
    ]
    [ C.grid []

    , C.yAxis []
    , C.xAxis []
    , C.yTicks []
    , C.yLabels []

    , C.series .x
        [ C.linear .z [ C.area "rgba(5,142,218, 0.25)" ]
        , C.monotone .y []
        ]
        data


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
            C.map OnHover (C.getNearest (C.withoutUnknowns >> C.getDots))
        ]
    ]
    [ C.grid []

    , C.yAxis []
    , C.yTicks []
    , C.xAxis []
    , C.yLabels []
    , C.xLabels []

    , C.series .x
        [ C.linear .z [ C.label "area", C.unit "m2", C.area "rgba(5,142,218, 0.25)" ]
        , C.monotone .y [ C.label "speed", C.unit "km/h" ]
        ]
        data

    , C.when model.hovering <| \item rest ->
        C.tooltipOnTop (always item.center.x) (always item.center.y) []
          [ tooltipRow item ]
    ]


tooltipRow : C.Single Float Datum -> H.Html msg
tooltipRow hovered =
  H.div [ HA.style "color" hovered.metric.color ]
    [ H.text hovered.metric.label
    , H.text " : "
    , H.text (String.fromFloat hovered.values.y)
    --, H.text <|
    --    case hovered.values.y of
    --      Just y -> String.fromFloat y
    --      Nothing -> "unknown"
    , H.text " "
    , H.text hovered.metric.unit
    ]
