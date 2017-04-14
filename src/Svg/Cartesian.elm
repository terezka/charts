module Svg.Cartesian
  exposing
    ( Plane, Axis, PlaneConfig, AxisConfig, Coord
    , coord, plane, defaultPlane
    , toSVG, toSVGX, toSVGY
    , toCartesian, toCartesianX, toCartesianY
    )

{-| Cartesian to SVG coordinate translation helpers.

@docs Plane, Axis, PlaneConfig, AxisConfig, Coord, coord, plane, defaultPlane

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
defaultPlane : Plane
defaultPlane =
  { x = Axis 0 1
  , y = Axis 0 1
  }


{-| -}
plane : List Coord -> Plane
plane coordinates =
  let
    axis data v =
      { min = min data.min v
      , max = max data.max v
      }

    foldPlane { x, y } result =
      case result of
        Nothing ->
          Just
            { x = { min = x, max = x }
            , y = { min = y, max = y }
            }

        Just summary ->
          Just
            { x = axis summary.x x
            , y = axis summary.y y
            }
  in
    coordinates
      |> List.foldl foldPlane Nothing
      |> Maybe.withDefault defaultPlane



-- TRANSLATION


{-| -}
toSVG : AxisConfig -> Axis -> Float -> Float
toSVG config axis value =
  value * (innerLength config) / (range config axis)


{-| -}
toSVGX : PlaneConfig -> Plane -> Float -> Float
toSVGX config plane value =
  toSVG config.x plane.x (value - plane.x.min) + config.x.marginLower


{-| -}
toSVGY : PlaneConfig -> Plane -> Float -> Float
toSVGY config plane value =
  toSVG config.y plane.y (plane.y.max - value) + config.y.marginLower


{-| -}
toCartesian : AxisConfig -> Axis -> Float -> Float
toCartesian config axis value =
  value * (range config axis) / (innerLength config)


{-| -}
toCartesianX : PlaneConfig -> Plane -> Float -> Float
toCartesianX config plane value =
  toCartesian config.x plane.x (value - config.x.marginLower) + plane.x.min


{-| -}
toCartesianY : PlaneConfig -> Plane -> Float -> Float
toCartesianY config plane value =
  range config.y plane.y - toCartesian config.y plane.y (value - config.y.marginLower) + plane.y.min



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
