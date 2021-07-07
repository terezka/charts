module Examples.Frontpage.Concise exposing (..)


-- THIS IS A GENERATED MODULE!

import Html as H
import Svg as S
import Chart as C
import Chart.Svg as CS
import Chart.Attributes as CA
import Chart.Events as CE


type alias Model =
  { hovering : List (CE.Group (CE.Stack Datum) CE.Any (Maybe Float) Datum) }


init : Model
init =
  { hovering = [] }


type Msg
  = OnHover (List (CE.Group (CE.Stack Datum) CE.Any (Maybe Float) Datum))


update : Msg -> Model -> Model
update msg model =
  case msg of
    OnHover hovering ->
      { model | hovering = hovering }


view : Model -> H.Html Msg
view model =
  C.chart
    [ CA.height 300
    , CA.width 500
    , CA.static
    , CE.onMouseMove OnHover (CE.getNearest CE.stack)
    , CE.onMouseLeave (OnHover [])
    ]
    [ C.grid []
    , C.yLabels [ CA.format (\y -> String.fromFloat y ++ "M")]

    , C.bars
        [ CA.roundTop 0.2
        , CA.margin 0.2
        , CA.spacing 0.05
        , CA.noGrid
        ]
        [ C.stacked
            [ C.bar .cats
                [ CA.gradient [ "#54c8ddD0", "#54c8dd90" ] ]
                |> C.named "Cats"
            , C.bar .dogs
                [ CA.gradient [ "#0f9ff0D0", "#0f9ff090" ] ]
                |> C.named "Dogs"
            ]
        , C.bar .people
            [ CA.gradient [ "#653bf4D0", "#653bf490" ] ]
                |> C.named "People"
        ]
        data

    , C.labelAt (CA.percent 30) .max
        [ CA.moveDown 3, CA.fontSize 15 ]
        [ S.text "Populations in Scandinavia" ]

    , C.labelAt (CA.percent 30) .max
        [ CA.moveDown 20, CA.fontSize 12 ]
        [ S.text "Note: Based on made up data." ]

    , C.binLabels .country [ CA.moveDown 18 ]
    , C.barLabels [ CA.moveDown 18, CA.color weakWhite ]
    , C.legendsAt .max .max [ CA.alignRight, CA.column, CA.spacing 7 ] []

    , let
        toBrightLabel =
          C.barLabel [ CA.moveDown 18, CA.color white ]
      in
      C.each model.hovering <| \p stack ->
        List.map toBrightLabel (CE.getProducts stack)

    , C.eachBin <| \p bin ->
        let common = CE.getCommonality bin
            yPos = (CE.getTop p bin).y
            xMid = (CE.getCenter p bin).x
        in
        if common.datum.country == "Finland" then
          [ C.line
              [ CA.x1 common.start
              , CA.x2 common.end
              , CA.y1 yPos
              , CA.moveUp 15
              , CA.tickLength 5
              ]
          , C.label
              [ CA.moveUp 22, CA.fontSize 10 ]
              [ S.text "Most pets per person"]
              { x = xMid, y = yPos }
          ]
        else
          []
    ]

purple = "#7b4dffB8"
pink = "#e958c1B8"
blue = "#2F80EDB8"
green = "#13E2DAB8"
darkBlue = "#666bfeF0"
weakWhite = "rgba(255, 255, 255, 0.7)"
white = "white"



meta =
  { category = "Front page"
  , categoryOrder = 1
  , name = "Labels for bars"
  , description = "Add custom bar labels."
  , order = 15
  }


type alias Datum =
  { cats : Float
  , dogs : Float
  , people : Float
  , country : String
  }


data : List Datum
data =
  [ Datum 2.4 1.2 5.3 "Norway"
  , Datum 2.2 2.4 5.8 "Denmark"
  , Datum 3.6 2.2 10.2 "Sweden"
  , Datum 3.4 1.2 5.5 "Finland"
  ]



