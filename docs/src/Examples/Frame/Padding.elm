module Examples.Frame.Padding exposing (..)


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
    , CA.padding { top = 20, bottom = 20, left = 20, right = 20 }
    ]
    [ C.grid []
    , C.xAxis []
    , C.yAxis []
    , C.series .x
        [ C.interpolated .y [  ] [] ]
        [ { x = 0, y = 0 }
        , { x = 10, y = 10 }
        ]
    , C.xLabels [ CA.pinned .min ]
    , C.yLabels [ CA.pinned .min ]
    ]


meta =
  { category = "Navigation"
  , categoryOrder = 4
  , name = "Padding"
  , description = "Add padding to frame."
  , order = 16
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
    , CA.padding { top = 20, bottom = 20, left = 20, right = 20 }
    ]
    [ C.grid []
    , C.xAxis []
    , C.yAxis []
    , C.series .x
        [ C.interpolated .y [  ] [] ]
        [ { x = 0, y = 0 }
        , { x = 10, y = 10 }
        ]
    , C.xLabels [ CA.pinned .min ]
    , C.yLabels [ CA.pinned .min ]
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
    , CA.padding { top = 20, bottom = 20, left = 20, right = 20 }
    ]
    [ C.grid []
    , C.xAxis []
    , C.yAxis []
    , C.series .x
        [ C.interpolated .y [  ] [] ]
        [ { x = 0, y = 0 }
        , { x = 10, y = 10 }
        ]
    , C.xLabels [ CA.pinned .min ]
    , C.yLabels [ CA.pinned .min ]
    ]
  """