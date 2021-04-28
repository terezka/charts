module Features exposing (..)

import Html as H
import Html.Attributes as HA
import Html.Events as HE
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


main =
  Browser.sandbox
    { init = init
    , update = update
    , view = view
    }


type alias Model =
  { select : Maybe { a : Float, b : Float }
  , rangeMin : Float
  , rangeMax : Float
  }


init : Model
init =
  Model Nothing 1262217600000 1640908800000


type Msg
  = OnMouseDown Coordinates.Point
  | OnMouseMove Coordinates.Point
  | OnMouseUp Coordinates.Point
  | OnReset


update : Msg -> Model -> Model
update msg model =
  case msg of
    OnMouseDown coords ->
      { model | select = Just { a = coords.x, b = coords.x } }

    OnMouseMove coords ->
      case model.select of
        Nothing -> model
        Just select -> { model | select = Just { select | b = coords.x } }

    OnMouseUp coords ->
      case model.select of
        Nothing -> model
        Just select ->
          { model | select = Nothing, rangeMin = min select.a coords.x, rangeMax = max select.a coords.x }

    OnReset ->
      init


view : Model -> H.Html Msg
view model =
  H.div
    [ HA.style "font-size" "12px"
    , HA.style "font-family" "monospace"
    , HA.style "margin" "0 auto"
    , HA.style "padding-top" "50px"
    , HA.style "padding-bottom" "100px"
    , HA.style "width" "100vw"
    , HA.style "max-width" "1000px"
    , HA.style "display" "flex"
    , HA.style "flex-flow" "wrap"
    ]
    [ H.h1 [ HA.style "width" "100%" ] [ H.text "Axes and grid" ]
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.xAxis []
        , C.xLabels []
        , C.yAxis []
        , C.yLabels []
        ]

    -- GRID
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels []
        , C.yAxis []
        , C.yLabels []
        ]

    , H.h1 [ HA.style "width" "100%" ] [ H.text "Scatters" ]

    -- SCATTER
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels []
        , C.yAxis []
        , C.yLabels []
        , C.series .x
            [ C.property .y "y" [] [] ]
            [ { x = 0, y = Just 2 }
            , { x = 5, y = Just 3 }
            , { x = 10, y = Just 4 }
            ]
        ]

    -- SCATTER / TRIANGLE
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels []
        , C.yAxis []
        , C.yLabels []
        , C.series .x
            [ C.property .y "y" [] [ CA.triangle ] ]
            [ { x = 0, y = Just 2 }
            , { x = 5, y = Just 3 }
            , { x = 10, y = Just 4 }
            ]
        ]

    -- SCATTER / SIZE
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels []
        , C.yAxis []
        , C.yLabels []
        , C.series .x
            [ C.property .y "y" [] [ CA.size 10 ] ]
            [ { x = 0, y = Just 2 }
            , { x = 5, y = Just 3 }
            , { x = 10, y = Just 4 }
            ]
        ]

    -- SCATTER / COLOR
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels []
        , C.yAxis []
        , C.yLabels []
        , C.series .x
            [ C.property .y "y" [] [ CA.color CA.purple ] ]
            [ { x = 0, y = Just 2 }
            , { x = 5, y = Just 3 }
            , { x = 10, y = Just 4 }
            ]
        ]

    , H.h1 [ HA.style "width" "100%" ] [ H.text "Interpoliations" ]

    -- LINEAR
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels []
        , C.yAxis []
        , C.yLabels []
        , C.series .x
            [ C.property .y "y" [ CA.linear, CA.opacity 0 ] [] ]
            [ { x = 0, y = Just 2 }
            , { x = 5, y = Just 3 }
            , { x = 10, y = Just 4 }
            ]
        ]

    -- LINEAR / DOT
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels []
        , C.yAxis []
        , C.yLabels []
        , C.series .x
            [ C.property .y "y" [ CA.linear, CA.opacity 0 ] [ CA.cross ] ]
            [ { x = 0, y = Just 2 }
            , { x = 5, y = Just 3 }
            , { x = 10, y = Just 4 }
            ]
        ]

    -- MONOTONE
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels []
        , C.yAxis []
        , C.yLabels []
        , C.series .x
            [ C.property .y "y" [ CA.monotone, CA.opacity 0 ] [] ]
            [ { x = 0, y = Just 2 }
            , { x = 0.5, y = Just 1 }
            , { x = 1, y = Just 4 }
            , { x = 2, y = Just 3 }
            ]
        ]

    -- LINEAR / AREA
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels []
        , C.yAxis []
        , C.yLabels []
        , C.series .x
            [ C.property .y "y" [ CA.linear ] [] ]
            [ { x = 0, y = Just 2 }
            , { x = 5, y = Just 3 }
            , { x = 10, y = Just 4 }
            ]
        ]

    -- LINEAR / SEVERAL
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels []
        , C.yAxis []
        , C.yLabels []
        , C.series .x
            [ C.property .y "y" [ CA.linear, CA.opacity 0 ] []
            , C.property .z "z" [ CA.linear, CA.opacity 0 ] []
            ]
            [ { x = 0, y = Just 2, z = Just 1 }
            , { x = 1, y = Just 3, z = Just 2 }
            , { x = 2, y = Just 4, z = Just 0.5 }
            ]
        ]

     -- LINEAR / DASH
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels []
        , C.yAxis []
        , C.yLabels []
        , C.series .x
            [ C.property .y "y" [ CA.linear, CA.opacity 0, CA.dashed [ 2, 3 ] ] []
            , C.property .z "z" [ CA.linear, CA.opacity 0 ] []
            ]
            [ { x = 0, y = Just 2, z = Just 1 }
            , { x = 1, y = Just 3, z = Just 2 }
            , { x = 2, y = Just 4, z = Just 0.5 }
            ]
        ]

    -- LINEAR / STACKED
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels []
        , C.yAxis []
        , C.yLabels []
        , C.series .x
            [ C.stacked
                [ C.property .y "y" [ CA.linear, CA.opacity 0 ] []
                , C.property .z "z" [ CA.linear, CA.opacity 0, CA.color CA.purple ] []
                ]
            ]
            [ { x = 0, y = Just 2, z = Just 1 }
            , { x = 1, y = Just 3, z = Just 2 }
            , { x = 2, y = Just 4, z = Just 0.5 }
            ]
        ]

    -- AREA / STACKED
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels []
        , C.yAxis []
        , C.yLabels []
        , C.series .x
            [ C.stacked
                [ C.property .y "y" [ CA.linear ] []
                , C.property .z "z" [ CA.linear, CA.color CA.purple ] []
                ]
            ]
            [ { x = 0, y = Just 2, z = Just 1 }
            , { x = 1, y = Just 3, z = Just 2 }
            , { x = 2, y = Just 4, z = Just 0.5 }
            ]
        ]

    , H.h1 [ HA.style "width" "100%" ] [ H.text "Bars" ]

    -- BARS
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels [ C.amount 4 ]
        , C.yAxis []
        , C.yLabels []
        , C.bars
            []
            [ C.bar .y "y" []
            ]
            [ { x = 0, y = Just 2, z = Just 1 }
            , { x = 1, y = Just 3, z = Just 2 }
            , { x = 2, y = Just 4, z = Just 0.5 }
            ]
        ]

    -- BARS
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels [ C.amount 4 ]
        , C.yAxis []
        , C.yLabels []
        , C.bars
            []
            [ C.bar .y "y" []
            , C.bar .z "z" []
            ]
            [ { x = 0, y = Just 2, z = Just 1 }
            , { x = 1, y = Just 3, z = Just 2 }
            , { x = 2, y = Just 4, z = Just 0.5 }
            ]
        ]

    -- BARS / GROUPED
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels [ C.amount 4 ]
        , C.yAxis []
        , C.yLabels []
        , C.bars
            [ CA.grouped ]
            [ C.bar .y "y" []
            , C.bar .z "z" []
            ]
            [ { x = 0, y = Just 2, z = Just 1 }
            , { x = 1, y = Just 3, z = Just 2 }
            , { x = 2, y = Just 4, z = Just 0.5 }
            ]
        ]

    -- BARS / STACKED
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels [ C.amount 4 ]
        , C.yAxis []
        , C.yLabels []
        , C.bars
            [ CA.grouped ]
            [ C.stacked
                [ C.bar .y "y" []
                , C.bar .z "z" []
                ]
            ]
            [ { x = 0, y = Just 2, z = Just 1 }
            , { x = 1, y = Just 3, z = Just 2 }
            , { x = 2, y = Just 4, z = Just 0.5 }
            ]
        ]

    -- BARS / ROUNDED TOP
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels [ C.amount 4 ]
        , C.yAxis []
        , C.yLabels []
        , C.bars
            [ CA.grouped
            , CA.roundTop 0.2
            ]
            [ C.stacked
                [ C.bar .y "y" []
                , C.bar .z "z" []
                ]
            ]
            [ { x = 0, y = Just 2, z = Just 1 }
            , { x = 1, y = Just 3, z = Just 2 }
            , { x = 2, y = Just 4, z = Just 0.5 }
            ]
        ]

    -- BARS / ROUNDED BOTTOM
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels [ C.amount 4 ]
        , C.yAxis []
        , C.yLabels []
        , C.bars
            [ CA.grouped
            , CA.roundTop 0.2
            , CA.roundBottom 0.2
            ]
            [ C.stacked
                [ C.bar .y "y" []
                , C.bar .z "z" []
                ]
            ]
            [ { x = 0, y = Just 2, z = Just 1 }
            , { x = 1, y = Just 3, z = Just 2 }
            , { x = 2, y = Just 4, z = Just 0.5 }
            ]
        ]

    -- BARS / MARGIN
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels [ C.amount 4 ]
        , C.yAxis []
        , C.yLabels []
        , C.bars
            [ CA.grouped
            , CA.margin 0.3
            ]
            [ C.stacked
                [ C.bar .y "y" []
                , C.bar .z "z" []
                ]
            ]
            [ { x = 0, y = Just 2, z = Just 1 }
            , { x = 1, y = Just 3, z = Just 2 }
            , { x = 2, y = Just 4, z = Just 0.5 }
            ]
        ]

    -- BARS / MARGIN
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels [ C.amount 4 ]
        , C.yAxis []
        , C.yLabels []
        , C.bars
            [ CA.grouped
            , CA.spacing 0.1
            ]
            [ C.stacked
                [ C.bar .y "y" []
                , C.bar .z "z" []
                ]
            , C.bar .y "y2" [ CA.color CA.purple ]
            ]
            [ { x = 0, y = Just 2, z = Just 1 }
            , { x = 1, y = Just 3, z = Just 2 }
            , { x = 2, y = Just 4, z = Just 0.5 }
            ]
        ]

    -- BARS / PATTERN
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels [ C.amount 4 ]
        , C.yAxis []
        , C.yLabels []
        , C.bars
            []
            [ C.bar .y "y" [ CA.striped [] ]
            ]
            [ { x = 0, y = Just 2, z = Just 1 }
            , { x = 1, y = Just 3, z = Just 2 }
            , { x = 2, y = Just 4, z = Just 0.5 }
            ]
        ]

    -- BARS / PATTERN
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels [ C.amount 4 ]
        , C.yAxis []
        , C.yLabels []
        , C.bars
            []
            [ C.bar .y "y" [ CA.striped [ CA.rotate 45 ] ]
            ]
            [ { x = 0, y = Just 2, z = Just 1 }
            , { x = 1, y = Just 3, z = Just 2 }
            , { x = 2, y = Just 4, z = Just 0.5 }
            ]
        ]

    -- BARS / PATTERN
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels [ C.amount 4 ]
        , C.yAxis []
        , C.yLabels []
        , C.bars
            []
            [ C.bar .y "y" [ CA.striped [ CA.rotate 45, CA.width 2 ] ]
            ]
            [ { x = 0, y = Just 2, z = Just 1 }
            , { x = 1, y = Just 3, z = Just 2 }
            , { x = 2, y = Just 4, z = Just 0.5 }
            ]
        ]

    -- BARS / PATTERN
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels [ C.amount 4 ]
        , C.yAxis []
        , C.yLabels []
        , C.bars
            []
            [ C.bar .y "y" [ CA.striped [ CA.rotate 45, CA.width 2, CA.space 2 ] ]
            ]
            [ { x = 0, y = Just 2, z = Just 1 }
            , { x = 1, y = Just 3, z = Just 2 }
            , { x = 2, y = Just 4, z = Just 0.5 }
            ]
        ]

    -- BARS / PATTERN
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels [ C.amount 4 ]
        , C.yAxis []
        , C.yLabels []
        , C.bars
            []
            [ C.bar .y "y" [ CA.dotted [] ]
            ]
            [ { x = 0, y = Just 2, z = Just 1 }
            , { x = 1, y = Just 3, z = Just 2 }
            , { x = 2, y = Just 4, z = Just 0.5 }
            ]
        ]

    -- BARS / PATTERN
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels [ C.amount 4 ]
        , C.yAxis []
        , C.yLabels []
        , C.bars
            []
            [ C.bar .y "y" [ CA.dotted [ CA.rotate 45 ] ]
            ]
            [ { x = 0, y = Just 2, z = Just 1 }
            , { x = 1, y = Just 3, z = Just 2 }
            , { x = 2, y = Just 4, z = Just 0.5 }
            ]
        ]

    -- BARS / PATTERN
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels [ C.amount 4 ]
        , C.yAxis []
        , C.yLabels []
        , C.bars
            []
            [ C.bar .y "y" [ CA.dotted [ CA.rotate 45, CA.width 3 ] ]
            ]
            [ { x = 0, y = Just 2, z = Just 1 }
            , { x = 1, y = Just 3, z = Just 2 }
            , { x = 2, y = Just 4, z = Just 0.5 }
            ]
        ]

    -- BARS / PATTERN
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels [ C.amount 4 ]
        , C.yAxis []
        , C.yLabels []
        , C.bars
            []
            [ C.bar .y "y" [ CA.dotted [ CA.rotate 45, CA.width 2, CA.space 3 ] ]
            ]
            [ { x = 0, y = Just 2, z = Just 1 }
            , { x = 1, y = Just 3, z = Just 2 }
            , { x = 2, y = Just 4, z = Just 0.5 }
            ]
        ]

    -- BARS / NEGATIVE
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels [ C.amount 4 ]
        , C.yAxis []
        , C.yLabels []
        , C.bars
            [ CA.roundTop 0.2
            , CA.roundBottom 0.2
            , CA.grouped
            ]
            [ C.bar .y "y" []
            , C.bar .z "z" []
            ]
            [ { x = 0, y = Just 2, z = Just 1 }
            , { x = 1, y = Just -3, z = Just -2 }
            , { x = 2, y = Just 4, z = Just 3 }
            ]
        ]


    , H.h1 [ HA.style "width" "100%" ] [ H.text "Editing range and domain" ]

    -- BARS / EDIT DOMAIN
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        , C.domain
            [ C.lowest -1 C.orHigher
            , C.highest 5 C.orHigher
            ]
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels [ C.amount 4 ]
        , C.yAxis []
        , C.yLabels []
        , C.bars
            [ CA.roundTop 0.2
            , CA.roundBottom 0.2
            , CA.grouped
            ]
            [ C.bar .y "y" []
            , C.bar .z "z" []
            ]
            [ { x = 0, y = Just 2, z = Just 1 }
            , { x = 1, y = Just -3, z = Just -2 }
            , { x = 2, y = Just 4, z = Just 3 }
            ]
        ]

    -- BARS / EDIT RANGE
    , C.chart
        [ CA.height 250
        , CA.width 250
        , CA.static
        , C.range
            [ C.lowest 1.2 C.orHigher
            , C.highest 5 C.orHigher
            ]
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels [ C.amount 4 ]
        , C.yAxis []
        , C.yLabels []
        , C.bars
            [ CA.roundTop 0.2
            , CA.roundBottom 0.2
            , CA.grouped
            ]
            [ C.bar .y "y" []
            , C.bar .z "z" []
            ]
            [ { x = 0, y = Just 2, z = Just 1 }
            , { x = 1, y = Just -3, z = Just -2 }
            , { x = 2, y = Just 4, z = Just 3 }
            ]
        ]


    , H.h1 [ HA.style "width" "100%" ] [ H.text "Editing ticks and labels" ]
    , H.button [ HE.onClick OnReset ] [ H.text "Reset" ]
    , H.node "style" [] [ H.text ".elm-charts__label { user-select: none; } " ]

    -- LABELS
    , C.chart
        [ CA.height 250
        , CA.width 1000
        , CA.static
        , C.range
            [ C.lowest model.rangeMin C.exactly
            , C.highest model.rangeMax C.exactly
            ]
        , CA.events
            [ C.event "mousedown" (C.map OnMouseDown C.getCoords)
            , C.event "mousemove" (C.map OnMouseMove C.getCoords)
            , C.event "mouseup" (C.map OnMouseUp C.getCoords)
            ]
        ]
        [ C.grid []
        , C.xAxis []
        , C.xLabels [ C.amount 12, C.times Time.utc ]
        , C.yAxis []
        , C.yLabels []
        , case model.select of
            Just select -> C.rect [ CA.x1 select.a, CA.x2 select.b ]
            Nothing -> C.none
        ]
    ]