smallCode : String
smallCode =
  """
  C.chart
    [ CA.height 300
    , CA.width 500
    , CA.static
    , CE.onMouseMove OnHover (CE.getNearest CE.stack)
    , CE.onMouseLeave (OnHover [])
    ]
    [ C.grid []
    , C.yLabels [ CA.format (\\y -> String.fromFloat y ++ "M")]

    , C.bars
        [ CA.roundTop 0.2
        , CA.margin 0.2
        , CA.spacing 0.05
        , CA.noGrid
        ]
        [ C.stacked
            [ C.bar .cats
                [ CA.gradient [ "#54c8ddD0", "#54c8dd90" ] ]
                |> C.named "Cats"
            , C.bar .dogs
                [ CA.gradient [ "#0f9ff0D0", "#0f9ff090" ] ]
                |> C.named "Dogs"
            ]
        , C.bar .people
            [ CA.gradient [ "#653bf4D0", "#653bf490" ] ]
                |> C.named "People"
        ]
        data

    , C.labelAt (CA.percent 30) .max
        [ CA.moveDown 3, CA.fontSize 15 ]
        [ S.text "Populations in Scandinavia" ]

    , C.labelAt (CA.percent 30) .max
        [ CA.moveDown 20, CA.fontSize 12 ]
        [ S.text "Note: Based on made up data." ]

    , C.binLabels .country [ CA.moveDown 18 ]
    , C.barLabels [ CA.moveDown 18, CA.color weakWhite ]
    , C.legendsAt .max .max [ CA.alignRight, CA.column, CA.spacing 7 ] []

    , let
        toBrightLabel =
          C.barLabel [ CA.moveDown 18, CA.color white ]
      in
      C.each model.hovering <| \\p stack ->
        List.map toBrightLabel (CE.getProducts stack)

    , C.eachBin <| \\p bin ->
        let common = CE.getCommonality bin
            yPos = (CE.getTop p bin).y
            xMid = (CE.getCenter p bin).x
        in
        if common.datum.country == "Finland" then
          [ C.line
              [ CA.x1 common.start
              , CA.x2 common.end
              , CA.y1 yPos
              , CA.moveUp 15
              , CA.tickLength 5
              ]
          , C.label
              [ CA.moveUp 22, CA.fontSize 10 ]
              [ S.text "Most pets per person"]
              { x = xMid, y = yPos }
          ]
        else
          []
    ]
  """


largeCode : String
largeCode =
  """
import Html as H
import Svg as S
import Chart as C
import Chart.Svg as CS
import Chart.Attributes as CA
import Chart.Events as CE


type alias Model =
  { hovering : List (CE.Group (CE.Stack Datum) CE.Any (Maybe Float) Datum) }


init : Model
init =
  { hovering = [] }


type Msg
  = OnHover (List (CE.Group (CE.Stack Datum) CE.Any (Maybe Float) Datum))


update : Msg -> Model -> Model
update msg model =
  case msg of
    OnHover hovering ->
      { model | hovering = hovering }


view : Model -> H.Html Msg
view model =
  C.chart
    [ CA.height 300
    , CA.width 500
    , CA.static
    , CE.onMouseMove OnHover (CE.getNearest CE.stack)
    , CE.onMouseLeave (OnHover [])
    ]
    [ C.grid []
    , C.yLabels [ CA.format (\\y -> String.fromFloat y ++ "M")]

    , C.bars
        [ CA.roundTop 0.2
        , CA.margin 0.2
        , CA.spacing 0.05
        , CA.noGrid
        ]
        [ C.stacked
            [ C.bar .cats
                [ CA.gradient [ "#54c8ddD0", "#54c8dd90" ] ]
                |> C.named "Cats"
            , C.bar .dogs
                [ CA.gradient [ "#0f9ff0D0", "#0f9ff090" ] ]
                |> C.named "Dogs"
            ]
        , C.bar .people
            [ CA.gradient [ "#653bf4D0", "#653bf490" ] ]
                |> C.named "People"
        ]
        data

    , C.labelAt (CA.percent 30) .max
        [ CA.moveDown 3, CA.fontSize 15 ]
        [ S.text "Populations in Scandinavia" ]

    , C.labelAt (CA.percent 30) .max
        [ CA.moveDown 20, CA.fontSize 12 ]
        [ S.text "Note: Based on made up data." ]

    , C.binLabels .country [ CA.moveDown 18 ]
    , C.barLabels [ CA.moveDown 18, CA.color weakWhite ]
    , C.legendsAt .max .max [ CA.alignRight, CA.column, CA.spacing 7 ] []

    , let
        toBrightLabel =
          C.barLabel [ CA.moveDown 18, CA.color white ]
      in
      C.each model.hovering <| \\p stack ->
        List.map toBrightLabel (CE.getProducts stack)

    , C.eachBin <| \\p bin ->
        let common = CE.getCommonality bin
            yPos = (CE.getTop p bin).y
            xMid = (CE.getCenter p bin).x
        in
        if common.datum.country == "Finland" then
          [ C.line
              [ CA.x1 common.start
              , CA.x2 common.end
              , CA.y1 yPos
              , CA.moveUp 15
              , CA.tickLength 5
              ]
          , C.label
              [ CA.moveUp 22, CA.fontSize 10 ]
              [ S.text "Most pets per person"]
              { x = xMid, y = yPos }
          ]
        else
          []
    ]

purple = "#7b4dffB8"
pink = "#e958c1B8"
blue = "#2F80EDB8"
green = "#13E2DAB8"
darkBlue = "#666bfeF0"
weakWhite = "rgba(255, 255, 255, 0.7)"
white = "white"

  """