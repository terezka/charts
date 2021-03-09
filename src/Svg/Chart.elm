module Svg.Chart
  exposing
    ( responsive, static, frame
    , Dot, clear, empty, disconnected, aura, full
    , circle, triangle, square, diamond, plus, cross
    , scatter, linear, linearArea, monotone, monotoneArea
    , Group, bars
    , Bin, Bar, histogram
    , xAxis, yAxis, xArrow, yArrow
    , xGrid, yGrid
    , xTicks, xTick, yTicks, yTick
    , xLabels, yLabels, xLabel, yLabel
    , line, horizontal, vertical
    , position, positionHtml

    , eventCatcher, container, decodePoint
    , Point, toPoints, DataPoint, toDataPoints
    , getNearest, getNearestX, getWithin, getWithinX
    , tooltip, tooltipOnTop, isXPastMiddle, middleOfY, middleOfX

    , toBarPoints
    )


{-| This module contains low-level SVG plotting elements.

# Series

## Sizing
@docs static, responsive, frame

## Dots
@docs Dot, clear, empty, disconnected, aura, full
@docs circle, triangle, square, diamond, plus, cross

## Interpolation
@docs scatter, linear, linearArea, monotone, monotoneArea

# Bar charts
@docs Group, bars, Bin, Bar, histogram

# Straight lines
@docs line, xAxis, yAxis, xArrow, yArrow, xGrid, yGrid, horizontal, vertical

## Ticks
ProTip: Passing a negative value as the height/width of a tick renders it
mirrored on the other side of the axis!

@docs xTick, xTicks, yTick, yTicks

## Labels

@docs xLabel, xLabels, yLabel, yLabels


## Positioning anything
@docs position, positionHtml


# Events

@docs container, eventCatcher

@docs decodePoint, Point, toPoints, DataPoint, toDataPoints

@docs getNearest, getNearestX, getWithin, getWithinX

@docs tooltip, isXPastMiddle, middleOfY, middleOfX


-}

import Html exposing (Html)
import Html.Attributes as HA
import Svg exposing (Svg, Attribute, g, path, rect, text)
import Svg.Attributes as Attributes exposing (class, width, height, stroke, fill, d, transform, viewBox)
import Svg.Coordinates exposing (Plane, place, toSVGX, toSVGY, toCartesianX, toCartesianY, scaleSVG, scaleCartesian, placeWithOffset)
import Svg.Commands exposing (..)
import Internal.Colors exposing (..)
import Internal.Svg exposing (..)
import Json.Decode as Json
import DOM


{-| Set the size of your chart.
-}
static : Plane -> List (Attribute msg)
static plane =
  [ width (String.fromFloat plane.x.length)
  , height (String.fromFloat plane.y.length)
  ]


{-| Set the dimensions of your chart, but let it respond to size changes in parent.
-}
responsive : Plane -> Attribute msg
responsive plane =
  viewBox ("0 0 " ++ String.fromFloat plane.x.length ++ " " ++ String.fromFloat plane.y.length)


{-| Create an id to use in a clip path to prevent elements from going into your margins.

    svg []
      [ frame "some-id" plane
      , g [ clipPath "url(#some-id)" ] [ stuffThatShouldntGoIntoTheMargin ]
      ]
-}
frame : String -> Plane -> Svg.Svg msg
frame id plane =
  Svg.defs []
    [ Svg.clipPath
        [ Attributes.id id ]
        [ Svg.rect (areaAttributes plane) []
        ]
    ]



-- BARS


{-| -}
type alias Group msg =
  { label : String
  , spacing : Float
  , tickLength : Float
  , tickWidth : Float
  , bars : List (Bar msg)
  }


{-| -}
bars : Plane -> List (Group msg) -> Svg msg
bars plane groups =
  let viewGroupBin i group =
        viewBin plane
          { label = group.label
          , start = toFloat i + 0.5
          , end = toFloat i + 1.5
          , spacing = group.spacing
          , tickLength = group.tickLength
          , tickWidth = group.tickWidth
          , bars = group.bars
          }
  in
  g [ class "elm-charts__bars" ] (List.indexedMap viewGroupBin groups)



-- HISTOGRAM


{-| -}
type alias Bin msg =
  { label : String
  , start : Float
  , end : Float
  , spacing : Float
  , tickLength : Float
  , tickWidth : Float
  , bars : List (Bar msg)
  }


{-| -}
type alias Bar msg =
  { attributes : List (Attribute msg)
  , label : Maybe String
  , rounded : Float
  , roundBottom : Bool
  , width : Float
  , value : Float
  }


