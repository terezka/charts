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
@docs PlaneConfig, AxisConfig, Plane, Axis, Point, point, plane

# Cartesian to SVG
@docs toSVGX, toSVGY, scaleSVG

# SVG to cartesian
@docs toCartesianX, toCartesianY, scaleCartesian

# Helpers
@docs place, placeWithOffset

-}

import Svg exposing (Attribute)
import Svg.Attributes exposing (transform)


-- Config


{-| -}
type alias PlaneConfig =
  { x : AxisConfig
  , y : AxisConfig
  }


{-| -}
type alias AxisConfig =
  { marginLower : Float
  , marginUpper : Float
  , length : Float
  , min : Float -> Float
  , max : Float -> Float
  }



-- Plane


{-| -}
type alias Plane =
  { x : Axis
  , y : Axis
  }


{-| -}
type alias Axis =
  { marginLower : Float
  , marginUpper : Float
  , length : Float
  , min : Float
  , max : Float
  }


{-| -}
type alias Point =
  { x : Float
  , y : Float
  }


{-| Produce a point. First argument is the x-coordinate,
  second is then y-coordinate.
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


{-| For scaling a cartesian value to a SVG value.

  Note that this will _not_ return a coordinate on the plane,
  but the scaled value.
-}
scaleSVG : Axis -> Float -> Float
scaleSVG axis value =
  value * (innerLength axis) / (range axis)


{-| Translate SVG x to cartesian x.
-}
toSVGX : Plane -> Float -> Float
toSVGX plane value =
  scaleSVG plane.x (value - plane.x.min) + plane.x.marginLower


{-| Translate SVG y to cartesian y.
-}
toSVGY : Plane -> Float -> Float
toSVGY plane value =
  scaleSVG plane.y (plane.y.max - value) + plane.y.marginLower


{-| For scaling a SVG value to a cartesian value.

  Note that this will _not_ return a coordinate on the plane,
  but the scaled value.
-}
scaleCartesian : Axis -> Float -> Float
scaleCartesian axis value =
  value * (range axis) / (innerLength axis)


{-| Translate cartesian x to SVG x.
-}
toCartesianX : Plane -> Float -> Float
toCartesianX plane value =
  scaleCartesian plane.x (value - plane.x.marginLower) + plane.x.min


{-| Translate cartesian y to SVG y.
-}
toCartesianY : Plane -> Float -> Float
toCartesianY plane value =
  range plane.y - scaleCartesian plane.y (value - plane.y.marginLower) + plane.y.min



-- PLACING HELPERS


{-| A transform translate(x, y) SVG attribute. Beware that using this and
  and another transform attribute on the same node, will overwrite the first.
  If that's the case, just concat them:

    myTransformAttribute : Svg.Attribute msg
    myTransformAttribute =
      transform <|
        "translate(" ++ toString (toSVGX plane x) ++ "," ++ toString (toSVGY plane y) ++ ") "
        ++ "rotateX(" ++ whatever ++ ")"
-}
place : Plane -> Point -> Attribute msg
place plane point =
  placeWithOffset plane point 0 0


{-| Place at coordinate, but with an SVG offset. See `place` above for important notes.
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
