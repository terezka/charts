module Charts.Dashboard4 exposing (Model, Msg, init, update, view)

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
  { hovering : List (CE.Product CE.Bar (Maybe Float) Datum)
  }


init : Model
init =
  { hovering = []
  }


type Msg
  = OnHover (List (CE.Product CE.Bar (Maybe Float) Datum))


update : Msg -> Model -> Model
update msg model =
  case msg of
    OnHover hovering ->
      { model | hovering = hovering }


view : Model -> H.Html Msg
view model =
  C.chart
    [ CA.height 130
    , CA.width 500
    , CE.onMouseMove OnHover (CE.getNearest CE.bar)
    , CE.onMouseLeave (OnHover [])
    ]
    [ C.bars
        [ CA.roundTop 1
        , CA.roundBottom 1
        , CA.margin 0.2
        ]
        [ C.bar .y [ CA.color "lightgray" ]
            |> C.amongst model.hovering (\_ -> [ CA.color CA.mint, CA.opacity 0.8 ])
        ]
        data
    ]


type alias Datum =
  { y : Maybe Float
  }


data : List Datum
data =
  [ Datum (Just 128)
  , Datum (Just 123)
  , Datum (Just 118)
  , Datum (Just 127)
  , Datum (Just 132)
  , Datum (Just 143)
  , Datum (Just 134)
  , Datum (Just 145)
  , Datum (Just 156)
  , Datum (Just 136)
  , Datum (Just 139)
  , Datum (Just 129)
  , Datum (Just 116)
  , Datum (Just 112)
  , Datum (Just 110)
  , Datum (Just 125)
  , Datum (Just 125)
  , Datum (Just 135)
  , Datum (Just 145)
  , Datum (Just 149)
  , Datum (Just 159)
  , Datum (Just 154)
  , Datum (Just 142)
  , Datum (Just 137)
  , Datum (Just 138)
  , Datum (Just 129)
  , Datum (Just 132)
  , Datum (Just 148)
  , Datum (Just 159)
  , Datum (Just 164)
  ]

