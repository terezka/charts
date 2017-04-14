module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, tuple, string)
import String
import Svg.Cartesian exposing (..)


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


all : Test
all =
  describe "Cartesian translation"
    [ describe "Translations"
      [ test "toSVGX" <|
        \() ->
          Expect.equal 10 (toSVGX defaultPlaneConfig defaultPlane 1)
      , test "toSVGY" <|
        \() ->
          Expect.equal 10 (toSVGY defaultPlaneConfig defaultPlane 1)
      {-, test "This test should fail - you should remove it" <|
        \() ->
          Expect.fail "Failed as expected!" -}
      ]
    {-}, describe "Fuzz test examples, using randomly generated input"
      [ fuzz (list int) "Lists always have positive length" <|
        \aList ->
          List.length aList |> Expect.atLeast 0
      , fuzz (list int) "Sorting a list does not change its length" <|
        \aList ->
          List.sort aList |> List.length |> Expect.equal (List.length aList)
      , fuzzWith { runs = 1000 } int "List.member will find an integer in a list containing it" <|
        \i ->
          List.member i [ i ] |> Expect.true "If you see this, List.member returned False!"
      , fuzz2 string string "The length of a string equals the sum of its substrings' lengths" <|
        \s1 s2 ->
          s1 ++ s2 |> String.length |> Expect.equal (String.length s1 + String.length s2)
      ]-}
    ]
