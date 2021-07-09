module Examples.BarCharts.BinLabelsAdvanced exposing (..)

{-| @LARGE -}
import Html as H
import Svg as S
import Chart as C
import Chart.Attributes as CA
import Chart.Events as CE


view : Model -> H.Html Msg
view model =
{-| @SMALL -}
  C.chart
    [ CA.height 300
    , CA.width 300
    ]
    [ C.grid []
    , C.yLabels []

    , C.eachBin <| \p bin ->
        let common = CE.getCommonality bin
            isSpecial = common.datum.y + common.datum.z > 6

            labelBasic =
              String.fromFloat common.start ++ " - " ++
              String.fromFloat common.end

            label =
              if isSpecial
              then "→ " ++ labelBasic ++ " ←"
              else labelBasic

            color =
              if isSpecial
              then "blue"
              else CA.labelGray
        in
        [ C.label
            [ CA.color color, CA.moveDown 18 ]
            [ S.text label ]
            (CE.getBottom p bin)
        ]

    , C.bars
        [ CA.x1 .x ]
        [ C.bar .z []
        , C.bar .y []
        ]
        data
    ]
{-| @SMALL END -}
{-| @LARGE END -}


meta =
  { category = "Bar charts"
  , categoryOrder = 1
  , name = "Advanced labels for bins"
  , description = "Add custom bin labels."
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


type alias Datum =
  { x : Float
  , y : Float
  , z : Float
  , label : String
  }


data : List Datum
data =
  [ Datum 1.0 2 4 "Norway"
  , Datum 2.0 1 3 "Denmark"
  , Datum 3.0 3 2 "Sweden"
  , Datum 4.0 5 4 "Finland"
  ]



