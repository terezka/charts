module Svg.Plot exposing (line, area, Interpolation(..))

{-| First of all: If you're looking to a plotting library
 use [elm-plot](https://github.com/terezka/elm-plot) instead! If you feel
 like you're missing something in that library, you should just open an issue
 in that repo and I'll see what I can do to accommodate your needs.

 That said, this is raw plotting elements.

@docs line, area, Interpolation

-}

import Svg exposing (Svg, Attribute, path, text)
import Svg.Attributes exposing (width, height, stroke, fill, d, transform)
import Svg.Coordinates exposing (Plane, Point, toSVGX, toSVGY)


{-| -}
line : List (Attribute msg) -> Interpolation -> Plane -> List Point -> Svg msg
line attributes interpolation plane points =
  case points of
    first :: rest ->
      let
        commands =
          Move first.x first.y :: interpolate interpolation (first :: rest)
      in
        path (stroke "pink" :: attributes ++ [ fill "transparent", d (description plane commands) ]) []

    _ ->
      text "Missing data passed to this line element."


{-| -}
area : List (Attribute msg) -> Interpolation -> Plane -> List Point -> Svg msg
area attributes interpolation plane points =
  case points of
    first :: rest ->
      let
        last =
          List.drop (List.length rest - 1) rest
            |> List.head
            |> Maybe.withDefault first

        yOrigin =
          clamp plane.y.min plane.y.max 0

        commands =
          [ Move first.x yOrigin, Line first.x first.y ]
          ++ interpolate interpolation (first :: rest)
          ++ [ Line last.x yOrigin ]
      in
        path (stroke "pink" :: fill "lightpink" :: attributes ++ [ d (description plane commands) ]) []

    _ ->
      text "Missing data passed to this area element."



-- INTERPOLATION


{-| -}
type Interpolation
  = Linear
  | Monotone


interpolate : Interpolation -> List Point -> List Command
interpolate interpolation points =
  case interpolation of
    Linear ->
      List.map (\{ x, y } -> Line x y) points

    Monotone ->
      monotoneX points



-- PATH COMMANDS


type Command
  = Move Float Float
  | Line Float Float
  | CubicBeziers Float Float Float Float Float Float
  | CubicBeziersShort Float Float Float Float
  | QuadraticBeziers Float Float Float Float
  | QuadraticBeziersShort Float Float
  | Arc Float Float Bool Bool Bool Float Float
  | Close


description : Plane -> List Command -> String
description plane commands =
  joinCommands (List.map (translate plane >> stringCommand) commands)


translate : Plane -> Command -> Command
translate plane command =
  case command of
    Move x y ->
      Move (toSVGX plane x) (toSVGY plane y)

    Line x y ->
      Line (toSVGX plane x) (toSVGY plane y)

    CubicBeziers cx1 cy1 cx2 cy2 x y ->
      CubicBeziers (toSVGX plane cx1) (toSVGY plane cy1) (toSVGX plane cx2) (toSVGY plane cy2) (toSVGX plane x) (toSVGY plane y)

    CubicBeziersShort cx1 cy1 x y ->
      CubicBeziersShort (toSVGX plane cx1) (toSVGY plane cy1) (toSVGX plane x) (toSVGY plane y)

    QuadraticBeziers cx1 cy1 x y ->
      QuadraticBeziers (toSVGX plane cx1) (toSVGY plane cy1) (toSVGX plane x) (toSVGY plane y)

    QuadraticBeziersShort x y ->
      QuadraticBeziersShort (toSVGX plane x) (toSVGY plane y)

    Arc rx ry xAxisRotation largeArcFlag sweepFlag x y ->
      Arc (toSVGX plane rx) (toSVGY plane ry) xAxisRotation largeArcFlag sweepFlag (toSVGX plane x) (toSVGY plane y)

    Close ->
      Close


stringCommand : Command -> String
stringCommand command =
  case command of
    Move x y ->
      "M" ++ stringPoint (Point x y)

    Line x y ->
      "L" ++ stringPoint (Point x y)

    CubicBeziers cx1 cy1 cx2 cy2 x y ->
      "C" ++ stringPoints [ (Point cx1 cy1), (Point cx2 cy2), (Point x y) ]

    CubicBeziersShort cx1 cy1 x y ->
      "Q" ++ stringPoints [ (Point cx1 cy1), (Point x y) ]

    QuadraticBeziers cx1 cy1 x y ->
      "Q" ++ stringPoints [ (Point cx1 cy1), (Point x y) ]

    QuadraticBeziersShort x y ->
      "T" ++ stringPoint (Point x y)

    Arc rx ry xAxisRotation largeArcFlag sweepFlag x y ->
      "A" ++ joinCommands
        [ stringPoint (Point rx ry)
        , toString xAxisRotation
        , stringBool largeArcFlag
        , stringBool sweepFlag
        , stringPoint (Point x y)
        ]

    Close ->
      "Z"


joinCommands : List String -> String
joinCommands commands =
  String.join " " commands


stringPoint : Point -> String
stringPoint { x, y } =
  toString x ++ " " ++ toString y


stringPoints : List Point -> String
stringPoints points =
  String.join "," (List.map stringPoint points)


stringBool : Bool -> String
stringBool bool =
  if bool then
    "0"
  else
    "1"



-- MONOTONE INTERPOLATION


monotoneX : List Point -> List Command
monotoneX points =
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


monotoneXNext : List Point -> Float -> List Command -> List Command
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


monotoneXCurve : Point -> Point -> Float -> Float -> List Command
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
