module Examples.Frame.Legends exposing (..)


-- THIS IS A GENERATED MODULE!

import Html as H
import Html.Attributes as HA
import Svg as S
import Chart as C
import Chart.Attributes as CA
import Chart.Events as CE


view : Model -> H.Html Msg
view model =
  C.chart
    [ CA.height 300
    , CA.width 300
    , CA.paddingLeft 10
    , CA.marginTop 30
    , CA.range [ CA.lowest 0 CA.exactly ]
    ]
    [ C.grid []
    , C.xAxis []
    , C.yLabels [ CA.pinned .min ]

    -- BAR CHART
    , C.bars
        [ CA.roundTop 0.3
        , CA.x1 .x
        ]
        [ C.named "B1" <| C.bar .z []
        , C.named "B2" <| C.bar .y [ CA.striped [] ]
        ]
        data

    -- LINE CHART
    , C.series .x
        [ C.named "A1" <|
            C.property .p
              [ CA.linear ]
              [ CA.cross, CA.borderWidth 2, CA.border "white" ]
        , C.named "A2" <|
            C.property .q
              [ CA.linear ]
              [ CA.cross, CA.borderWidth 2, CA.border "white" ]
        ]
        data

    -- LEGENDS
    , C.legendsAt .min .max 0 25
        [ CA.row
        , CA.spacing 15
        ]
        [ CA.width 20 ]

    -- SPECIAL BIN LABELS
    , C.withProducts <| \p products ->
        let toLabel i =
              C.xLabel
                [ CA.x (CE.getCenter p i).x, CA.noGrid, CA.moveUp 5 ]
                [ S.text (String.fromFloat (CE.getCommonality i).start) ]
        in
        List.map toLabel (CE.group (CE.filter CE.bar CE.bin) products)
    ]


meta =
  { category = "Frame and navigation"
  , name = "Legends"
  , description = "Add legends to chart."
  , order = 21
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


type alias Datum =
  { x : Float
  , y : Maybe Float
  , z : Maybe Float
  , v : Maybe Float
  , w : Maybe Float
  , p : Maybe Float
  , q : Maybe Float
  }


data : List Datum
data =
  let toDatum x y z v w p q =
        Datum x (Just y) (Just z) (Just v) (Just w) (Just p) (Just q)
  in
  [ toDatum 0  2 1 4.6 6.9 7.3 8.0
  , toDatum 2  3 2 5.2 6.2 7.0 8.7
  , toDatum 4  3 4 5.3 5.7 6.2 7.8
  , toDatum 6  4 1 4.8 5.4 7.2 8.3
  , toDatum 8  6 3 5.4 3.9 7.6 8.5
  , toDatum 10 4 3 4.5 5.3 6.3 7.0
  ]



smallCode : String
smallCode =
  """
  C.chart
    [ CA.height 300
    , CA.width 300
    , CA.paddingLeft 10
    , CA.marginTop 30
    , CA.range [ CA.lowest 0 CA.exactly ]
    ]
    [ C.grid []
    , C.xAxis []
    , C.yLabels [ CA.pinned .min ]

    -- BAR CHART
    , C.bars
        [ CA.roundTop 0.3
        , CA.x1 .x
        ]
        [ C.named "B1" <| C.bar .z []
        , C.named "B2" <| C.bar .y [ CA.striped [] ]
        ]
        data

    -- LINE CHART
    , C.series .x
        [ C.named "A1" <|
            C.property .p
              [ CA.linear ]
              [ CA.cross, CA.borderWidth 2, CA.border "white" ]
        , C.named "A2" <|
            C.property .q
              [ CA.linear ]
              [ CA.cross, CA.borderWidth 2, CA.border "white" ]
        ]
        data

    -- LEGENDS
    , C.legendsAt .min .max 0 25
        [ CA.row
        , CA.spacing 15
        ]
        [ CA.width 20 ]

    -- SPECIAL BIN LABELS
    , C.withProducts <| \\p products ->
        let toLabel i =
              C.xLabel
                [ CA.x (CE.getCenter p i).x, CA.noGrid, CA.moveUp 5 ]
                [ S.text (String.fromFloat (CE.getCommonality i).start) ]
        in
        List.map toLabel (CE.group (CE.filter CE.bar CE.bin) products)
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
import Chart.Events as CE


view : Model -> H.Html Msg
view model =
  C.chart
    [ CA.height 300
    , CA.width 300
    , CA.paddingLeft 10
    , CA.marginTop 30
    , CA.range [ CA.lowest 0 CA.exactly ]
    ]
    [ C.grid []
    , C.xAxis []
    , C.yLabels [ CA.pinned .min ]

    -- BAR CHART
    , C.bars
        [ CA.roundTop 0.3
        , CA.x1 .x
        ]
        [ C.named "B1" <| C.bar .z []
        , C.named "B2" <| C.bar .y [ CA.striped [] ]
        ]
        data

    -- LINE CHART
    , C.series .x
        [ C.named "A1" <|
            C.property .p
              [ CA.linear ]
              [ CA.cross, CA.borderWidth 2, CA.border "white" ]
        , C.named "A2" <|
            C.property .q
              [ CA.linear ]
              [ CA.cross, CA.borderWidth 2, CA.border "white" ]
        ]
        data

    -- LEGENDS
    , C.legendsAt .min .max 0 25
        [ CA.row
        , CA.spacing 15
        ]
        [ CA.width 20 ]

    -- SPECIAL BIN LABELS
    , C.withProducts <| \\p products ->
        let toLabel i =
              C.xLabel
                [ CA.x (CE.getCenter p i).x, CA.noGrid, CA.moveUp 5 ]
                [ S.text (String.fromFloat (CE.getCommonality i).start) ]
        in
        List.map toLabel (CE.group (CE.filter CE.bar CE.bin) products)
    ]
  """