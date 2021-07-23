module Examples.Interactivity.ZoomAlt exposing (..)

{-| @LARGE -}
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



{-| @SMALL -}
type alias Model =
  { moving : Maybe ( CS.Point, CS.Point )
  , offset : CS.Point
  , center : CS.Point
  , percentage : Float
  }


init : Model
init =
  { moving = Nothing
  , offset = { x = 0, y = 0 }
  , center = { x = 0, y = 0 }
  , percentage = 100
  }


type Msg
  = OnMouseMove CS.Point
  | OnMouseDown CS.Point
  | OnMouseUp CS.Point
  | OnMouseLeave
  | OnDoubleClick CS.Point
  | OnZoomIn
  | OnZoomOut
  | OnZoomReset


update : Msg -> Model -> Model
update msg model =
  case msg of
    OnMouseDown coords ->
      { model | moving = Just ( coords, coords ) }

    OnMouseMove coords ->
      case model.moving of
        Nothing ->
          model

        Just ( start, _ ) ->
          { model | moving = Just ( start, coords ) }

    OnMouseUp coords ->
      case model.moving of
        Nothing ->
          model

        Just ( start, _ ) ->
          { model | moving = Nothing, offset =
              { x = model.offset.x + start.x - coords.x
              , y = model.offset.y + start.y - coords.y
              }
          }

    OnMouseLeave ->
      case model.moving of
        Nothing ->
          model

        Just ( start, coords ) ->
          { model | moving = Nothing, offset =
              { x = model.offset.x + start.x - coords.x
              , y = model.offset.y + start.y - coords.y
              }
          }

    OnDoubleClick coords ->
      { model
      | percentage = model.percentage + 20
      , center = coords
      , offset = { x = 0, y = 0 }
      }

    OnZoomIn ->
      { model | percentage = model.percentage + 20 }

    OnZoomOut ->
      { model | percentage = max 1 (model.percentage - 20) }

    OnZoomReset ->
      { model | percentage = 100, offset = { x = 0, y = 0 }, center = { x = 0, y = 0 } }


view : Model -> Html Msg
view model =
  let ( xOff, yOff ) =
        case model.moving of
          Just ( a, b ) ->
            ( model.offset.x + a.x - b.x
            , model.offset.y + a.y - b.y
            )

          Nothing ->
            ( model.offset.x
            , model.offset.y
            )
  in
  C.chart
    [ CA.height 300
    , CA.width 300
    , CA.range [ CA.zoom model.percentage, CA.move model.center.x, CA.pad -xOff xOff ]
    , CA.domain [ CA.zoom model.percentage, CA.move model.center.y, CA.pad yOff -yOff ]

    , CE.onMouseDown OnMouseDown CE.getSvgCoords
    , CE.onMouseMove OnMouseMove CE.getSvgCoords
    , CE.onMouseUp OnMouseUp CE.getSvgCoords
    , CE.onMouseLeave OnMouseLeave
    , CE.onDoubleClick OnDoubleClick CE.getCoords

    , CA.htmlAttrs
        [ HA.style "user-select" "none"
        , HA.style "cursor" <|
            case model.moving of
              Just _ -> "grabbing"
              Nothing -> "grab"
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
{-| @SMALL END -}
{-| @LARGE END -}


meta =
  { category = "Interactivity"
  , categoryOrder = 5
  , name = "Zoom"
  , description = "Add zoom effect."
  , order = 20
  }

