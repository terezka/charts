module Examples.BarCharts.Spacing exposing (..)

{-| @LARGE -}
import Html as H
import Chart as C
import Chart.Attributes as CA


view : Model -> H.Html Msg
view model =
{-| @SMALL -}
  C.chart
    [ CA.height 300
    , CA.width 760
    , CA.static
    ]
    [ C.grid []
    , C.xLabels []
    , C.yLabels []
    , C.bars
        [ CA.spacing 0.1 ] -- Number is percentage of bin width
        [ C.bar .y []
        , C.bar .z []
        ]
        data
    ]
{-| @SMALL END -}
{-| @LARGE END -}


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
  }


data : List Datum
data =
  let toDatum x x1 y z v w p q =
        Datum x x1 x1 (Just y) (Just z) (Just v) (Just w) (Just p) (Just q)
  in
  [ toDatum 0.0 0.0 1.2 4.0 4.6 6.9 7.3 8.0
  , toDatum 1.0 0.4 2.2 4.2 5.3 5.7 6.2 7.8
  , toDatum 2.0 0.6 1.0 3.2 4.8 5.4 7.2 8.3
  , toDatum 3.0 0.8 2.3 3.6 5.8 4.6 6.5 6.9
  , toDatum 4.0 1.1 1.0 4.2 4.5 5.3 6.3 7.0
  ]
