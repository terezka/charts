module Examples.Frame.GridFilter exposing (..)

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
    , C.xLabels [ CA.noGrid ]
    , C.yLabels []
    ]
{-| @SMALL END -}
{-| @LARGE END -}


meta =
  { category = "Frame and navigation"
  , name = "Remove grid lines"
  , description = "Prevent automatically added gridlines."
  , order = 15
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

