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
          { model | moving = Just <| Debug.log "moving" ( start, coords ) }

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

    OnDoubleClick coords ->
      { model
      | percentage = model.percentage + 20
      , center = coords
      , offset = { x = 0, y = 0 }
      }

    OnZoomIn ->
      { model | percentage = model.percentage + 20 }

    OnZoomOut ->
      { model | percentage = model.percentage - 20 }

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
    , CA.padding { top = -yOff, bottom = yOff, left = -xOff, right = xOff }
    , CA.range [ CA.zoom model.percentage, CA.move model.center.x ]
    , CA.domain [ CA.zoom model.percentage, CA.move model.center.y ]

    , CE.onMouseDown OnMouseDown CE.getSvgCoords
    , CE.onMouseMove OnMouseMove CE.getSvgCoords
    , CE.onMouseUp OnMouseUp CE.getSvgCoords
    , CE.onDoubleClick OnDoubleClick CE.getCoords

    , CA.htmlAttrs
        [ HA.style "user-select" "none"
        , HA.style "cursor" <|
            case model.moving of
              Just _ -> "grabbing"
              Nothing -> "grab"
        ]
    ]
    [ C.xLabels [ CA.withGrid, CA.amount 10, CA.ints ]
    , C.yLabels [ CA.withGrid, CA.amount 10, CA.ints ]
    , C.xTicks [ CA.amount 10, CA.ints ]
    , C.yTicks [ CA.amount 10, CA.ints ]

    , C.series .x
        [ C.scatter .y [ CA.size 10 ] ]
        [ { x = -100, y = -100 }
        , { x = -40, y = -30 }
        , { x = 20, y = 80 }
        , { x = 40, y = 50 }
        , { x = 0, y = 0 }
        , { x = 20, y = 80 }
        , { x = 40, y = 50 }
        , { x = 80, y = 20 }
        , { x = 100, y = 100 }
        ]

    , C.withPlane <| \p ->
        [ C.line [ CA.color "red", CA.y1 (CA.middle p.y) ]
        , C.line [ CA.color "red", CA.x1 (CA.middle p.x) ]
        ]

    , C.htmlAt .max .max 0 0
        [ HA.style "transform" "translateX(-100%)" ]
        [ H.button [ HE.onClick OnZoomIn ] [ H.text "+" ]
        , H.button [ HE.onClick OnZoomOut ] [ H.text "-" ]
        , H.button [ HE.onClick OnZoomReset ] [ H.text "⨯" ]
        ]
    ]
{-| @SMALL END -}
{-| @LARGE END -}


meta =
  { category = "Interactivity"
  , categoryOrder = 5
  , name = "Traditional zoom"
  , description = "Add zoom effect."
  , order = 21
  }

