module Charts.Dashboard3 exposing (Model, Msg, init, update, view)

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
  { hovering : List (CE.Product CE.Dot (Maybe Float) Datum)
  }


init : Model
init =
  { hovering = []
  }


type Msg
  = OnHover (List (CE.Product CE.Dot (Maybe Float) Datum))


update : Msg -> Model -> Model
update msg model =
  case msg of
    OnHover hovering ->
      { model | hovering = hovering }


view : Model -> H.Html Msg
view model =
  C.chart
    [ CA.height 300
    , CA.width 500
    , CA.paddingRight 0
    , CE.onMouseMove OnHover (CE.getNearestX CE.dot)
    , CE.onMouseLeave (OnHover [])
    ]
    [ C.xLabels [ CA.times Time.utc, CA.uppercase, CA.fontSize 18, CA.amount 10 ]

    , C.each model.hovering <| \p dot ->
        [ C.line [ CA.x1 (CE.getIndependent dot), CA.width 3, CA.dashed [ 10, 10 ] ] ]

    , C.series .x
        [ C.interpolated .y
            [ CA.linear, CA.color CA.blue, CA.width 3, CA.opacity 0.4, CA.gradient [ CA.colors [ CA.blue, "white" ] ] ]
            [ CA.diamond, CA.color "white", CA.borderWidth 3, CA.size 20 ]
            |> C.amongst model.hovering (\_ -> [ CA.size 40 ])
        ]
        lineData

    ]


type alias Datum =
  { x : Float
  , y : Maybe Float
  }


lineData : List Datum
lineData =
  [ Datum 1612137600000 (Just 80)
  , Datum 1614556800000 (Just 97)
  , Datum 1617235200000 (Just 65)
  , Datum 1617235200001 Nothing
  , Datum 1619827200000 (Just 72)
  , Datum 1622505600000 (Just 56)
  , Datum 1625097600000 (Just 82)
  , Datum 1627776000000 (Just 94)
  , Datum 1630454400000 (Just 76)
  , Datum 1633046400000 (Just 83)
  ]

