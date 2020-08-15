module Svg.Chart
  exposing
    ( Dot, clear, empty, disconnected, aura, full
    , circle, triangle, square, diamond, plus, cross
    , scatter, linear, linearArea, monotone, monotoneArea
    , Bar, bar, bars, histogram
    , line, horizontal, vertical, fullHorizontal, fullVertical
    , xTicks, xTick, yTicks, yTick
    , xLabels, yLabels, xLabel, yLabel
    )


{-| This module contains higher-level SVG plotting elements.

# Series

## Dots
@docs Dot, clear, empty, disconnected, aura, full
@docs circle, triangle, square, diamond, plus, cross

## Interpolation
@docs scatter, linear, linearArea, monotone, monotoneArea

# Bar charts
@docs Bar, bar, bars, histogram

# Straight lines
@docs line, fullHorizontal, fullVertical, horizontal, vertical

## Ticks
ProTip: Passing a negative value as the height/width of a tick renders it
mirrored on the other side of the axis!

@docs xTick, xTicks, yTick, yTicks

## Labels

@docs xLabel, xLabels, yLabel, yLabels


-}

import Svg exposing (Svg, Attribute, g, path, rect, text)
import Svg.Attributes as Attributes exposing (class, width, height, stroke, fill, d, transform)
import Svg.Coordinates exposing (Plane, place, toSVGX, toSVGY, placeWithOffset)
import Svg.Commands exposing (..)
import Internal.Colors exposing (..)
import Internal.Svg exposing (..)



-- BARS


{-| -}
type Bar msg =
  Bar (List (Attribute msg)) Float


{-| -}
bar : List (Attribute msg) -> Float -> Bar msg
bar =
  Bar


{-| You can draw a bar chart like this:

    main : Svg msg
    main =
      svg
        [ width (String.fromFloat plane.x.length)
        , height (String.fromFloat plane.y.length)
        ]
        [ bars plane 0.8
            [ bar [ fill "red" ] << Tuple.first
            , bar [ fill "blue" ] << Tuple.second
            ]
            [ ( 2, 3 ), ( 5, 1 ), ( 1, 5 ) ]
        ]

Note on `width`: The width takes catersian units, however, should you have
a width in SVG units, you can use `Svg.Coordinates.scaleCartesian` to
translate it into cartesian units.
-}
bars : Plane -> Float -> List (data -> Bar msg) -> List data -> Svg msg
bars plane width toYs data =
  g [ class "elm-charts__bars" ] (List.indexedMap (viewBars plane width toYs) data)


viewBars : Plane -> Float -> List (data -> Bar msg) -> Int -> data -> Svg msg
viewBars plane width toYs groupIndex data =
  let
    barWidth =
      width / toFloat (List.length toYs)

    indexOffset index =
      toFloat index - (toFloat (List.length toYs) / 2)

    x index =
      toFloat groupIndex + 1 + barWidth * indexOffset index

    viewGroupBar index toBar =
      viewBar plane barWidth (x index) (toBar data)
  in
    g [ class "elm-charts__bar" ] (List.indexedMap viewGroupBar toYs)



-- HISTOGRAM


{-| Make a histogram.

    main : Svg msg
    main =
      svg
        [ width (String.fromFloat plane.x.length)
        , height (String.fromFloat plane.y.length)
        ]
        [ histogram plane 1 1 (bar [ stroke blueStroke, fill blueFill ]) [ 1, 2, 3, 6, 8, 9, 6, 4, 2, 1 ] ]
-}
histogram : Plane -> Float -> Float -> (data -> Bar msg) -> List data -> Svg msg
histogram plane intervalBegin interval toBar data =
  let
    x index =
      intervalBegin + toFloat index * interval

    viewHistogramBar index datum =
      viewBar plane interval (x index) (toBar datum)
  in
    g [ class "elm-charts__histogram" ] (List.indexedMap viewHistogramBar data)



-- BARS INTERNAL


viewBar : Plane -> Float -> Float -> Bar msg -> Svg msg
viewBar plane width x (Bar customAttributes y) =
  let
    commands =
      [ Move x (closestToZero plane)
      , Line x y
      , Line (x + width) y
      , Line (x + width) (closestToZero plane)
      ]

    attributes =
      concat
        [ stroke pinkStroke, fill pinkFill ]
        customAttributes
        [ d (description plane commands) ]
  in
    path attributes []



