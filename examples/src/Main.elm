module Main exposing (..)

import Html as H
import Html.Attributes as HA
import Svg as S exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes as SA exposing (width, height, stroke, fill, r, transform)
import Svg.Coordinates as Coordinates
import Chart as C
import Svg.Chart as SC
import Browser
import Time
import Data.Iris as Iris
import Data.LigeLoen as LigeLoen
import Dict


-- TODO
-- labels + ticks + grid automation?
-- clean up Item / Items
-- Title


main =
  Browser.sandbox
    { init = init
    , update = update
    , view = view
    }


type alias Model =
  { hoveringSalery : List (C.Single Float LigeLoen.Datum)
  , hovering : List (C.Single Float Datum)
  , point : Maybe SC.Point
  }


init : Model
init =
  Model [] [] Nothing


type Msg
  = OnHoverSalery (List (C.Single Float LigeLoen.Datum))
  | OnHover (List (C.Single Float Datum))
  | OnCoords SC.Point -- TODO


update : Msg -> Model -> Model
update msg model =
  case msg of
    OnHoverSalery bs -> { model | hoveringSalery = bs }
    OnHover bs -> { model | hovering = bs }
    OnCoords p -> { model | point = Just p }


type alias Datum =
  { x : Float
  , y : Maybe Float
  , z : Maybe Float
  , label : String
  }


data : List Datum
data =
  [ { x = 2, y = Just 4, z = Just 5, label = "DK" }
  , { x = 4, y = Just 2, z = Just 3, label = "NO" }
  , { x = 6, y = Just 4, z = Nothing, label = "SE" }
  , { x = 8, y = Just 3, z = Just 7, label = "FI" }
  , { x = 10, y = Just 4, z = Just 3, label = "IS" }
  ]


view : Model -> H.Html Msg
view model =
  H.div
    [ HA.style "font-size" "12px"
    , HA.style "font-family" "monospace"
    , HA.style "margin" "0 auto"
    , HA.style "padding-top" "50px"
    , HA.style "width" "100vw"
    , HA.style "max-width" "1000px"
    ]
    [ viewSaleryStatestic model
    --, H.h1 [] [ H.text "Iris" ]
    --, viewIris
    ]


viewSaleryStatestic : Model -> H.Html Msg
viewSaleryStatestic model =
  let value min max func d =
        if LigeLoen.womenPerc d >= min && LigeLoen.womenPerc d < max then func d else Nothing
  in
  C.chart
    [ C.height 400
    , C.width 800
    , C.static
    , C.marginLeft 50
    , C.range (C.startMax 20000)
    , C.domain (C.startMax 75)
    , C.paddingTop 15
    , C.events
        [ C.event "mouseleave" (C.map (\_ -> OnHoverSalery []) C.getCoords)
        , C.event "mousemove" (C.map OnHoverSalery (C.getNearest (C.withoutUnknowns >> C.getDots)))
        ]
    ]
    [ C.grid []
    , C.xAxis []
    , C.yAxis []
    , C.xTicks [ C.amount 10 ]
    , C.xLabels [ C.amount 10 ]
    , C.yLabels []
    , C.yTicks []
    , C.series .saleryBoth
        [ C.scatter (value 0 40 LigeLoen.womenSaleryPerc) [ C.size (\d -> d.numOfBoth / 200), C.style (\_ -> C.opaque 1 0.5), C.circle ]
        , C.scatter (value 40 60 LigeLoen.womenSaleryPerc) [ C.size (\d -> d.numOfBoth / 200), C.style (\_ -> C.opaque 1 0.5), C.circle, C.color C.purple ]
        , C.scatter (value 60 100 LigeLoen.womenSaleryPerc) [ C.size (\d -> d.numOfBoth / 200), C.style (\_ -> C.opaque 1 0.5), C.circle, C.color C.pink ]
        ]
        (List.filter (.year >> (==) 2019) LigeLoen.data)

    , C.when model.hoveringSalery <| \item rest ->
        C.tooltipOnTop (always item.center.x) (always item.position.y2) [] [ saleryTooltip item ]
    ]


saleryTooltip : C.Single Float LigeLoen.Datum -> H.Html msg
saleryTooltip hovered =
  H.div []
    [ H.h4
        [ HA.style "max-width" "200px"
        , HA.style "margin-top" "5px"
        , HA.style "margin-bottom" "8px"
        , HA.style "color" hovered.metric.color
        ]
        [ H.text hovered.datum.sector ]
    , H.div []
        [ H.text "Women: "
        , H.text (String.fromFloat hovered.datum.saleryWomen)
        ]
    , H.div []
        [ H.text "Men: "
        , H.text (String.fromFloat hovered.datum.saleryMen)
        ]
    ]


