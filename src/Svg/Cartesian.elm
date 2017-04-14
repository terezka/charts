module Svg.Cartesian
  exposing
    ( Plane, Axis, PlaneConfig, AxisConfig, Coord
    , coord, plane
    , scaleSVG, toSVGX, toSVGY
    , scaleCartesian, toCartesianX, toCartesianY
    )

{-| Cartesian to SVG coordinate translation helpers.

# Plane
@docs PlaneConfig, AxisConfig, Plane, Axis, Coord, coord, plane

# Cartesian to SVG
@docs toSVGX, toSVGY, scaleSVG

# SVG to cartesian
@docs toCartesianX, toCartesianY, scaleCartesian

-}


-- Plane


{-| -}
type alias Plane =
  { x : Axis
  , y : Axis
  }


{-| -}
type alias Axis =
  { min : Float
  , max : Float
  }



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



-- Plane compilation


{-| -}
type alias Coord =
  { x : Float
  , y : Float
  }


{-| -}
coord : Float -> Float -> Coord
coord =
  Coord


{-| -}
plane : List Coord -> Plane
plane coordinates =
    { x =
      { min = min .x coordinates
      , max = max .x coordinates
      }
    , y =
      { min = min .y coordinates
      , max = max .y coordinates
      }
    }


min : (Coord -> Float) -> List Coord -> Float
min toValue =
  List.map toValue
    >> List.minimum
    >> Maybe.withDefault 0


max : (Coord -> Float) -> List Coord -> Float
max toValue =
  List.map toValue
    >> List.maximum
    >> Maybe.withDefault 0



-- TRANSLATION


{-| For scaling a cartesian value to a SVG value.

  Note that this will _not_ return a coordinate on the plane,
  but the relative value.
-}
scaleSVG : AxisConfig -> Axis -> Float -> Float
scaleSVG config axis value =
  value * (innerLength config) / (range config axis)


{-| Translate SVG x to cartesian x -}
toSVGX : PlaneConfig -> Plane -> Float -> Float
toSVGX config plane value =
  scaleSVG config.x plane.x (value - config.x.min plane.x.min) + config.x.marginLower


{-| Translate SVG y to cartesian y -}
toSVGY : PlaneConfig -> Plane -> Float -> Float
toSVGY config plane value =
  scaleSVG config.y plane.y (config.y.max plane.y.max - value) + config.y.marginLower


{-| For scaling a SVG value to a cartesian value.

  Note that this will _not_ return a coordinate on the plane,
  but the relative value.
-}
scaleCartesian : AxisConfig -> Axis -> Float -> Float
scaleCartesian config axis value =
  value * (range config axis) / (innerLength config)


{-| Translate cartesian x to SVG x -}
toCartesianX : PlaneConfig -> Plane -> Float -> Float
toCartesianX config plane value =
  scaleCartesian config.x plane.x (value - config.x.marginLower) + config.x.min plane.x.min


{-| Translate cartesian y to SVG y -}
toCartesianY : PlaneConfig -> Plane -> Float -> Float
toCartesianY config plane value =
  range config.y plane.y - scaleCartesian config.y plane.y (value - config.y.marginLower) + config.y.min plane.y.min



-- HELPERS


range : AxisConfig -> Axis -> Float
range config axis =
  Basics.max 0 (config.max axis.max - config.min axis.min)


innerLength : AxisConfig -> Float
innerLength config =
  Basics.max 1 (config.length - config.marginLower - config.marginUpper)
