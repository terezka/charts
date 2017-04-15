module Svg.Coordinates
  exposing
    ( Plane, Axis, PlaneConfig, AxisConfig, Point
    , point, plane
    , scaleSVG, toSVGX, toSVGY
    , scaleCartesian, toCartesianX, toCartesianY
    , place, placeWithOffset
    )

{-| Cartesian to SVG coordinate translation helpers.

# Plane
@docs Plane, Axis

# Plane based on data
@docs PlaneConfig, AxisConfig, Point, point, plane

# Cartesian to SVG
@docs toSVGX, toSVGY, scaleSVG

# SVG to cartesian
@docs toCartesianX, toCartesianY, scaleCartesian

# Helpers
@docs place, placeWithOffset

-}

import Svg exposing (Attribute)
import Svg.Attributes exposing (transform)



-- Plane


{-| The properties of your plane.
-}
type alias Plane =
  { x : Axis
  , y : Axis
  }


{-| The axis of the plane.

  - The margin properties are the upper and lower margins for the axis. So for example,
    if you want to add margin on top of the plot, increase the marginUpper of
    the y-`Axis`.
  - The length is the length of your SVG axis. (Plane.x.length is the width,
    Plane.y.length is the height)
  - The `min` and `max` values is the reach of your plane. (Domain for the y-axis, range
    for the x-axis)
-}
type alias Axis =
  { marginLower : Float
  , marginUpper : Float
  , length : Float
  , min : Float
  , max : Float
  }



-- Config


{-| The configuration when you want to build a plane based on some
  data points.
-}
type alias PlaneConfig =
  { x : AxisConfig
  , y : AxisConfig
  }


{-| The axis in `PlaneConfig`. The only difference from the `Plane` is the reach properties.
  Here the `min` and `max` properties is for restricting the reach of your plane based on
  the data. The functions are passed the actual data reach, meaning that for example the `min`
  will be passed the lowest value in your data set of the axis in question.

  So if for example you'd want to have your x-axis _always_ be always zero,
  then you'd need to add `min = always 0` on your x-`AxisConfig`.
-}
type alias AxisConfig =
  { marginLower : Float
  , marginUpper : Float
  , length : Float
  , min : Float -> Float
  , max : Float -> Float
  }


{-| Representation of a point in your plane.
-}
type alias Point =
  { x : Float
  , y : Float
  }


{-| Produce a point. First argument is the x-coordinate,
  second is the y-coordinate.
-}
point : Float -> Float -> Point
point =
  Point


{-| Produce the plane fitting your points.
-}
plane : PlaneConfig -> List Point -> Plane
plane config coordinates =
    { x =
      { marginLower = config.x.marginLower
      , marginUpper = config.x.marginUpper
      , length = config.x.length
      , min = config.x.min (min .x coordinates)
      , max = config.x.max (max .x coordinates)
      }
    , y =
      { marginLower = config.y.marginLower
      , marginUpper = config.y.marginUpper
      , length = config.y.length
      , min = config.y.min (min .y coordinates)
      , max = config.y.max (max .y coordinates)
      }
    }


min : (Point -> Float) -> List Point -> Float
min toValue =
  List.map toValue
    >> List.minimum
    >> Maybe.withDefault 0


max : (Point -> Float) -> List Point -> Float
max toValue =
  List.map toValue
    >> List.maximum
    >> Maybe.withDefault 0



-- TRANSLATION


{-| For scaling a cartesian value to a SVG value. Note that this will _not_
  return a coordinate on the plane, but the scaled value.
-}
scaleSVG : Axis -> Float -> Float
scaleSVG axis value =
  value * (innerLength axis) / (range axis)


{-| Translate a SVG x-coordinate to its cartesian x-coordinate.
-}
toSVGX : Plane -> Float -> Float
toSVGX plane value =
  scaleSVG plane.x (value - plane.x.min) + plane.x.marginLower


{-| Translate a SVG y-coordinate to its cartesian y-coordinate.
-}
toSVGY : Plane -> Float -> Float
toSVGY plane value =
  scaleSVG plane.y (plane.y.max - value) + plane.y.marginLower


{-| For scaling a SVG value to a cartesian value. Note that this will _not_
  return a coordinate on the plane, but the scaled value.
-}
scaleCartesian : Axis -> Float -> Float
scaleCartesian axis value =
  value * (range axis) / (innerLength axis)


{-| Translate a cartesian x-coordinate to its SVG x-coordinate.
-}
toCartesianX : Plane -> Float -> Float
toCartesianX plane value =
  scaleCartesian plane.x (value - plane.x.marginLower) + plane.x.min


{-| Translate a cartesian y-coordinate to its SVG y-coordinate.
-}
toCartesianY : Plane -> Float -> Float
toCartesianY plane value =
  range plane.y - scaleCartesian plane.y (value - plane.y.marginLower) + plane.y.min



-- PLACING HELPERS


{-| A `transform translate(x, y)` SVG attribute. Beware that using this and
  and another transform attribute on the same node, will overwrite the first.
  If that's the case, just make one yourself:

    myTransformAttribute : Svg.Attribute msg
    myTransformAttribute =
      transform <|
        "translate("
        ++ toString (toSVGX plane x) ++ ","
        ++ toString (toSVGY plane y) ++ ") "
        ++ "rotateX(" ++ whatever ++ ")"
-}
place : Plane -> Point -> Attribute msg
place plane point =
  placeWithOffset plane point 0 0


{-| Place at coordinate, but you may add a SVG offset. See `place` above for important notes.
-}
placeWithOffset : Plane -> Point -> Float -> Float -> Attribute msg
placeWithOffset plane { x, y } offsetX offsetY =
  transform ("translate(" ++ toString (toSVGX plane x + offsetX) ++ "," ++ toString (toSVGY plane y + offsetY) ++ ")")



-- INTERNAL HELPERS


range : Axis -> Float
range axis =
  let
    diff =
      axis.max - axis.min
  in
    if diff > 0 then diff else 1


innerLength : Axis -> Float
innerLength axis =
  Basics.max 1 (axis.length - axis.marginLower - axis.marginUpper)
