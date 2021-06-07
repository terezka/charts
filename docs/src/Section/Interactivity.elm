module Section.Interactivity exposing (..)


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
import Chart.Events as CE
import Internal.Item as CI
import Chart.Svg as CS

import Element as E
import Element.Font as F
import Element.Border as B
import Element.Input as I
import Element.Background as BG

import Ui.Section as Section


type alias Model =
  { hovering : List (CI.Product CI.General Datum)
  , hovering2 : List (CE.Group (CE.Stack Datum) CI.General Datum)
  }


init : Model
init =
  { hovering = []
  , hovering2 = []
  }


type Msg
  = OnHover (List (CI.Product CI.General Datum))
  | OnHover2 (List (CE.Group (CE.Stack Datum) CI.General Datum))


update : Msg -> Model -> Model
update msg model =
  case msg of
    OnHover groups -> { model | hovering = groups }
    OnHover2 groups -> { model | hovering2 = groups }



section : (Msg -> msg) -> Model -> Section.Section msg
section onMsg model =
  let frame toEls tooltip =
        H.div
          [ HA.style "width" "760px"
          , HA.style "height" "300px"
          ]
          [ C.chart
              [ CA.height 300
              , CA.width 760
              , CE.onMouseMove (OnHover >> onMsg) (CE.getNearest CE.product)
              , CE.onMouseLeave (OnHover [] |> onMsg)
              ]
              [ C.grid []
              , C.xLabels []
              , C.yLabels []
              , toEls
                  [ C.property .z [] []
                  , C.property .y [] []
                  ]
                  data
              , tooltip
              ]
          ]
  in
  { title = "Interactivity"
  , template = -- TODO
      """
      C.chart
        [ CA.height 300
        , CA.width 760
        , CE.onMouseMove OnHover (CE.getNearest CE.product)
        , CE.onMouseLeave OnReset
        ]
        [ C.grid []
        , C.xLabels []
        , C.yLabels []
        , C.series .x props data
        , {{1}}
        ]
      """
  , configs =
      Tuple.pair
      { title = "Basic"
      , edits =
          ["""
          C.each model.hovering <| \\p item ->
            [ C.tooltip item [] [] [] ]
          """]
      , chart = \_ ->
          frame  (C.series .x) <|
            C.each model.hovering <| \p item ->
              [ C.tooltip item [] [] [] ]
      }
      [ { title = "Direction"
        , edits =
            ["""
          C.each model.hovering <| \\p item ->
            [ C.tooltip item [ CA.onLeft ] [] [] ]
            """]
        , chart = \_ ->
            frame (C.series .x) <|
              C.each model.hovering <| \p item ->
                [ C.tooltip item [ CA.onLeft ] [] []
                ]
        }
      , { title = "No arrow"
        , edits =
            ["""
          C.each model.hovering <| \\p item ->
            [ C.tooltip item [ CA.noPointer ] [] [] ]
            """]
        , chart = \_ ->
            frame (C.series .x) <|
              C.each model.hovering <| \p item ->
                [ C.tooltip item [ CA.noPointer ] [] []
                ]
        }
      , { title = "Offset"
        , edits =
            ["""
          C.each model.hovering <| \\p item ->
            [ C.tooltip item [ CA.offset 0 ] [] [] ]
            """]
        , chart = \_ ->
            frame (C.series .x) <|
              C.each model.hovering <| \p item ->
                [ C.tooltip item [ CA.offset 0 ] [] []
                ]
        }
      , { title = "Width"
        , edits =
            ["""
          C.each model.hovering <| \\p item ->
            [ C.tooltip item [ CA.width 20, CA.onLeftOrRight ] [] [] ]
            """]
        , chart = \_ ->
            frame (C.series .x) <|
              C.each model.hovering <| \p item ->
                [ C.tooltip item [ CA.width 20, CA.onLeftOrRight ] [] []
                ]
        }
      , { title = "Height"
        , edits =
            ["""
          C.each model.hovering <| \\p item ->
            [ C.tooltip item [ CA.height 20, CA.onTopOrBottom ] [] [] ]
            """]
        , chart = \_ ->
            frame (C.series .x) <|
              C.each model.hovering <| \p item ->
                [ C.tooltip item [ CA.height 20, CA.onTopOrBottom ] [] []
                ]
        }
      , { title = "Border"
        , edits =
            ["""
          C.each model.hovering <| \\p item ->
            [ C.tooltip item [ CA.border "red" ] [] [] ]
            """]
        , chart = \_ ->
            frame (C.series .x) <|
              C.each model.hovering <| \p item ->
                [ C.tooltip item [ CA.border "red" ] [] []
                ]
        }
      , { title = "Background"
        , edits =
            ["""
          C.each model.hovering <| \\p item ->
            [ C.tooltip item [ CA.background "beige" ] [] [] ]
            """]
        , chart = \_ ->
            frame (C.series .x) <|
              C.each model.hovering <| \p item ->
                [ C.tooltip item [ CA.background "beige" ] [] []
                ]
        }
      , { title = "Bars"
        , edits =
            ["""
          C.each model.hovering <| \\p item ->
            [ C.tooltip item [] [] [] ]
            """]
        , chart = \_ ->
            -- TODO
            H.div
              [ HA.style "width" "760px"
              , HA.style "height" "300px"
              ]
              [ C.chart
                  [ CA.height 300
                  , CA.width 760
                  , CA.marginBottom 20
                  , CA.paddingLeft 10
                  , CE.onMouseMove (OnHover2 >> onMsg) (CE.getNearest CE.stack)
                  , CE.onMouseLeave (OnHover2 [] |> onMsg)
                  ]
                  [ C.grid []
                  , C.xLabels []
                  , C.yLabels []
                  , C.bars []
                      [ C.stacked
                          [ C.property .z [] []
                              |> C.named "Cats"
                          , C.property .y [] []
                              |> C.named "Dogs"
                          ]
                      , C.property .v [] []
                          |> C.named "Fish"
                      ]
                      data
                  , C.each model.hovering2 <| \p item ->
                      [ C.tooltip item [ CA.onTop ] [] [] ]

                  , C.htmlAt .max .max -10 0
                      [ HA.style "display" "flex"
                      , HA.style "align-items" "baseline"
                      , HA.style "transform" "translate(-100%, 0%)"
                      ]
                      [ CS.lineLegend
                          [ CA.title "hello"
                          , CA.fontSize 14
                          , CA.spacing 7
                          , CA.width 20
                          , CA.height 10
                          , CA.htmlAttrs
                              [ HA.style "margin-right" "15px" ]
                          ]
                          [ CA.color CA.blue
                          , CA.opacity 0.4
                          , CA.linear
                          ]
                          [ CA.square
                          , CA.size 5
                          ]
                      , CS.barLegend
                          [ CA.title "longer text"
                          , CA.fontSize 14
                          , CA.spacing 7
                          ]
                          [ CA.borderWidth 1
                          , CA.color CA.pink
                          , CA.roundTop 0.6
                          , CA.roundBottom 0.6
                          ]
                      ]
                  ]
              ]
        }
      ]
  }


type alias Datum =
  { x : Float
  , y : Maybe Float
  , z : Maybe Float
  , v : Maybe Float
  , w : Maybe Float
  , p : Maybe Float
  , q : Maybe Float
  }


data : List Datum
data =
  let toDatum x y z v w p q =
        Datum x (Just y) (Just z) (Just v) (Just w) (Just p) (Just q)
  in
  [ toDatum 0.0 2.0 4.0 4.6 6.9 7.3 8.0
  , toDatum 0.2 3.0 4.2 5.2 6.2 7.0 8.7
  , toDatum 0.8 4.0 4.6 5.5 5.2 7.2 8.1
  , toDatum 1.0 2.0 4.2 5.3 5.7 6.2 7.8
  , toDatum 1.2 5.0 3.5 4.9 5.9 6.7 8.2
  , toDatum 2.0 2.0 3.2 4.8 5.4 7.2 8.3
  , toDatum 2.3 1.0 4.3 5.3 5.1 7.8 7.1
  , toDatum 2.8 3.0 2.9 5.4 3.9 7.6 8.5
  , toDatum 3.0 2.0 3.6 5.8 4.6 6.5 6.9
  , toDatum 4.0 1.0 4.2 4.5 5.3 6.3 7.0
  ]

