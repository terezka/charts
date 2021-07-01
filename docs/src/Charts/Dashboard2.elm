module Charts.Dashboard2 exposing (Model, Msg, init, update, view)

import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Svg as S exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes as SA exposing (width, height, stroke, fill, r, transform)
import Browser
import Time
import Data.Iris as Iris
import Data.Salary as Salary
import Data.Education as Education
import Dict
import Time

import Chart as C
import Chart.Attributes as CA
import Chart.Events as CE
import Chart.Svg as CS

import Element as E
import Element.Font as F
import Element.Border as B
import Element.Background as BG

import Chart.Events


type alias Model =
  { hovering : List (CE.Product CE.Dot Float Datum)
  }


init : Model
init =
  { hovering = []
  }


type Msg
  = OnHover (List (CE.Product CE.Dot Float Datum))


update : Msg -> Model -> Model
update msg model =
  case msg of
    OnHover hovering ->
      { model | hovering = hovering }


view : Model -> H.Html Msg
view model =
  C.chart
    [ CA.height 135
    , CA.width 225
    , CA.static
    , CA.paddingRight 0
    , CA.paddingBottom 0
    , CA.paddingTop 0
    , CE.onMouseMove OnHover (CE.getNearest <| CE.keep CE.realValues CE.dot)
    , CE.onMouseLeave (OnHover [])
    ]
    [ C.series .x
        [ C.interpolated .y
            [ CA.monotone, CA.color "#555", CA.dashed [ 5, 5 ], CA.width 3, CA.opacity 0.1 ]
            []
            |> C.named "Combinations"
            |> C.amongst model.hovering (\_ -> [ CA.circle, CA.color CA.pink, CA.size 15 ])
        ]
        lineData

    , C.bars
        [ CA.x1 .x
        , CA.roundTop 0.2
        , CA.ungroup
        , CA.margin 0.05
        ]
        [ C.bar .y [ CA.color CA.pink, CA.opacity 0.8 ]
        ]
        barData

    , C.eachBar <| \p bar ->
        let bottom = CE.getBottom p bar
            value = Maybe.withDefault 0 (CE.getDependent bar)
            color = if value < 10 then "#6f6f6f" else "white"
        in
        if value == 0 then [] else
        [ C.label [ CA.color color, CA.moveUp 6, CA.fontSize 14 ] [ S.text (String.fromFloat value) ] bottom ]

    , C.each model.hovering <| \p dot ->
        [ C.label [ CA.fontSize 14, CA.moveUp 10 ] [ S.text (String.fromFloat <| CE.getDependent dot) ] (CE.getTop p dot) ]
    ]


type alias Datum =
  { x : Float
  , y : Maybe Float
  }


barData : List Datum
barData =
  [ Datum 1612440000000 (Just 56)
  , Datum 1612440300000 (Just 32)
  , Datum 1612440600000 (Just 0)
  , Datum 1612440900000 (Just 7)
  , Datum 1612441200000 (Just 48)
  , Datum 1612441500000 (Just 24)
  , Datum 1612441800000 (Just 0)
  , Datum 1612442100000 (Just 88)
  ]


lineData : List Datum
lineData =
  [ Datum 1612440000000 (Just 90)
  , Datum 1612440300000 (Just 80)
  , Datum 1612440600000 (Just 97)
  , Datum 1612440900000 (Just 65)
  , Datum 1612441200000 (Just 72)
  , Datum 1612441500000 (Just 56)
  , Datum 1612441800000 (Just 82)
  , Datum 1612442100000 (Just 94)
  , Datum 1612442400000 (Just 76)
  ]

