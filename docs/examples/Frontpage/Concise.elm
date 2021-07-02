module Examples.Frontpage.Concise exposing (..)

{-| @LARGE -}
import Html as H
import Svg as S
import Chart as C
import Chart.Attributes as CA
import Chart.Events as CE


type alias Model =
  { hovering : List (CE.Group (CE.Stack Datum) CE.Any (Maybe Float) Datum) }


init : Model
init =
  { hovering = [] }


type Msg
  = OnHover (List (CE.Group (CE.Stack Datum) CE.Any (Maybe Float) Datum))


update : Msg -> Model -> Model
update msg model =
  case msg of
    OnHover hovering ->
      { model | hovering = hovering }


view : Model -> H.Html Msg
view model =
{-| @SMALL -}
  C.chart
    [ CA.height 300
    , CA.width 300
    , CA.static
    , CE.onMouseMove OnHover (CE.getNearest CE.stack)
    , CE.onMouseLeave (OnHover [])
    ]
    [ C.grid []
    , C.yLabels []

    , C.bars [ CA.roundTop 0.5 ]
        [ C.stacked
            [ C.bar .p [ CA.opacity 0.8 ]
            , C.bar .w [ CA.opacity 0.8 ]
            ]
        , C.bar .q [ CA.opacity 0.8, CA.dotted [ CA.spacing 2.2 ] ]
        ]
        data

    , C.binLabels .country CE.getBottom [ CA.moveDown 15 ]
    , C.barLabels CE.getTop [ CA.moveDown 15, CA.color "white" ]
    , C.each model.hovering <| \p stack -> [ C.tooltip stack [] [] [] ]
    ]
{-| @SMALL END -}
{-| @LARGE END -}


meta =
  { category = "Front page"
  , categoryOrder = 1
  , name = "Labels for bars"
  , description = "Add custom bar labels."
  , order = 15
  }


type alias Datum =
  { x : Float
  , x1 : Float
  , y : Float
  , z : Float
  , v : Float
  , w : Float
  , p : Float
  , q : Float
  , country : String
  }


data : List Datum
data =
  [ Datum 0.0 0.0 1.2 4.0 4.6 6.9 7.3 8.0 "Norway"
  , Datum 2.0 0.4 2.2 4.2 5.3 5.7 6.2 7.8 "Denmark"
  , Datum 3.0 0.6 1.0 3.2 4.8 5.4 7.2 8.3 "Sweden"
  , Datum 4.0 0.2 1.2 3.0 4.1 5.5 7.9 8.1 "Finland"
  ]

