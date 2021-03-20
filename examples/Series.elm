module Series exposing (..)

import Html as H
import Html.Attributes as HA
import Svg as S exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes as SA exposing (width, height, stroke, fill, r, transform)
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
        [ C.linear .z
            [ C.area 0.2
            , C.size (always 3)
            --, C.dot
            --    [ C.shape (always C.cross)
            --    , C.style (\d -> if isHovered d then C.aura 3 6 else C.disconnected 3)
            --    , C.size (always 6)
            --    ]
            ]
        , C.monotone .y []
        ]
        data
    ]


viewHover : Model -> H.Html Msg
viewHover model =
  let isHovered d =
        List.member d (List.map .datum model.hovering)
  in
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
        [ C.linear .z [ C.name "area", C.unit "m2", C.area 0.25, C.size (\d -> if isHovered d then 6 else 3), C.style (\_ -> C.empty 1), C.dot customDot ]
        , C.monotone .y [ C.name "speed", C.unit "km/h", C.size (\d -> if isHovered d then 6 else 3) ]
        ]
        data

    , C.when model.hovering <| \item rest ->
        C.tooltipOnTop (always item.center.x) (always item.center.y) []
          [ tooltipRow item ]
    ]


customDot : Datum -> S.Svg msg
customDot _ =
  S.rect [ SA.width "10", SA.height "20", SA.fill "lightblue", SA.transform "translate(-5,-10)" ] []


tooltipRow : C.Single Float Datum -> H.Html msg
tooltipRow hovered =
  H.div
    [ HA.style "color" hovered.metric.color ]
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
