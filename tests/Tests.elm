module Tests exposing (..)

import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import Expect
import Fuzz exposing (Fuzzer, list, int, float, tuple, string, map)
import Html exposing (Html, div)
import Svg exposing (Svg, svg)
import Svg.Attributes
import Svg.Coordinates as Coordinates exposing (..)
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
          Expect.equal 10 (toSVGX defaultPlane 1)
    , test "toSVGY" <|
        \() ->
          Expect.equal 90 (toSVGY defaultPlane 1)
    , test "toSVGX with lower margin" <|
        \() ->
          Expect.equal 28 (toSVGX { defaultPlane | x = updateMarginLower defaultPlane.x 20 } 1)
    , test "toSVGX with upper margin" <|
        \() ->
          Expect.equal 8 (toSVGX { defaultPlane | x = updateMarginUpper defaultPlane.x 20 } 1)
    , test "toSVGY with lower margin" <|
        \() ->
          Expect.equal 92 (toSVGY { defaultPlane | y = updateMarginLower defaultPlane.y 20 } 1)
    , test "Length should default to 1" <|
        \() ->
          Expect.equal 0.9 (toSVGY { defaultPlane | y = updatelength defaultPlane.y 0 } 1)
    , fuzz float "x-coordinate produced should always be a number" <|
        \number ->
          toSVGX defaultPlane number
            |> isNaN
            |> Expect.false "Coordinate should always be a number!"
    , fuzz float "y-coordinate produced should always be a number" <|
        \number ->
          toSVGY defaultPlane number
            |> isNaN
            |> Expect.false "Coordinate should always be a number!"
    ]


plots : Test
plots =
  describe "Plots"
    -- TODO: These doesn't have to be fuzz tests.
    [ fuzz randomPoints "User can set stroke for lines" <|
        \points ->
            case points of
              [] ->
                Expect.pass

              actualPoints ->
                wrapSvg [ monotone (planeFromPoints actualPoints) [ Svg.Attributes.stroke "red" ] (List.map clear actualPoints) ]
                  |> Query.fromHtml
                  |> Query.find [ Selector.tag "path" ]
                  |> Query.has [ Selector.attribute "stroke" "red" ]
    , fuzz randomPoints "User can set fill for areas" <|
        \points ->
            case points of
              [] ->
                Expect.pass

              actualPoints ->
                wrapSvg [ monotone (planeFromPoints actualPoints) [ Svg.Attributes.fill "red" ] (List.map clear actualPoints) ]
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
  list (map (\( x, y ) -> Point x y) (tuple (float, float)))


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


defaultPlane : Plane
defaultPlane =
  { x = defaultAxis
  , y = defaultAxis
  }


defaultAxis : Axis
defaultAxis =
  { marginLower = 0
  , marginUpper = 0
  , length = 100
  , min = 0
  , max = 10
  }


updateMarginLower : Axis -> Float -> Axis
updateMarginLower config marginLower =
  { config | marginLower = marginLower }


updateMarginUpper : Axis -> Float -> Axis
updateMarginUpper config marginUpper =
  { config | marginUpper = marginUpper }


updatelength : Axis -> Float -> Axis
updatelength config length =
  { config | length = length }
