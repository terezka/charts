module Charts.Dashboard1 exposing (Model, Msg, init, update, view)

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
    , CA.width 490
    , CA.static
    , CA.marginRight 10
    , CA.marginLeft 10
    , CA.marginBottom 18
    , CA.paddingRight 35
    , CE.onMouseMove OnHover (CE.getNearest CE.dot)
    , CE.onMouseLeave (OnHover [])
    ]
    [ C.grid [ CA.dashed [ 3, 2 ]]
    , C.xLabels [ CA.times Time.utc, CA.amount 20, CA.fontSize 10 ]
    , C.yLabels [ CA.pinned .max, CA.moveUp 7, CA.moveRight 10, CA.fontSize 10 ]

    , C.barsMap Bar
        [ CA.x1 (\d -> d.x + 150000)
        , CA.noGrid
        , CA.roundTop 0.2
        , CA.ungroup
        ]
        [ C.bar .y [ CA.color "#7b4dff", CA.gradient [ CA.colors [ "#7b4dff6F", "#7b4dff1F" ] ] ]
        , C.bar .z [ CA.color "#bfc2c9", CA.gradient [ CA.colors [ "#bfc2c9", "#bfc2c96F" ] ] ]
        ]
        barData

    , C.seriesMap Dot .x
        [ C.interpolated .y
            [ CA.monotone, CA.color "#7b4dff", CA.width 1.5, CA.opacity 0.2 ]
            [ CA.color "white", CA.borderWidth 1.5, CA.circle ]
            |> C.named "Traffic"
            |> C.amongst (CE.filterDatum justDot model.hovering) (\_ -> [ CA.color "#7b4dff", CA.border "white" ])
        ]
        lineData

    , C.each model.hovering <| \p dot ->
        [ C.tooltip dot [ CA.onTop, CA.offset 3 ] [] [] ]
    ]


type Datum
  = Bar BarDatum
  | Dot DotDatum


justDot : Datum -> Maybe DotDatum
justDot datum =
  case datum of
    Bar _ -> Nothing
    Dot dot -> Just dot


type alias BarDatum =
  { x : Float
  , y : Float
  , z : Float
  }


barData : List BarDatum
barData =
  [ BarDatum 1612440000000 1000 200
  , BarDatum 1612440300000 1250 120
  , BarDatum 1612440600000 1500 230
  , BarDatum 1612440900000 850 80
  , BarDatum 1612441200000 540 120
  , BarDatum 1612441500000 300 0
  , BarDatum 1612441800000 760 230
  , BarDatum 1612442100000 870 180
  , BarDatum 1612442400000 900 60
  , BarDatum 1612442700000 1020 300
  , BarDatum 1612443000000 1220 340
  ]


type alias DotDatum =
  { x : Float
  , y : Float
  }


lineData : List DotDatum
lineData =
  [ DotDatum 1612440000000 1400
  , DotDatum 1612440300000 1350
  , DotDatum 1612440600000 1600
  , DotDatum 1612440900000 950
  , DotDatum 1612441200000 740
  , DotDatum 1612441500000 320
  , DotDatum 1612441800000 860
  , DotDatum 1612442100000 830
  , DotDatum 1612442400000 600
  , DotDatum 1612442700000 920
  , DotDatum 1612443000000 720
  , DotDatum 1612443300000 520
  , DotDatum 1612443600000 620
  ]

