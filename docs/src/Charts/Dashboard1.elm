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
import Chart.Item as CI
import Chart.Svg as CS

import Element as E
import Element.Font as F
import Element.Border as B
import Element.Background as BG

import Chart.Events


type alias Model =
  { hovering : List (CI.One Datum CI.Dot)
  }


init : Model
init =
  { hovering = []
  }


type Msg
  = OnHover (List (CI.One Datum CI.Dot))


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
    , CA.margin { top = 0, bottom = 18, left = 10, right = 10 }
    , CA.padding { top = 10, bottom = 0, left = 0, right = 35 }
    , CE.onMouseMove OnHover (CE.getNearest CI.dots)
    , CE.onMouseLeave (OnHover [])
    ]
    [ C.grid [ CA.dashed [ 3, 2 ]]
    , C.xLabels [ CA.times Time.utc, CA.amount 20, CA.fontSize 10 ]
    , C.yLabels
        [ CA.pinned .max, CA.moveUp 7, CA.moveRight 10, CA.fontSize 10
        , CA.format (\i -> String.fromFloat (i / 1000) ++ "k")
        ]

    , C.barsMap Bar
        [ CA.x1 (\d -> d.x + 150000)
        , CA.noGrid
        , CA.roundTop 0.2
        , CA.ungroup
        ]
        [ C.bar .y [ CA.color "#7b4dff", CA.gradient [ "#7b4dff6F", "#7b4dff1F" ] ]
        , C.bar .z [ CA.color "#bfc2c9", CA.gradient [ "#bfc2c9", "#bfc2c96F" ] ]
        ]
        barData

    , C.seriesMap Dot .x
        [ C.interpolated .y
            [ CA.monotone, CA.color "#7b4dff", CA.width 1.5, CA.opacity 0.2 ]
            [ CA.color "white", CA.borderWidth 1.5, CA.circle ]
            |> C.named "Traffic"
            |> C.amongst (CI.filter justDot model.hovering) (\_ -> [ CA.color "#7b4dff", CA.border "white" ])
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
  [ BarDatum 1612440000000 100000 20000
  , BarDatum 1612440300000 125000 12000
  , BarDatum 1612440600000 150000 23000
  , BarDatum 1612440900000 85000 8000
  , BarDatum 1612441200000 54000 12000
  , BarDatum 1612441500000 30000 0
  , BarDatum 1612441800000 76000 23000
  , BarDatum 1612442100000 87000 18000
  , BarDatum 1612442400000 90000 6000
  , BarDatum 1612442700000 102000 30000
  , BarDatum 1612443000000 122000 34000
  ]


type alias DotDatum =
  { x : Float
  , y : Float
  }


lineData : List DotDatum
lineData =
  [ DotDatum 1612440000000 140000
  , DotDatum 1612440300000 135000
  , DotDatum 1612440600000 160000
  , DotDatum 1612440900000 95000
  , DotDatum 1612441200000 74000
  , DotDatum 1612441500000 32000
  , DotDatum 1612441800000 86000
  , DotDatum 1612442100000 83000
  , DotDatum 1612442400000 60000
  , DotDatum 1612442700000 92000
  , DotDatum 1612443000000 72000
  , DotDatum 1612443300000 52000
  , DotDatum 1612443600000 62000
  ]