{-| -}
histogram : Plane -> List (Bin msg) -> Svg msg
histogram plane bins =
  g [ class "elm-charts__histogram" ] (List.map (viewBin plane) bins)


viewBin : Plane -> Bin msg -> Svg msg
viewBin plane bin =
  let binWidth =
        bin.end - bin.start

      binOffset =
        (binWidth - binWidth * usedWidthPer) / 2

      usedWidthPer =
        min 1 <| List.sum (List.map .width bin.bars) + bin.spacing * toFloat (List.length bin.bars - 1)

      adjustBar barOffset bar =
        { attributes = bar.attributes
        , label = bar.label
        , rounded = bar.rounded
        , roundBottom = bar.roundBottom
        , position = bin.start + binOffset + barOffset
        , width = binWidth * bar.width
        , value = bar.value
        }

      foldAdjustedBars b ( offset, acc ) =
        ( offset + binWidth * b.width + binWidth * bin.spacing
        , adjustBar offset b :: acc
        )

      ( _, adjustedBars ) =
        List.foldl foldAdjustedBars ( 0, [] ) bin.bars

      viewValueLabel bar =
        case bar.label of
          Just string ->
            viewXLabel plane [] string (bar.position + bar.width / 2) bar.value 0 -5

          Nothing ->
            Svg.text ""
  in
  g [ class "elm-charts__bin" ]
    [ g [ class "elm-charts__bars" ] (List.map (viewBar plane) adjustedBars)
    , xTicks plane bin.tickLength [ Attributes.strokeWidth (String.fromFloat bin.tickWidth) ] (closestToZero plane) [ bin.start, bin.end ]
    , viewXLabel plane [ class "elm-charts__bin-label" ] bin.label (bin.start + binWidth / 2) (closestToZero plane) 0 20
    , g [ class "elm-charts__bin-bar-labels" ] (List.map viewValueLabel adjustedBars)
    ]


toBarPoints : Plane -> Bin msg -> List Point
toBarPoints plane bin =
  let binWidth =
        bin.end - bin.start

      binOffset =
        (binWidth - binWidth * usedWidthPer) / 2

      usedWidthPer =
        min 1 <| List.sum (List.map .width bin.bars) + bin.spacing * toFloat (List.length bin.bars - 1)

      foldAdjustedBars bar ( offset, acc ) =
        let barWidth = binWidth * bar.width
            barOffset = offset + barWidth
        in
        ( barOffset + binWidth * bin.spacing
        , { x = bin.start + binOffset + barOffset - barWidth / 2, y = bar.value } :: acc
        )
  in
  List.foldl foldAdjustedBars ( 0, [] ) bin.bars
    |> Tuple.second




-- BARS INTERNAL


type alias InternalBar msg =
  { attributes : List (Attribute msg)
  , label : Maybe String
  , rounded : Float
  , roundBottom : Bool
  , position : Float
  , width : Float
  , value : Float
  }


viewBar : Plane ->  InternalBar msg -> Svg msg
viewBar plane bar_ =
  let x = bar_.position
      y = bar_.value
      w = bar_.width
      bs = closestToZero plane
      b = scaleSVG plane.x w * 0.5 * (clamp 0 1 bar_.rounded)
      ys = abs (scaleSVG plane.y bar_.value)
      rx = scaleCartesian plane.x b
      ry = scaleCartesian plane.y b
      roundBottom = bar_.roundBottom

      commands =
        if bs == y then
          []
        else if b == 0 || ys < b then
          commandsNoRound
        else
          if y < 0 then
            if roundBottom then
              commandsRoundBoth False (ry * -1)
            else
              commandsRoundTop False ry
          else
            if roundBottom then
              commandsRoundBoth True ry
            else
              commandsRoundTop True (ry * -1)

      commandsNoRound =
        [ Move x bs
        , Line x y
        , Line (x + w) y
        , Line (x + w) bs
        ]

      commandsRoundBoth outwards ry_ =
        [ Move (x + rx) bs
        , Arc b b -45 False outwards x (bs + ry_)
        , Line x (y - ry_)
        , Arc b b -45 False outwards (x + rx) y
        , Line (x + w - rx) y
        , Arc b b -45 False outwards (x + w) (y - ry_)
        , Line (x + w) (bs + ry_)
        , Arc b b -45 False outwards (x + w - rx) bs
        ]

      commandsRoundTop outwards ry_ =
        [ Move x bs
        , Line x (y + ry_)
        , Arc b b -45 False outwards (x + rx) y
        , Line (x + w - rx) y
        , Arc b b -45 False outwards (x + w) (y + ry_)
        , Line (x + w) bs
        ]

      commandsRoundBottom outwards ry_ =
        [ Move (x + rx) bs
        , Arc b b -45 False outwards x (bs + ry_)
        , Line x y
        , Line (x + w) y
        , Line (x + w) (bs + ry_)
        , Arc b b -45 False outwards (x + w - rx) bs
        ]

      attributes =
        concat
          [ stroke pinkStroke, fill pinkFill ]
          bar_.attributes
          [ d (description plane commands) ]
  in
  path attributes []



