module Examples.Interactivity.ZoomAlt exposing (..)


-- THIS IS A GENERATED MODULE!

import Html as H exposing (Html)
import Html.Attributes as HA
import Html.Events as HE
import Svg as S
import Svg.Attributes as SA

import Chart as C
import Chart.Attributes as CA
import Chart.Events as CE
import Chart.Item as CI
import Chart.Svg as CS



type alias Model =
  { movingOffset : Maybe CS.Point
  , center : CS.Point
  , offset : CS.Point
  , percentage : Float
  }


init : Model
init =
  { movingOffset = Nothing
  , center = { x = 0, y = 0 }
  , offset = { x = 0, y = 0 }
  , percentage = 100
  }


type Msg
  = OnMouseMove CS.Point
  | OnMouseDown CS.Point
  | OnMouseUp CS.Point CS.Point
  | OnMouseLeave
  | OnZoomIn
  | OnZoomOut
  | OnZoomReset


update : Msg -> Model -> Model
update msg model =
  case msg of
    OnMouseDown off ->
      { model | movingOffset = Just off }

    OnMouseMove off ->
      case model.movingOffset of
        Just start ->
          { model | offset = { x = start.x - off.x, y = start.y - off.y } }

        Nothing ->
          model

    OnMouseUp off coord ->
      case model.movingOffset of
        Just start ->
          if start == off then
            { model | center = coord, movingOffset = Nothing }
          else
            { model | center =
                { x = model.center.x + start.x - off.x
                , y = model.center.y + start.y - off.y
                }
            , offset = { x = 0, y = 0 }
            , movingOffset = Nothing
            }

        Nothing ->
          { model | center = off, offset = { x = 0, y = 0 } }

    OnMouseLeave ->
      { model | movingOffset = Nothing
      , center =
          { x = model.center.x + model.offset.x
          , y = model.center.y + model.offset.y
          }
      , offset = { x = 0, y = 0 }
      }

    OnZoomIn ->
      { model | percentage = model.percentage + 20 }

    OnZoomOut ->
      { model | percentage = max 1 (model.percentage - 20) }

    OnZoomReset ->
      { model | percentage = 100, center = { x = 0, y = 0 }, offset = { x = 0, y = 0 } }


view : Model -> Html Msg
view model =
  C.chart
    [ CA.height 300
    , CA.width 300
    , CA.range [ CA.zoom model.percentage, CA.centerAt model.center.x, CA.move model.offset.x ]
    , CA.domain [ CA.zoom model.percentage, CA.centerAt model.center.y, CA.move model.offset.y ]

    , CE.onMouseDown OnMouseDown CE.getOffset
    , CE.onMouseMove OnMouseMove CE.getOffset
    , CE.on "mouseup" (CE.map2 OnMouseUp CE.getOffset CE.getCoords)
    , CE.onMouseLeave OnMouseLeave

    , CA.htmlAttrs
        [ HA.style "user-select" "none"
        --, HA.style "cursor" <|
        --    case model.moving of
        --      Just _ -> "grabbing"
        --      Nothing -> "grab"
        ]
    ]
    [ C.xLabels [ CA.withGrid, CA.amount 10, CA.ints, CA.fontSize 9 ]
    , C.yLabels [ CA.withGrid, CA.amount 10, CA.ints, CA.fontSize 9 ]
    , C.xTicks [ CA.amount 10, CA.ints ]
    , C.yTicks [ CA.amount 10, CA.ints ]

    , C.series .x
        [ C.scatter .y [ CA.opacity 0.2, CA.borderWidth 1 ]
            |> C.variation (\_ d -> [ CA.size (d.s * model.percentage / 100) ])
        ]
        [ { x = -100, y = -100, s = 40 }
        , { x = -80, y = -30, s = 30 }
        , { x = -60, y = 80, s = 60 }
        , { x = -50, y = 50, s = 70 }
        , { x = 20, y = 80, s = 40 }
        , { x = 30, y = -20, s = 60 }
        , { x = 40, y = 50, s = 80 }
        , { x = 80, y = 20, s = 50 }
        , { x = 100, y = 100, s = 40 }
        ]

    , C.withPlane <| \p ->
        [ C.line [ CA.color CA.darkGray, CA.dashed [ 6, 6 ], CA.y1 (CA.middle p.y) ]
        , C.line [ CA.color CA.darkGray, CA.dashed [ 6, 6 ], CA.x1 (CA.middle p.x) ]
        ]

    , C.htmlAt .max .max 0 0
        [ HA.style "transform" "translateX(-100%)" ]
        [ H.button [ HE.onClick OnZoomIn, HA.style "margin-right" "5px" ] [ H.text "+" ]
        , H.button [ HE.onClick OnZoomOut, HA.style "margin-right" "5px" ] [ H.text "-" ]
        , H.button [ HE.onClick OnZoomReset ] [ H.text "⨯" ]
        ]
    ]


