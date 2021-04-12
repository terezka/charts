module Test exposing (..)

import Html as H
import Html.Attributes as HA
import Svg as S exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes as SA exposing (width, height, stroke, fill, r, transform)
import Svg.Coordinates as Coordinates
import Svg.Chart as SC
import Browser
import Time
import Data.Iris as Iris
import Data.Salery as Salery
import Data.Education as Education
import Dict

import Chart as C
import Chart.Attributes as CA
import Chart.Item as CI


-- TODO
-- labels + ticks + grid automation?
-- Title
-- seperate areas from lines + dots to fix opacity


main =
  Browser.sandbox
    { init = init
    , update = update
    , view = view
    }


type alias Model =
  { hoveringSalery : List (CI.BarItem Salery.Datum)
  , hovering : List (CI.BarItem Datum)
  , hoveringNew : List (CI.BarItem Datum)
  , point : Maybe Coordinates.Point
  }


init : Model
init =
  Model [] [] [] Nothing


type Msg
  = OnHoverSalery (List (CI.BarItem Salery.Datum))
  | OnHover (List (CI.BarItem Datum))
  | OnHoverNew (List (CI.BarItem Datum))
  | OnCoords Coordinates.Point -- TODO


update : Msg -> Model -> Model
update msg model =
  case msg of
    OnHoverSalery bs -> { model | hoveringSalery = bs }
    OnHoverNew bs -> { model | hoveringNew = bs }
    OnHover bs -> { model | hovering = bs }
    OnCoords p -> { model | point = Just p }


type alias Datum =
  { x : Float
  , y : Maybe Float
  , z : Maybe Float
  , label : String
  }


data : List Datum
data =
  [ { x = 2, y = Just 6, z = Just 2, label = "DK" }
  , { x = 6, y = Just 8, z = Just 5, label = "SE" }
  , { x = 8, y = Just 3, z = Just 2, label = "FI" }
  , { x = 10, y = Just 4, z = Just 3, label = "IS" }
  ]


view : Model -> H.Html Msg
view model =
  H.div
    [ HA.style "font-size" "12px"
    , HA.style "font-family" "monospace"
    , HA.style "margin" "0 auto"
    , HA.style "padding-top" "50px"
    , HA.style "width" "100vw"
    , HA.style "max-width" "1000px"
    ]
    [ C.chart
      [ C.height 400
      , C.width 1000
      , C.static
      --, C.marginLeft 0
      , C.paddingTop 15
      --, C.range (C.startMin 0 >> C.endMax 6)
      --, C.domain (C.startMax 0 >> C.endMin 19)
      --, C.events
      --    [ CA.getNearest CI.getCenter (C.getBars >> C.only "cats")
      --        |> C.map OnHoverNew
      --        |> C.event "mousemove"
      --    ]
      , C.id "salery-discrepancy"
      ]
      [ C.grid []

      , C.bars
          [ CA.roundTop 0.2
          , CA.roundBottom 0.2
          , CA.grouped
          , CA.x1 .x
          , CA.x2 (.x >> (\x -> x + 1))
          , CA.margin 0.1
          , CA.spacing 0.04
          ]
          [ C.stacked
              [ C.property .y "cats" "km" [] []
              , C.property .z "cats" "km" [] []
              , C.property (Just << .x) "cats" "km" [] []
              ]
          , C.property .z "cats" "km" [] []
          ]
          data

      , C.yAxis []
      , C.xTicks []
      , C.xLabels []
      , C.yLabels [ C.ints ]
      , C.yTicks [ C.ints ]

      , C.series .x
          [ C.stacked
              [ C.property .y "cats" "km" [ CA.linear, CA.opacity 0.25 ] [ CA.circle ]
                  |> C.variation (\datum -> [ CA.size (Maybe.withDefault 2 datum.y) ])
              , C.property .z "cats" "km" [ CA.linear, CA.opacity 0.25, CA.color CA.purple ] [ CA.circle ]
              ]
          ]
          data

      , C.xAxis []
      ]
    ]


tooltip : CI.BarItem Datum -> List (CI.BarItem Datum) -> H.Html msg
tooltip hovered _ =
  H.div []
    [ H.h4
        [ HA.style "max-width" "200px"
        , HA.style "margin-top" "5px"
        , HA.style "margin-bottom" "8px"
        , hovered
            |> CI.getItems
            |> List.head
            |> Maybe.map CI.getColor
            |> Maybe.withDefault "blue"
            |> HA.style "color"
        ]
        [ hovered
            |> CI.getItems
            |> List.head
            |> Maybe.map CI.getName
            |> Maybe.withDefault "WHAT"
            |> H.text
        ]
    , H.div []
        [ H.text "X: "
        , H.text <| Debug.toString <| .x <| CI.getDatum hovered
        ]
    , H.div []
        [ H.text "Y: "
        , H.text <| Debug.toString <| .y <| CI.getDatum hovered
        ]
    ]