-- STRAIGHT LINES


{-| Renders a line.

    myLine : Svg msg
    myLine =
      line plane [ stroke "pink" ] x0 y0 x1 y1
-}
line : Plane -> List (Attribute msg) -> Float -> Float -> Float -> Float -> Svg msg
line plane userAttributes x1 y1 x2 y2 =
  let
    attributes =
      concat
        [ stroke "rgb(210, 210, 210)" ]
        userAttributes
        [ d (description plane [ Move x1 y1, Line x1 y1, Line x2 y2 ]) ]
  in
    path attributes []


{-| Renders a horizontal line.

    myLine : Svg msg
    myLine =
      horizontal plane [ stroke "pink" ] y x0 x1

-}
horizontal : Plane -> List (Attribute msg) -> Float -> Float -> Float -> Svg msg
horizontal plane userAttributes y x1 x2 =
  let
    attributes =
      concat
        [ stroke "rgb(210, 210, 210)" ]
        userAttributes
        [ d (description plane [ Move x1 y, Line x1 y, Line x2 y ]) ]
  in
    path attributes []


{-| Renders a vertical line.

    myLine : Svg msg
    myLine =
      vertical plane [ stroke "pink" ] x y0 y1

-}
vertical : Plane -> List (Attribute msg) -> Float -> Float -> Float -> Svg msg
vertical plane userAttributes x y1 y2 =
  let
    attributes =
      concat
        [ stroke "rgb(210, 210, 210)" ]
        userAttributes
        [ d (description plane [ Move x y1, Line x y1, Line x y2 ]) ]
  in
    path attributes []


{-| Renders a horizontal line with the full length of the range.

    myXAxisOrGridLine : Svg msg
    myXAxisOrGridLine =
      xAxis plane [] yPosition
-}
xAxis : Plane -> List (Attribute msg) -> Float -> Svg msg
xAxis plane userAttributes y =
  horizontal plane userAttributes y plane.x.min plane.x.max


{-| Renders a horizontal line with the full length of the range.
-}
xGrid : Plane -> List (Attribute msg) -> Float -> Svg msg
xGrid =
  xAxis


{-| Renders a vertical line with the full length of the domain.

    myYAxisOrGridLine : Svg msg
    myYAxisOrGridLine =
      yAxis plane [] xPosition
-}
yAxis : Plane -> List (Attribute msg) -> Float -> Svg msg
yAxis plane userAttributes x =
  vertical plane userAttributes x plane.y.min plane.y.max


{-| Renders a horizontal line with the full length of the domain.
-}
yGrid : Plane -> List (Attribute msg) -> Float -> Svg msg
yGrid =
  yAxis


{-| Renders ticks for the horizontal axis.

    horizontalTicks : Svg msg
    horizontalTicks =
      xTicks plane height [ stroke "pink" ] axisYCoordinate tickPositions
-}
xTicks : Plane -> Float -> List (Attribute msg) -> Float -> List Float -> Svg msg
xTicks plane height userAttributes y xs =
  g [ class "elm-charts__x-ticks" ] (List.map (xTick plane height userAttributes y) xs)


{-| Renders a single tick for the horizontal axis.
-}
xTick : Plane -> Float -> List (Attribute msg) -> Float -> Float -> Svg msg
xTick plane height userAttributes y x =
  let
    attributes =
      concat
        [ class "elm-charts__tick", stroke "rgb(210, 210, 210)" ]
        userAttributes
        [ Attributes.x1 <| String.fromFloat (toSVGX plane x)
        , Attributes.x2 <| String.fromFloat (toSVGX plane x)
        , Attributes.y1 <| String.fromFloat (toSVGY plane y)
        , Attributes.y2 <| String.fromFloat (toSVGY plane y + height)
        ]
  in
    Svg.line attributes []


{-| Renders ticks for the vertical axis.

    verticalTicks : Svg msg
    verticalTicks =
      yTicks plane width [ stroke "pink" ] axisXCoordinate tickPositions
-}
yTicks : Plane -> Float -> List (Attribute msg) -> Float -> List Float -> Svg msg
yTicks plane width userAttributes x ys =
  g [ class "elm-charts__y-ticks" ] (List.map (yTick plane width userAttributes x) ys)


