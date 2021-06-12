module Examples.BarCharts.Ungroup exposing (..)


-- THIS IS A GENERATED MODULE!

import Html as H
import Svg as S
import Chart as C
import Chart.Attributes as CA


view : Model -> H.Html Msg
view model =
  C.chart
    [ CA.height 300
    , CA.width 300
    ]
    [ C.grid []
    , C.xLabels []
    , C.yLabels []
    , C.bars
        [ CA.ungroup ]
        [ C.bar .w []
        , C.bar .z [ CA.striped [] ]
        ]
        data
    ]

meta =
  { category = "Bar charts"
  , categoryOrder = 1
  , name = "Ungroup"
  , description = "Have bars overlap rather than be side-by-side."
  , order = 4
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
  }


data : List Datum
data =
  let toDatum x x1 y z v w p q =
        Datum x x1 y (Just y) (Just z) (Just v) (Just w) (Just p) (Just q)
  in
  [ toDatum 0.0 0.0 2.0 4.0 4.6 6.9 7.3 8.0
  , toDatum 1.0 2.0 3.0 4.2 5.3 5.7 6.2 7.8
  , toDatum 2.0 3.0 4.0 3.2 4.8 5.4 7.2 8.3
  , toDatum 3.0 4.0 5.0 3.0 4.1 5.5 7.9 8.1
  ]


smallCode : String
smallCode =
  """
  C.chart
    [ CA.height 300
    , CA.width 300
    ]
    [ C.grid []
    , C.xLabels []
    , C.yLabels []
    , C.bars
        [ CA.ungroup ]
        [ C.bar .w []
        , C.bar .z [ CA.striped [] ]
        ]
        data
    ]
  """


largeCode : String
largeCode =
  """
import Html as H
import Svg as S
import Chart as C
import Chart.Attributes as CA


view : Model -> H.Html Msg
view model =
  C.chart
    [ CA.height 300
    , CA.width 300
    ]
    [ C.grid []
    , C.xLabels []
    , C.yLabels []
    , C.bars
        [ CA.ungroup ]
        [ C.bar .w []
        , C.bar .z [ CA.striped [] ]
        ]
        data
    ]
  """