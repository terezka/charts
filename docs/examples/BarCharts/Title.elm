module Examples.BarCharts.Title exposing (..)

{-| @LARGE -}
import Html as H
import Svg as S
import Chart as C
import Chart.Attributes as CA


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

    , C.labelAt .max .max
        [ CA.moveLeft 8, CA.moveDown 5, CA.alignRight ]
        [ S.text "Quarterly revenue" ]

    , C.labelAt CA.middle .min
        [ CA.moveDown 18 ]
        [ S.text "Quarter" ]

    , C.labelAt .min CA.middle
        [ CA.moveLeft 25, CA.rotate 90 ]
        [ S.text "Revenue" ]

    , C.bars []
        [ C.bar .z []
        , C.bar .y []
        ]
        data
    ]
{-| @SMALL END -}
{-| @LARGE END -}


meta =
  { category = "Bar charts"
  , categoryOrder = 1
  , name = "Titles"
  , description = "Add labels to bar chart."
  , order = 16
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
  , y : Float
  , z : Float
  , v : Float
  , w : Float
  , p : Float
  , q : Float
  }


data : List Datum
data =
  [ Datum 0.0 0.0 1.2 4.0 4.6 6.9 7.3 8.0
  , Datum 2.0 0.4 2.2 4.2 5.3 5.7 6.2 7.8
  , Datum 3.0 0.6 1.0 3.2 4.8 5.4 7.2 8.3
  , Datum 4.0 0.2 1.2 3.0 4.1 5.5 7.9 8.1
  ]

