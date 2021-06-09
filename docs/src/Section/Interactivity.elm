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
  { hovering : List (CI.Product CI.Any (Maybe Float) Datum)
  , hovering2 : List (CE.Group (CE.Bin Datum) CS.Dot (Maybe Float) Datum)
  , hovering3 : List (CE.Group CE.SameX CS.Dot (Maybe Float) Datum)
  }


init : Model
init =
  { hovering = []
  , hovering2 = []
  , hovering3 = []
  }


type Msg
  = OnHover (List (CI.Product CI.Any (Maybe Float) Datum))
  | OnHover2
      (List (CE.Group (CE.Bin Datum) CS.Dot (Maybe Float) Datum))
      (List (CE.Group CE.SameX CS.Dot (Maybe Float) Datum))


update : Msg -> Model -> Model
update msg model =
  case msg of
    OnHover groups -> { model | hovering = groups }
    OnHover2 groups prods -> { model | hovering2 = groups, hovering3 = prods }



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
            H.map onMsg <|
            C.chart
              [ CA.height 350
              , CA.width 760
              , CA.marginTop 50
              , CA.marginBottom 20
              , CA.paddingLeft 10
              , CA.static
              , CE.onMouseLeave (OnHover2 [] [])
              , CE.on "mousemove" <|
                  CE.map2 OnHover2
                    (CE.getNearest <| CE.filter CE.dot CE.bin)
                    (CE.getNearest <| CE.filter CE.dot CE.sameX)
              ]
              [ C.legendsAt .max .max 0 50
                  [ CA.row
                  , CA.spacing 20
                  , CA.alignRight
                  , CA.htmlAttrs [ HA.style "padding" "20px 10px" ]
                  ]
                  [ CA.fontSize 14
                  , CA.spacing 7
                  , CA.width 10
                  , CA.height 10
                  ]

              , C.grid []
              , C.xLabels [ CA.amount 10 ]
              , C.yLabels [ CA.xOff -10 ]

              --, C.bars
              --    [ CA.roundTop 0.5
              --    , CA.roundBottom 0.5
              --    --, CA.ungroup
              --    ]
              --    --[ C.stacked
              --        [ C.named "Cats" (C.property .v [] [])
              --        , C.named "Dogs" (C.property .z [] [])
              --        , C.named "Fish" (C.property .y [] [])
              --        ]
              --    --]
              --    data

              , C.series .x
                  [ C.stacked
                      [ C.named "Blues" (C.property .v [ CA.stepped, CA.color CA.turquoise, CA.opacity 0 ] [])
                      , C.named "Greens" (C.property .q [ CA.stepped, CA.color CA.green, CA.opacity 0 ] [])
                      , C.named "Reds" (C.property .w [ CA.stepped, CA.color CA.red, CA.opacity 0 ] [])
                      ]
                  ]
                  data

              --, C.each (List.concatMap CE.getProducts model.hovering2) <| \p item ->
              --    [ C.tooltip item [ CA.onTop ] [] [] ]

              , C.each (model.hovering3) <| \p item ->
                  [ C.tooltip item [ CA.onTop ] [] [] ]
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
        Datum x y (Just z) (Just v) (Just w) (Just p) q
  in
  [ toDatum 0.0 (Just 2.0) 4.0 4.6 6.9 7.3 (Just 8.0)
  , toDatum 0.2 (Just 3.0) 4.2 5.2 6.2 7.0 (Just 7.0)
  , toDatum 0.8 (Just 4.0) 4.6 5.5 5.2 7.2 (Just 5.0)
  , toDatum 1.0 Nothing    4.2 5.3 5.7 6.2 (Just 4.0)
  , toDatum 1.2 (Just 5.0) 3.5 4.9 5.9 6.7 Nothing
  , toDatum 2.0 (Just 2.0) 3.2 4.8 5.4 7.2 (Just 7.0)
  , toDatum 2.3 (Just 1.0) 4.3 5.3 5.1 7.8 (Just 6.0)
  , toDatum 2.8 (Just 3.0) 2.9 5.4 3.9 7.6 (Just 6.0)
  , toDatum 3.0 Nothing    3.6 5.8 4.6 6.5 (Just 5.0)
  , toDatum 4.0 (Just 1.0) 4.2 4.5 5.3 6.3 (Just 7.0)
  ]

