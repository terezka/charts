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

      , C.domain
          [ C.highest 1 C.more
          ]

      , CA.events
          [ C.getNearestX CI.getCenter identity
              |> C.map OnHover
              |> C.event "mousemove"
          ]
      ]
      [ C.grid []

      , C.withPlane <| \p ->
          [ C.title [ CA.xOff 20, CA.fontSize 12, CA.rotate 90 ] "Height"
              { x = 0, y = p.y.min + (p.y.max - p.y.min) * 0.85 }
          ]

      , C.xAxis []
      --, C.xLabels [ C.amount 10 ]
      --, C.yAxis [ C.pinned .dataMax ]

      , C.bars
          [ CA.roundTop 0.2
          --, CA.roundBottom 0.2
          , CA.margin 0.3
          ]
          [ C.stacked
              [ C.bar .y "owls"
                  [ CA.color CA.blue
                  --, CA.opacity 0.75
                  , CA.striped [ CA.width 2, CA.space 2, CA.rotate 135 ]
                  , CA.border "transparent"
                  , CA.borderWidth 0.5
                  ]
              , C.bar .z "trees"
                  [ CA.color CA.purple
                  --, CA.opacity 0.75
                  , CA.striped [ CA.width 2, CA.space 2, CA.rotate 45 ]
                  , CA.border "transparent"
                  , CA.borderWidth 0.5
                  ]
              ]
          ]
          data

      , C.eachBin <| \p i ->
          if List.isEmpty <| List.filterMap CI.isBarSeries (CI.getProducts i) then [] else
          [ C.title [ CA.yOff 5, CA.xOff 5, CA.borderWidth 0, CA.leftAlign ] (CI.getCommonality i).datum.label { x = CI.getX1 p i, y = p.y.max }
          ]

      --, C.series .x
      --    [ C.stacked
      --        [ C.property .y "owls"
      --            [ CA.linear, CA.opacity 0.5
      --            , CA.striped [ CA.width 2 ]
      --            ]
      --            [ CA.circle, CA.size 10, CA.opacity 0, CA.border CA.blue ]
      --        , C.property (C.just (.x >> (+) 4)) "kids"
      --            [ CA.linear, CA.opacity 0.4, CA.color CA.purple
      --            , CA.dotted [ CA.width 4 ]
      --            ]
      --            [ CA.circle, CA.size 10, CA.opacity 0, CA.border CA.purple ]
      --        , C.property .z "trees"
      --            [ CA.linear, CA.opacity 0.4, CA.color CA.pink, CA.dashed [ 5, 3 ]
      --            , CA.striped [ CA.width 5, CA.rotate 45, CA.space 3 ]
      --            ]
      --            [ CA.circle, CA.size 10, CA.opacity 0, CA.border CA.pink ]
      --        ]
      --    ]
      --    data

      , C.yLabels [ C.ints ]

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
