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
import Chart.Item as CI
import Chart.Svg as CS

import Element as E
import Element.Font as F
import Element.Border as B
import Element.Input as I
import Element.Background as BG

import Ui.Section as Section


type alias Model =
  { hovering : List (CI.Product CI.General Datum)
  }


init : Model
init =
  { hovering = []
  }


type Msg
  = OnHover (List (CI.Product CI.General Datum))


update : Msg -> Model -> Model
update msg model =
  case msg of
    OnHover products -> { model | hovering = products }


view : (String -> Int -> msg) -> Dict.Dict String Int -> (Msg -> msg) -> Model -> E.Element msg
view onSelect selected onMsg model =
  let frame events tooltip =
        H.div
          [ HA.style "width" "300px"
          , HA.style "height" "300px"
          ]
          [ C.chart
              [ CA.height 300
              , CA.width 300
              , CA.events events
              ]
              [ C.grid []
              , C.xLabels []
              , C.yLabels []
              , C.series .x
                  [ C.property .y "y" [] []
                  , C.property .z "z" [] []
                  ]
                  data
              , tooltip
              ]
          ]
  in
  Section.view
    { title = "Interactivity"
    , onSelect = onSelect
    , selected = selected
    , frame = -- TODO
        """
        C.chart
          [ CA.height 300
          , CA.width 300
          , CA.events
              [ C.event "mousemove" <|
                  C.map OnHover (C.getNearest CI.getCenter identity)
              , C.event "mouseleave" <|
                  C.map OnReset C.getCoords
              ]
          ]
          [ C.grid []
          , C.xLabels []
          , C.yLabels []
          , C.series .x props data
          , {{CONFIG}}
          ]
        """
    , configs =
        [ { title = "Basic"
          , code =
              """
          C.each (always model.hovering) <| \\p item ->
            [ C.tooltip item [] []
                [ H.text <| String.fromFloat (CI.getInd item)
                , H.text ", "
                , H.text <| String.fromFloat (CI.getValue item)
                ]
            ]
              """
          , chart = \_ ->
              frame
                [ C.event "mousemove" (C.map (OnHover >> onMsg) (C.getNearest CI.getCenter identity))
                , C.event "mouseleave" (C.map (\_ -> OnHover [] |> onMsg) C.getCoords)
                ] <|
                C.each (\_ -> model.hovering) <| \p item ->
                  [ C.tooltip item [] []
                      [ H.text <| String.fromFloat (CI.getInd item) -- TODO
                      , H.text ", "
                      , H.text <| String.fromFloat (Maybe.withDefault 0 <| CI.getValue item)
                      ]
                  ]
          }
        , { title = "Direction"
          , code =
              """
          C.each (always model.hovering) <| \\p item ->
            [ C.tooltip item [ CA.onLeft ] []
                [ H.text <| String.fromFloat (CI.getInd item)
                , H.text ", "
                , H.text <| String.fromFloat (CI.getValue item)
                ]
            ]
              """
          , chart = \_ ->
              frame
                [ C.event "mousemove" (C.map (OnHover >> onMsg) (C.getNearest CI.getCenter identity))
                , C.event "mouseleave" (C.map (\_ -> OnHover [] |> onMsg) C.getCoords)
                ] <|
                C.each (\_ -> model.hovering) <| \p item ->
                  [ C.tooltip item [ CA.onLeft ] []
                      [ H.text <| String.fromFloat (CI.getInd item) -- TODO
                      , H.text ", "
                      , H.text <| String.fromFloat (Maybe.withDefault 0 <| CI.getValue item)
                      ]
                  ]
          }
        , { title = "No arrow"
          , code =
              """
          C.each (always model.hovering) <| \\p item ->
            [ C.tooltip item [ CA.noPointer ] []
                [ H.text <| String.fromFloat (CI.getInd item)
                , H.text ", "
                , H.text <| String.fromFloat (CI.getValue item)
                ]
            ]
              """
          , chart = \_ ->
              frame
                [ C.event "mousemove" (C.map (OnHover >> onMsg) (C.getNearest CI.getCenter identity))
                , C.event "mouseleave" (C.map (\_ -> OnHover [] |> onMsg) C.getCoords)
                ] <|
                C.each (\_ -> model.hovering) <| \p item ->
                  [ C.tooltip item [ CA.noPointer ] []
                      [ H.text <| String.fromFloat (CI.getInd item) -- TODO
                      , H.text ", "
                      , H.text <| String.fromFloat (Maybe.withDefault 0 <| CI.getValue item)
                      ]
                  ]
          }
        , { title = "Offset"
          , code =
              """
          C.each (always model.hovering) <| \\p item ->
            [ C.tooltip item [ CA.offset 0 ] []
                [ H.text <| String.fromFloat (CI.getInd item)
                , H.text ", "
                , H.text <| String.fromFloat (CI.getValue item)
                ]
            ]
              """
          , chart = \_ ->
              frame
                [ C.event "mousemove" (C.map (OnHover >> onMsg) (C.getNearest CI.getCenter identity))
                , C.event "mouseleave" (C.map (\_ -> OnHover [] |> onMsg) C.getCoords)
                ] <|
                C.each (\_ -> model.hovering) <| \p item ->
                  [ C.tooltip item [ CA.offset 0 ] []
                      [ H.text <| String.fromFloat (CI.getInd item) -- TODO
                      , H.text ", "
                      , H.text <| String.fromFloat (Maybe.withDefault 0 <| CI.getValue item)
                      ]
                  ]
          }
        , { title = "Width"
          , code =
              """
          C.each (always model.hovering) <| \\p item ->
            [ C.tooltip item [ CA.width 20, CA.onLeftOrRight ] []
                [ H.text <| String.fromFloat (CI.getInd item)
                , H.text ", "
                , H.text <| String.fromFloat (CI.getValue item)
                ]
            ]
              """
          , chart = \_ ->
              frame
                [ C.event "mousemove" (C.map (OnHover >> onMsg) (C.getNearest CI.getCenter identity))
                , C.event "mouseleave" (C.map (\_ -> OnHover [] |> onMsg) C.getCoords)
                ] <|
                C.each (\_ -> model.hovering) <| \p item ->
                  [ C.tooltip item [ CA.width 20, CA.onLeftOrRight ] []
                      [ H.text <| String.fromFloat (CI.getInd item) -- TODO
                      , H.text ", "
                      , H.text <| String.fromFloat (Maybe.withDefault 0 <| CI.getValue item)
                      ]
                  ]
          }
        , { title = "Height"
          , code =
              """
          C.each (always model.hovering) <| \\p item ->
            [ C.tooltip item [ CA.height 20, CA.onTopOrBottom ] []
                [ H.text <| String.fromFloat (CI.getInd item)
                , H.text ", "
                , H.text <| String.fromFloat (CI.getValue item)
                ]
            ]
              """
          , chart = \_ ->
              frame
                [ C.event "mousemove" (C.map (OnHover >> onMsg) (C.getNearest CI.getCenter identity))
                , C.event "mouseleave" (C.map (\_ -> OnHover [] |> onMsg) C.getCoords)
                ] <|
                C.each (\_ -> model.hovering) <| \p item ->
                  [ C.tooltip item [ CA.height 20, CA.onTopOrBottom  ] []
                      [ H.text <| String.fromFloat (CI.getInd item) -- TODO
                      , H.text ", "
                      , H.text <| String.fromFloat (Maybe.withDefault 0 <| CI.getValue item)
                      ]
                  ]
          }
        , { title = "Border"
          , code =
              """
          C.each (always model.hovering) <| \\p item ->
            [ C.tooltip item [ CA.border "red" ] []
                [ H.text <| String.fromFloat (CI.getInd item)
                , H.text ", "
                , H.text <| String.fromFloat (CI.getValue item)
                ]
            ]
              """
          , chart = \_ ->
              frame
                [ C.event "mousemove" (C.map (OnHover >> onMsg) (C.getNearest CI.getCenter identity))
                , C.event "mouseleave" (C.map (\_ -> OnHover [] |> onMsg) C.getCoords)
                ] <|
                C.each (\_ -> model.hovering) <| \p item ->
                  [ C.tooltip item [ CA.border "red" ] []
                      [ H.text <| String.fromFloat (CI.getInd item) -- TODO
                      , H.text ", "
                      , H.text <| String.fromFloat (Maybe.withDefault 0 <| CI.getValue item)
                      ]
                  ]
          }
        , { title = "Background"
          , code =
              """
          C.each (always model.hovering) <| \\p item ->
            [ C.tooltip item [ CA.background "beige" ] []
                [ H.text <| String.fromFloat (CI.getInd item)
                , H.text ", "
                , H.text <| String.fromFloat (CI.getValue item)
                ]
            ]
              """
          , chart = \_ ->
              frame
                [ C.event "mousemove" (C.map (OnHover >> onMsg) (C.getNearest CI.getCenter identity))
                , C.event "mouseleave" (C.map (\_ -> OnHover [] |> onMsg) C.getCoords)
                ] <|
                C.each (\_ -> model.hovering) <| \p item ->
                  [ C.tooltip item [ CA.background "beige" ] []
                      [ H.text <| String.fromFloat (CI.getInd item) -- TODO
                      , H.text ", "
                      , H.text <| String.fromFloat (Maybe.withDefault 0 <| CI.getValue item)
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