{-| Renders a single tick for the vertical axis.
-}
yTick : Plane -> Float -> List (Attribute msg) -> Float -> Float -> Svg msg
yTick plane width userAttributes x y =
  let
    attributes =
      concat
        [ class "elm-charts__tick", stroke "rgb(210, 210, 210)" ]
        userAttributes
        [ Attributes.x1 <| String.fromFloat (toSVGX plane x)
        , Attributes.x2 <| String.fromFloat (toSVGX plane x - width)
        , Attributes.y1 <| String.fromFloat (toSVGY plane y)
        , Attributes.y2 <| String.fromFloat (toSVGY plane y)
        ]
  in
    Svg.line attributes []


{-| Renders labels for the horizontal axis.

    horizontalLabels : Svg msg
    horizontalLabels =
      xLabels plane (xLabel "blue" .timestamp format) axisYCoordinate data
-}
xLabels : Plane -> (Plane -> Float -> data -> Svg msg) -> Float -> List data -> Svg msg
xLabels plane toLabel y xs =
  g [ class "elm-charts__x-labels" ] (List.map (toLabel plane y) xs)


{-| Renders a label for the horizontal axis.

    horizontalLabel : Svg msg
    horizontalLabel =
      xLabel "blue" .timestamp format plane y datum
-}
xLabel : List (Attribute msg) -> (data -> Float) -> (data -> String) -> Plane -> Float -> data -> Svg msg
xLabel attrs toX toString plane y datum =
  Svg.g
    [ placeWithOffset plane (toX datum) y 0 20
    , Attributes.style "text-anchor: middle;"
    ]
    [ viewLabel attrs (toString datum) ]


{-| Renders labels for the vertical axis.

    verticalLabels : Svg msg
    verticalLabels =
      yLabels plane (yLabel "blue" .age format) axisXCoordinate data
-}
yLabels : Plane -> (Plane -> Float -> data -> Svg msg) -> Float -> List data -> Svg msg
yLabels plane toLabel x ys =
  g [ class "elm-charts__y-labels" ] (List.map (toLabel plane x) ys)


{-| Renders a label for the vertical axis.

    verticalLabel : Svg msg
    verticalLabel =
      yLabel "blue" .age format plane x y
-}
yLabel : List (Attribute msg) -> (data -> Float) -> (data -> String) -> Plane -> Float -> data -> Svg msg
yLabel attrs toY toString plane x datum =
  Svg.g
    [ placeWithOffset plane x (toY datum) -10 4
    , Attributes.style "text-anchor: end;"
    ]
    [ viewLabel attrs (toString datum) ]


viewLabel : List (Attribute msg) -> String -> Svg msg
viewLabel userAttributes string =
  let attributes =
        concat
          [ class "elm-charts__label"
          , Attributes.stroke "white"
          , Attributes.strokeWidth "0.2"
          , Attributes.fill "#808BAB"
          , Attributes.style "pointer-events: none;"
          ]
          userAttributes
          []
  in
  Svg.text_ attributes
    [ Svg.tspan [] [ Svg.text string ] ]


viewXLabel : Plane -> List (Attribute msg) -> String -> Float -> Float -> Float -> Float -> Svg msg
viewXLabel plane userAttributes string x y xOff yOff =
  Svg.g
    [ placeWithOffset plane x y xOff yOff
    , Attributes.style "text-anchor: middle;"
    ]
    [ viewLabel [] string ]


{-| Place an arrow pointing to the right somewhere.

      xArrow plane color x y xOff yOff

-}
xArrow : Plane -> String -> Float -> Float -> Float -> Float -> Svg msg
xArrow plane color x y xOff yOff =
    g [ position plane x y xOff yOff ]
      [ Svg.polygon
          [ fill color
          , Attributes.points "0,0 50,0 25.0,43.3"
          , transform "translate(6 0) scale(0.15) rotate(150)"
          ]
          []
      ]


{-| Place an arrow pointing up somewhere.

      yArrow plane color x y xOff yOff

-}
yArrow : Plane -> String -> Float -> Float -> Float -> Float -> Svg msg
yArrow plane color x y xOff yOff =
    g [ position plane x y xOff yOff ]
      [ Svg.polygon
          [ fill color
          , Attributes.points "0,0 50,0 25.0,43.3"
          , transform "translate(0 -6) scale(0.15) rotate(60)"
          ]
          []
      ]



-- SERIES


{-| -}
type alias Dot msg =
  (Plane -> Float -> Float -> Svg msg)


{-| A dot without visual representation.
-}
clear : Dot msg
clear _ _ _ =
  Svg.text ""


{-| Make a regular shape.

    someDot : Svg msg
    someDot =
      full radius circle "blue" plane x y
-}
full : Float -> Shape -> String -> Dot msg
full radius shape color =
  viewShape radius Full shape color


