module Examples.Interactivity.Zoom exposing (..)


-- THIS IS A GENERATED MODULE!

import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Svg as S
import Chart as C
import Chart.Attributes as CA
import Chart.Events as CE


type Model
  = NoZoom
  | Zooming CE.Point CE.Point
  | ReZooming CE.Point CE.Point CE.Point CE.Point
  | Zoomed CE.Point CE.Point


getNewSelection : Model -> Maybe ( CE.Point, CE.Point )
getNewSelection model =
  case model of
    NoZoom -> Nothing
    Zooming start end -> Just ( start, end )
    ReZooming _ _ start end -> Just ( start, end )
    Zoomed _ _ -> Nothing


getCurrentWindow : Model -> Maybe ( CE.Point, CE.Point )
getCurrentWindow model =
  case model of
    NoZoom -> Nothing
    Zooming _ _ -> Nothing
    ReZooming start end _ _ -> Just ( start, end )
    Zoomed start end -> Just ( start, end )



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
    OnDown point ->
      case model of
        NoZoom ->
          Zooming point point

        Zoomed start end ->
          ReZooming start end point point

        _ -> model

    OnMove point ->
      case model of
        Zooming start _ ->
          Zooming start point

        ReZooming startOld endOld start _ ->
          ReZooming startOld endOld start point

        _ ->
          model

    OnUp point ->
      case model of
        Zooming start _ ->
          Zoomed
            { x = min start.x point.x, y = min start.y point.y }
            { x = max start.x point.x, y = max start.y point.y }

        ReZooming _ _ start _ ->
          Zoomed
            { x = min start.x point.x, y = min start.y point.y }
            { x = max start.x point.x, y = max start.y point.y }

        _ ->
          model

    OnReset ->
      NoZoom


view : Model -> H.Html Msg
view model =
  C.chart
    [ CA.height 300
    , CA.width 300
    , CA.static
    , CA.htmlAttrs [ HA.style "cursor" "crosshair" ]

    , CE.onMouseDown OnDown CE.getCoords
    , CE.onMouseMove OnMove CE.getCoords
    , CE.onMouseUp OnUp CE.getCoords

    , case getCurrentWindow model of
        Just ( start, end ) ->
          CA.range
            [ CA.lowest start.x CA.exactly
            , CA.highest end.x CA.exactly
            ]

        Nothing ->
          CA.range []

    , case getCurrentWindow model of
        Just ( start, end ) ->
          CA.domain
            [ CA.lowest start.y CA.exactly
            , CA.highest end.y CA.exactly
            ]

        Nothing ->
          CA.range []
    ]
    [ C.grid []
    , C.xLabels []
    , C.yLabels []

    , C.series .x
        [ C.property .y [ CA.monotone ] [ CA.circle, CA.color "white", CA.borderWidth 1 ]
        , C.property .z [ CA.monotone ] [ CA.circle, CA.color "white", CA.borderWidth 1 ]
        , C.property .v [ CA.monotone ] [ CA.circle, CA.color "white", CA.borderWidth 1 ]
        , C.property .w [ CA.monotone ] [ CA.circle, CA.color "white", CA.borderWidth 1 ]
        , C.property .p [ CA.monotone ] [ CA.circle, CA.color "white", CA.borderWidth 1 ]
        , C.property .q [ CA.monotone ] [ CA.circle, CA.color "white", CA.borderWidth 1 ]
        ]
        data

    , case getNewSelection model of
        Just ( start, end ) ->
          C.rect
            [ CA.x1 start.x
            , CA.x2 end.x
            , CA.y1 start.y
            , CA.y2 end.y
            ]

        Nothing ->
          C.none

    , case getCurrentWindow model of
        Just ( start, end ) ->
          C.htmlAt .max .max -10 -10
            [ HA.style "transform" "translateX(-100%)"
            ]
            [ H.button
                [ HE.onClick OnReset
                , HA.style "border" "1px solid black"
                , HA.style "border-radius" "5px"
                , HA.style "padding" "2px 10px"
                , HA.style "background" "white"
                , HA.style "font-size" "14px"
                ]
                [ H.text "Reset" ]
            ]

        Nothing ->
          C.none
    ]


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



