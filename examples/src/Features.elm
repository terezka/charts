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
import Data.Salary as Salary
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
  , hoveringScatter : List (CI.Product CI.General ScatterDatum)
  , hoveringBars : List (CI.Product CI.General ScatterDatum)
  , hoveringStackedBars : List (CI.Product CI.General ScatterDatum)
  , hoveringBinnedBars : List (CI.Group (CI.Bin ScatterDatum) CI.General ScatterDatum)
  -- SALERY
  , selectSalary : Maybe { a : Coordinates.Point, b : Coordinates.Point }
  , hoveringSalary : List (CI.Product CI.General Salary.Datum)
  , salaryWindow : Maybe Coordinates.Position
  , salaryYear : Float
  }


init : Model
init =
  Model Nothing 1262217600000 1640908800000 [] [] [] [] Nothing [] Nothing 2019


type alias ScatterDatum =
  { x : Float
  , y : Maybe Float
  , z : Maybe Float
  , s : Float
  }



type Msg
  = OnMouseDown Coordinates.Point
  | OnMouseMove Coordinates.Point
  | OnMouseUp Coordinates.Point
  | OnReset
  --
  | OnHoverScatter (List (CI.Product CI.General ScatterDatum))
  | OnHoverBars (List (CI.Product CI.General ScatterDatum))
  | OnHoverStackedBars (List (CI.Product CI.General ScatterDatum))
  | OnHoverBinnedBars (List (CI.Group (CI.Bin ScatterDatum) CI.General ScatterDatum))
  --
  | OnHoverSalary (List (CI.Product CI.General Salary.Datum)) Coordinates.Point
  | OnMouseDownSalary Coordinates.Point
  | OnMouseUpSalary Coordinates.Point
  | OnResetSalary
  | OnResetSalaryWindow
  | OnSalaryYear Float


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

    --

    OnHoverScatter hovering ->
      { model | hoveringScatter = hovering }

    OnHoverBars hovering ->
      { model | hoveringBars = hovering }

    OnHoverStackedBars hovering ->
      { model | hoveringStackedBars = hovering }

    OnHoverBinnedBars hovering ->
      { model | hoveringBinnedBars = hovering }


    --

    OnHoverSalary hovering coords ->
      case model.selectSalary of
        Nothing -> { model | hoveringSalary = hovering }
        Just select -> { model | selectSalary = Just { select | b = coords }, hoveringSalary = [] }

    OnMouseDownSalary coords ->
      { model | selectSalary = Just { a = coords, b = coords } }

    OnMouseUpSalary coords ->
      case model.selectSalary of
        Nothing -> model
        Just select ->
          if select.a == coords
          then { model | selectSalary = Nothing, salaryWindow = Nothing }
          else
            { model | selectSalary = Nothing
            , salaryWindow = Just
                { x1 = min select.a.x coords.x
                , x2 = max select.a.x coords.x
                , y1 = min select.a.y coords.y
                , y2 = max select.a.y coords.y
                }
            }

    OnResetSalary ->
      { model | hoveringSalary = [] }

    OnResetSalaryWindow ->
      { model | salaryWindow = Nothing }

    OnSalaryYear year ->
      { model | salaryYear = year }



view : Model -> H.Html Msg
view model =
  H.div
    [ HA.style "font-size" "12px"
    , HA.style "font-family" "\"IBM Plex Sans\", sans-serif"
    , HA.style "margin" "0 auto"
    , HA.style "padding-top" "25px"
    , HA.style "padding-bottom" "100px"
    , HA.style "width" "100vw"
    , HA.style "max-width" "1000px"
    , HA.style "display" "flex"
    , HA.style "flex-flow" "wrap"
    ]
    [ viewSalaryDiscrepancy model
    --, viewSalaryDiscrepancyBar model
    , H.h1
        [ HA.style "width" "100%"
        , HA.style "font-size" "50px"
        , HA.style "color" "rgb(80, 80, 80)"
        , HA.style "margin" "20px 0 60px 0"
        ]
        [ H.text "elm-charts" ]
    ]


