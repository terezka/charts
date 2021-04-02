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
  { hoveringSalery : List (SC.Item Float SC.BarDetails Salery.Datum)
  , hovering : List (SC.Item Float SC.BarDetails Datum)
  , point : Maybe SC.Point
  }


init : Model
init =
  Model [] [] Nothing


type Msg
  = OnHoverSalery (List (SC.Item Float SC.BarDetails Salery.Datum))
  | OnHover (List (SC.Item Float SC.BarDetails Datum))
  | OnCoords SC.Point -- TODO


update : Msg -> Model -> Model
update msg model =
  case msg of
    OnHoverSalery bs -> { model | hoveringSalery = bs }
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
  , { x = 4, y = Just 4, z = Just 3, label = "NO" }
  , { x = 6, y = Just 10, z = Just 13, label = "SE" }
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
      , C.marginLeft 50
      , C.paddingTop 15
      , C.id "salery-discrepancy"
      ]
      [ C.grid []
      --, C.bars
      --    [ C.start (\d -> d.x - 2), C.end .x, C.rounded 0.2, C.roundBottom ]
      --    [ C.stacked
      --        [ C.property .y [] (always [])
      --        , C.property .z [ C.color C.pink ] (always [])
      --        , C.property (C.just .x) [ C.color C.orange ] (always [])
      --        ]
      --    ]
      --    data
      , C.xAxis []
      , C.yAxis []
      , C.xTicks []
      , C.xLabels []
      , C.yLabels [ C.ints ]
      , C.yTicks [ C.ints ]
      , C.series .x
          [ C.stacked
              [ C.property .y [ C.area 0.2, C.linear 0, C.color C.blue ] (always [])
              , C.property .z [ C.area 0.5, C.linear 1, C.color C.pink ] (always [])
              ]
          ]
          data
      ]
    ]
