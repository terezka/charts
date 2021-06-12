module Examples.Frame.Times exposing (..)

{-| @LARGE -}
import Html as H
import Svg as S
import Chart as C
import Chart.Attributes as CA
import Time


view : Model -> H.Html Msg
view model =
{-| @SMALL -}
  C.chart
    [ CA.height 300
    , CA.width 300
    , CA.paddingRight 25
    , CA.range
        [ CA.lowest 1591974241000 CA.exactly
        , CA.highest 1623510241000 CA.exactly
        ]
    ]
    [ C.grid []
    , C.xAxis []
    , C.xTicks [ CA.times Time.utc ]
    , C.xLabels [ CA.times Time.utc ]
    ]
{-| @SMALL END -}
{-| @LARGE END -}


meta =
  { category = "Frame and navigation"
  , name = "Timeline"
  , description = "Use dates as labels."
  , order = 8
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