features model =
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
            [ C.property .y "y" [] [ CA.size 6, CA.triangle ]
            , C.property .z "z" [] [ CA.size 6, CA.cross ]
            , C.property .v "v" [] [ CA.size 6, CA.square ]
            , C.property .w "w" [] [ CA.size 6, CA.circle ]
            , C.property .p "p" [] [ CA.size 6, CA.diamond ]
            , C.property .q "q" [] [ CA.size 6, CA.plus ]
            ]
            [ { x = 0, y = Just 2, z = Just 3, v = Just 1, w = Just 5, p = Just 4, q = Just 6 }
            , { x = 2, y = Just 1, z = Just 2, v = Just 3, w = Just 4, p = Just 6, q = Just 4 }
            , { x = 5, y = Just 1, z = Just 2, v = Just 3, w = Just 4, p = Just 6, q = Just 4 }
            , { x = 7, y = Just 4, z = Just 5, v = Just 3, w = Just 2, p = Just 7, q = Just 6 }
            , { x = 10, y = Just 4, z = Just 5, v = Just 3, w = Just 2, p = Just 7, q = Just 6 }
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

    -- SCATTER / OPACITY
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
            [ C.property .y "y" [] [ CA.size 10, CA.opacity 0.75 ] ]
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


    -- SCATTER / STYLE
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
            [ C.property .y "y" [] [ CA.size 10, CA.border CA.blue, CA.opacity 0, CA.color CA.purple ] ]
            [ { x = 0, y = Just 2 }
            , { x = 5, y = Just 3 }
            , { x = 10, y = Just 4 }
            ]
        ]

    -- SCATTER / SIZE / VARIABLE
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
            [ C.property .y "y" [] [ CA.size 10, CA.border CA.purple, CA.opacity 0.25, CA.color CA.purple ]
                |> C.variation (\datum -> [ CA.size datum.s ])
            ]
            [ { x = 0, y = Just 2, s = 65 }
            , { x = 2, y = Just 6, s = 20 }
            , { x = 5, y = Just 3, s = 95 }
            , { x = 7, y = Just 1, s = 78 }
            , { x = 10, y = Just 4, s = 49 }
            ]
        ]

    -- SCATTER / SIZE / VARIABLE
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
            [ C.property .y "y" [] [ CA.size 10, CA.border CA.purple, CA.opacity 0.25, CA.color CA.purple ]
                |> C.variation (\datum -> if datum.x == 5 then [ CA.aura 0.2, CA.auraWidth 5 ] else [])
            ]
            [ { x = 0, y = Just 2 }
            , { x = 2, y = Just 6 }
            , { x = 5, y = Just 3 }
            , { x = 7, y = Just 1 }
            , { x = 10, y = Just 4 }
            ]
        ]

    , H.h1 [ HA.style "width" "100%" ] [ H.text "Interpolations" ]

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
            , { x = 3, y = Just 1 }
            , { x = 6, y = Just 4 }
            , { x = 10, y = Just 3 }
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
            , { x = 5, y = Just 3, z = Just 2 }
            , { x = 10, y = Just 4, z = Just 0.5 }
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
            , { x = 5, y = Just 3, z = Just 2 }
            , { x = 10, y = Just 4, z = Just 0.5 }
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
            , { x = 5, y = Just 3, z = Just 2 }
            , { x = 10, y = Just 4, z = Just 0.5 }
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
            , { x = 5, y = Just 3, z = Just 2 }
            , { x = 10, y = Just 4, z = Just 0.5 }
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
            , { x = 5, y = Just 3, z = Just 2 }
            , { x = 10, y = Just 4, z = Just 0.5 }
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
            , { x = 5, y = Just 3, z = Just 2 }
            , { x = 10, y = Just 4, z = Just 0.5 }
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
            , { x = 5, y = Just 3, z = Just 2 }
            , { x = 10, y = Just 4, z = Just 0.5 }
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
            , { x = 5, y = Just 3, z = Just 2 }
            , { x = 10, y = Just 4, z = Just 0.5 }
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
            , { x = 5, y = Just 3, z = Just 2 }
            , { x = 10, y = Just 4, z = Just 0.5 }
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
            , { x = 5, y = Just 3, z = Just 2 }
            , { x = 10, y = Just 4, z = Just 0.5 }
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
            , { x = 5, y = Just 3, z = Just 2 }
            , { x = 10, y = Just 4, z = Just 0.5 }
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
            , { x = 5, y = Just 3, z = Just 2 }
            , { x = 10, y = Just 4, z = Just 0.5 }
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
            , { x = 5, y = Just 3, z = Just 2 }
            , { x = 10, y = Just 4, z = Just 0.5 }
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
            , { x = 5, y = Just 3, z = Just 2 }
            , { x = 10, y = Just 4, z = Just 0.5 }
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
            , { x = 5, y = Just 3, z = Just 2 }
            , { x = 10, y = Just 4, z = Just 0.5 }
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
            , { x = 5, y = Just 3, z = Just 2 }
            , { x = 10, y = Just 4, z = Just 0.5 }
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
            , { x = 5, y = Just 3, z = Just 2 }
            , { x = 10, y = Just 4, z = Just 0.5 }
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
            , { x = 5, y = Just 3, z = Just 2 }
            , { x = 10, y = Just 4, z = Just 0.5 }
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
            , { x = 5, y = Just 3, z = Just 2 }
            , { x = 10, y = Just 4, z = Just 0.5 }
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
            , { x = 5, y = Just 3, z = Just 2 }
            , { x = 10, y = Just 4, z = Just 0.5 }
            ]
        ]

    -- BARS / X1
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
            [ CA.x1 .x1
            , CA.roundTop 0.2
            , CA.roundBottom 0.2
            , CA.grouped
            ]
            [ C.bar .y "y" []
            , C.bar .z "z" []
            ]
            [ { x1 = 0, y = Just 2, z = Just 1 }
            , { x1 = 1, y = Just 2, z = Just 3 }
            , { x1 = 3, y = Just 3, z = Just 2 }
            , { x1 = 4, y = Just 4, z = Just 3 }
            ]
        ]

    -- BARS / X1 / X2
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
            [ CA.x1 .x1
            , CA.x2 .x2
            , CA.roundTop 0.2
            , CA.roundBottom 0.2
            , CA.grouped
            ]
            [ C.bar .y "y" []
            , C.bar .z "z" []
            ]
            [ { x1 = 0, x2 = 1, y = Just 2, z = Just 1 }
            , { x1 = 1, x2 = 2, y = Just 2, z = Just 3 }
            , { x1 = 3, x2 = 4, y = Just 3, z = Just 2 }
            , { x1 = 4, x2 = 5, y = Just 4, z = Just 3 }
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
    , H.button [ HE.onClick OnReset, HA.style "margin" "10px 0" ] [ H.text "Reset" ]
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
        , C.xTicks [ C.amount 12, C.times Time.utc ]
        , C.xLabels [ C.amount 12, C.times Time.utc ]
        , C.yAxis []
        , C.yLabels []
        , case model.select of
            Just select -> C.rect [ CA.x1 select.a, CA.x2 select.b ]
            Nothing -> C.none
        ]

    , H.h1 [ HA.style "width" "100%" ] [ H.text "Tooltips" ]

    -- TOOLTIP
    , C.chart
        [ CA.height 250
        , CA.width 500
        , CA.static
        , CA.events
            [ C.event "mousemove" (C.map OnHoverScatter <| C.getNearest CI.getCenter identity)
            , C.event "mouseleave" (C.map (\_ -> OnHoverScatter []) C.getCoords)
            ]
        ]
        [ C.grid []
        , C.xAxis []
        , C.xTicks [ C.amount 12 ]
        , C.xLabels [ C.amount 12 ]
        , C.yAxis []
        , C.yLabels []
        , C.series .x
            [ C.property .y "y" [] [ CA.size 10, CA.opacity 0.25, CA.border CA.purple, CA.color CA.purple ]
                |> C.variation (\datum -> [ CA.size datum.s ] ++ if List.any (CI.getDatum >> (==) datum) model.hoveringScatter then [ CA.aura 0.2, CA.auraWidth 5 ] else [])
            ]
            [ { x = 0, y = Just 2, z = Just 4, s = 65 }
            , { x = 1, y = Just 3, z = Just 2, s = 50 }
            , { x = 1.3, y = Just 3, z = Just 7, s = 40 }
            , { x = 2, y = Just 2, z = Just 7, s = 20 }
            , { x = 4, y = Just 5, z = Just 3, s = 64 }
            , { x = 5, y = Just 3, z = Just 6, s = 95 }
            , { x = 7, y = Just 1, z = Just 2, s = 78 }
            , { x = 7.1, y = Just 1.1, z = Just 2, s = 20 }
            , { x = 10, y = Just 4, z = Just 3, s = 49 }
            ]
        , C.each (\_ -> model.hoveringScatter) <| \p i ->
            [ C.tooltip i [] [] [ tooltipContent i ] ]
        ]

    , C.chart
        [ CA.height 250
        , CA.width 500
        , CA.static
        , CA.events
            [ C.event "mousemove" (C.map OnHoverBars <| C.getNearest CI.getCenter identity)
            , C.event "mouseleave" (C.map (\_ -> OnHoverBars []) C.getCoords)
            ]
        ]
        [ C.grid []
        , C.xAxis []
        , C.xTicks []
        , C.xLabels []
        , C.yAxis []
        , C.yLabels []
        , C.bars
            [ CA.roundTop 0.2
            , CA.grouped
            ]
            [ C.stacked
                [ C.bar .y "y" []
                , C.bar .z "z" []
                ]
            , C.bar .y "w" [ CA.color CA.purple ]
            ]
            [ { x = 0, y = Just 2, z = Just 4, s = 65 }
            , { x = 1, y = Just 3, z = Just 2, s = 50 }
            , { x = 2, y = Just 2, z = Just 7, s = 20 }
            , { x = 4, y = Just 5, z = Just 3, s = 64 }
            , { x = 5, y = Just 3, z = Just 6, s = 95 }
            , { x = 7, y = Just 1, z = Just 2, s = 78 }
            , { x = 10, y = Just 4, z = Just 3, s = 49 }
            ]
        , C.each (\_ -> model.hoveringBars) <| \p i ->
            [ C.tooltip i [] [] [ tooltipContent i ] ]
        ]

    , C.chart
        [ CA.height 250
        , CA.width 500
        , CA.static
        , CA.events
            [ C.event "mousemove" (C.map OnHoverStackedBars <| C.getNearestX CI.getCenter identity)
            , C.event "mouseleave" (C.map (\_ -> OnHoverStackedBars []) C.getCoords)
            ]
        ]
        [ C.grid []
        , C.xAxis []
        , C.xTicks []
        , C.xLabels []
        , C.yAxis []
        , C.yLabels []
        , C.bars
            [ CA.roundTop 0.2
            , CA.grouped
            ]
            [ C.stacked
                [ C.bar .y "y" []
                , C.bar .z "z" []
                ]
            , C.bar .y "w" [ CA.color CA.purple ]
            ]
            [ { x = 0, y = Just 2, z = Just 4, s = 65 }
            , { x = 1, y = Just 3, z = Just 2, s = 50 }
            , { x = 2, y = Just 2, z = Just 7, s = 20 }
            , { x = 4, y = Just 5, z = Just 3, s = 64 }
            , { x = 5, y = Just 3, z = Just 6, s = 95 }
            , { x = 7, y = Just 1, z = Just 2, s = 78 }
            , { x = 10, y = Just 4, z = Just 3, s = 49 }
            ]
        , C.each (\_ -> CI.groupBy CI.isSameStack model.hoveringStackedBars) <| \p i ->
            [ C.tooltip i [ CA.onTop ] [] (List.map tooltipContent (CI.getProducts i)) ]
        ]

    , C.chart
        [ CA.height 250
        , CA.width 500
        , CA.static
        , CA.events
            [ C.event "mousemove" (C.map OnHoverBinnedBars <| C.getNearestX CI.getCenter (CI.groupBy CI.isSameBin))
            , C.event "mouseleave" (C.map (\_ -> OnHoverBinnedBars []) C.getCoords)
            ]
        ]
        [ C.grid []
        , C.xAxis []
        , C.xTicks []
        , C.xLabels []
        , C.yAxis []
        , C.yLabels []
        , C.bars
            [ CA.roundTop 0.2
            , CA.grouped
            ]
            [ C.stacked
                [ C.bar .y "y" []
                , C.bar .z "z" []
                ]
            , C.bar .y "w" [ CA.color CA.purple ]
            ]
            [ { x = 0, y = Just 2, z = Just 4, s = 65 }
            , { x = 1, y = Just 3, z = Just 2, s = 50 }
            , { x = 2, y = Just 2, z = Just 7, s = 20 }
            , { x = 4, y = Just 5, z = Just 3, s = 64 }
            , { x = 5, y = Just 3, z = Just 6, s = 95 }
            , { x = 7, y = Just 1, z = Just 2, s = 78 }
            , { x = 10, y = Just 4, z = Just 3, s = 49 }
            ]
        , C.each (\_ -> model.hoveringBinnedBars) <| \p i ->
            [ C.tooltip i [ CA.onTop ] [] (List.map tooltipContent (CI.getProducts i)) ]
        ]
    ]


