module Examples.Navigation.AxisLength exposing (..)

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
    , CA.paddingTop 0
    , CA.paddingRight 0
    , CA.range
        [ CA.lowest 0 CA.orLower
        , CA.highest 100 CA.orHigher
        ]
    , CA.domain
        [ CA.lowest 0 CA.orLower
        , CA.highest 100 CA.orHigher
        ]
    ]
    [ C.grid []
    , C.series .x
        [ C.property .y [ CA.linear ] [] ]
        [ { x = 10, y = Just 20 }
        , { x = 85, y = Just 80 }
        ]
    , C.xAxis [ CA.noArrow, CA.limits [ CA.likeData ] ]
    , C.xLabels []
    ]
{-| @SMALL END -}
{-| @LARGE END -}


meta =
  { category = "Navigation"
  , name = "Adjust axis line"
  , description = "Change the length of your axis line."
  , order = 12
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


