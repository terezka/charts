module Examples.Frame.AxisLength exposing (..)


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
        [ C.interpolated .y [  ] [] ]
        [ { x = 10, y = 20 }
        , { x = 85, y = 80 }
        ]
    , C.xAxis [ CA.noArrow, CA.limits [ CA.likeData ] ]
    , C.xLabels []
    ]


meta =
  { category = "Navigation"
  , categoryOrder = 4
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




smallCode : String
smallCode =
  """
  C.chart
    [ CA.height 300
    , CA.width 300
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
        [ C.interpolated .y [  ] [] ]
        [ { x = 10, y = 20 }
        , { x = 85, y = 80 }
        ]
    , C.xAxis [ CA.noArrow, CA.limits [ CA.likeData ] ]
    , C.xLabels []
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
        [ C.interpolated .y [  ] [] ]
        [ { x = 10, y = 20 }
        , { x = 85, y = 80 }
        ]
    , C.xAxis [ CA.noArrow, CA.limits [ CA.likeData ] ]
    , C.xLabels []
    ]
  """