tooltipContent : CI.Product CI.General ScatterDatum -> H.Html msg
tooltipContent each =
  H.div
    [ HA.style "max-width" "200px"
    , HA.style "color" (CI.getColor each)
    ]
    [ H.text (CI.getName each)
    , H.text ": "
    , H.text (String.fromFloat <| Maybe.withDefault 0 <| CI.getValue each)
    ]


viewSalaryDiscrepancy : Model -> H.Html Msg
viewSalaryDiscrepancy model =
  C.chart
    [ CA.height 600
    , CA.width 1000
    , CA.static
    , C.marginLeft 0
    , C.marginRight 0
    , C.paddingTop 15

    , C.range <|
        case model.salaryWindow of
          Just window -> [ C.lowest window.x1 C.exactly, C.highest window.x2 C.exactly ]
          Nothing -> [ C.lowest 20000 C.orHigher ]

    , C.domain  <|
        case model.salaryWindow of
          Just window -> [ C.lowest window.y1 C.exactly, C.highest window.y2 C.exactly ]
          Nothing -> [ C.lowest 76 C.orHigher ]

    , CA.events
        [ C.map2 OnHoverSalary (C.getNearest CI.getCenter identity) C.getCoords
            |> C.event "mousemove"

        , C.event "mouseleave" (C.map (\_ -> OnResetSalary) C.getCoords)
        , C.event "mousedown" (C.map OnMouseDownSalary C.getCoords)
        , C.event "mouseup" (C.map OnMouseUpSalary C.getCoords)
        ]

    , CA.htmlAttrs
        [ HA.style "cursor" "crosshair" ]
    ]
    [ C.grid []

    , C.each (CS.produce 10 CS.ints << .x) <| \p t ->
        [ C.label [ CA.leftAlign, CA.yOff 15 ] (String.fromInt t) { x = toFloat t, y = p.y.min } ]

    , C.each (CS.produce 8 CS.ints << .y) <| \p t ->
        [ (if t == 100 then C.title else C.label) [ CA.leftAlign, CA.yOff -5 ] (String.fromInt t) { x = p.x.min, y = toFloat t } ]

    , C.withPlane <| \p ->
        [ C.title [ CA.fontSize 14, CA.yOff -3 ] ("Gender salary gap in Denmark " ++ String.fromFloat model.salaryYear) { x = C.middle p.x, y = p.y.max }
        , C.title [ CA.fontSize 11, CA.yOff 12 ] "Data from Danmarks Statestik" { x = C.middle p.x, y = p.y.max }
        , C.title [ CA.fontSize 12, CA.yOff 35 ] "Average salary in DKK" { x = C.middle p.x, y = p.y.min }
        , C.title [ CA.fontSize 12, CA.xOff -15, CA.rotate 90 ] "Womens percentage of mens salary" { x = p.x.min, y = C.middle p.y }
        , C.line [ CA.dashed [ 4, 2 ], CA.opacity 0.7, CA.color "#f56dbc", CA.x1 Salary.avgSalaryWomen ]
        , C.line [ CA.dashed [ 4, 2 ], CA.opacity 0.7, CA.color "#58a9f6", CA.x1 Salary.avgSalaryMen ]
        ]

    , C.line [ CA.dashed [ 3, 3 ], CA.y1 100 ]

    , salarySeries model 0.7 5 200

    , C.eachProduct <| \p product ->
        let datum = CI.getDatum product
            color = CI.getColor product
            top = CI.getTop p product
            toSvgX = Coordinates.scaleCartesianX p
            toSvgY = Coordinates.scaleCartesianY p
        in
        if String.startsWith "251 " datum.sector then
          [ C.line [ CA.color color, CA.break, CA.x1 top.x, CA.x2 (top.x + toSvgX 10), CA.y1 top.y, CA.y2 (top.y + toSvgY 10) ]
          , C.title [ CA.color color,CA.leftAlign, CA.xOff 5, CA.yOff 3 ] "Software engineering" { x = top.x + toSvgX 10, y = top.y + toSvgY 10 }
          ]
        else
          []

    , case model.salaryWindow of
        Just _ ->
         C.htmlAt .max .min -10 10
            [ HA.style "transform" "translate(-100%, -100%)"
            , HA.style "background" "white"
            , HA.style "border" "1px solid rgb(210, 210, 210)"
            ]
            [ viewSalaryDiscrepancyMini model
            , H.button
                [ HA.style "position" "absolute"
                , HA.style "top" "0"
                , HA.style "right" "0"
                , HA.style "background" "transparent"
                , HA.style "color" "rgb(100, 100, 100)"
                , HA.style "border" "0"
                , HA.style "height" "30px"
                , HA.style "width" "30px"
                , HA.style "padding" "0"
                , HA.style "margin" "0"
                , HA.style "cursor" "pointer"
                , HE.onClick OnResetSalaryWindow
                ]
                [ H.span
                    [ HA.style "font-size" "28px"
                    , HA.style "position" "absolute"
                    , HA.style "top" "40%"
                    , HA.style "left" "50%"
                    , HA.style "transform" "translate(-50%, -50%)"
                    , HA.style "line-height" "10px"
                    ]
                    [ H.text "⨯" ]
                ]
            ]

        Nothing ->
          C.none

    , C.each (always model.hoveringSalary) <| \p item ->
        [ C.tooltip item [] [] [ salaryTooltip item ] ]

    , case model.selectSalary of
        Just select -> C.rect [ CA.opacity 0.5, CA.x1 select.a.x, CA.x2 select.b.x, CA.y1 select.a.y, CA.y2 select.b.y ]
        Nothing -> C.none


    , C.svg <| \_ ->
        S.defs []
          [ S.linearGradient
              [ SA.id "colorscale", SA.x1 "0", SA.x2 "100%", SA.y1 "0", SA.y2 "0" ]
              [ S.stop [ SA.offset "0%", SA.stopColor "#f56dbc" ] [] -- most pink
              , S.stop [ SA.offset "30%", SA.stopColor "#de74d7" ] [] -- pink
              , S.stop [ SA.offset "50%", SA.stopColor "#c579f2" ] [] -- middle
              , S.stop [ SA.offset "70%", SA.stopColor "#8a91f7" ] [] -- blue
              , S.stop [ SA.offset "100%", SA.stopColor "#58a9f6" ] [] -- most blue
              ]
          ]

    , C.withPlane <| \p ->
        let toSvgX = Coordinates.scaleCartesianX p
            toSvgY = Coordinates.scaleCartesianY p
            x1 = p.x.max - toSvgX 150
            x2 = p.x.max - toSvgX 20
            y1 = p.y.max - toSvgY 13
            y2 = p.y.max - toSvgY 10
        in
        [ C.rect [ CA.borderWidth 0, CA.x1 x1, CA.x2 x2, CA.y1 y1, CA.y2 y2, CA.color "url(#colorscale)" ]
        , C.title [ CA.fontSize 10 ] "more women" { x = x1, y = p.y.max - toSvgY 25 }
        , C.title [ CA.fontSize 10 ] "more men" { x = x2, y = p.y.max - toSvgY 25 }
        , C.htmlAt .max .max -45 -45
            [ HA.style "color" "rgb(90 90 90)"
            , HA.style "cursor" "pointer"
            ]
            [ H.div [ HE.onClick (OnSalaryYear 2016) ] [ H.text "2016" ]
            , H.div [ HE.onClick (OnSalaryYear 2017) ] [ H.text "2017" ]
            , H.div [ HE.onClick (OnSalaryYear 2018) ] [ H.text "2018" ]
            , H.div [ HE.onClick (OnSalaryYear 2019) ] [ H.text "2019" ]
            ]
        ]
    ]


