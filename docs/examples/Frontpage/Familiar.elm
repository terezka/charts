module Examples.Frontpage.Familiar exposing (..)

{-| @LARGE -}
import Html exposing (Html)
{-| @SMALL -}
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
    , C.series .x [ C.interpolated .y [ CA.width 2 ] [] ] data
    ]
{-| @SMALL END -}
{-| @LARGE END -}


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

