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
      [ C.height 400
      , C.width 1000
      , CA.static
      --, C.marginTop 60
      --, C.paddingTop 0
      --, C.paddingLeft 0
      --, C.paddingRight 0
      , C.range
          [ C.lowestShouldBe -2 C.orLower
          , C.highestShouldBe 12 C.orHigher
          ]
      , C.domain
          [ C.lowestShouldBe 0 C.orLower
          , C.lowestShouldBe 1 C.less
          , C.highestShouldBe 5 C.orHigher
          , C.highestShouldBe 8 C.orLower
          , C.highestShouldBe 1 C.more
          ]

      , C.events
          [ C.getNearestX CI.getCenter identity
              |> C.map OnHover
              |> C.event "mousemove"
          ]
      ]
      [ C.grid []

      --, C.bars
      --    [ CA.roundTop 0.2
      --    , CA.roundBottom 0.2
      --    , CA.grouped
      --    , CA.margin 0.1
      --    , CA.spacing 0.04
      --    ]
      --    [ C.stacked
      --        [ C.bar .y "cats" "km" [ CA.borderWidth 1 ]
      --        , C.bar .z "dogs" "km" [ CA.borderWidth 1 ]
      --        , C.bar (Just << .x) "fish" "km" [ CA.borderWidth 1 ]
      --        ]
      --    , C.bar .z "kids" "km" [ CA.color CA.purple ]
      --    ]
      --    data

      , C.eachBin <| \p i ->
          let bin = CI.getCommonality i
              pos = CI.getCenter p i
          in
          --[ C.label [ CA.yOff 15 ] (String.fromFloat bin.start) { x = bin.start, y = p.y.min }
          --, C.label [ CA.yOff 15 ] (String.fromFloat bin.end) { x = bin.end, y = p.y.min }
          [ C.label [ CA.yOff 15 ] bin.datum.label { x = pos.x, y = p.y.min }
          ]

      --, C.each (\_ -> CS.produce 10 CS.ints { min = 0, max = 20 }) <| \p int ->
      --    [ C.label [ CA.xOff 10, CA.yOff 3, CA.leftAlign ] (String.fromInt int) { x = 0, y = toFloat int } ]

      , C.yAxis []
      , C.yTicks [ C.ints ]
      , C.yLabels [ C.ints ]

      , C.series .x
          [ C.stacked
              [ C.property .y "owls" "km" [ CA.monotone, CA.opacity 0.25, CA.width 4 ] [ CA.circle, CA.opacity 0.25, CA.size 10 ]
                  |> C.variation (\datum ->
                        if List.any (\i -> CI.getDatum i == datum) model.hovering
                        then [ CA.auraWidth 5, CA.aura 0.40 ]
                        else [])
              , C.property .z "trees" "km" [ CA.monotone, CA.opacity 0.25, CA.width 4, CA.color CA.purple ] [ CA.circle, CA.opacity 0.25, CA.size 10 ]
                  |> C.variation (\datum ->
                        if List.any (\i -> CI.getDatum i == datum) model.hovering
                        then [ CA.auraWidth 5, CA.aura 0.40 ]
                        else [])
              ]
          ]
          data

      , C.each (\_ -> CI.groupBy CI.isSameStack model.hovering) <| \p i ->
          let bin = CI.getCommonality i
              bounds = CI.getBounds i
              top = CI.getTop p i
              cen = CI.getCenter p i
          in
          [ C.tooltip i [] [] <| List.map (\prod -> H.text (CI.getName prod)) (CI.getProducts i)
          , C.label [ CA.yOff -10 ] (String.fromFloat bounds.y2) { x = cen.x, y = top.y }
          ]


      , C.xAxis []
      , C.xLabels [ CA.yOff 20, C.amount 5 ]
      , C.xTicks [ C.amount 10, C.ints ]
      --, C.xLabels [ C.ints ]

      , C.yLabels [ C.ints ]

      --, C.tooltip (CI.groupBy CI.isSameStack model.hovering) [ CA.onTop, CA.offset 30 ] [] <| \hovered ->
      --    let viewOne each =
      --          H.div
      --              [ HA.style "max-width" "200px"
      --              , HA.style "color" (CI.getColor each)
      --              ]
      --              [ H.text (CI.getName each)
      --              , H.text ": "
      --              , H.text (String.fromFloat <| Maybe.withDefault 0 <| CI.getValue each)
      --              ]
      --    in
      --    List.map viewOne (CI.getProducts hovered)
      ]
    ]

