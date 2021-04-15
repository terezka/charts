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
      --, C.paddingLeft 15
      --, C.range (C.startMax 1.2 << C.endMax 6)
      , C.domain (C.startMin 0 << C.endMin 20)
      --, C.domain (C.startMin -1 << C.endMin 25)
      , C.events
          [ C.getNearestX CI.getCenter identity
              |> C.map OnHover
              |> C.event "mousemove"
          ]
      ]
      [ C.grid []

      , C.bars
          [ CA.roundTop 0.2
          , CA.roundBottom 0.2
          , CA.grouped
          , CA.margin 0.1
          , CA.spacing 0.04
          ]
          [ C.stacked
              [ C.bar .y "cats" "km" [ CA.borderWidth 1 ]
              , C.bar .z "dogs" "km" [ CA.borderWidth 1 ]
              , C.bar (Just << .x) "fish" "km" [ CA.borderWidth 1 ]
              ]
          , C.bar .z "kids" "km" [ CA.color CA.purple ]
          ]
          data

      , C.with (CI.onlyBarSeries >> CI.groupBy CI.isSameBin) <| \p ->
          List.concatMap <| \i ->
            let bin = CI.getCommonality i
                pos = CI.getCenter p i
            in
            [ C.label [ CA.yOff 15 ] (String.fromFloat bin.start) { x = bin.start, y = p.y.min }
            , C.label [ CA.yOff 15 ] (String.fromFloat bin.end) { x = bin.end, y = p.y.min }
            , C.label [ CA.yOff 15 ] bin.datum.label { x = pos.x, y = p.y.min }
            ]

      , C.with (CI.onlyBarSeries >> CI.groupBy CI.isSameStack) <| \p ->
          List.map <| \i ->
            let bin = CI.getCommonality i
                bounds = CI.getBounds i
                pos = CI.getCenter p i
            in
            C.label [ CA.yOff -10 ] (String.fromFloat bounds.y2) { x = pos.x, y = bounds.y2 }


      --, C.series .x
      --    [ C.stacked
      --        [ C.property .y "owls" "km" [ CA.linear, CA.opacity 0.25 ] [ CA.circle, CA.opacity 0.5 ]
      --            |> C.variation (\datum ->
      --                  if List.any (\i -> CI.getDatum i == datum) (List.concatMap CI.getProducts model.hovering)
      --                  then [ CA.auraWidth 8, CA.aura 0.40, CA.size (Maybe.withDefault 2 datum.z * 5) ]
      --                  else [ CA.size (Maybe.withDefault 2 datum.z * 5) ])
      --        , C.property .z "trees" "km" [ CA.linear, CA.opacity 0.25, CA.color CA.purple ] [ CA.circle, CA.opacity 0.5 ]
      --            |> C.variation (\datum ->
      --                  if List.any (\i -> CI.getDatum i == datum) (List.concatMap CI.getProducts model.hovering)
      --                  then [ CA.auraWidth 8, CA.aura 0.40, CA.size (Maybe.withDefault 2 datum.y * 5) ]
      --                  else [ CA.size (Maybe.withDefault 2 datum.y * 5) ])
      --        ]

      --    ]
      --    data

      , C.xAxis []
      , C.yAxis []
      --, C.xTicks [ C.amount 10, C.ints ]
      --, C.xLabels [ C.ints ]
      , C.yLabels [ C.ints ]
      , C.yTicks [ C.ints ]

      , C.tooltip (CI.groupBy CI.isSameStack model.hovering) [ CA.onTop, CA.offset 17 ] [] <| \hovered ->
          let viewOne each =
                H.div
                    [ HA.style "max-width" "200px"
                    , HA.style "color" (CI.getColor each)
                    ]
                    [ H.text (CI.getName each)
                    , H.text ": "
                    , H.text (String.fromFloat <| Maybe.withDefault 0 <| CI.getValue each)
                    ]
          in
          List.map viewOne (CI.getProducts hovered)
      ]
    ]

