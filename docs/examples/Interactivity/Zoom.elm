module Examples.Interactivity.Zoom exposing (..)

{-| @LARGE -}
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Svg as S
import Chart as C
import Chart.Attributes as CA
import Chart.Events as CE


type Model
  = NoZoom
  | ZoomStart CE.Point
  | ZoomProgress CE.Point CE.Point
  | ZoomDone CE.Point CE.Point



init : Model
init =
  NoZoom


type Msg
  = OnDown CE.Point
  | OnMove CE.Point
  | OnUp CE.Point
  | OnReset


update : Msg -> Model -> Model
update msg model =
  case msg of
    OnDown coords ->
      case model of
        NoZoom -> ZoomStart coords
        _ -> model

    OnMove coords ->
      case model of
        ZoomStart start ->
          ZoomProgress start coords

        ZoomProgress start _ ->
          ZoomProgress start coords

        _ ->
          model

    OnUp coords ->
      case model of
        ZoomProgress start _ ->
          ZoomDone
            { x = min start.x coords.x, y = min start.y coords.y }
            { x = max start.x coords.x, y = max start.y coords.y }

        _ ->
          model

    OnReset ->
      NoZoom


view : Model -> H.Html Msg
view model =
{-| @SMALL -}
  C.chart
    [ CA.height 300
    , CA.width 300
    , CA.static
    , CA.htmlAttrs [ HA.style "cursor" "crosshair" ]

    , CE.onMouseDown OnDown CE.getCoords
    , CE.onMouseMove OnMove CE.getCoords
    , CE.onMouseUp OnUp CE.getCoords

    , case model of
        ZoomDone start end ->
          CA.range
            [ CA.lowest start.x CA.exactly
            , CA.highest end.x CA.exactly
            ]

        _ ->
          CA.range []

    , case model of
        ZoomDone start end ->
          CA.domain
            [ CA.lowest start.y CA.exactly
            , CA.highest end.y CA.exactly
            ]

        _ ->
          CA.range []
    ]
    [ C.grid []
    , C.xLabels []
    , C.yLabels []

    , C.series .x
        [ C.property .y [ CA.monotone ] [ CA.circle ]
        , C.property .z [ CA.monotone ] [ CA.circle ]
        , C.property .v [ CA.monotone ] [ CA.circle ]
        , C.property .w [ CA.monotone ] [ CA.circle ]
        , C.property .p [ CA.monotone ] [ CA.circle ]
        , C.property .q [ CA.monotone ] [ CA.circle ]
        ]
        data

    , case model of
        NoZoom ->
          C.none

        ZoomStart start ->
          C.none

        ZoomProgress start end ->
          C.rect
            [ CA.x1 start.x
            , CA.x2 end.x
            , CA.y1 start.y
            , CA.y2 end.y
            ]

        ZoomDone start end ->
          C.htmlAt .max .max -10 -10
            [ HA.style "transform" "translateX(-100%)"
            ]
            [ H.button
                [ HE.onClick OnReset
                , HA.style "border" "1px solid black"
                , HA.style "padding" "2px 10px"
                , HA.style "background" "white"
                , HA.style "font-size" "14px"
                ]
                [ H.text "Reset" ]
            ]
    ]
{-| @SMALL END -}
{-| @LARGE END -}


meta =
  { category = "Interactivity"
  , categoryOrder = 5
  , name = "Zoom"
  , description = "Add zoom effect."
  , order = 17
  }



type alias Datum =
  { x : Float
  , x1 : Float
  , x2 : Float
  , y : Maybe Float
  , z : Maybe Float
  , v : Maybe Float
  , w : Maybe Float
  , p : Maybe Float
  , q : Maybe Float
  }


data : List Datum
data =
  let toDatum x x1 y z v w p q =
        Datum x x1 (x1 + 1) (Just y) (Just z) (Just v) (Just w) (Just p) (Just q)
  in
  [ toDatum 0.0 0.0 1.2 4.0 4.6 6.9 7.3 8.0
  , toDatum 2.0 1.0 2.2 4.2 5.3 5.7 6.2 7.8
  , toDatum 3.0 2.0 1.0 3.2 4.8 5.4 7.2 8.3
  , toDatum 4.0 3.0 1.2 3.0 4.1 5.5 7.9 8.1
  ]

