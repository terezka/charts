module Charts.Dashboard5 exposing (Model, Msg, init, update, view)

import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Svg as S exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes as SA exposing (width, height, stroke, fill, r, transform)
import Browser
import Time
import Data.Iris as Iris
import Data.Iris as Salary
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
  { hovering : List (CE.Product CE.Dot (Maybe Float) Iris.Datum)
  }


init : Model
init =
  { hovering = []
  }


type Msg
  = OnHover (List (CE.Product CE.Dot (Maybe Float) Iris.Datum))


update : Msg -> Model -> Model
update msg model =
  case msg of
    OnHover hovering ->
      { model | hovering = hovering }


view : Model -> H.Html Msg
view model =
  C.chart
    [ CA.height 180
    , CA.width 300
    , CA.marginLeft 10
    , CA.marginBottom 10
    , CA.paddingRight 15
    , CA.paddingLeft 15
    , CA.paddingBottom 20
    , CA.paddingTop 15
    , CA.domain [ CA.likeData ]
    , CE.onMouseMove OnHover (CE.getNearest CE.dot)
    , CE.onMouseLeave (OnHover [])
    ]
    [ C.grid [ CA.dashed [ 5, 5 ] ]
    , C.yTicks []
    , C.yLabels [ CA.ints, CA.fontSize 8, CA.moveRight 2 ]
    , C.xTicks [ CA.amount 8 ]
    , C.xLabels [ CA.ints, CA.fontSize 8, CA.moveUp 5 ]
    , C.xAxis []
    , C.yAxis []
    , C.series .sepalLength
        [ C.scatter (.sepalWidth >> Just) [ CA.opacity 0.6 ]
            |> C.variation (\i d ->
                let speciesColor =
                      case d.species of
                        Iris.Setosa -> CA.pink
                        Iris.Versicolor -> CA.purple
                        Iris.Virginica -> CA.turquoise

                in [ CA.size d.petalLength, CA.color speciesColor ]
            )
        ]
        Iris.data

    , C.labelAt CA.middle .max
        [ CA.fontSize 9, CA.moveDown 2, CA.color "#aaa" ]
        [ S.text "The Iris flower: Sepal length vs. sepal width" ]

    , C.each model.hovering <| \p dot ->
        let datum = CE.getDatum dot in
        [ C.tooltip dot
            [ CA.offset 1 ]
            []
            [ H.div
                [ HA.style "color" (CE.getColor dot)
                , HA.style "text-align" "center"
                , HA.style "padding-bottom" "2px"
                , HA.style "border-bottom" "1px solid lightgray"
                , HA.style "font-size" "10px"
                ]
                [ H.text (Iris.species datum) ]
            , H.table
                [ HA.style "color" "rgb(90, 90, 90)"
                , HA.style "width" "100%"
                , HA.style "font-size" "9px"
                ]
                [ H.tr []
                    [ H.th [] []
                    , H.th [ HA.style "text-align" "right", HA.style "color" "rgb(120, 120, 120)" ] [ H.text "Length" ]
                    , H.th [ HA.style "text-align" "right", HA.style "color" "rgb(120, 120, 120)"  ] [ H.text "Width" ]
                    ]
                , H.tr []
                    [ H.th [ HA.style "text-align" "left", HA.style "color" "rgb(120, 120, 120)"  ] [ H.text "Sepal" ]
                    , H.th [ HA.style "text-align" "right" ] [ H.text (String.fromFloat datum.sepalLength ++ " cm") ]
                    , H.th [ HA.style "text-align" "right" ] [ H.text (String.fromFloat datum.sepalWidth ++ " cm")]
                    ]
                , H.tr []
                    [ H.th [ HA.style "text-align" "left", HA.style "color" "rgb(120, 120, 120)"  ] [ H.text "Petal" ]
                    , H.th [ HA.style "text-align" "right" ] [ H.text (String.fromFloat datum.petalLength ++ " cm") ]
                    , H.th [ HA.style "text-align" "right" ] [ H.text (String.fromFloat datum.petalWidth ++ " cm") ]
                    ]
                ]
            ]
          ]
    ]