{-| Make a shape with a little translucent border.

    someDot : Svg msg
    someDot =
      aura radius width opacity circle "blue" plane x y
-}
aura : Float -> Int -> Float -> Shape -> String -> Dot msg
aura radius width opacity shape color =
  viewShape radius (Aura width opacity) shape color


{-| Make a shape with a white border.

    someDot : Svg msg
    someDot =
      disconnected radius width circle "blue" plane x y
-}
disconnected : Float -> Int -> Shape -> String -> Dot msg
disconnected radius width shape color =
  viewShape radius (Disconnected width) shape color


{-| Make a shape with a white core.

    someDot : Svg msg
    someDot =
      empty radius width circle "blue" plane x y
-}
empty : Float -> Int -> Shape -> String -> Dot msg
empty radius width shape color =
  viewShape radius (Empty width) shape color


{-| -}
type alias Shape =
  Internal.Svg.Shape


{-| -}
circle : Shape
circle =
  Circle


{-| -}
triangle : Shape
triangle =
  Triangle


{-| -}
square : Shape
square =
  Square


{-| -}
diamond : Shape
diamond =
  Diamond


{-| -}
plus : Shape
plus =
  Plus


{-| -}
cross : Shape
cross =
  Cross


{-| Series with no interpolation.

    someScatter : Svg msg
    someScatter =
      scatter plane .x .y (full 6 circle "blue") points
-}
scatter : Plane -> (data -> Float) -> (data -> Float) -> (data -> Dot msg) -> List data -> Svg msg
scatter plane toX toY dot data =
  viewSeries plane toX toY dot data (text "-- No interpolation --")


{-| Series with linear interpolation.
-}
linear : Plane -> (data -> Float) -> (data -> Float) -> List (Attribute msg) -> (data -> Dot msg) -> List data -> Svg msg
linear plane toX toY attributes dot data =
  let points = toPoints toX toY data in
  viewSeries plane toX toY dot data <|
    viewInterpolation plane False attributes points (linearInterpolation points)


{-| Area series with linear interpolation.
-}
linearArea : Plane -> (data -> Float) -> (data -> Float) -> List (Attribute msg) -> (data -> Dot msg) -> List data -> Svg msg
linearArea plane toX toY attributes dot data =
  let points = toPoints toX toY data in
  viewSeries plane toX toY dot data <|
      viewInterpolation plane True attributes points (linearInterpolation points)


{-| Series with monotone interpolation.
-}
monotone : Plane -> (data -> Float) -> (data -> Float) -> List (Attribute msg) -> (data -> Dot msg) -> List data -> Svg msg
monotone plane toX toY attributes dot data =
  let points = toPoints toX toY data in
  viewSeries plane toX toY dot data <|
    viewInterpolation plane False attributes points (monotoneInterpolation points)


{-| Area series with monotone interpolation.
-}
monotoneArea : Plane -> (data -> Float) -> (data -> Float) -> List (Attribute msg) -> (data -> Dot msg) -> List data -> Svg msg
monotoneArea plane toX toY attributes dot data =
  let points = toPoints toX toY data in
  viewSeries plane toX toY dot data <|
      viewInterpolation plane True attributes points (monotoneInterpolation points)


-- INTERNAL


viewSeries : Plane -> (data -> Float) -> (data -> Float) -> (data -> Dot msg) -> List data -> Svg msg -> Svg msg
viewSeries plane toX toY dot data interpolation =
  g [ class "elm-charts__serie" ]
    [ interpolation
    , g [ class "elm-charts__dots" ] (List.map (\datum -> dot datum plane (toX datum) (toY datum)) data)
    ]


viewInterpolation : Plane -> Bool -> List (Attribute msg) -> List Point -> List Command -> Svg msg
viewInterpolation plane hasArea userAttributes points commands =
  case ( points, hasArea ) of
    ( [], _ ) ->
      text "-- No data --"

    ( first :: rest, False ) ->
      viewLine plane userAttributes commands first rest

    ( first :: rest, True ) ->
      viewArea plane userAttributes commands first rest


viewLine : Plane -> List (Attribute msg) -> List Command -> Point -> List Point -> Svg msg
viewLine plane userAttributes interpolation first rest =
  let
    commands =
      concat [ Move first.x first.y ] interpolation []

    attributes =
      concat
        [ class "elm-charts__line", stroke pinkStroke ]
        userAttributes
        [ d (description plane commands), fill transparent ]
  in
    path attributes []


