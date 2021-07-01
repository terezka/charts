module Examples.Frame.Margin exposing (..)


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
    , CA.marginBottom 30
    , CA.marginTop 20
    , CA.marginLeft 30
    , CA.marginRight 20
    , CA.htmlAttrs
        [ HA.style "border" "1px solid darkgray" ]
    ]
    [ C.grid []
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
  , name = "Margin"
  , description = "Add margin to frame."
  , order = 17
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
    , CA.marginBottom 30
    , CA.marginTop 20
    , CA.marginLeft 30
    , CA.marginRight 20
    , CA.htmlAttrs
        [ HA.style "border" "1px solid darkgray" ]
    ]
    [ C.grid []
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
    , CA.marginBottom 30
    , CA.marginTop 20
    , CA.marginLeft 30
    , CA.marginRight 20
    , CA.htmlAttrs
        [ HA.style "border" "1px solid darkgray" ]
    ]
    [ C.grid []
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