viewIris : H.Html Msg
viewIris =
  let frame left right el =
        C.chart
          [ C.width 200
          , C.height 200
          , C.static
          , C.paddingLeft left
          , C.paddingRight right -- TODO what
          ]
          [ C.grid []
          , C.xAxis []
          , C.yAxis []
          , C.xTicks []
          , C.xLabels []
          , C.yLabels []
          , C.yTicks []
          , el
          ]

      scatter x y =
        frame 5 5 <|
          C.series x
            [ C.scatter (value Iris.Setosa y) [ C.color C.blue, C.name "Setosa", C.unit "cm", C.size (always 2), C.style (always <| C.detached 0.5), C.circle ]
            , C.scatter (value Iris.Versicolor y) [ C.color C.pink, C.name "Versicolor", C.unit "cm", C.size (always 2), C.style (always <| C.detached 0.5), C.circle ]
            , C.scatter (value Iris.Virginica y) [ C.color C.green, C.name "Virginica", C.unit "cm", C.size (always 2), C.style (always <| C.detached 0.5), C.circle ]
            ]
            Iris.data

      areas x =
        frame 0 5 <|
          C.series .bin
            [ C.monotone (count Iris.Setosa) [ C.area 0.5, C.noDot ]
            , C.monotone (count Iris.Versicolor) [ C.area 0.5, C.noDot ]
            , C.monotone (count Iris.Virginica) [ C.area 0.5, C.noDot ]
            ]
            (C.binned 0.35 x Iris.data)

      value species func d =
        if d.species == species then Just (func d) else Nothing

      count species ds =
        ds.data
          |> List.filter (\d -> d.species == species)
          |> List.length
          |> toFloat
          |> Just
  in
  H.div
    [ HA.style "display" "flex"
    , HA.style "width" "100%"
    , HA.style "max-width" "800px"
    , HA.style "flex-wrap" "wrap"
    , HA.style "margin" "0 auto"
    ]
    [ areas .sepalLength
    , scatter .sepalWidth .sepalLength
    , scatter .petalLength .sepalLength
    , scatter .petalWidth .sepalLength
    --
    , scatter .sepalLength .sepalWidth
    , areas .sepalWidth
    , scatter .petalLength .sepalWidth
    , scatter .petalWidth .sepalWidth
    --
    , scatter .sepalLength .petalLength
    , scatter .sepalWidth .petalLength
    , areas .petalLength
    , scatter .petalWidth .petalLength

    --
    , scatter .sepalLength .petalWidth
    , scatter .sepalWidth .petalWidth
    , scatter .petalLength .petalWidth
    , areas .petalWidth


        --, C.histogram .bin
        --    [ C.width (always 0.4), C.spacing 0, C.margin 0 ]
        --    [ C.bar (count Iris.Setosa) [ C.name "Records", C.unit "cm" ]
        --    ]
        --    (binned 0.4 .petalLength Iris.data)
        --, C.histogram .bin
        --    [ C.width (always 0.4), C.spacing 0, C.margin 0 ]
        --    [ C.bar (count Iris.Versicolor) [ C.color (always C.pink), C.name "Records", C.unit "cm" ]
        --    ]
        --    (binned 0.4 .petalLength Iris.data)
        --, C.histogram .bin
        --    [ C.width (always 0.4), C.spacing 0, C.margin 0 ]
        --    [ C.bar (count Iris.Virginica) [ C.color (always C.green), C.name "Records", C.unit "cm" ]
        --    ]
        --    (binned 0.4 .petalLength Iris.data)
    ]


viewHover : Model -> H.Html Msg
viewHover model =
  C.chart
    [ C.width 600
    , C.height 300
    , C.marginTop 40
    , C.htmlAttrs
        [ HA.style "font-size" "12px"
        , HA.style "font-family" "monospace"
        , HA.style "margin" "20px 40px"
        , HA.style "max-width" "700px"
        ]
    , C.events
        [ C.event "mouseleave" (C.map (\_ -> OnHover []) C.getCoords)
        , C.event "mousemove" <|
            C.map OnHover (C.getNearestX (C.withoutUnknowns >> C.getBars))
        ]
    ]
    [ C.grid []
    , C.histogram .x
        [ C.name "bars" ]
        [ C.bar (C.just .x) [ C.name "area", C.unit "m2" ]
        , C.bar .y [ C.name "speed", C.unit "km/h" ]
        , C.bar .z [ C.name "volume", C.unit "m3" ]
        ]
        data

    , C.yAxis []
    --, C.yTicks [ ] --  C.withGrid
    , C.xAxis []
    , C.yLabels [] --  C.withGrid
    --, C.xLabels [] --  C.withGrid

    , C.with C.getGroups <| \plane items ->
        let byItem i = [ i.position.x1, i.position.x2 ]
            values = List.concatMap byItem items
        in
        [ C.xTicks [ C.values identity values ]
        , C.xLabels
            [ C.yOffset -5
            , C.values (.center >> .x >> identity) items
            , C.format (.datum >> .label)
            ]
        ]

    , C.with C.getBars <| \plane items ->
        [ C.xLabels
            [ C.yOffset -25
            , C.values (.center >> .x) items
            , C.format (.position >> .y2 >> String.fromFloat)
            , C.at (.center >> .y)
            ]
        ]

    , C.when model.hovering <| \item rest ->
        C.tooltipOnTop (always item.center.x) (always item.center.y) [] [ tooltipRow item ]

    --, C.when model.hovering <| \item rest ->
    --    C.line [ C.horizontal 4, C.vertical 5 ]
    ]


tooltipRow : C.Single Float Datum -> H.Html msg
tooltipRow hovered =
  H.div [ HA.style "color" hovered.metric.color ]
    [ H.span [] [ H.text hovered.datum.label ]
    , H.text " "
    , H.text hovered.metric.label
    , H.text " : "
    , H.text (String.fromFloat hovered.values.y)
    --, H.text <|
    --    case hovered.values.y of
    --      Just y -> String.fromFloat y
    --      Nothing -> "unknown"
    , H.text " "
    , H.text hovered.metric.unit
    ]