meta =
  { category = "Interactivity"
  , categoryOrder = 5
  , name = "Zoom"
  , description = "Add zoom effect."
  , order = 20
  }



smallCode : String
smallCode =
  """
type alias Model =
  { movingOffset : Maybe CS.Point
  , center : CS.Point
  , offset : CS.Point
  , percentage : Float
  }


init : Model
init =
  { movingOffset = Nothing
  , center = { x = 0, y = 0 }
  , offset = { x = 0, y = 0 }
  , percentage = 100
  }


type Msg
  = OnMouseMove CS.Point
  | OnMouseDown CS.Point
  | OnMouseUp CS.Point CS.Point
  | OnMouseLeave
  | OnZoomIn
  | OnZoomOut
  | OnZoomReset


update : Msg -> Model -> Model
update msg model =
  case msg of
    OnMouseDown off ->
      { model | movingOffset = Just off }

    OnMouseMove off ->
      case model.movingOffset of
        Just start ->
          { model | offset = { x = start.x - off.x, y = start.y - off.y } }

        Nothing ->
          model

    OnMouseUp off coord ->
      case model.movingOffset of
        Just start ->
          if start == off then
            { model | center = coord, movingOffset = Nothing }
          else
            { model | center =
                { x = model.center.x + start.x - off.x
                , y = model.center.y + start.y - off.y
                }
            , offset = { x = 0, y = 0 }
            , movingOffset = Nothing
            }

        Nothing ->
          { model | center = off, offset = { x = 0, y = 0 } }

    OnMouseLeave ->
      { model | movingOffset = Nothing
      , center =
          { x = model.center.x + model.offset.x
          , y = model.center.y + model.offset.y
          }
      , offset = { x = 0, y = 0 }
      }

    OnZoomIn ->
      { model | percentage = model.percentage + 20 }

    OnZoomOut ->
      { model | percentage = max 1 (model.percentage - 20) }

    OnZoomReset ->
      { model | percentage = 100, center = { x = 0, y = 0 }, offset = { x = 0, y = 0 } }


view : Model -> Html Msg
view model =
  C.chart
    [ CA.height 300
    , CA.width 300
    , CA.range [ CA.zoom model.percentage, CA.centerAt model.center.x, CA.move model.offset.x ]
    , CA.domain [ CA.zoom model.percentage, CA.centerAt model.center.y, CA.move model.offset.y ]

    , CE.onMouseDown OnMouseDown CE.getOffset
    , CE.onMouseMove OnMouseMove CE.getOffset
    , CE.on "mouseup" (CE.map2 OnMouseUp CE.getOffset CE.getCoords)
    , CE.onMouseLeave OnMouseLeave

    , CA.htmlAttrs
        [ HA.style "user-select" "none"
        --, HA.style "cursor" <|
        --    case model.moving of
        --      Just _ -> "grabbing"
        --      Nothing -> "grab"
        ]
    ]
    [ C.xLabels [ CA.withGrid, CA.amount 10, CA.ints, CA.fontSize 9 ]
    , C.yLabels [ CA.withGrid, CA.amount 10, CA.ints, CA.fontSize 9 ]
    , C.xTicks [ CA.amount 10, CA.ints ]
    , C.yTicks [ CA.amount 10, CA.ints ]

    , C.series .x
        [ C.scatter .y [ CA.opacity 0.2, CA.borderWidth 1 ]
            |> C.variation (\\_ d -> [ CA.size (d.s * model.percentage / 100) ])
        ]
        [ { x = -100, y = -100, s = 40 }
        , { x = -80, y = -30, s = 30 }
        , { x = -60, y = 80, s = 60 }
        , { x = -50, y = 50, s = 70 }
        , { x = 20, y = 80, s = 40 }
        , { x = 30, y = -20, s = 60 }
        , { x = 40, y = 50, s = 80 }
        , { x = 80, y = 20, s = 50 }
        , { x = 100, y = 100, s = 40 }
        ]

    , C.withPlane <| \\p ->
        [ C.line [ CA.color CA.darkGray, CA.dashed [ 6, 6 ], CA.y1 (CA.middle p.y) ]
        , C.line [ CA.color CA.darkGray, CA.dashed [ 6, 6 ], CA.x1 (CA.middle p.x) ]
        ]

    , C.htmlAt .max .max 0 0
        [ HA.style "transform" "translateX(-100%)" ]
        [ H.button [ HE.onClick OnZoomIn, HA.style "margin-right" "5px" ] [ H.text "+" ]
        , H.button [ HE.onClick OnZoomOut, HA.style "margin-right" "5px" ] [ H.text "-" ]
        , H.button [ HE.onClick OnZoomReset ] [ H.text "⨯" ]
        ]
    ]
  """


