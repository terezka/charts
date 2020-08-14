module HeatMap exposing (..)

import Svg exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes exposing (width, height, stroke, fill, r, transform)
import Svg.Tiles as Tiles exposing (..)


proportion : Float -> Float
proportion =
  Tiles.proportion identity data


heatmap : Map msg
heatmap =
  { tiles = List.indexedMap tile data
  , tilesPerRow = 10
  , tileWidth = 30
  , tileHeight = 30
  }


{-| -}
tile : Int -> Float -> Tile msg
tile index value =
  { content = Nothing
  , attributes = [ fill ("rgba(253, 185, 231, " ++ String.fromFloat (proportion value) ++ ")") ]
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
