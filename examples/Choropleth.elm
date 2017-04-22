module Choropleth exposing (..)

import Svg exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes exposing (width, height, stroke, fill, r, transform)
import Svg.Tiles as Tiles exposing (..)


proportion : Float -> Float
proportion =
  Tiles.proportion identity data


heatmap : Map msg
heatmap =
  { tiles = List.map2 tile stateIndices data
  , tilesPerRow = 11
  , tileWidth = 30
  , tileHeight = 30
  }


{-| -}
tile : Int -> Float -> Tile msg
tile index value =
  { content = Nothing
  , attributes = [ fill ("rgba(253, 185, 231, " ++ toString (proportion value + 0.1) ++ ")") ]
  , index = index
  }


main : Svg msg
main =
  svg
    [ width "300"
    , height "300"
    ]
    [ Tiles.view heatmap ]


data : List Float
data =
  [ 1, 2, 3, 6, 8, 9, 6, 4, 2, 1, 3, 6, 8, 9, 6, 4, 2, 1, 4, 2, 1, 9, 6, 4, 2, 1, 3, 6, 8, 9, 6, 4, 2, 1, 4, 2, 1, 3, 6, 8, 9, 1, 2, 3, 6, 8, 9, 6, 4, 2, 1, 3, 6, 8, 9, 6, 4, 2, 1, 4, 2, 1, 9, 6, 4, 2, 1, 3, 6, 8, 9, 6, 4, 2, 1, 4, 2, 1, 3, 6, 8, 9,6, 4, 2, 1, 4, 2, 1, 3, 6, 8, 9, 6, 4, 2, 1, 4, 2, 1, 3, 6, 8, 9, 2, 1, 3, 6, 8, 9 ]


stateIndices : List Int
stateIndices =
  [ 0, 10, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 30, 31, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 56, 57, 58, 59, 60, 61, 62, 69, 70, 71, 72, 73, 77, 80, 85 ]
