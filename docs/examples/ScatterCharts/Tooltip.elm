module Examples.ScatterCharts.Tooltip exposing (..)

{-| @LARGE -}
import Html as H
import Svg as S
import Chart as C
import Chart.Attributes as CA
import Chart.Events as CE


type alias Model =
  { hovering : List (CE.Product CE.Dot (Maybe Float) Datum) }


init : Model
init =
  { hovering = [] }


type Msg
  = OnHover (List (CE.Product CE.Dot (Maybe Float) Datum))


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
    , CA.paddingLeft 30
    , CE.onMouseMove OnHover (CE.getNearest CE.dot)
    , CE.onMouseLeave (OnHover [])
    ]
    [ C.grid []
    , C.xLabels []
    , C.yLabels []
    , C.series .x
        [ C.property .y [] [ CA.opacity 0.2, CA.borderWidth 1 ]
            |> C.variation (\d -> [ CA.size (d.q * 20) ])
            |> C.amongst model.hovering (\d -> [ CA.aura 0.15 ])
        , C.property .z [] [ CA.opacity 0.2, CA.borderWidth 1 ]
            |> C.variation (\d -> [ CA.size (d.q * 20) ])
            |> C.amongst model.hovering (\d -> [ CA.aura 0.15 ])
        ]
        data
    , C.each model.hovering <| \p item ->
        [ C.tooltip item [] [] [] ]
    ]
{-| @SMALL END -}
{-| @LARGE END -}


meta =
  { category = "Scatter charts"
  , categoryOrder = 2
  , name = "Tooltip"
  , description = "Add basic tooltip."
  , order = 8
  }



type alias Datum =
  { x : Float
  , y : Maybe Float
  , z : Maybe Float
  , v : Maybe Float
  , w : Maybe Float
  , p : Maybe Float
  , q : Float
  }


data : List Datum
data =
  let toDatum x y z v w p q =
        Datum x (Just y) (Just z) (Just v) (Just w) (Just p) q
  in
  [ toDatum 0.6 2.0 4.0 4.6 6.9 7.3 2.0
  , toDatum 0.7 3.0 4.2 5.2 6.2 7.0 8.7
  , toDatum 0.8 4.0 4.6 5.5 5.2 7.2 3.1
  , toDatum 1.0 2.0 4.2 5.3 5.7 6.2 7.8
  , toDatum 1.2 5.0 3.5 4.9 5.9 6.7 5.2
  , toDatum 2.0 2.0 3.2 4.8 5.4 7.2 8.3
  , toDatum 2.3 1.0 4.3 5.3 5.1 7.8 10.1
  , toDatum 2.8 3.0 2.9 5.4 3.9 7.6 4.5
  , toDatum 3.0 2.0 3.6 5.8 4.6 6.5 6.9
  , toDatum 4.0 1.0 4.2 4.5 5.3 6.3 7.0
  ]

