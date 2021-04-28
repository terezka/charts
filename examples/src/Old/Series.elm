module Series exposing (..)

import Svg exposing (Svg, svg, g, text_, text)
import Svg.Events
import Svg.Attributes exposing (width, height, stroke, fill, r, transform, style)
import Svg.Coordinates exposing (..)
import Svg.Chart exposing (..)
import Html
import Html.Attributes
import Internal.Colors exposing (..)
import Browser


main =
  Browser.sandbox
    { init = Nothing
    , update = \msg model -> msg
    , view = view
    }


planeFromPoints : List Point -> Plane
planeFromPoints points =
  { x =
    { marginLower = 15
    , marginUpper = 10
    , length = 300
    , min = minimum [.x] points
    , max = maximum [.x] points
    }
  , y =
    { marginUpper = 10
    , marginLower = 20
    , length = 300
    , min = minimum [.y] points
    , max = maximum [.y] points
    }
  }


type alias Point =
  { x : Float
  , y : Float
  }


data1 : List Point
data1 =
  [ { x = -2, y = 5 }
  , { x = 1, y = 1.5 }
  , { x = 3, y = 5 }
  ]


data2 : List Point
data2 =
  [ { x = -4, y = 4 }
  , { x = -2, y = 3 }
  , { x = 4, y = -4 }
  , { x = 6, y = 4 }
  , { x = 8, y = 3 }
  , { x = 10, y = -4 }
  ]


data3 : List Point
data3 =
  [ { x = 1.0, y = 2 }
  , { x = 1.2, y = 1 }
  , { x = 1.8, y = 6 }
  ]


view : Maybe Point -> Svg (Maybe Point)
view model =
  let plane =
        planeFromPoints (data1 ++ data2 ++ data3)

      dataPoints =
        toDataPoints .x .y (data1 ++ data2 ++ data3)
  in
  Html.div
    [ Html.Attributes.style "padding" "100px" ]
    [ container plane []
        [ svg
          [ responsive plane
          ]
          [ linearArea plane .x .y [ stroke "transparent", fill blueFill ] (\_ -> clear) data1
          , linear plane .x .y [ stroke blueStroke ] (\_ -> clear) data1
          , monotone plane .x .y [ stroke pinkStroke ] (\_ -> aura 3 6 0.3 diamond pinkStroke) data2
          , scatter plane .x .y (\_ -> full 5 triangle blueStroke) data3
          , xAxis plane [] 0
          , yAxis plane [] 0
          , xTicks plane 5 [] 0 [ 1, 2, 3, 4, 5 ]
          , yTicks plane 5 [] 0 [ 1, 2, 3, 4, 5, 6 ]
          , xLabels plane (xLabel [] identity String.fromFloat) 0 [ 1, 2, 3, 4, 5, 10 ]
          , yLabels plane (yLabel [] identity String.fromFloat) 0 [ 1, 2, 3, 4, 5, 6 ]
          , eventCatcher plane [ Svg.Events.on "mousemove" (decodePoint plane (getNearest dataPoints)) ]
          ]
        , positionHtml plane 4 6 0 0
            [ Html.Attributes.style "color" "#fc00ff"
            , Html.Attributes.style "background" "#ffffff"
            , Html.Attributes.style "border" "1px solid gray"
            , Html.Attributes.style "padding" "2px 5px"
            , Html.Attributes.style "font-size" "10px"
            ]
            [ Html.text "Arbitrary HTML at (4, 6)!" ]
        , case model of
            Just point ->
              tooltip plane point.x point.y []
                [ Html.text (String.fromFloat point.x ++ ", " ++ String.fromFloat point.y) ]

            Nothing ->
              Html.text ""
        ]
    ]

