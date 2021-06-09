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
  , y : Maybe Float
  , z : Maybe Float
  , v : Maybe Float
  , w : Maybe Float
  , p : Maybe Float
  , q : Maybe Float
  }


data : List Datum
data =
  let toDatum x y z v w p q =
        Datum x y (Just z) (Just v) (Just w) (Just p) q
  in
  [ toDatum 0.0 (Just 2.0) 4.0 4.6 6.9 7.3 (Just 8.0)
  , toDatum 0.2 (Just 3.0) 4.2 5.2 6.2 7.0 (Just 7.0)
  , toDatum 0.8 (Just 4.0) 4.6 5.5 5.2 7.2 (Just 5.0)
  , toDatum 1.0 Nothing    4.2 5.3 5.7 6.2 (Just 4.0)
  , toDatum 1.2 (Just 5.0) 3.5 4.9 5.9 6.7 Nothing
  , toDatum 2.0 (Just 2.0) 3.2 4.8 5.4 7.2 (Just 7.0)
  , toDatum 2.3 (Just 1.0) 4.3 5.3 5.1 7.8 (Just 6.0)
  , toDatum 2.8 (Just 3.0) 2.9 5.4 3.9 7.6 (Just 6.0)
  , toDatum 3.0 Nothing    3.6 5.8 4.6 6.5 (Just 5.0)
  , toDatum 4.0 (Just 1.0) 4.2 4.5 5.3 6.3 (Just 7.0)
  ]
