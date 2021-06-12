module Examples.Navigation.Basic exposing (..)

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
    , C.xAxis []
    , C.xTicks []
    , C.xLabels []
    , C.yAxis []
    , C.yTicks []
    , C.yLabels []
    ]
{-| @SMALL END -}
{-| @LARGE END -}


meta =
  { category = "Navigation"
  , name = "Basic"
  , description = "Add grid, axes, ticks, and labels."
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