viewSalaryDiscrepancyMini : Model -> H.Html Msg
viewSalaryDiscrepancyMini model =
  C.chart
    [ CA.height 100
    , CA.width 167
    , CA.static
    , C.marginLeft 0
    , C.marginBottom 0
    , C.marginTop 0
    , C.marginRight 0
    , C.paddingTop 15
    , C.range [ C.lowest 20000 C.orHigher ]
    , C.domain [ C.lowest 76 C.orHigher ]
    ]
    [ C.each (CS.produce 10 CS.ints << .x) <| \p t ->
        [ C.label [ CA.leftAlign, CA.yOff 15 ] "" { x = toFloat t, y = p.y.min } ]

    , C.each (CS.produce 8 CS.ints << .y) <| \p t ->
        [ C.label [ CA.leftAlign, CA.yOff -5 ] "" { x = p.x.min, y = toFloat t } ]

    , C.line [ CA.dashed [ 3, 3 ], CA.y1 100, CA.width 0.5 ]

     , case model.salaryWindow of
        Just select -> C.rect [ CA.borderWidth 0, CA.x1 select.x1, CA.x2 select.x2, CA.y1 select.y1, CA.y2 select.y2 ]
        Nothing -> C.none

    , salarySeries model 0.5 3 4000
    ]


