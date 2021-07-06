module Examples.Frontpage.Familiar exposing (..)


-- THIS IS A GENERATED MODULE!

import Html exposing (Html)
import Chart as C
import Chart.Attributes as CA


view : Model -> Html Msg
view model =
  C.chart
    [ CA.height 300
    , CA.width 300
    , CA.static
    ]
    [ C.grid []
    , C.xLabels []
    , C.yLabels []
    , C.xAxis []
    , C.yAxis []
    , C.series .x [ C.interpolated .y [] [] ] data
    ]


meta =
  { category = "Front page"
  , categoryOrder = 2
  , name = "Basic"
  , description = "Make a basic scatter chart."
  , order = 1
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
  , y : Float
  }


data : List Datum
data =
  [ Datum 1 1
  , Datum 2 3
  , Datum 3 2
  , Datum 4.2 6.2
  ]



smallCode : String
smallCode =
  """
import Chart as C
import Chart.Attributes as CA


view : Model -> Html Msg
view model =
  C.chart
    [ CA.height 300
    , CA.width 300
    , CA.static
    ]
    [ C.grid []
    , C.xLabels []
    , C.yLabels []
    , C.xAxis []
    , C.yAxis []
    , C.series .x [ C.interpolated .y [] [] ] data
    ]
  """


largeCode : String
largeCode =
  """
import Html exposing (Html)
import Chart as C
import Chart.Attributes as CA


view : Model -> Html Msg
view model =
  C.chart
    [ CA.height 300
    , CA.width 300
    , CA.static
    ]
    [ C.grid []
    , C.xLabels []
    , C.yLabels []
    , C.xAxis []
    , C.yAxis []
    , C.series .x [ C.interpolated .y [] [] ] data
    ]
  """