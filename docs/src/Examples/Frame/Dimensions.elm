module Examples.Frame.Dimensions exposing (..)


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
        [ CA.lowest 5 CA.orLower
        , CA.highest 90 CA.orHigher
        ]
    , CA.domain
        [ CA.lowest 5 CA.orLower
        , CA.highest 100 CA.orHigher
        ]
    ]
    [ C.grid []
    , C.series .x
        [ C.interpolated .y [  ] [] ]
        [ { x = 10, y = 20 }
        , { x = 80, y = 80 }
        ]
    , C.xLabels [ CA.amount 10 ]
    , C.yLabels [ CA.amount 10 ]
    ]


meta =
  { category = "Navigation"
  , categoryOrder = 4
  , name = "Control dimensions"
  , description = "Limit or extend your range and domain."
  , order = 11
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
        [ CA.lowest 5 CA.orLower
        , CA.highest 90 CA.orHigher
        ]
    , CA.domain
        [ CA.lowest 5 CA.orLower
        , CA.highest 100 CA.orHigher
        ]
    ]
    [ C.grid []
    , C.series .x
        [ C.interpolated .y [  ] [] ]
        [ { x = 10, y = 20 }
        , { x = 80, y = 80 }
        ]
    , C.xLabels [ CA.amount 10 ]
    , C.yLabels [ CA.amount 10 ]
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
        [ CA.lowest 5 CA.orLower
        , CA.highest 90 CA.orHigher
        ]
    , CA.domain
        [ CA.lowest 5 CA.orLower
        , CA.highest 100 CA.orHigher
        ]
    ]
    [ C.grid []
    , C.series .x
        [ C.interpolated .y [  ] [] ]
        [ { x = 10, y = 20 }
        , { x = 80, y = 80 }
        ]
    , C.xLabels [ CA.amount 10 ]
    , C.yLabels [ CA.amount 10 ]
    ]
  """