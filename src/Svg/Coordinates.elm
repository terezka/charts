module Svg.Coordinates
  exposing
    ( Plane, Bounds, Margin, minimum, maximum
    , scaleSVGX, scaleSVGY
    , toSVGX, toSVGY
    , scaleCartesianX, scaleCartesianY
    , toCartesianX, toCartesianY
    , place, placeWithOffset
    , Point, Position

    , toBounds, XY
    )

{-| This module contains helpers for cartesian/SVG coordinate translation.

# Plane
@docs Plane, Axis

# Plane from data

You may want to produce a plane which fits all your data. For that you need
to find the minimum and maximum values withing your data in order to calculate
the domain and range.

@docs minimum, maximum

    planeFromPoints : List Point -> Plane
    planeFromPoints points =
      { x =
        { marginLower = 10
        , marginUpper = 10
        , length = 300
        , min = minimum .x points
        , max = maximum .x points
        }
      , y =
        { marginLower = 10
        , marginUpper = 10
        , length = 300
        , min = minimum .y points
        , max = maximum .y points
        }
      }

# Cartesian to SVG
@docs toSVGX, toSVGY, scaleSVG

# SVG to cartesian
@docs toCartesianX, toCartesianY, scaleCartesian

# Helpers
@docs place, placeWithOffset

-}

import Svg exposing (Attribute)
import Svg.Attributes exposing (transform)



type alias Point =
  { x : Float
  , y : Float
  }


type alias Position =
  { x1 : Float
  , x2 : Float
  , y1 : Float
  , y2 : Float
  }



-- PLANE


{-| -}
type alias Plane =
  { width : Float
  , height : Float
  , margin : Margin
  , x : Bounds
  , y : Bounds
  }


{-| -}
type alias Margin =
  { top : Float
  , right : Float
  , left : Float
  , bottom : Float
  }


{-| -}
type alias Bounds =
  { dataMin : Float
  , dataMax : Float
  , min : Float
  , max : Float
  }


{-| -}
type alias XY =
  { x : Bounds
  , y : Bounds
  }


{-| -}
toBounds : List (a -> Maybe Float) -> List (a -> Maybe Float) -> List a -> Maybe XY -> Maybe XY
toBounds xs ys data prev =
  let fold vs datum bounds_ =
        { min = min (getMin vs datum) bounds_.min
        , max = max (getMax vs datum) bounds_.max
        , dataMin = min (getMin vs datum) bounds_.min
        , dataMax = max (getMax vs datum) bounds_.max
        }

      getMin toValues datum =
        List.minimum (getValues toValues datum)
          |> Maybe.withDefault 0

      getMax toValues datum =
        List.maximum (getValues toValues datum)
          |> Maybe.withDefault 1

      getValues toValues datum =
        List.filterMap (\v -> v datum) toValues

      initial fs datum =
        { min = getMin fs datum
        , max = getMax fs datum
        , dataMin = getMin fs datum
        , dataMax = getMax fs datum
        }
  in
  case data of
    first :: rest ->
      case prev of
        Just { x, y } ->
          Just
            { x = List.foldl (fold xs) x data
            , y = List.foldl (fold ys) y data
            }

        Nothing ->
          Just
            { x = List.foldl (fold xs) (initial xs first) rest
            , y = List.foldl (fold ys) (initial ys first) rest
            }

    [] ->
      prev


{-| Helper to extract the minimum value amongst your coordinates.
-}
minimum : List (a -> Maybe Float) -> List a -> Float
minimum toValues =
  let fold datum toValue all =
        case toValue datum of
          Just v -> v :: all
          Nothing -> all

      eachDatum datum = List.foldl (fold datum) [] toValues
  in
  List.concatMap eachDatum
    >> List.minimum
    >> Maybe.withDefault 0


{-| Helper to extract the maximum value amongst your coordinates.
-}
maximum : List (a -> Maybe Float) -> List a -> Float
maximum toValues =
  let fold datum toValue all =
        case toValue datum of
          Just v -> v :: all
          Nothing -> all

      eachDatum datum = List.foldl (fold datum) [] toValues
  in
  List.concatMap eachDatum
    >> List.maximum
    >> Maybe.withDefault 1



-- TRANSLATION


{-| For scaling a cartesian value to a SVG value. Note that this will _not_
  return a coordinate on the plane, but the scaled value.
-}
scaleSVGX : Plane -> Float -> Float
scaleSVGX plane value =
  value * (innerLengthX plane) / (range plane.x)


scaleSVGY : Plane -> Float -> Float
scaleSVGY plane value =
  value * (innerLengthY plane) / (range plane.y)


{-| Translate a SVG x-coordinate to its cartesian x-coordinate.
-}
toSVGX : Plane -> Float -> Float
toSVGX plane value =
  scaleSVGX plane (value - plane.x.min) + plane.margin.left


{-| Translate a SVG y-coordinate to its cartesian y-coordinate.
-}
toSVGY : Plane -> Float -> Float
toSVGY plane value =
  scaleSVGY plane (plane.y.max - value) + plane.margin.top


{-| For scaling a SVG value to a cartesian value. Note that this will _not_
  return a coordinate on the plane, but the scaled value.
-}
scaleCartesianX : Plane -> Float -> Float
scaleCartesianX plane value =
  value * (range plane.x) / (innerLengthX plane)


scaleCartesianY : Plane -> Float -> Float
scaleCartesianY plane value =
  value * (range plane.y) / (innerLengthY plane)


{-| Translate a cartesian x-coordinate to its SVG x-coordinate.
-}
toCartesianX : Plane -> Float -> Float
toCartesianX plane value =
  scaleCartesianX plane (value - plane.margin.left) + plane.x.min


{-| Translate a cartesian y-coordinate to its SVG y-coordinate.
-}
toCartesianY : Plane -> Float -> Float
toCartesianY plane value =
  range plane.y - scaleCartesianY plane (value - plane.margin.top) + plane.y.min



-- PLACING HELPERS


{-| A `transform translate(x, y)` SVG attribute. Beware that using this and
  and another transform attribute on the same node, will overwrite the first.
  If that's the case, just make one yourself:

    myTransformAttribute : Svg.Attribute msg
    myTransformAttribute =
      transform <|
        "translate("
        ++ String.fromFloat (toSVGX plane x) ++ ","
        ++ String.fromFloat (toSVGY plane y) ++ ") "
        ++ "rotateX(" ++ whatever ++ ")"
-}
place : Plane -> Float -> Float -> Attribute msg
place plane x y =
  placeWithOffset plane x y 0 0


{-| Place at coordinate, but you may add a SVG offset. See `place` above for important notes.
-}
placeWithOffset : Plane -> Float -> Float -> Float -> Float -> Attribute msg
placeWithOffset plane x y offsetX offsetY =
  transform ("translate(" ++ String.fromFloat (toSVGX plane x + offsetX) ++ "," ++ String.fromFloat (toSVGY plane y + offsetY) ++ ")")



-- INTERNAL HELPERS


range : Bounds -> Float
range bounds =
  let diff = bounds.max - bounds.min in
  if diff > 0 then diff else 1


innerLengthX : Plane -> Float
innerLengthX plane =
  Basics.max 1 (plane.width - plane.margin.left - plane.margin.right)


innerLengthY : Plane -> Float
innerLengthY plane =
  Basics.max 1 (plane.height - plane.margin.top - plane.margin.bottom)