smallCode : String
smallCode =
  """
  C.chart
    [ CA.height 300
    , CA.width 300
    , CA.static
    , CA.htmlAttrs [ HA.style "cursor" "crosshair" ]

    , CE.onMouseDown OnDown CE.getCoords
    , CE.onMouseMove OnMove CE.getCoords
    , CE.onMouseUp OnUp CE.getCoords

    , case getCurrentWindow model of
        Just ( start, end ) ->
          CA.range
            [ CA.lowest start.x CA.exactly
            , CA.highest end.x CA.exactly
            ]

        Nothing ->
          CA.range []

    , case getCurrentWindow model of
        Just ( start, end ) ->
          CA.domain
            [ CA.lowest start.y CA.exactly
            , CA.highest end.y CA.exactly
            ]

        Nothing ->
          CA.range []
    ]
    [ C.grid []
    , C.xLabels []
    , C.yLabels []

    , C.series .x
        [ C.property .y [ CA.monotone ] [ CA.circle, CA.color "white", CA.borderWidth 1 ]
        , C.property .z [ CA.monotone ] [ CA.circle, CA.color "white", CA.borderWidth 1 ]
        , C.property .v [ CA.monotone ] [ CA.circle, CA.color "white", CA.borderWidth 1 ]
        , C.property .w [ CA.monotone ] [ CA.circle, CA.color "white", CA.borderWidth 1 ]
        , C.property .p [ CA.monotone ] [ CA.circle, CA.color "white", CA.borderWidth 1 ]
        , C.property .q [ CA.monotone ] [ CA.circle, CA.color "white", CA.borderWidth 1 ]
        ]
        data

    , case getNewSelection model of
        Just ( start, end ) ->
          C.rect
            [ CA.x1 start.x
            , CA.x2 end.x
            , CA.y1 start.y
            , CA.y2 end.y
            ]

        Nothing ->
          C.none

    , case getCurrentWindow model of
        Just ( start, end ) ->
          C.htmlAt .max .max -10 -10
            [ HA.style "transform" "translateX(-100%)"
            ]
            [ H.button
                [ HE.onClick OnReset
                , HA.style "border" "1px solid black"
                , HA.style "border-radius" "5px"
                , HA.style "padding" "2px 10px"
                , HA.style "background" "white"
                , HA.style "font-size" "14px"
                ]
                [ H.text "Reset" ]
            ]

        Nothing ->
          C.none
    ]
  """


largeCode : String
largeCode =
  """
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Svg as S
import Chart as C
import Chart.Attributes as CA
import Chart.Events as CE


type Model
  = NoZoom
  | Zooming CE.Point CE.Point
  | ReZooming CE.Point CE.Point CE.Point CE.Point
  | Zoomed CE.Point CE.Point


getNewSelection : Model -> Maybe ( CE.Point, CE.Point )
getNewSelection model =
  case model of
    NoZoom -> Nothing
    Zooming start end -> Just ( start, end )
    ReZooming _ _ start end -> Just ( start, end )
    Zoomed _ _ -> Nothing


getCurrentWindow : Model -> Maybe ( CE.Point, CE.Point )
getCurrentWindow model =
  case model of
    NoZoom -> Nothing
    Zooming _ _ -> Nothing
    ReZooming start end _ _ -> Just ( start, end )
    Zoomed start end -> Just ( start, end )



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
    OnDown point ->
      case model of
        NoZoom ->
          Zooming point point

        Zoomed start end ->
          ReZooming start end point point

        _ -> model

    OnMove point ->
      case model of
        Zooming start _ ->
          Zooming start point

        ReZooming startOld endOld start _ ->
          ReZooming startOld endOld start point

        _ ->
          model

    OnUp point ->
      case model of
        Zooming start _ ->
          Zoomed
            { x = min start.x point.x, y = min start.y point.y }
            { x = max start.x point.x, y = max start.y point.y }

        ReZooming _ _ start _ ->
          Zoomed
            { x = min start.x point.x, y = min start.y point.y }
            { x = max start.x point.x, y = max start.y point.y }

        _ ->
          model

    OnReset ->
      NoZoom


view : Model -> H.Html Msg
view model =
  C.chart
    [ CA.height 300
    , CA.width 300
    , CA.static
    , CA.htmlAttrs [ HA.style "cursor" "crosshair" ]

    , CE.onMouseDown OnDown CE.getCoords
    , CE.onMouseMove OnMove CE.getCoords
    , CE.onMouseUp OnUp CE.getCoords

    , case getCurrentWindow model of
        Just ( start, end ) ->
          CA.range
            [ CA.lowest start.x CA.exactly
            , CA.highest end.x CA.exactly
            ]

        Nothing ->
          CA.range []

    , case getCurrentWindow model of
        Just ( start, end ) ->
          CA.domain
            [ CA.lowest start.y CA.exactly
            , CA.highest end.y CA.exactly
            ]

        Nothing ->
          CA.range []
    ]
    [ C.grid []
    , C.xLabels []
    , C.yLabels []

    , C.series .x
        [ C.property .y [ CA.monotone ] [ CA.circle, CA.color "white", CA.borderWidth 1 ]
        , C.property .z [ CA.monotone ] [ CA.circle, CA.color "white", CA.borderWidth 1 ]
        , C.property .v [ CA.monotone ] [ CA.circle, CA.color "white", CA.borderWidth 1 ]
        , C.property .w [ CA.monotone ] [ CA.circle, CA.color "white", CA.borderWidth 1 ]
        , C.property .p [ CA.monotone ] [ CA.circle, CA.color "white", CA.borderWidth 1 ]
        , C.property .q [ CA.monotone ] [ CA.circle, CA.color "white", CA.borderWidth 1 ]
        ]
        data

    , case getNewSelection model of
        Just ( start, end ) ->
          C.rect
            [ CA.x1 start.x
            , CA.x2 end.x
            , CA.y1 start.y
            , CA.y2 end.y
            ]

        Nothing ->
          C.none

    , case getCurrentWindow model of
        Just ( start, end ) ->
          C.htmlAt .max .max -10 -10
            [ HA.style "transform" "translateX(-100%)"
            ]
            [ H.button
                [ HE.onClick OnReset
                , HA.style "border" "1px solid black"
                , HA.style "border-radius" "5px"
                , HA.style "padding" "2px 10px"
                , HA.style "background" "white"
                , HA.style "font-size" "14px"
                ]
                [ H.text "Reset" ]
            ]

        Nothing ->
          C.none
    ]
  """