viewArea : Plane -> List (Attribute msg) -> List Command -> Point -> List Point -> Svg msg
viewArea plane userAttributes interpolation first rest =
  let
    commands =
      concat
        [ Move first.x (closestToZero plane), Line first.x first.y ]
        interpolation
        [ Line (Maybe.withDefault first (last rest) |> .x) (closestToZero plane) ]

    attributes =
      concat
        [ class "elm-charts__area", stroke pinkStroke ]
        userAttributes
        [ d (description plane commands) ]
  in
    path attributes []



-- LINEAR INTERPOLATION


linearInterpolation : List Point -> List Command
linearInterpolation =
  List.map (\{ x, y } -> Line x y)



-- MONOTONE INTERPOLATION


monotoneInterpolation : List Point -> List Command
monotoneInterpolation points =
  case points of
    p0 :: p1 :: p2 :: rest ->
      let
        nextTangent =
          slope3 p0 p1 p2

        previousTangent =
          slope2 p0 p1 nextTangent
      in
        monotoneCurve p0 p1 previousTangent nextTangent ++
        monotoneNext (p1 :: p2 :: rest) nextTangent

    _ ->
      []


monotoneNext : List Point -> Float -> List Command
monotoneNext points previousTangent =
  case points of
    p0 :: p1 :: p2 :: rest ->
      let
        nextTangent =
          slope3 p0 p1 p2
      in
        monotoneCurve p0 p1 previousTangent nextTangent ++
        monotoneNext (p1 :: p2 :: rest) nextTangent

    [ p0, p1 ] ->
      monotoneCurve p0 p1 previousTangent (slope3 p0 p1 p1)

    _ ->
        []


monotoneCurve : Point -> Point -> Float -> Float -> List Command
monotoneCurve point0 point1 tangent0 tangent1 =
  let
    dx =
      (point1.x - point0.x) / 3
  in
    [ CubicBeziers (point0.x + dx) (point0.y + dx * tangent0) (point1.x - dx) (point1.y - dx * tangent1) point1.x point1.y ]


{-| Calculate the slopes of the tangents (Hermite-type interpolation) based on
 the following paper: Steffen, M. 1990. A Simple Method for Monotonic
 Interpolation in One Dimension
-}
slope3 : Point -> Point -> Point -> Float
slope3 point0 point1 point2 =
  let
    h0 = point1.x - point0.x
    h1 = point2.x - point1.x
    s0h = toH h0 h1
    s1h = toH h1 h0
    s0 = (point1.y - point0.y) / s0h
    s1 = (point2.y - point1.y) / s1h
    p = (s0 * h1 + s1 * h0) / (h0 + h1)
    slope = (sign s0 + sign s1) * (min (min (abs s0) (abs s1)) (0.5 * abs p))
  in
    if isNaN slope then 0 else slope


toH : Float -> Float -> Float
toH h0 h1 =
  if h0 == 0 then
    if h1 < 0 then
      0 * -1
    else
      h1
  else
    h0


{-| Calculate a one-sided slope.
-}
slope2 : Point -> Point -> Float -> Float
slope2 point0 point1 t =
  let
    h =
      point1.x - point0.x
  in
    if h /= 0 then (3 * (point1.y - point0.y) / h - t) / 2 else t


sign : Float -> Float
sign x =
  if x < 0 then
    -1
  else
    1



-- HELPERS


last : List a -> Maybe a
last list =
  List.head (List.drop (List.length list - 1) list)


concat : List a -> List a -> List a -> List a
concat first second third =
  first ++ second ++ third


closestToZero : Plane -> Float
closestToZero plane =
  clamp plane.y.min plane.y.max 0



{-| Place some SVG on specific coordinates.

-}
position : Plane -> Float -> Float -> Float -> Float -> Svg.Attribute msg
position plane x y xOff yOff =
  transform <| "translate(" ++ String.fromFloat (toSVGX plane x + xOff) ++ "," ++ String.fromFloat (toSVGY plane y + yOff) ++ ")"



-- EVENTS


{-| -}
eventCatcher : Plane -> List (Svg.Attribute msg) -> Svg msg
eventCatcher plane events =
  Svg.rect
    (areaAttributes plane ++ events)
    []


{-| Container for your chart, in case you use the `eventCatcher`.
Without this, your coordinates from the events will be wrong!

-}
container : Plane -> List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
container plane attrs =
  Html.div <|
    [ HA.style "position" "relative"
    ] ++ attrs



{-| -}
type alias Point =
  { x : Float
  , y : Float
  }


{-| -}
toPoints : (data -> Float) -> (data -> Float) -> List data -> List Point
toPoints toX toY =
  List.map <| \d -> { x = toX d, y = toY d }


{-| -}
type alias DataPoint data =
  { org : data
  , point : Point
  }


