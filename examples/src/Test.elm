module Test exposing (..)

import Html as H
import Html.Attributes as HA
import Svg as S exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes as SA exposing (width, height, stroke, fill, r, transform)
import Svg.Coordinates as Coordinates
import Chart as C
import Svg.Chart as SC
import Browser
import Time
import Data.Iris as Iris
import Data.Salery as Salery
import Data.Education as Education
import Dict
import Chart.Svg as CS
import Chart.Attributes as CA
import Chart.Item as Item


-- TODO
-- labels + ticks + grid automation?
-- clean up Item / Items
-- Title
-- seperate areas from lines + dots to fix opacity


main =
  Browser.sandbox
    { init = init
    , update = update
    , view = view
    }


type alias Model =
  { hoveringSalery : List (Item.BarItem Salery.Datum)
  , hovering : List (Item.BarItem Datum)
  , hoveringNew : List (Item.BarItem Datum)
  , point : Maybe Coordinates.Point
  }


init : Model
init =
  Model [] [] [] Nothing


type Msg
  = OnHoverSalery (List (Item.BarItem Salery.Datum))
  | OnHover (List (Item.BarItem Datum))
  | OnHoverNew (List (Item.BarItem Datum))
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
  [ { x = 2, y = Just 6, z = Just 5, label = "DK" }
  , { x = 6, y = Just 5, z = Just 5, label = "SE" }
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
      --    [ C.decoder (\is pl ps -> CS.getNearest Item.center (C.getBars is) pl ps)
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
          --, CA.margin 0
          --, CA.spacing 0
          ]
          [ C.stacked
              [ C.property .y [] [] (always [])
              , C.property .z [] [] (always [])
              , C.property (C.just .x) [] [] (always [])
              ]
          , C.property .z [] [] (always [])
          ]
          data

      , C.yAxis []
      , C.xTicks []
      , C.xLabels []
      , C.yLabels [ C.ints ]
      , C.yTicks [ C.ints ]

      , C.series .x
          [ C.stacked
              [ C.property .y [] [ CA.circle, CA.linear, CA.area 0.25 ] (always [])
                  --(\d -> if hovered d then [ C.aura 5 0.5 ] else [])
              , C.property .z [] [ CA.circle, CA.linear, CA.area 0.25, CA.color CS.purple ] (always [])
              ]
          ]
          data

      , C.xAxis []
      ]
    ]


tooltip : Item.BarItem Datum -> List (Item.BarItem Datum) -> H.Html msg
tooltip hovered _ =
  H.div []
    [ H.h4
        [ HA.style "max-width" "200px"
        , HA.style "margin-top" "5px"
        , HA.style "margin-bottom" "8px"
        , hovered
            |> Item.getItems
            |> List.head
            |> Maybe.map Item.getColor
            |> Maybe.withDefault "blue"
            |> HA.style "color"
        ]
        [ hovered
            |> Item.getItems
            |> List.head
            |> Maybe.map Item.getName
            |> Maybe.withDefault "WHAT"
            |> H.text
        ]
    , H.div []
        [ H.text "X: "
        , H.text <| Debug.toString <| .x <| Item.getDatum hovered
        ]
    , H.div []
        [ H.text "Y: "
        , H.text <| Debug.toString <| .y <| Item.getDatum hovered
        ]
    ]
