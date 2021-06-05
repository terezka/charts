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
  , hovering2 : List (CE.Group (CE.Bin Datum) CI.General Datum)
  }


init : Model
init =
  { hovering = []
  , hovering2 = []
  }


type Msg
  = OnHover (List (CE.Group () CI.General Datum))
  | OnHover2 (List (CE.Group (CE.Bin Datum) CI.General Datum))


update : Msg -> Model -> Model
update msg model =
  case msg of
    OnHover groups -> { model | hovering = List.concatMap CE.getProducts groups }
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
        , CE.onMouseLeave (OnHover [])
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
        [ C.tooltip item [] []
            [ H.text <| String.fromFloat (CI.getInd item)
            , H.text ", "
            , H.text <| String.fromFloat (CI.getValue item)
            ]
        ]
          """]
      , chart = \_ ->
          frame  (C.series .x) <|
            C.each model.hovering <| \p item ->
              [ C.tooltip item [] []
                  [ H.text <| String.fromFloat (CI.getInd item) -- TODO
                  , H.text ", "
                  , H.text <| String.fromFloat (Maybe.withDefault 0 <| CI.getValue item)
                  ]
              ]
      }
      [ { title = "Direction"
        , edits =
            ["""
        C.each model.hovering <| \\p item ->
          [ C.tooltip item [ CA.onLeft ] []
              [ H.text <| String.fromFloat (CI.getInd item)
              , H.text ", "
              , H.text <| String.fromFloat (CI.getValue item)
              ]
          ]
            """]
        , chart = \_ ->
            frame (C.series .x) <|
              C.each model.hovering <| \p item ->
                [ C.tooltip item [ CA.onLeft ] []
                    [ H.text <| String.fromFloat (CI.getInd item) -- TODO
                    , H.text ", "
                    , H.text <| String.fromFloat (Maybe.withDefault 0 <| CI.getValue item)
                    ]
                ]
        }
      , { title = "No arrow"
        , edits =
            ["""
        C.each model.hovering <| \\p item ->
          [ C.tooltip item [ CA.noPointer ] []
              [ H.text <| String.fromFloat (CI.getInd item)
              , H.text ", "
              , H.text <| String.fromFloat (CI.getValue item)
              ]
          ]
            """]
        , chart = \_ ->
            frame (C.series .x) <|
              C.each model.hovering <| \p item ->
                [ C.tooltip item [ CA.noPointer ] []
                    [ H.text <| String.fromFloat (CI.getInd item) -- TODO
                    , H.text ", "
                    , H.text <| String.fromFloat (Maybe.withDefault 0 <| CI.getValue item)
                    ]
                ]
        }
      , { title = "Offset"
        , edits =
            ["""
        C.each model.hovering <| \\p item ->
          [ C.tooltip item [ CA.offset 0 ] []
              [ H.text <| String.fromFloat (CI.getInd item)
              , H.text ", "
              , H.text <| String.fromFloat (CI.getValue item)
              ]
          ]
            """]
        , chart = \_ ->
            frame (C.series .x) <|
              C.each model.hovering <| \p item ->
                [ C.tooltip item [ CA.offset 0 ] []
                    [ H.text <| String.fromFloat (CI.getInd item) -- TODO
                    , H.text ", "
                    , H.text <| String.fromFloat (Maybe.withDefault 0 <| CI.getValue item)
                    ]
                ]
        }
      , { title = "Width"
        , edits =
            ["""
        C.each model.hovering <| \\p item ->
          [ C.tooltip item [ CA.width 20, CA.onLeftOrRight ] []
              [ H.text <| String.fromFloat (CI.getInd item)
              , H.text ", "
              , H.text <| String.fromFloat (CI.getValue item)
              ]
          ]
            """]
        , chart = \_ ->
            frame (C.series .x) <|
              C.each model.hovering <| \p item ->
                [ C.tooltip item [ CA.width 20, CA.onLeftOrRight ] []
                    [ H.text <| String.fromFloat (CI.getInd item) -- TODO
                    , H.text ", "
                    , H.text <| String.fromFloat (Maybe.withDefault 0 <| CI.getValue item)
                    ]
                ]
        }
      , { title = "Height"
        , edits =
            ["""
        C.each model.hovering <| \\p item ->
          [ C.tooltip item [ CA.height 20, CA.onTopOrBottom ] []
              [ H.text <| String.fromFloat (CI.getInd item)
              , H.text ", "
              , H.text <| String.fromFloat (CI.getValue item)
              ]
          ]
            """]
        , chart = \_ ->
            frame (C.series .x) <|
              C.each model.hovering <| \p item ->
                [ C.tooltip item [ CA.height 20, CA.onTopOrBottom  ] []
                    [ H.text <| String.fromFloat (CI.getInd item) -- TODO
                    , H.text ", "
                    , H.text <| String.fromFloat (Maybe.withDefault 0 <| CI.getValue item)
                    ]
                ]
        }
      , { title = "Border"
        , edits =
            ["""
        C.each model.hovering <| \\p item ->
          [ C.tooltip item [ CA.border "red" ] []
              [ H.text <| String.fromFloat (CI.getInd item)
              , H.text ", "
              , H.text <| String.fromFloat (CI.getValue item)
              ]
          ]
            """]
        , chart = \_ ->
            frame (C.series .x) <|
              C.each model.hovering <| \p item ->
                [ C.tooltip item [ CA.border "red" ] []
                    [ H.text <| String.fromFloat (CI.getInd item) -- TODO
                    , H.text ", "
                    , H.text <| String.fromFloat (Maybe.withDefault 0 <| CI.getValue item)
                    ]
                ]
        }
      , { title = "Background"
        , edits =
            ["""
        C.each model.hovering <| \\p item ->
          [ C.tooltip item [ CA.background "beige" ] []
              [ H.text <| String.fromFloat (CI.getInd item)
              , H.text ", "
              , H.text <| String.fromFloat (CI.getValue item)
              ]
          ]
            """]
        , chart = \_ ->
            frame (C.series .x) <|
              C.each model.hovering <| \p item ->
                [ C.tooltip item [ CA.background "beige" ] []
                    [ H.text <| String.fromFloat (CI.getInd item) -- TODO
                    , H.text ", "
                    , H.text <| String.fromFloat (Maybe.withDefault 0 <| CI.getValue item)
                    ]
                ]
        }
      , { title = "Bars"
        , edits =
            [""" --TODO
        C.each model.hovering <| \\p item ->
          [ C.tooltip item [ CA.background "beige" ] []
              [ H.text <| String.fromFloat (CI.getInd item)
              , H.text ", "
              , H.text <| String.fromFloat (CI.getValue item)
              ]
          ]
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
                  , CE.onMouseMove (OnHover2 >> onMsg) (CE.getNearest CE.bin)
                  , CE.onMouseLeave (OnHover2 [] |> onMsg)
                  ]
                  [ C.grid []
                  , C.xLabels []
                  , C.yLabels []
                  , C.bars []
                      [ C.stacked
                          [ C.property .z [] []
                          , C.property .y [] []
                          ]
                      , C.property .v [] []
                      ]
                      data
                  , C.each (List.concatMap (CE.regroup CE.stack) model.hovering2) <| \p item ->
                      let show i = H.div [] [ H.text (String.fromFloat <| Maybe.withDefault -1 <| CE.getDependent i) ]
                      in
                      [ C.tooltip item [ CA.onTop ] [] (List.map show (CE.getProducts item))
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