largeCode : String
largeCode =
  """
import Html as H exposing (Html)
import Html.Attributes as HA
import Html.Events as HE
import Svg as S
import Svg.Attributes as SA

import Chart as C
import Chart.Attributes as CA
import Chart.Events as CE
import Chart.Item as CI
import Chart.Svg as CS



type alias Model =
  { movingOffset : Maybe CS.Point
  , center : CS.Point
  , offset : CS.Point
  , percentage : Float
  }


init : Model
init =
  { movingOffset = Nothing
  , center = { x = 0, y = 0 }
  , offset = { x = 0, y = 0 }
  , percentage = 100
  }


type Msg
  = OnMouseMove CS.Point
  | OnMouseDown CS.Point
  | OnMouseUp CS.Point CS.Point
  | OnMouseLeave
  | OnZoomIn
  | OnZoomOut
  | OnZoomReset


update : Msg -> Model -> Model
update msg model =
  case msg of
    OnMouseDown off ->
      { model | movingOffset = Just off }

    OnMouseMove off ->
      case model.movingOffset of
        Just start ->
          { model | offset = { x = start.x - off.x, y = start.y - off.y } }

        Nothing ->
          model

    OnMouseUp off coord ->
      case model.movingOffset of
        Just start ->
          if start == off then
            { model | center = coord, movingOffset = Nothing }
          else
            { model | center =
                { x = model.center.x + start.x - off.x
                , y = model.center.y + start.y - off.y
                }
            , offset = { x = 0, y = 0 }
            , movingOffset = Nothing
            }

        Nothing ->
          { model | center = off, offset = { x = 0, y = 0 } }

    OnMouseLeave ->
      { model | movingOffset = Nothing
      , center =
          { x = model.center.x + model.offset.x
          , y = model.center.y + model.offset.y
          }
      , offset = { x = 0, y = 0 }
      }

    OnZoomIn ->
      { model | percentage = model.percentage + 20 }

    OnZoomOut ->
      { model | percentage = max 1 (model.percentage - 20) }

    OnZoomReset ->
      { model | percentage = 100, center = { x = 0, y = 0 }, offset = { x = 0, y = 0 } }


view : Model -> Html Msg
view model =
  C.chart
    [ CA.height 300
    , CA.width 300
    , CA.range [ CA.zoom model.percentage, CA.centerAt model.center.x, CA.move model.offset.x ]
    , CA.domain [ CA.zoom model.percentage, CA.centerAt model.center.y, CA.move model.offset.y ]

    , CE.onMouseDown OnMouseDown CE.getOffset
    , CE.onMouseMove OnMouseMove CE.getOffset
    , CE.on "mouseup" (CE.map2 OnMouseUp CE.getOffset CE.getCoords)
    , CE.onMouseLeave OnMouseLeave

    , CA.htmlAttrs
        [ HA.style "user-select" "none"
        --, HA.style "cursor" <|
        --    case model.moving of
        --      Just _ -> "grabbing"
        --      Nothing -> "grab"
        ]
    ]
    [ C.xLabels [ CA.withGrid, CA.amount 10, CA.ints, CA.fontSize 9 ]
    , C.yLabels [ CA.withGrid, CA.amount 10, CA.ints, CA.fontSize 9 ]
    , C.xTicks [ CA.amount 10, CA.ints ]
    , C.yTicks [ CA.amount 10, CA.ints ]

    , C.series .x
        [ C.scatter .y [ CA.opacity 0.2, CA.borderWidth 1 ]
            |> C.variation (\\_ d -> [ CA.size (d.s * model.percentage / 100) ])
        ]
        [ { x = -100, y = -100, s = 40 }
        , { x = -80, y = -30, s = 30 }
        , { x = -60, y = 80, s = 60 }
        , { x = -50, y = 50, s = 70 }
        , { x = 20, y = 80, s = 40 }
        , { x = 30, y = -20, s = 60 }
        , { x = 40, y = 50, s = 80 }
        , { x = 80, y = 20, s = 50 }
        , { x = 100, y = 100, s = 40 }
        ]

    , C.withPlane <| \\p ->
        [ C.line [ CA.color CA.darkGray, CA.dashed [ 6, 6 ], CA.y1 (CA.middle p.y) ]
        , C.line [ CA.color CA.darkGray, CA.dashed [ 6, 6 ], CA.x1 (CA.middle p.x) ]
        ]

    , C.htmlAt .max .max 0 0
        [ HA.style "transform" "translateX(-100%)" ]
        [ H.button [ HE.onClick OnZoomIn, HA.style "margin-right" "5px" ] [ H.text "+" ]
        , H.button [ HE.onClick OnZoomOut, HA.style "margin-right" "5px" ] [ H.text "-" ]
        , H.button [ HE.onClick OnZoomReset ] [ H.text "⨯" ]
        ]
    ]
  """