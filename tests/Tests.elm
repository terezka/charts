module Tests exposing (..)

import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import Expect
import Fuzz exposing (Fuzzer, list, int, float, tuple, string, map)
import Html exposing (Html, div)
import Svg exposing (Svg, svg)
import Svg.Attributes
import Svg.Coordinates exposing (..)
import Svg.Plot exposing (..)


all : Test
all =
  describe "elm-plot rouge"
    [ coordinates
    , plots
    ]

coordinates : Test
coordinates =
  describe "Cartesian translation"
    [ test "toSVGX" <|
        \() ->
          Expect.equal 10 (toSVGX (makePlane defaultPlaneConfig) 1)
    , test "toSVGY" <|
        \() ->
          Expect.equal 90 (toSVGY (makePlane defaultPlaneConfig) 1)
    , test "toSVGX with lower margin" <|
        \() ->
          Expect.equal 28 (toSVGX (makePlane { defaultPlaneConfig | x = updateMarginLower defaultPlaneConfig.x 20 }) 1)
    , test "toSVGX with upper margin" <|
        \() ->
          Expect.equal 8 (toSVGX (makePlane { defaultPlaneConfig | x = updateMarginUpper defaultPlaneConfig.x 20 }) 1)
    , test "toSVGY with lower margin" <|
        \() ->
          Expect.equal 92 (toSVGY (makePlane { defaultPlaneConfig | y = updateMarginLower defaultPlaneConfig.y 20 }) 1)
    , test "Length should default to 1" <|
        \() ->
          Expect.equal 0.9 (toSVGY (makePlane { defaultPlaneConfig | y = updatelength defaultPlaneConfig.y 0 }) 1)
    , fuzz float "x-coordinate produced should always be a number" <|
        \number ->
          toSVGX (makePlane defaultPlaneConfig) number
            |> isNaN
            |> Expect.false "Coordinate should always be a number!"
    , fuzz float "y-coordinate produced should always be a number" <|
        \number ->
          toSVGY (makePlane defaultPlaneConfig) number
            |> isNaN
            |> Expect.false "Coordinate should always be a number!"
    ]


plots : Test
plots =
  describe "Plots"
    -- TODO: These doesn't have to be fuzz tests.
    [ fuzz randomPoints "User can overwrite stroke for lines" <|
        \points ->
            case points of
              [] ->
                Expect.pass

              actualPoints ->
                wrapSvg [ line [ Svg.Attributes.stroke "red" ] Monotone (plane defaultPlaneConfig actualPoints) actualPoints ]
                  |> Query.fromHtml
                  |> Query.find [ Selector.tag "path" ]
                  |> Query.has [ Selector.attribute "stroke" "red" ]
    , fuzz randomPoints "User cannot overwrite fill for lines" <|
        \points ->
            case points of
              [] ->
                Expect.pass

              actualPoints ->
                wrapSvg [ line [ Svg.Attributes.fill "red" ] Monotone (plane defaultPlaneConfig actualPoints) actualPoints ]
                  |> Query.fromHtml
                  |> Query.find [ Selector.tag "path" ]
                  |> Query.has [ Selector.attribute "fill" "transparent" ]
    , fuzz randomPoints "User can overwrite stroke for areas" <|
        \points ->
            case points of
              [] ->
                Expect.pass

              actualPoints ->
                wrapSvg [ area [ Svg.Attributes.stroke "red" ] Monotone (plane defaultPlaneConfig actualPoints) actualPoints ]
                  |> Query.fromHtml
                  |> Query.find [ Selector.tag "path" ]
                  |> Query.has [ Selector.attribute "stroke" "red" ]
    , fuzz randomPoints "User can overwrite fill for areas" <|
        \points ->
            case points of
              [] ->
                Expect.pass

              actualPoints ->
                wrapSvg [ area [ Svg.Attributes.fill "red" ] Monotone (plane defaultPlaneConfig actualPoints) actualPoints ]
                  |> Query.fromHtml
                  |> Query.find [ Selector.tag "path" ]
                  |> Query.has [ Selector.attribute "fill" "red" ]
    ]



-- HELPERS


wrapSvg : List (Svg msg) -> Html msg
wrapSvg children =
  div [] [ svg [] children ]


randomPoints : Fuzzer (List Point)
randomPoints =
  list (map (\( x, y ) -> point x y) (tuple (float, float)))


makePlane : PlaneConfig -> Plane
makePlane config =
  plane config []


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
