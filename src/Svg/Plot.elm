module Svg.Plot
  exposing
    ( Dot
    , dot
    , clear
    , scatter
    , linear
    , monotone
    , Bar
    , Groups
    , grouped
    , Histogram
    , histogram
    , horizontal
    , vertical
    , fullHorizontal
    , fullVertical
    , xTicks
    , xTick
    , yTicks
    , yTick
    )



{-| _Disclaimer:_ If you're looking for a plotting library, then please
use [elm-plot](https://github.com/terezka/elm-plot) instead, as this library is not
made to be user friendly. If you feel like you're missing something in elm-plot,
you're welcome to open an issue in the repo and I'll see what I can do
to accommodate your needs!

---

This module contains higher-level SVG plotting elements.


# Series

## Dots
@docs Dot, dot, clear

## Interpolation
@docs scatter, linear, monotone

## Note on usage
These elements render a line series if no `fill` attribute is added!

    areaSeries : Svg msg
    areaSeries =
      monotone plane [ fill "pink" ] dots

    lineSeries : Svg msg
    lineSeries =
      monotone plane [] dots

# Bars
@docs Bar

# Groups
@docs Groups, grouped

## Histograms
@docs Histogram, histogram

# Straight lines
@docs fullHorizontal, fullVertical, horizontal, vertical

## Ticks
ProTip: Passing a negative value as the height/width of a tick renders it
mirrored on the other side of the axis!

@docs xTick, xTicks, yTick, yTicks

-}

import Svg exposing (Svg, Attribute, g, path, rect, text)
import Svg.Attributes as Attributes exposing (class, width, height, stroke, fill, d, transform)
import Svg.Coordinates exposing (Plane, Point, place, toSVGX, toSVGY)
import Svg.Commands exposing (..)
import Colors exposing (..)



-- BARS


{-| -}
type alias Bar msg =
  { attributes : List (Attribute msg)
  , y : Float
  }


{-| -}
type alias Groups msg =
  { groups : List (List (Bar msg))
  , width : Float
  }


{-| You can draw a bar chart like this:

    group : List Float -> List (Bar msg)
    group =
      List.map (Bar [ stroke "pink", fill "lightpink" ])

    groups : Groups msg
    groups =
       { groups = List.map group [ [ 2, 3, 1 ], [ 5, 1, 4 ], [ 1, 5, 3 ] ]
       , width = 0.8
       }

    main : Svg msg
    main =
      svg
        [ width (toString plane.x.length)
        , height (toString plane.y.length)
        ]
        [ grouped plane groups ]

Note on `width`: The width takes catersian units, however, should you have
a width in SVG units, you can use `Svg.Coordinates.scaleCartesian` to
translate it into cartesian units.
-}
grouped : Plane -> Groups msg -> Svg msg
grouped plane { width, groups } =
  g [ class "elm-plot__grouped" ] (List.indexedMap (viewGroup plane width) groups)


viewGroup : Plane -> Float -> Int -> List (Bar msg) -> Svg msg
viewGroup plane width groupIndex bars =
  let
    barWidth =
      width / toFloat (List.length bars)

    indexOffset index =
      toFloat index - (toFloat (List.length bars) / 2)

    x index =
      toFloat groupIndex + 1 + barWidth * indexOffset index

    viewGroupBar index bar =
      viewBar plane barWidth (x index) bar
  in
    g [ class "elm-plot__group" ] (List.indexedMap viewGroupBar bars)



-- HISTOGRAM


{-| The bars are the class frequencies and the interval is the class interval's
upper limit minus lower limit. Right now, you can only have equal class intervals,
but I might add unequal support later!

[What is going on with all these words?](http://onlinestatbook.com/2/graphing_distributions/histograms.html)
-}
type alias Histogram msg =
  { bars : List (Bar msg)
  , interval : Float
  , intervalBegin : Float
  }


{-|

    frequencies : List Float
    frequencies =
      [ 1, 2, 3, 6, 8, 9, 6, 4, 2, 1 ]

    testScores : Histogram msg
    testScores =
      { bars = List.map (Bar [ stroke blueStroke, fill blueFill ]) frequencies
      , interval = 1
      }

    main : Svg msg
    main =
      svg
        [ width (toString plane.x.length)
        , height (toString plane.y.length)
        ]
        [ histogram plane testScores ]
-}
histogram : Plane -> Histogram msg -> Svg msg
histogram plane { bars, intervalBegin, interval } =
  let
    x index =
      intervalBegin + toFloat index * interval

    viewHistogramBar index bar =
      viewBar plane interval (x index) bar
  in
    g [ class "elm-plot__histogram" ] (List.indexedMap viewHistogramBar bars)



-- BARS INTERNAL


viewBar : Plane -> Float -> Float -> Bar msg -> Svg msg
viewBar plane width x bar =
  let
    commands =
      [ Move x (closestToZero plane)
      , Line x bar.y
      , Line (x + width) bar.y
      , Line (x + width) (closestToZero plane)
      ]

    attributes =
      concat
        [ stroke pinkStroke, fill pinkFill ]
        bar.attributes
        [ d (description plane commands) ]
  in
    path attributes []



-- STRAIGHT LINES


{-| Renders a horizontal line.

    myLine : Svg msg
    myLine =
      horizontal plane [ stroke pink ] y x0 x1

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
fullVertical plane userAttributes y =
  vertical plane userAttributes y plane.y.min plane.y.max


{-| Renders ticks for the horizontal axis.

    horizontalTicks : Svg msg
    horizontalTicks =
      xTicks plane height [ stroke "pink" ] axisYCoordinate tickPositions
-}
xTicks : Plane -> Int -> List (Attribute msg) -> Float -> List Float -> Svg msg
xTicks plane height userAttributes y xs =
  g [ class "elm-plot__x-ticks" ] (List.map (xTick plane height userAttributes y) xs)


{-| Renders a single tick for the horizontal axis.
-}
xTick : Plane -> Int -> List (Attribute msg) -> Float -> Float -> Svg msg
xTick plane height userAttributes y x =
  let
    attributes =
      concat
        [ class "elm-plot__tick", stroke darkGrey ]
        userAttributes
        [ Attributes.x1 <| toString (toSVGX plane x)
        , Attributes.x2 <| toString (toSVGX plane x)
        , Attributes.y1 <| toString (toSVGY plane y)
        , Attributes.y2 <| toString (toSVGY plane y + toFloat height)
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
  g [ class "elm-plot__y-ticks" ] (List.map (yTick plane width userAttributes x) ys)


{-| Renders a single tick for the vertical axis.
-}
yTick : Plane -> Int -> List (Attribute msg) -> Float -> Float -> Svg msg
yTick plane width userAttributes x y =
  let
    attributes =
      concat
        [ class "elm-plot__tick",stroke darkGrey ]
        userAttributes
        [ Attributes.x1 <| toString (toSVGX plane x)
        , Attributes.x2 <| toString (toSVGX plane x - toFloat width)
        , Attributes.y1 <| toString (toSVGY plane y)
        , Attributes.y2 <| toString (toSVGY plane y)
        ]
  in
    Svg.line attributes []



-- SERIES


{-| -}
type alias Dot msg =
  { view : Maybe (Svg msg)
  , x : Float
  , y : Float
  }


{-| A dot without visual representation.
-}
clear : Point -> Dot msg
clear { x, y } =
  Dot Nothing x y


{-| An dot with a view.
-}
dot : Svg msg -> Point -> Dot msg
dot view { x, y } =
  Dot (Just view) x y


{-| Series with no interpolation.
-}
scatter : Plane -> List (Dot msg) -> Svg msg
scatter plane dots =
  viewSeries plane dots (text "-- No interpolation --")


{-| Series with linear interpolation.
-}
linear : Plane -> List (Attribute msg) -> List (Dot msg) -> Svg msg
linear plane attributes dots =
  viewSeries plane dots <|
    viewInterpolation plane attributes dots (linearInterpolation dots)


{-| Series with monotone interpolation.
-}
monotone : Plane -> List (Attribute msg) -> List (Dot msg) -> Svg msg
monotone plane attributes dots =
  viewSeries plane dots <|
    viewInterpolation plane attributes dots (monotoneInterpolation dots)



-- INTERNAL


viewSeries : Plane -> List (Dot msg) -> Svg msg -> Svg msg
viewSeries plane dots interpolation =
  g [ class "elm-plot__series" ]
    [ interpolation
    , g [ class "elm-plot__dots" ] (List.map (viewDot plane) dots)
    ]


viewInterpolation : Plane -> List (Attribute msg) -> List (Dot msg) -> List Command -> Svg msg
viewInterpolation plane userAttributes dots commands =
  case ( dots, hasFill userAttributes ) of
    ( [], _ ) ->
      text "-- No data --"

    ( first :: rest, False ) ->
      viewLine plane userAttributes commands first rest

    ( first :: rest, True ) ->
      viewArea plane userAttributes commands first rest


viewLine : Plane -> List (Attribute msg) -> List Command -> Dot msg -> List (Dot msg) -> Svg msg
viewLine plane userAttributes interpolation first rest =
  let
    commands =
      concat [ Move first.x first.y ] interpolation []

    attributes =
      concat
        [ class "elm-plot__line", stroke pinkStroke ]
        userAttributes
        [ d (description plane commands), fill transparent ]
  in
    path attributes []


viewArea : Plane -> List (Attribute msg) -> List Command -> Dot msg -> List (Dot msg) -> Svg msg
viewArea plane userAttributes interpolation first rest =
  let
    commands =
      concat
        [ Move first.x (closestToZero plane), Line first.x first.y ]
        interpolation
        [ Line (Maybe.withDefault first (last rest) |> .x) (closestToZero plane) ]

    attributes =
      concat
        [ class "elm-plot__area", stroke pinkStroke ]
        userAttributes
        [ d (description plane commands) ]
  in
    path attributes []


viewDot : Plane -> Dot msg -> Svg msg
viewDot plane dot =
  case dot.view of
    Nothing ->
      text ""

    Just view ->
      g [ place plane (point dot) ] [ view ]


point : Dot msg -> Point
point { x, y } =
  Point x y



-- LINEAR INTERPOLATION


linearInterpolation : List (Dot msg) -> List Command
linearInterpolation =
  List.map (\{ x, y } -> Line x y)



-- MONOTONE INTERPOLATION


monotoneInterpolation : List (Dot view) -> List Command
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


monotoneNext : List (Dot view) -> Float -> List Command
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


monotoneCurve : (Dot view) -> (Dot view) -> Float -> Float -> List Command
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
slope3 : (Dot view) -> (Dot view) -> (Dot view) -> Float
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
slope2 : (Dot view) -> (Dot view) -> Float -> Float
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


{- Sorry, Evan -}
hasFill : List (Attribute msg) -> Bool
hasFill attributes =
  List.any (toString >> String.contains "realKey = \"fill\"") attributes


concat : List a -> List a -> List a -> List a
concat first second third =
  first ++ second ++ third


closestToZero : Plane -> Float
closestToZero plane =
  clamp plane.y.min plane.y.max 0
