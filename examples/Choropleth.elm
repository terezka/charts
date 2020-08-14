module Choropleth exposing (..)

import Svg exposing (Svg, svg, g, circle, text_, text, tspan)
import Svg.Attributes exposing (width, height, stroke, fill, r, transform)
import Svg.Tiles as Tiles exposing (..)


proportion : Float -> Float
proportion =
  Tiles.proportion identity data


america : Map msg
america =
  { tiles = List.map3 tile stateIndices stateAbbs data
  , tilesPerRow = 11
  , tileWidth = 30
  , tileHeight = 30
  }


{-| -}
tile : Int -> String -> Float -> Tile msg
tile index abbrivation value =
  { content = Just (viewLabel abbrivation)
  , attributes = [ fill ("rgba(253, 185, 231, " ++ String.fromFloat (proportion value + 0.1) ++ ")") ]
  , index = index
  }


viewLabel : String -> Svg msg
viewLabel string =
  text_ [] [ tspan [] [ text string ] ]


main : Svg msg
main =
  svg
    [ width "300"
    , height "300"
    ]
    [ Tiles.view america ]


data : List Float
data =
  [ 1, 2, 3, 6, 8, 9, 6, 4, 2, 1, 3, 6, 8, 9, 6, 4, 2, 1, 4, 2, 1, 9, 6, 4, 2, 1, 3, 6, 8, 9, 6, 4, 2, 1, 4, 2, 1, 3, 6, 8, 9, 1, 2, 3, 6, 8, 9, 6, 4, 2, 1, 3, 6, 8, 9, 6, 4, 2, 1, 4, 2, 1, 9, 6, 4, 2, 1, 3, 6, 8, 9, 6, 4, 2, 1, 4, 2, 1, 3, 6, 8, 9,6, 4, 2, 1, 4, 2, 1, 3, 6, 8, 9, 6, 4, 2, 1, 4, 2, 1, 3, 6, 8, 9, 2, 1, 3, 6, 8, 9 ]


stateIndices : List Int
stateIndices =
  [ 0, 10, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 30, 31, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 56, 57, 58, 59, 60, 61, 62, 69, 70, 71, 72, 73, 77, 80, 85 ]


{- I do realize these aren't in the inded order. Fortunately, I don't care.
-}
stateAbbs : List String
stateAbbs =
  [ "AK", "AL", "AR", "AZ", "CA", "CO", "CT", "DC", "DE", "FL", "GA", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD", "ME", "MI", "MN", "MO", "MS", "MT", "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VA", "VT", "WA", "WI", "WV", "WY" ]
