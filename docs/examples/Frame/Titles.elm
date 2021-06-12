module Examples.Frame.Titles exposing (..)

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
    , CA.paddingTop 25
    , CA.range [ CA.lowest 0 CA.exactly ]
    ]
    [ C.grid []
    , C.xAxis []
    , C.xTicks []
    , C.xLabels []
    , C.yAxis []
    , C.yTicks []
    , C.yLabels []
    , C.series .age
        [ C.property .toys []
            [ CA.opacity 0, CA.borderWidth 1 ]
        ]
        data

    , C.titleAt .min CA.middle [ CA.moveLeft 35, CA.rotate 90 ]
        [ S.text "Fruits" ]
    , C.titleAt CA.middle .min [ CA.moveDown 30 ]
        [ S.text "Age" ]
    , C.titleAt CA.middle .max [ CA.fontSize 14 ]
        [ S.text "How many fruits do children eat? (2021)" ]
    , C.titleAt CA.middle .max [ CA.moveDown 15 ]
        [ S.text "Data from fruits.com" ]
    ]
{-| @SMALL END -}


type alias Datum =
  { age : Float
  , toys : Maybe Float
  }

data : List Datum
data =
  [ Datum 0.5 (Just 4)
  , Datum 0.8 (Just 5)
  , Datum 1.2 (Just 6)
  , Datum 1.4 (Just 6)
  , Datum 1.6 (Just 4)
  , Datum 3 (Just 8)
  , Datum 3 (Just 9)
  , Datum 3.2 (Just 10)
  , Datum 3.8 (Just 7)
  , Datum 6 (Just 12)
  , Datum 6.2 (Just 8)
  , Datum 6 (Just 10)
  , Datum 6 (Just 9)
  , Datum 9.1 (Just 8)
  , Datum 9.2 (Just 13)
  , Datum 9.8 (Just 10)
  , Datum 12 (Just 7)
  , Datum 12.5 (Just 5)
  , Datum 12.5 (Just 2)
  ]


{-| @LARGE END -}


meta =
  { category = "Frame and navigation"
  , name = "Titles"
  , description = "Add titles to chart."
  , order = 20
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

