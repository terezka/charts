module Test exposing (..)

import Html as H
import Html.Attributes as HA
import Svg as S exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes as SA exposing (width, height, stroke, fill, r, transform)
import Svg.Coordinates as Coordinates
import Svg.Chart as SC
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
  { hovering : List (CI.Collection () (List (CI.Product CS.Bar Datum)))
  }


init : Model
init =
  Model []


type Msg
  = OnHover (List (CI.Collection () (List (CI.Product CS.Bar Datum))))


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
  [ { x = 2, y = Just 6, z = Just 2, label = "DK" }
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
      , C.static
      --, C.marginTop 60
      , C.paddingTop 15
      --, C.range (C.startMin 0 >> C.endMax 6)
      --, C.domain (C.startMax 0 >> C.endMin 19)
      , C.events
          [ let filter series =
                  let _ =
                        series
                          |> List.filterMap CI.getBarSeries -- List series
                          |> List.concatMap CI.getProducts -- List Product
                          |> CI.getStacked
                          |> List.map (List.map (List.map (\i -> ( CI.getName i, CI.getDatum i ))))
                          |> Debug.log "here"
                  in
                  series
                    |> List.filterMap CI.getBarSeries -- List series
                    |> List.concatMap CI.getProducts -- List Product
                    |> CI.getStacked
                    |> List.map CI.toCollection
            in
            C.event "mousemove" <| C.map OnHover <| C.getNearestX CI.getCenter filter
          ]
      , C.id "salery-discrepancy"
      ]
      [ C.grid []

      , C.bars
          [ CA.roundTop 0.2
          , CA.roundBottom 0.2
          , CA.grouped
          , CA.x1 .x
          , CA.x2 (.x >> (\x -> x + 2))
          , CA.margin 0.1
          , CA.spacing 0.04
          ]
          [ C.stacked
              [ C.bar .y "cats" "km" [ C.borderWidth 1 ]
              , C.bar .z "dogs" "km" [ C.borderWidth 1 ]
              , C.bar (Just << .x) "fish" "km" [ C.borderWidth 1 ]
              ]
          , C.bar .z "kids" "km" []
          ]
          data

      , C.yAxis []
      , C.xTicks []
      , C.xLabels []
      , C.yLabels [ C.ints ]
      , C.yTicks [ C.ints ]

      , C.series .x
          [ C.stacked
              [ C.property .y "owls" "km" [ CA.linear, CA.opacity 0.25 ] [ CA.circle ]
                  --|> C.variation (\datum ->
                  --      if List.any (\i -> CI.getDatum i == datum) model.hovering
                  --      then [ CA.auraWidth 8, CA.aura 0.40, CA.size (Maybe.withDefault 2 datum.z * 5) ]
                  --      else [ CA.size (Maybe.withDefault 2 datum.z * 5) ])
              , C.property .z "trees" "km" [ CA.linear, CA.opacity 0.25, CA.color CA.purple ] [ CA.circle ]
                  --|> C.variation (\datum ->
                  --      if List.any (\i -> CI.getDatum i == datum) model.hovering
                  --      then [ CA.auraWidth 8, CA.aura 0.40, CA.size (Maybe.withDefault 2 datum.y * 5) ]
                  --      else [ CA.size (Maybe.withDefault 2 datum.y * 5) ])
              ]
          , C.property .y "cats" "km" [ CA.linear, CA.opacity 0 ] [ CA.circle, CA.color CA.pink ]
          ]
          data

      , C.xAxis []

      --, C.tooltip model.hoveringNew [ CA.onLeftOrRight, CA.offset 17 ] [] <| \hovered ->
      --    [ H.div []
      --        [ H.span
      --            [ HA.style "max-width" "200px"
      --            , HA.style "color" (CI.getColor hovered)
      --            ]
      --            [ H.text (CI.getName hovered)
      --            , H.text ": "
      --            , H.text (String.fromFloat <| Maybe.withDefault 0 <| CI.getValue hovered)
      --            ]

      --        ]
      --    ]

      , let tools : List (CI.Collection () (List (CI.Product CS.Bar Datum)))
            tools =
              model.hovering
                |> List.map CI.getItems -- List (List (List (CI.Product CS.Bar Datum)))
                |> List.concatMap (List.map (List.singleton >> CI.toCollection))
        in
        C.tooltip tools [ CA.onTop, CA.offset 17 ] [] <| \hovered ->
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
          List.concatMap (List.map viewOne) (CI.getItems hovered)
      ]
    ]

