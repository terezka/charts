module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, float, tuple, string)
import Svg.Coordinates exposing (..)


all : Test
all =
  describe "Cartesian translation"
    [ describe "Translations"
      [ test "toSVGX" <|
        \() ->
          Expect.equal 10 (toSVGX defaultPlaneConfig defaultPlane 1)
      , test "toSVGY" <|
        \() ->
          Expect.equal 90 (toSVGY defaultPlaneConfig defaultPlane 1)
      , test "toSVGX with lower margin" <|
        \() ->
          Expect.equal 28 (toSVGX ({ defaultPlaneConfig | x = updateMarginLower defaultPlaneConfig.x 20 }) defaultPlane 1)
      , test "toSVGX with upper margin" <|
        \() ->
          Expect.equal 8 (toSVGX ({ defaultPlaneConfig | x = updateMarginUpper defaultPlaneConfig.x 20 }) defaultPlane 1)
      , test "toSVGY with lower margin" <|
        \() ->
          Expect.equal 92 (toSVGY ({ defaultPlaneConfig | y = updateMarginLower defaultPlaneConfig.y 20 }) defaultPlane 1)
      , test "Length should default to 1" <|
        \() ->
          Expect.equal 0.9 (toSVGY ({ defaultPlaneConfig | y = updatelength defaultPlaneConfig.y 0 }) defaultPlane 1)
      ]
    , describe "Test validity of coordinates"
      [ fuzz float "x-coordinate produced should always be a number" <|
        \number ->
          toSVGX defaultPlaneConfig defaultPlane number
            |> isNaN
            |> Expect.false "Coordinate should always be a number!"
      , fuzz float "y-coordinate produced should always be a number" <|
        \number ->
          toSVGX defaultPlaneConfig defaultPlane number
            |> isNaN
            |> Expect.false "Coordinate should always be a number!"
      ]
    ]



-- HELPERS


defaultPlane : Plane
defaultPlane =
  plane []


defaultPlaneConfig : PlaneConfig
defaultPlaneConfig =
  { x = defaultAxisConfig
  , y = defaultAxisConfig
  }


defaultAxisConfig : AxisConfig
defaultAxisConfig =
  { marginLower = 0
  , marginUpper = 0
  , length = 100
  , min = always 0
  , max = always 10
  }


updateMarginLower : AxisConfig -> Float -> AxisConfig
updateMarginLower config marginLower =
  { config | marginLower = marginLower }


updateMarginUpper : AxisConfig -> Float -> AxisConfig
updateMarginUpper config marginUpper =
  { config | marginUpper = marginUpper }


updatelength : AxisConfig -> Float -> AxisConfig
updatelength config length =
  { config | length = length }