-- STRAIGHT LINES


{-| Renders a line.

    myLine : Svg msg
    myLine =
      horizontal plane [ stroke "pink" ] x0 y0 x1 y1
-}
line : Plane -> List (Attribute msg) -> Float -> Float -> Float -> Float -> Svg msg
line plane userAttributes x1 y1 x2 y2 =
  let
    attributes =
      concat
        [ stroke darkGrey ]
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
        [ stroke darkGrey ]
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
        [ stroke darkGrey ]
        userAttributes
        [ d (description plane [ Move x y1, Line x y1, Line x y2 ]) ]
  in
    path attributes []


{-| Renders a horizontal line with the full length of the range.

    myXAxisOrGridLine : Svg msg
    myXAxisOrGridLine =
      fullHorizontal plane [] yPosition
-}
fullHorizontal : Plane -> List (Attribute msg) -> Float -> Svg msg
fullHorizontal plane userAttributes y =
  horizontal plane userAttributes y plane.x.min plane.x.max


{-| Renders a vertical line with the full length of the domain.

    myYAxisOrGridLine : Svg msg
    myYAxisOrGridLine =
      fullVertical plane [] xPosition
-}
fullVertical : Plane -> List (Attribute msg) -> Float -> Svg msg
fullVertical plane userAttributes x =
  vertical plane userAttributes x plane.y.min plane.y.max


{-| Renders ticks for the horizontal axis.

    horizontalTicks : Svg msg
    horizontalTicks =
      xTicks plane height [ stroke "pink" ] axisYCoordinate tickPositions
-}
xTicks : Plane -> Int -> List (Attribute msg) -> Float -> List Float -> Svg msg
xTicks plane height userAttributes y xs =
  g [ class "elm-charts__x-ticks" ] (List.map (xTick plane height userAttributes y) xs)


{-| Renders a single tick for the horizontal axis.
-}
xTick : Plane -> Int -> List (Attribute msg) -> Float -> Float -> Svg msg
xTick plane height userAttributes y x =
  let
    attributes =
      concat
        [ class "elm-charts__tick", stroke darkGrey ]
        userAttributes
        [ Attributes.x1 <| String.fromFloat (toSVGX plane x)
        , Attributes.x2 <| String.fromFloat (toSVGX plane x)
        , Attributes.y1 <| String.fromFloat (toSVGY plane y)
        , Attributes.y2 <| String.fromFloat (toSVGY plane y + toFloat height)
        ]
  in
    Svg.line attributes []


{-| Renders ticks for the vertical axis.

    verticalTicks : Svg msg
    verticalTicks =
      yTicks plane width [ stroke "pink" ] axisXCoordinate tickPositions
-}
yTicks : Plane -> Int -> List (Attribute msg) -> Float -> List Float -> Svg msg
yTicks plane width userAttributes x ys =
  g [ class "elm-charts__y-ticks" ] (List.map (yTick plane width userAttributes x) ys)


{-| Renders a single tick for the vertical axis.
-}
yTick : Plane -> Int -> List (Attribute msg) -> Float -> Float -> Svg msg
yTick plane width userAttributes x y =
  let
    attributes =
      concat
        [ class "elm-charts__tick", stroke darkGrey ]
        userAttributes
        [ Attributes.x1 <| String.fromFloat (toSVGX plane x)
        , Attributes.x2 <| String.fromFloat (toSVGX plane x - toFloat width)
        , Attributes.y1 <| String.fromFloat (toSVGY plane y)
        , Attributes.y2 <| String.fromFloat (toSVGY plane y)
        ]
  in
    Svg.line attributes []


{-| Renders labels for the horizontal axis.

    horizontalLabels : Svg msg
    horizontalLabels =
      xLabels plane (xLabel "blue" String.fromFloat) axisYCoordinate tickPositions
-}
xLabels : Plane -> (Plane -> Float -> Float -> Svg msg) -> Float -> List Float -> Svg msg
xLabels plane toLabel y xs =
  g [ class "elm-charts__x-labels" ] (List.map (toLabel plane y) xs)