salarySeries : Model -> Float -> Float -> Float -> C.Element Salary.Datum Msg
salarySeries model border auraSize size =
  C.series .salaryBoth
      [ C.property Salary.womenSalaryPerc "percentage" []
          [ CA.opacity 0.5, CA.circle, CA.border CA.blue, CA.borderWidth border ]
          |> C.variation (\d ->
                let precentOfWomen = Salary.womenPerc d
                    isHovered = List.any (CI.getDatum >> (==) d) model.hoveringSalary

                    color =
                      if precentOfWomen < 20
                      then [ CA.border "#58a9f6", CA.color "#58a9f6" ]
                      else if precentOfWomen < 40
                      then [ CA.border "#8a91f7", CA.color "#8a91f7" ]
                      else if precentOfWomen < 60
                      then [ CA.border "#c579f2", CA.color "#c579f2" ]
                      else if precentOfWomen < 80
                      then [ CA.border "#de74d7", CA.color "#de74d7" ]
                      else [ CA.border "#f56dbc", CA.color "#f56dbc" ]

                    aura =
                      if isHovered
                      then [ CA.aura 0.4, CA.auraWidth auraSize, CA.opacity 0.7 ]
                      else []
                in
                [ CA.size (d.numOfBoth / size) ] ++ color ++ aura
              )
      ]
      (List.filter (.year >> (==) model.salaryYear) Salary.data)


