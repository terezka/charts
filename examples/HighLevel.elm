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
    { init = Model Nothing []
    , update = \msg model ->
        case msg of
          OnHover p ps -> { point = Just p, hovering = ps }
          OnLeave -> { point = Nothing, hovering = [] }

    , view = view
    }


type alias Model =
  { point : Maybe SC.Point
  , hovering : List BarPoint
  }


type Msg
  = OnHover SC.Point (List BarPoint)
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
        [ C.event "mousemove" <|
            C.map2 OnHover C.getPoint C.getNearestX
        ]
    ]
    [ C.bars
        [ ]
        [ C.bar .y [ C.color C.pink ]
        , C.bar .z []
        ]
        data
    , C.yAxis []
    , C.yLabels []
    , C.xAxis []
    --, C.xLabels []
    --, C.series .x
    --    [ C.monotone .y []
    --    , C.linear .z []
    --    , C.scatter .x []
    --    ]
    --    data
    , case ( model.point, model.hovering ) of
        ( Just point, points ) ->
          C.tooltip (\_ -> toFloat <| round point.x) C.middle [] <|
            List.map (\a -> Html.div [] [ Html.text a ]) <| String.split "}," (Debug.toString points)
        ( _, _ ) -> C.none
    ]