{-| -}
toDataPoints : (data -> Float) -> (data -> Float) -> List data -> List (DataPoint data)
toDataPoints toX toY =
  List.map <| \d -> DataPoint d { x = toX d, y = toY d }



{-| Get the data coordinates nearest to the event.
Returns `Nothing` if you have no data showing.

-}
getNearest : List (DataPoint data) -> Plane -> Point -> Maybe (DataPoint data)
getNearest points plane searchedSvg =
  let searched =
        { x = toCartesianX plane searchedSvg.x
        , y = toCartesianY plane searchedSvg.y
        }
  in
  getNearestHelp points plane searched


{-| Get the data coordinates nearest of the event within the radius
you provide in the first argument. Returns `Nothing` if you have no data showing.

-}
getWithin : Float -> List (DataPoint data) -> Plane -> Point -> Maybe (DataPoint data)
getWithin radius points plane searchedSvg =
    let
      searched =
        { x = toCartesianX plane searchedSvg.x
        , y = toCartesianY plane searchedSvg.y
        }

      keepIfEligible closest =
          if withinRadius plane radius searched closest.point
            then Just closest
            else Nothing
    in
    getNearestHelp points plane searched
      |> Maybe.andThen keepIfEligible


{-| Get the data coordinates horizontally nearest to the event.
-}
getNearestX : List (DataPoint data) -> Plane -> Point -> List (DataPoint data)
getNearestX points plane searchedSvg =
    let
      searched =
        { x = toCartesianX plane searchedSvg.x
        , y = toCartesianY plane searchedSvg.y
        }
    in
    getNearestXHelp points plane searched


{-| Finds the data coordinates horizontally nearest to the event, within the
distance you provide in the first argument.

-}
getWithinX : Float -> List (DataPoint data) -> Plane -> Point -> List (DataPoint data)
getWithinX radius points plane searchedSvg =
    let
      searched =
        { x = toCartesianX plane searchedSvg.x
        , y = toCartesianY plane searchedSvg.y
        }

      keepIfEligible =
          withinRadiusX plane radius searched << .point
    in
    getNearestXHelp points plane searched
      |> List.filter keepIfEligible


{-| A basic tooltip.

      tooltip plane x y
        [ style "font-size" "14px" ]
        [ Html.text "I'm a tooltip!" ]
-}
tooltip : Plane -> Float -> Float -> List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
tooltip plane x y attrs =
    let
        xOff = if isXPastMiddle plane x then -15 else 15
    in
    positionHtml plane x y xOff 0 <|
      [ if isXPastMiddle plane x
          then HA.style "transform" "translate(-100%, -50%)"
          else HA.style "transform" "translate(0, -50%)"
      , HA.style "padding" "5px 10px"
      , HA.style "background" "rgba(255, 255, 255, 0.8)"
      , HA.style "border" "1px solid #EFF2FA"
      , HA.style "border-radius" "3px"
      , HA.style "pointer-events" "none"
      ] ++ attrs


{-| -}
tooltipOnTop : Plane -> Float -> Float -> List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
tooltipOnTop plane x y attrs content =
  let stylesheet =
        """
        .elm-charts__tooltip:before, .elm-charts__tooltip:after {
          content: "";
          position: absolute;
          border-left: 5px solid transparent;
          border-right: 5px solid transparent;
          top: 100%;
          left: 50%;
          margin-left: -5px;
        }

        .elm-charts__tooltip:after{
          border-top: 5px solid white;
          margin-top: -1px;
          z-index: 1;
        }

        .elm-charts__tooltip:before {
          border-top: 5px solid #D8D8D8;
        }

        """

      attributes =
        [ HA.class "elm-charts__tooltip"
        , HA.style "transform" "translate(-50%, -100%)"
        , HA.style "padding" "5px 10px"
        , HA.style "background" "white"
        , HA.style "border" "1px solid #D8D8D8"
        , HA.style "border-radius" "3px"
        , HA.style "pointer-events" "none"
        ] ++ attrs

      children =
        Html.node "style" [] [ Html.text stylesheet ] :: content
  in
    positionHtml plane x y 0 -10 attributes children


{-| Place some Html on specific coordinates. You must wrap your chart
in `container` for it to work! Remember also to put your html elements outside
your `svg` element, otherwise they won't work!

      positionHtml plane x y xOff yOff
        [ style "font-size" "14px" ]
        [ text "Hello!" ]

-}
positionHtml : Plane -> Float -> Float -> Float -> Float -> List (Html.Attribute msg) -> List (Html msg) -> Html msg
positionHtml plane x y xOff yOff attrs content =
    let
        xPercentage = (toSVGX plane x + xOff) * 100 / plane.x.length
        yPercentage = (toSVGY plane y + yOff) * 100 / plane.y.length

        posititonStyles =
            [ HA.style "left" (String.fromFloat xPercentage ++ "%")
            , HA.style "top" (String.fromFloat yPercentage ++ "%")
            , HA.style "margin-right" "-400px"
            , HA.style "position" "absolute"
            ]
    in
    Html.div (posititonStyles ++ attrs) content