viewSalaryDiscrepancyBar : Model -> H.Html Msg
viewSalaryDiscrepancyBar model =
  C.chart
    [ CA.height 100
    , CA.width 1000
    , CA.static
    , C.marginLeft 0
    , C.marginRight 0
    , C.marginBottom 0
    , C.marginTop 0
    , C.paddingTop 0
    , C.range [ C.lowest 20000 C.orHigher ]
    --, C.domain [ C.lowest 76 C.orHigher ]
    ]
    [ C.grid []

    --, C.xLabels [ C.amount 10 ]
    --, C.yLabels []

    , C.bars
        [ CA.grouped
        , CA.spacing 0.1
        , CA.margin 0.3
        , CA.roundTop 0.2
        , CA.roundBottom 0.2
        , CA.x1 (\d -> d.bin - 5000)
        , CA.x2 .bin
        ]
        [ C.bar (.data >> List.map .numOfWomen >> List.sum >> Just) "women" [ CA.color "#f56dbc", CA.striped [ CA.rotate 45, CA.width 2, CA.space 1.5 ] ]
        , C.bar (.data >> List.map .numOfMen >> List.sum >> Just) "men" [ CA.color "#58a9f6", CA.dotted [ CA.rotate 45, CA.width 2, CA.space 1.5 ] ]
        ]
        (C.binned 5000 .salaryBoth <| List.filter (.year >> (==) 2019) Salary.data)
    ]


