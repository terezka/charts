module Examples.Interactivity.Zoom exposing (..)

{-| @LARGE -}
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Svg as S
import Chart as C
import Chart.Attributes as CA
import Chart.Events as CE
import Data.Iris


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
{-| @SMALL -}
  C.chart
    [ CA.height 300
    , CA.width 300
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

    , C.series .sepalWidth
        [ C.scatter (Data.Iris.only Data.Iris.Setosa .petalWidth)
            [ CA.size 3, CA.color "white", CA.borderWidth 1, CA.circle ]
        , C.scatter (Data.Iris.only Data.Iris.Versicolor .petalWidth)
            [ CA.size 3, CA.color "white", CA.borderWidth 1, CA.square ]
        , C.scatter (Data.Iris.only Data.Iris.Virginica .petalWidth)
            [ CA.size 3, CA.color "white", CA.borderWidth 1, CA.diamond ]
        ]
        Data.Iris.data

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
{-| @SMALL END -}
{-| @LARGE END -}


meta =
  { category = "Interactivity"
  , categoryOrder = 5
  , name = "Zoom"
  , description = "Add zoom effect."
  , order = 20
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
  , r : Maybe Float
  , s : Maybe Float
  , k : Maybe Float
  , l : Maybe Float
  , a11 : Maybe Float
  , a12 : Maybe Float
  , a13 : Maybe Float
  }


data : List Datum
data =
  let toDatum x x1 y z v w p q r s k l a11 a12 a13 =
        Datum x x1 (x1 + 1) (Just y) (Just z) (Just v) (Just w) (Just p) (Just q) (Just r) (Just s) (Just k) (Just l) (Just a11) (Just a12) (Just a13)
  in
  [ toDatum 0.0 0.0 1.2 4.0 4.6 6.9 7.3 8.0 9.2 9.3 9.9 10.8 11.2 12.1 13.1
  , toDatum 2.0 1.0 2.2 4.2 5.3 5.7 6.2 7.8 8.9 10.2 9.4 10.2 11.8 13.0 13.8
  , toDatum 3.0 2.0 1.0 3.2 4.8 5.4 7.2 8.3 8.4 9.3 10.5 10.1 11.2 12.9 14.0
  , toDatum 4.0 3.0 1.2 3.0 4.1 5.5 7.9 8.1 8.7 9.7 10.8 11.2 11.9 12.3 13.7
  ]

