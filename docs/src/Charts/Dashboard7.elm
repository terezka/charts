module Charts.Dashboard7 exposing (Model, Msg, init, update, view)

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
  { hoveringBin : List (CE.Group (CE.Bin Datum) CE.Any (Maybe Float) Datum)
  , hoveringDot : List (CE.Product CE.Dot (Maybe Float) Datum)
  }


init : Model
init =
  { hoveringBin = []
  , hoveringDot = []
  }


type Msg
  = OnHover
      (List (CE.Group (CE.Bin Datum) CE.Any (Maybe Float) Datum))
      (List (CE.Product CE.Dot (Maybe Float) Datum))


update : Msg -> Model -> Model
update msg model =
  case msg of
    OnHover hoveringBin hoveringDot ->
      { model | hoveringBin = hoveringBin, hoveringDot = hoveringDot }


view : Model -> H.Html Msg
view model =
  C.chart
    [ CA.height 300
    , CA.width 500
    , CA.marginRight 20
    , CA.paddingRight 20
    , CA.paddingLeft 20
    , CA.paddingBottom 10
    , CE.on "mousemove" <|
        CE.map2 OnHover
          (CE.getNearestX CE.bin)
          (CE.getNearest CE.dot)

    , CE.onMouseLeave (OnHover [] [])
    ]
    [ C.grid []
    , C.yTicks [ CA.height 0 ]
    --, C.yLabels [ CA.fontSize 8, CA.moveUp 6, CA.moveRight 10, CA.alignLeft ]
    , C.xLabels [ CA.noGrid, CA.pinned .min, CA.times Time.utc, CA.uppercase, CA.fontSize 10, CA.amount 8 ]

    , C.each model.hoveringBin <| \p bin ->
        let common = CE.getCommonality bin in
        [ C.line [ CA.x1 common.start, CA.dashed [ 3, 3 ], CA.width 2 ] ]

    , let binMembers = List.concatMap CE.getProducts model.hoveringBin
      in
      C.series .x
        [ C.interpolated (.low >> (+) -10 >> Just) [ CA.stepped, CA.width 2, CA.color "#C600C5AF" ] []
            |> C.amongst binMembers (\_ -> [ CA.circle, CA.size 12 ])
            |> C.amongst model.hoveringDot (\_ -> [ CA.color "white", CA.borderWidth 2, CA.size 18, CA.highlight 0.5, CA.highlightWidth 8, CA.highlightColor "#C600C5" ])
            |> C.named "Lowest"
        , C.interpolated (.avg >> Just) [ CA.monotone, CA.width 2, CA.color "#1600D2AF", CA.dashed [ 5, 5 ] ] []
            |> C.amongst binMembers (\_ -> [ CA.circle, CA.size 12 ])
            |> C.amongst model.hoveringDot (\_ -> [ CA.color "white", CA.borderWidth 2, CA.size 18, CA.highlight 0.5, CA.highlightWidth 8, CA.highlightColor "#1600D2" ])
            |> C.named "Average"
        , C.interpolated (.high >> (+) 10 >> Just) [ CA.stepped, CA.width 2, CA.color "#00E58AAF" ] []
            |> C.amongst binMembers (\_ -> [ CA.circle, CA.size 12 ])
            |> C.amongst model.hoveringDot (\_ -> [ CA.color "white", CA.borderWidth 2, CA.size 18, CA.highlight 0.5, CA.highlightWidth 8, CA.highlightColor "#00E58A" ])
            |> C.named "Highest"
        ]
        lineData
    ]


type alias Datum =
  { x : Float
  , low : Float
  , avg : Float
  , high : Float
  }


lineData : List Datum
lineData =
  [ Datum 1609459200000 -12 -2  4
  , Datum 1612137600000 -15 -3  2
  , Datum 1614556800000 -4   0  6
  , Datum 1617235200000 -2   3  6
  , Datum 1619827200000  2   5 14
  , Datum 1622505600000  4   8 17
  , Datum 1625097600000  4  12 28
  , Datum 1627776000000 11  16 32
  , Datum 1630454400000 12  18 28
  , Datum 1633046400000  8  13 22
  , Datum 1635724800000  2   9 14
  , Datum 1638316800000 -2   4 10
  , Datum 1640995200000 -7   0  5
  ]

