module Examples.Navigation.CustomLabels exposing (..)

{-| @LARGE -}
import Html as H
import Svg as S
import Chart as C
import Chart.Attributes as CA
import Chart.Svg as CS


view : Model -> H.Html Msg
view model =
{-| @SMALL -}
  C.chart
    [ CA.height 300
    , CA.width 300
    ]
    [ C.grid []
    , C.xAxis []
    , C.generate 12 CS.ints .x [] <| \p num ->
        let isEven = remainderBy 2 num == 0 in
        [ C.xLabel
            [ CA.x (toFloat num)
            , if isEven then identity else CA.y p.y.max
            , if isEven then identity else CA.moveUp 28
            , if isEven then identity else CA.fontSize 10
            , if isEven then identity else CA.color CA.blue
            ]
            [ S.text (String.fromInt num ++ "°") ]
        ]
    ]
{-| @SMALL END -}
{-| @LARGE END -}


meta =
  { category = "Navigation"
  , name = "Custom labels"
  , description = "Control labels entirely."
  , order = 9
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
        Datum x x1 x1 (Just y) (Just z) (Just v) (Just w) (Just p) (Just q)
  in
  [ toDatum 0.0 0.0 1.2 4.0 4.6 6.9 7.3 8.0
  , toDatum 2.0 0.4 2.2 4.2 5.3 5.7 6.2 7.8
  , toDatum 3.0 0.6 1.0 3.2 4.8 5.4 7.2 8.3
  , toDatum 4.0 0.2 1.2 3.0 4.1 5.5 7.9 8.1
  ]

