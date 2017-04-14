module Svg.Cartesian
  exposing
    ( Plane, Axis, PlaneConfig, AxisConfig, Coord
    , coord, plane
    , toSVG, toSVGX, toSVGY
    , toCartesian, toCartesianX, toCartesianY
    )

{-| Cartesian to SVG coordinate translation helpers.

@docs Plane, Axis, PlaneConfig, AxisConfig, Coord, coord, plane

@docs toSVG, toSVGX, toSVGY, toSVG

@docs toCartesian, toCartesianX, toCartesianY

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


{-| -}
toSVG : AxisConfig -> Axis -> Float -> Float
toSVG config axis value =
  value * (innerLength config) / (range config axis)


{-| -}
toSVGX : PlaneConfig -> Plane -> Float -> Float
toSVGX config plane value =
  toSVG config.x plane.x (value - config.x.min plane.x.min) + config.x.marginLower


{-| -}
toSVGY : PlaneConfig -> Plane -> Float -> Float
toSVGY config plane value =
  toSVG config.y plane.y (config.y.max plane.y.max - value) + config.y.marginLower


{-| -}
toCartesian : AxisConfig -> Axis -> Float -> Float
toCartesian config axis value =
  value * (range config axis) / (innerLength config)


{-| -}
toCartesianX : PlaneConfig -> Plane -> Float -> Float
toCartesianX config plane value =
  toCartesian config.x plane.x (value - config.x.marginLower) + config.x.min plane.x.min


{-| -}
toCartesianY : PlaneConfig -> Plane -> Float -> Float
toCartesianY config plane value =
  range config.y plane.y - toCartesian config.y plane.y (value - config.y.marginLower) + config.y.min plane.y.min



-- HELPERS


range : AxisConfig -> Axis -> Float
range config axis =
  let
    diff =
      config.max axis.max - config.min axis.min
  in
    -- Range of 0 is bad
    if diff /= 0 then diff else 1


innerLength : AxisConfig -> Float
innerLength config =
  config.length - config.marginLower - config.marginUpper
