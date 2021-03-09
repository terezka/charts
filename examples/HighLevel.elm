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
    { init = Model Nothing
    , update = \msg model ->
        case msg of
          OnHover ps -> { model | hovering = ps }
          OnLeave -> { model | hovering = Nothing }

    , view = view
    }


type alias Model =
  { hovering : Maybe (SC.DataPoint BarPoint)
  }


type Msg
  = OnHover (Maybe (SC.DataPoint BarPoint))
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
  , { x = 10, y = 4, z = 3, label = "IS" }
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
    , C.htmlAttrs
        [ HA.style "font-size" "12px"
        , HA.style "font-family" "monospace"
        , HA.style "margin" "20px 40px"
        , HA.style "max-width" "700px"
        ]
    , C.paddingLeft 10
    , C.events
        [ C.event "mousemove" (C.map OnHover C.getNearest)
        ]
    ]
    [
    --[ C.histogram .x
    --    [ C.tickLength 4, C.spacing 0.05, C.margin 0.1, C.binLabel .label, C.binWidth (always 2) ]
    --    [ C.bar .z []
    --    , C.bar .y [ C.barColor (\d -> C.pink) ]
    --    , C.bar .z []
    --    ]
    --    data
    C.yAxis []
    , C.yTicks []
    , C.yLabels [ C.center ]
    , C.xAxis []
    , C.xTicks [ C.amount 20 ]
    , C.xLabels []
    , C.series .x
        [ C.monotone .y [ C.label "velocity", C.unit "m/s" ]
        , C.linear .z []
        , C.scatter .x []
        ]
        data
    , C.whenJust model.hovering <| \hovered ->
        C.tooltipOnTop (\_ -> hovered.point.x) (\_ -> hovered.point.y) [ HA.style "color" hovered.color ] <|
          [ Html.span [] [ Html.text hovered.datum.label ]
          , Html.text " "
          , Html.text hovered.label
          , Html.text " : "
          , Html.span [] [ Html.text (String.fromFloat hovered.datum.x) ]
          , Html.text " "
          , Html.text hovered.unit
          , Html.text " , "
          , Html.span [] [ Html.text (String.fromFloat hovered.point.y) ]
          ]
    ]

