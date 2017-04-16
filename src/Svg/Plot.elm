module Svg.Plot exposing (Dot, dot, clear, viewScatter, viewLinear, viewMonotone)

{-| First of all: If you're looking to a plotting library
 use [elm-plot](https://github.com/terezka/elm-plot) instead! This library is not
 made to be userfriendly. If you feel like you're missing something in elm-plot,
 you're welcome to open an issue in the repo and I'll see what I can do
 to accommodate your needs.

 That said, here are some plotting helpers.

# Dots
@docs Dot, dot, clear

# Views
@docs viewScatter, viewLinear, viewMonotone

-}

import Svg exposing (Svg, Attribute, g, path, text)
import Svg.Attributes exposing (class, width, height, stroke, fill, d, transform)
import Svg.Coordinates exposing (Plane, Point, place)
import Svg.Commands exposing (..)


{-| -}
type alias Dot msg =
  { view : Maybe (Svg msg)
  , x : Float
  , y : Float
  }


{-| -}
clear : Point -> Dot msg
clear { x, y } =
  Dot Nothing x y


{-| -}
dot : Svg msg -> Point -> Dot msg
dot view { x, y } =
  Dot (Just view) x y


{-| -}
viewScatter : Plane -> List (Dot msg) -> data -> Svg msg
viewScatter plane dots =
  viewSeries plane dots (text "No interpolation!")


{-| -}
viewLinear : Plane -> List (Attribute msg) -> List (Dot msg) -> Svg msg
viewLinear plane attributes dots =
  viewSeries plane dots (viewInterpolation plane attributes dots (linearInterpolation dots))


{-| -}
viewMonotone : Plane -> List (Attribute msg) -> List (Dot msg) -> Svg msg
viewMonotone plane attributes dots =
  viewSeries plane dots (viewInterpolation plane attributes dots (monotoneXInterpolation dots))


viewSeries : Plane -> List (Dot msg) -> Svg msg -> Svg msg
viewSeries plane dots interpolation =
  g [ class "elm-plot__series" ]
    [ interpolation
    , g [ class "elm-plot__dots" ] (List.map (viewDot plane) dots)
    ]


viewInterpolation : Plane -> List (Attribute msg) -> List (Dot msg) -> List Command -> Svg msg
viewInterpolation plane userAttributes dots interpolationCommands =
  case ( dots, hasFill userAttributes ) of
    ( [], _ ) ->
      text "No data!"

    ( first :: rest, False ) ->
      viewLine plane userAttributes interpolationCommands first rest

    ( first :: rest, True ) ->
      viewArea plane userAttributes interpolationCommands first rest


viewLine : Plane -> List (Attribute msg) -> List Command -> Dot msg -> List (Dot msg) -> Svg msg
viewLine plane userAttributes interpolationCommands first rest =
  let
    commands =
      concat [ Move first.x first.y ] interpolationCommands []

    attributes =
      concat
        [ class "elm-plot__line", stroke "pink" ]
        userAttributes
        [ d (description plane commands), fill "transparent" ]
  in
    path attributes []


viewArea : Plane -> List (Attribute msg) -> List Command -> Dot msg -> List (Dot msg) -> Svg msg
viewArea plane userAttributes interpolationCommands first rest =
  let
    commands =
      concat
        [ Move first.x (closestToZero plane), Line first.x first.y ]
        interpolationCommands
        [ Line (Maybe.withDefault first (last rest) |> .x) (closestToZero plane) ]

    attributes =
      concat
        [ class "elm-plot__area", stroke "pink", fill "lightpink" ]
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


monotoneXInterpolation : List (Dot view) -> List Command
monotoneXInterpolation points =
    case points of
      p0 :: p1 :: p2 :: rest ->
        let
          tangent1 =
            slope3 p0 p1 p2

          tangent0 =
            slope2 p0 p1 tangent1
        in
          monotoneXCurve p0 p1 tangent0 tangent1 ++ monotoneXNext (p1 :: p2 :: rest) tangent1 []

      _ ->
        []


monotoneXNext : List (Dot view) -> Float -> List Command -> List Command
monotoneXNext points tangent0 commands =
  case points of
    p0 :: p1 :: p2 :: rest ->
      let
        tangent1 =
          slope3 p0 p1 p2

        nextCommands =
          commands ++ monotoneXCurve p0 p1 tangent0 tangent1
      in
        monotoneXNext (p1 :: p2 :: rest) tangent1 nextCommands

    [ p1, p2 ] ->
      let
        tangent1 =
          slope3 p1 p2 p2
      in
        commands ++ monotoneXCurve p1 p2 tangent0 tangent1

    _ ->
        commands


monotoneXCurve : (Dot view) -> (Dot view) -> Float -> Float -> List Command
monotoneXCurve point0 point1 tangent0 tangent1 =
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


{- Sorry, Evan :C -}
hasFill : List (Attribute msg) -> Bool
hasFill attributes =
  List.any (toString >> String.contains "realKey = \"fill\"") attributes


concat : List a -> List a -> List a -> List a
concat first second third =
  first ++ second ++ third


closestToZero : Plane -> Float
closestToZero plane =
  clamp plane.y.min plane.y.max 0
