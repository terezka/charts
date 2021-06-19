module Examples.Frame.Titles exposing (..)


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
    , CA.paddingTop 25
    , CA.range [ CA.lowest 0 CA.exactly ]
    ]
    [ C.grid []
    , C.xAxis []
    , C.xTicks [ CA.ints ]
    , C.xLabels [ CA.ints ]
    , C.yAxis []
    , C.yTicks [ CA.ints ]
    , C.yLabels [ CA.ints ]
    , C.series .age
        [ C.property .toys []
            [ CA.opacity 0, CA.borderWidth 1 ]
        ]
        data

    , C.labelAt .min CA.middle [ CA.moveLeft 35, CA.rotate 90 ]
        [ S.text "Fruits" ]
    , C.labelAt CA.middle .min [ CA.moveDown 30 ]
        [ S.text "Age" ]
    , C.labelAt CA.middle .max [ CA.fontSize 14 ]
        [ S.text "How many fruits do children eat? (2021)" ]
    , C.labelAt CA.middle .max [ CA.moveDown 15 ]
        [ S.text "Data from fruits.com" ]
    ]


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




meta =
  { category = "Frame and navigation"
  , categoryOrder = 4
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



smallCode : String
smallCode =
  """
  C.chart
    [ CA.height 300
    , CA.width 300
    , CA.paddingTop 25
    , CA.range [ CA.lowest 0 CA.exactly ]
    ]
    [ C.grid []
    , C.xAxis []
    , C.xTicks [ CA.ints ]
    , C.xLabels [ CA.ints ]
    , C.yAxis []
    , C.yTicks [ CA.ints ]
    , C.yLabels [ CA.ints ]
    , C.series .age
        [ C.property .toys []
            [ CA.opacity 0, CA.borderWidth 1 ]
        ]
        data

    , C.labelAt .min CA.middle [ CA.moveLeft 35, CA.rotate 90 ]
        [ S.text "Fruits" ]
    , C.labelAt CA.middle .min [ CA.moveDown 30 ]
        [ S.text "Age" ]
    , C.labelAt CA.middle .max [ CA.fontSize 14 ]
        [ S.text "How many fruits do children eat? (2021)" ]
    , C.labelAt CA.middle .max [ CA.moveDown 15 ]
        [ S.text "Data from fruits.com" ]
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
    , CA.paddingTop 25
    , CA.range [ CA.lowest 0 CA.exactly ]
    ]
    [ C.grid []
    , C.xAxis []
    , C.xTicks [ CA.ints ]
    , C.xLabels [ CA.ints ]
    , C.yAxis []
    , C.yTicks [ CA.ints ]
    , C.yLabels [ CA.ints ]
    , C.series .age
        [ C.property .toys []
            [ CA.opacity 0, CA.borderWidth 1 ]
        ]
        data

    , C.labelAt .min CA.middle [ CA.moveLeft 35, CA.rotate 90 ]
        [ S.text "Fruits" ]
    , C.labelAt CA.middle .min [ CA.moveDown 30 ]
        [ S.text "Age" ]
    , C.labelAt CA.middle .max [ CA.fontSize 14 ]
        [ S.text "How many fruits do children eat? (2021)" ]
    , C.labelAt CA.middle .max [ CA.moveDown 15 ]
        [ S.text "Data from fruits.com" ]
    ]


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


  """