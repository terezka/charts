module Examples.Frame.Background exposing (..)


-- THIS IS A GENERATED MODULE!

import Html as H
import Html.Attributes as HA
import Svg as S
import Chart as C
import Chart.Attributes as CA


view : Model -> H.Html Msg
view model =
  C.chart
    [ CA.height 300
    , CA.width 300
    , CA.margin { top = 20, bottom = 30, left = 30, right = 20 }
    , CA.htmlAttrs
        [ HA.style "background" "#fcf9e9" ]
    ]
    [ C.grid [ CA.color "white" ]
    , C.xAxis []
    , C.yAxis []
    , C.series .x
        [ C.interpolated .y [  ] [] ]
        [ { x = 0, y = 0 }
        , { x = 10, y = 10 }
        ]
    , C.xLabels []
    , C.yLabels []
    ]


meta =
  { category = "Navigation"
  , categoryOrder = 4
  , name = "Background"
  , description = "Color the frame."
  , order = 18
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
    , CA.margin { top = 20, bottom = 30, left = 30, right = 20 }
    , CA.htmlAttrs
        [ HA.style "background" "#fcf9e9" ]
    ]
    [ C.grid [ CA.color "white" ]
    , C.xAxis []
    , C.yAxis []
    , C.series .x
        [ C.interpolated .y [  ] [] ]
        [ { x = 0, y = 0 }
        , { x = 10, y = 10 }
        ]
    , C.xLabels []
    , C.yLabels []
    ]
  """


largeCode : String
largeCode =
  """
import Html as H
import Html.Attributes as HA
import Svg as S
import Chart as C
import Chart.Attributes as CA


view : Model -> H.Html Msg
view model =
  C.chart
    [ CA.height 300
    , CA.width 300
    , CA.margin { top = 20, bottom = 30, left = 30, right = 20 }
    , CA.htmlAttrs
        [ HA.style "background" "#fcf9e9" ]
    ]
    [ C.grid [ CA.color "white" ]
    , C.xAxis []
    , C.yAxis []
    , C.series .x
        [ C.interpolated .y [  ] [] ]
        [ { x = 0, y = 0 }
        , { x = 10, y = 10 }
        ]
    , C.xLabels []
    , C.yLabels []
    ]
  """