salaryTooltip : CI.Product CI.General Salary.Datum -> H.Html msg
salaryTooltip hovered =
  let datum = CI.getDatum hovered
      precentOfWomen = round (Salary.womenPerc datum)
      percentOfSalary = round (Maybe.withDefault 0 (Salary.womenSalaryPerc datum))
      percentOfSalaryMen = round (Maybe.withDefault 0 (Salary.menSalaryPerc datum))
  in
  H.div []
    [ H.h4
        [ HA.style "width" "240px"
        , HA.style "margin-top" "5px"
        , HA.style "margin-bottom" "5px"
        , HA.style "color" (CI.getColor hovered)
        ]
        [ H.text datum.sector ]

    , H.table [ HA.style "color" "rgb(90, 90, 90)", HA.style "width" "100%", HA.style "font-size" "11px" ]
        [ H.tr []
            [ H.th [] []
            , H.th [ HA.style "text-align" "right" ] [ H.text "Women" ]
            , H.th [ HA.style "text-align" "right" ] [ H.text "%" ]
            , H.th [ HA.style "text-align" "right" ] [ H.text "Men" ]
            , H.th [ HA.style "text-align" "right" ] [ H.text "%" ]
            ]
        , H.tr []
            [ H.th [ HA.style "text-align" "left" ] [ H.text "Salary" ]
            , H.th [ HA.style "text-align" "right" ] [ H.text (String.fromInt (round datum.salaryWomen)) ]
            , H.th [ HA.style "text-align" "right" ] [ H.text (String.fromInt percentOfSalary) ]
            , H.th [ HA.style "text-align" "right" ] [ H.text (String.fromInt (round datum.salaryMen)) ]
            , H.th [ HA.style "text-align" "right" ] [ H.text (String.fromInt percentOfSalaryMen) ]
            ]
        , H.tr []
            [ H.th [ HA.style "text-align" "left" ] [ H.text "Distribution" ]
            , H.th [ HA.style "text-align" "right" ] [ H.text (String.fromFloat datum.numOfWomen) ]
            , H.th [ HA.style "text-align" "right" ] [ H.text (String.fromInt precentOfWomen) ]
            , H.th [ HA.style "text-align" "right" ] [ H.text (String.fromFloat datum.numOfMen) ]
            , H.th [ HA.style "text-align" "right" ] [ H.text (String.fromInt (100 - precentOfWomen)) ]
            ]
        ]
    ]