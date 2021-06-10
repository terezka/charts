module Examples.BarCharts.BarLabels exposing (..)

{-| @LARGE -}
import Html as H
import Svg as S
import Chart as C
import Chart.Attributes as CA
import Chart.Events as CE


view : Model -> H.Html Msg
view model =
{-| @SMALL -}
  C.chart
    [ CA.height 300
    , CA.width 300
    ]
    [ C.grid []

    , C.xLabels []
    , C.yLabels []
    , C.bars []
        [ C.property .q [] []
        , C.property .p [] []
        ]
        data
    , C.eachProduct <| \p bar ->
        let top = CE.getTop p bar
            label =
              CE.getDependent bar
                |> Maybe.map String.fromFloat
                |> Maybe.withDefault "N/A"
        in
        [ C.xLabel
            [ CA.x top.x
            , CA.y top.y
            , CA.yOff -2
            , CA.color "white"
            ]
            [ S.text label ]
        ]
    ]
{-| @SMALL END -}
{-| @LARGE END -}


meta =
  { category = "Bar charts"
  , name = "Labels for bars"
  , description = "Add custom bar labels."
  , order = 15
  }


type alias Model =
  ()


init : Model
init =
  ()


type Msg
  = Msg


update : Msg -> Model -> Model
update msg model =
  model


type alias Datum =
  { x : Float
  , x1 : Float
  , x2 : Float
  , y : Maybe Float
  , z : Maybe Float
  , v : Maybe Float
  , w : Maybe Float
  , p : Maybe Float
  , q : Maybe Float
  , label : String
  }


data : List Datum
data =
  let toDatum x x1 y z v w p q label =
        Datum x x1 x1 (Just y) (Just z) (Just v) (Just w) (Just p) (Just q) label
  in
  [ toDatum 0.0 0.0 1.2 4.0 4.6 6.9 7.3 8.0 "Norway"
  , toDatum 2.0 0.4 2.2 4.2 5.3 5.7 6.2 7.8 "Denmark"
  , toDatum 3.0 0.6 1.0 3.2 4.8 5.4 7.2 8.3 "Sweden"
  , toDatum 4.0 0.2 1.2 3.0 4.1 5.5 7.9 8.1 "Finland"
  ]