{-| Is x past the middle of the chart?

-}
isXPastMiddle : Plane -> Float -> Bool
isXPastMiddle plane x =
    x - plane.x.min > plane.x.max - x


{-| Get the midmost y coordinate.

-}
middleOfY : Plane -> Float
middleOfY plane =
    plane.y.min + (plane.y.max - plane.y.min) / 2


{-| Get the midmost x coordinate.

-}
middleOfX : Plane -> Float
middleOfX plane =
    plane.x.min + (plane.x.max - plane.x.min) / 2




-- COORDINATE HELPERS


getNearestHelp : List (DataPoint data) -> Plane -> Point -> Maybe (DataPoint data)
getNearestHelp points plane searched =
  let
      distance_ =
          distance plane searched

      getClosest point closest =
          if distance_ closest.point < distance_ point.point
            then closest
            else point
  in
  withFirst points (List.foldl getClosest)


getNearestXHelp : List (DataPoint data) -> Plane -> Point -> List (DataPoint data)
getNearestXHelp points plane searched =
  let
      distanceX_ =
          distanceX plane searched

      getClosest point allClosest =
        case List.head allClosest of
          Just closest ->
              if closest.point.x == point.point.x then point :: allClosest
              else if distanceX_ closest.point > distanceX_ point.point then [ point ]
              else allClosest

          Nothing ->
            [ point ]
  in
  List.foldl getClosest [] points


distanceX : Plane -> Point -> Point -> Float
distanceX plane searched dot =
    abs <| toSVGX plane dot.x - toSVGX plane searched.x


distanceY : Plane -> Point -> Point -> Float
distanceY plane searched dot =
    abs <| toSVGY plane dot.y - toSVGY plane searched.y


distance : Plane -> Point -> Point -> Float
distance plane searched dot =
    sqrt <| distanceX plane searched dot ^ 2 + distanceY plane searched dot ^ 2


withinRadius : Plane -> Float -> Point -> Point -> Bool
withinRadius plane radius searched dot =
    distance plane searched dot <= radius


withinRadiusX : Plane -> Float -> Point -> Point -> Bool
withinRadiusX plane radius searched dot =
    distanceX plane searched dot <= radius



-- DECODER


{-| Decode position of mouse when tracking events. The `Plane` may
change due to size changes of the viewport, so make sure to use the
one given in the second argument. Also, make sure to wrap your chart
in `container` otherwise your read coordinates maybe wrong!

-}
decodePoint : Plane -> (Plane -> Point -> msg) -> Json.Decoder msg
decodePoint ({x, y} as plane) toMsg =
  let
    handle mouseX mouseY { left, top, height, width } =
      let
        widthPercent = width / plane.x.length
        heightPercent = height / plane.y.length

        newPlane =
          { x =
              { x | length = width
              , marginLower = plane.x.marginLower * widthPercent
              , marginUpper = plane.x.marginUpper * widthPercent
              }
          , y =
              { y | length = height
              , marginLower = plane.y.marginLower * heightPercent
              , marginUpper = plane.y.marginUpper * heightPercent
              }
          }
      in
      toMsg newPlane { x = mouseX - left, y = mouseY - top }
  in
  Json.map3 handle
    (Json.field "pageX" Json.float)
    (Json.field "pageY" Json.float)
    (DOM.target decodePosition)


decodePosition : Json.Decoder DOM.Rectangle
decodePosition =
  Json.oneOf
    [ DOM.boundingClientRect
    , Json.lazy (\_ -> DOM.parentElement decodePosition)
    ]



-- HELPERS


areaAttributes : Plane -> List (Svg.Attribute msg)
areaAttributes plane =
  [ Attributes.x (String.fromFloat plane.x.marginLower)
  , Attributes.y (String.fromFloat plane.y.marginUpper)
  , Attributes.width (String.fromFloat (plane.x.length - plane.x.marginLower - plane.x.marginUpper))
  , Attributes.height (String.fromFloat (plane.y.length - plane.y.marginLower - plane.y.marginUpper))
  , Attributes.fill "transparent"
  ]


{-| -}
withFirst : List a -> (a -> List a -> b) -> Maybe b
withFirst stuff process =
  case stuff of
    first :: rest ->
      Just (process first rest)

    _ ->
      Nothing