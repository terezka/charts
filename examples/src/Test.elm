module Test exposing (..)

import Html as H
import Html.Attributes as HA
import Svg as S exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes as SA exposing (width, height, stroke, fill, r, transform)
import Svg.Coordinates as Coordinates
import Browser
import Time
import Data.Iris as Iris
import Data.Salery as Salery
import Data.Education as Education
import Dict

import Chart as C
import Chart.Attributes as CA
import Chart.Item as CI
import Chart.Svg as CS


-- TODO
-- labels + ticks + grid automation?
-- Title
-- seperate areas from lines + dots to fix opacity


main =
  Browser.sandbox
    { init = init
    , update = update
    , view = view
    }


type alias Model =
  { hovering : List (CI.Product CI.General Datum)
  }


init : Model
init =
  Model []


type Msg
  = OnHover (List (CI.Product CI.General Datum))


update : Msg -> Model -> Model
update msg model =
  case msg of
    OnHover items -> { model | hovering = items }


type alias Datum =
  { x : Float
  , y : Maybe Float
  , z : Maybe Float
  , label : String
  }


data : List Datum
data =
  [ { x = -1, y = Just 5, z = Just 3, label = "IT" }
  , { x = 0, y = Just 3, z = Just 6, label = "DE" }
  , { x = 2, y = Just 2, z = Just 2, label = "DK" }
  , { x = 6, y = Just 8, z = Just 5, label = "SE" }
  , { x = 8, y = Just 3, z = Just 2, label = "FI" }
  , { x = 10, y = Just 4, z = Just 3, label = "IS" }
  ]


view : Model -> H.Html Msg
view model =
  H.div
    [ HA.style "font-size" "12px"
    , HA.style "font-family" "monospace"
    , HA.style "margin" "0 auto"
    , HA.style "padding-top" "50px"
    , HA.style "width" "100vw"
    , HA.style "max-width" "1000px"
    ]
    [ C.chart
      [ CA.height 400
      , CA.width 1000
      , CA.static

      , C.marginTop 30
      , C.marginRight 30

      --, C.domain
      --    [ C.lowest -2 C.orLower
      --    , C.highest 5 C.orHigher
      --    ]

      , CA.events
          [ C.getNearestX CI.getCenter identity
              |> C.map OnHover
              |> C.event "mousemove"
          ]
      ]
      [ C.grid []

      , C.eachBin <| \p i ->
          [ C.label [ CA.yOff 15 ] (CI.getCommonality i).datum.label { x = (CI.getCenter p i).x, y = p.y.min } ]

      , C.xAxis []
      , C.yAxis []

      , C.bars
          [ CA.roundTop 0.1, CA.roundBottom 0.1 ]
          [ C.stacked
              [ C.bar .y "owls"
                  [ CA.color CA.blue
                  , CA.opacity 0.5
                  , CA.gradient [ CA.bottom CA.green ]
                  , CA.border "transparent"
                  , CA.borderWidth 0.5
                  ]
              , C.bar .z "trees"
                  [ CA.color CA.purple
                  , CA.opacity 0.5
                  , CA.gradient [ CA.bottom CA.pink ]
                  , CA.border "transparent"
                  , CA.borderWidth 0.5
                  ]
              ]
          ]
          data


      --, C.series .x
      --    [ C.stacked
      --        [ C.property .y "owls"
      --            [ CA.linear, CA.opacity 0.75
      --            , CA.dotted [ CA.color CA.blue, CA.width 2, CA.rotate 225 ]
      --            ]
      --            []
      --        , C.property .z "trees"
      --            [ CA.linear, CA.opacity 0.4, CA.color CA.purple
      --            , CA.gradient [ CA.top CA.purple, CA.bottom CA.pink ]
      --            ]
      --            [ CA.circle, CA.size 3 ]
      --        ]
      --    ]
      --    data

      , C.yLabels []

      , C.each (\_ -> CI.groupBy CI.isSameStack model.hovering) <| \p i ->
          let bin = CI.getCommonality i
              bounds = CI.getBounds i
              top = CI.getTop p i
              cen = CI.getCenter p i
          in
          [ C.tooltip i [ CA.onTop ] [] (List.map tooltipContent (CI.getProducts i))
          --, C.label [ CA.yOff -10 ] (String.fromFloat bounds.y2) { x = cen.x, y = top.y }
          ]
      ]
    ]


tooltipContent : CI.Product CI.General Datum -> H.Html msg
tooltipContent each =
  H.div
    [ HA.style "max-width" "200px"
    , HA.style "color" (CI.getColor each)
    ]
    [ H.text (CI.getName each)
    , H.text ": "
    , H.text (String.fromFloat <| Maybe.withDefault 0 <| CI.getValue each)
    ]