{-| Renders a label for the horizontal axis.

    horizontalLabel : Svg msg
    horizontalLabel =
      xLabel "blue" String.fromFloat plane y x
-}
xLabel : String -> (Float -> String) -> Plane -> Float -> Float -> Svg msg
xLabel color toString plane y x =
  Svg.g
    [ placeWithOffset plane x y 0 20
    , Attributes.style "text-anchor: middle;"
    ]
    [ viewLabel color (toString x) ]


{-| Renders labels for the vertical axis.

    verticalLabels : Svg msg
    verticalLabels =
      yLabels plane (yLabel "blue" String.fromFloat) axisXCoordinate tickPositions
-}
yLabels : Plane -> (Plane -> Float -> Float -> Svg msg) -> Float -> List Float -> Svg msg
yLabels plane toLabel x ys =
  g [ class "elm-charts__y-labels" ] (List.map (toLabel plane x) ys)


{-| Renders a label for the vertical axis.

    verticalLabel : Svg msg
    verticalLabel =
      yLabel "blue" String.fromFloat plane x y
-}
yLabel : String -> (Float -> String) -> Plane -> Float -> Float -> Svg msg
yLabel color toString plane x y =
  Svg.g
    [ placeWithOffset plane x y -10 5
    , Attributes.style "text-anchor: end;"
    ]
    [ viewLabel color (toString y) ]


viewLabel : String -> String -> Svg msg
viewLabel color string =
  Svg.text_
    [ Attributes.fill color
    , Attributes.style "pointer-events: none;"
    ]
    [ Svg.tspan [] [ Svg.text string ] ]


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
scatter : Plane -> (data -> Float) -> (data -> Float) -> Dot msg -> List data -> Svg msg
scatter plane toX toY dot data =
  viewSeries plane toX toY dot data (text "-- No interpolation --")


{-| Series with linear interpolation.
-}
linear : Plane -> (data -> Float) -> (data -> Float) -> List (Attribute msg) -> Dot msg -> List data -> Svg msg
linear plane toX toY attributes dot data =
  let points = toPoints toX toY data in
  viewSeries plane toX toY dot data <|
    viewInterpolation plane False attributes points (linearInterpolation points)


{-| Area series with linear interpolation.
-}
linearArea : Plane -> (data -> Float) -> (data -> Float) -> List (Attribute msg) -> Dot msg -> List data -> Svg msg
linearArea plane toX toY attributes dot data =
  let points = toPoints toX toY data in
  viewSeries plane toX toY dot data <|
      viewInterpolation plane True attributes points (linearInterpolation points)


{-| Series with monotone interpolation.
-}
monotone : Plane -> (data -> Float) -> (data -> Float) -> List (Attribute msg) -> Dot msg -> List data -> Svg msg
monotone plane toX toY attributes dot data =
  let points = toPoints toX toY data in
  viewSeries plane toX toY dot data <|
    viewInterpolation plane False attributes points (monotoneInterpolation points)


{-| Area series with monotone interpolation.
-}
monotoneArea : Plane -> (data -> Float) -> (data -> Float) -> List (Attribute msg) -> Dot msg -> List data -> Svg msg
monotoneArea plane toX toY attributes dot data =
  let points = toPoints toX toY data in
  viewSeries plane toX toY dot data <|
      viewInterpolation plane True attributes points (monotoneInterpolation points)


-- INTERNAL


type alias Point =
  { x : Float
  , y : Float
  }


toPoints : (data -> Float) -> (data -> Float) -> List data -> List Point
toPoints toX toY data =
  List.map (\datum -> Point (toX datum) (toY datum)) data


viewSeries : Plane -> (data -> Float) -> (data -> Float) -> Dot msg -> List data -> Svg msg -> Svg msg
viewSeries plane toX toY dot data interpolation =
  g [ class "elm-charts__series" ]
    [ interpolation
    , g [ class "elm-charts__dots" ] (List.map (\datum -> dot plane (toX datum) (toY datum)) data)
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


translate : Plane -> Float -> Float -> Float -> Float -> Svg.Attribute msg
translate plane x y xOff yOff =
  transform <| "translate(" ++ String.fromFloat (toSVGX plane x + xOff) ++ "," ++ String.fromFloat (toSVGY plane y + yOff) ++ ")"


