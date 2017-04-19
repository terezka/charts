module HeatMap exposing (..)

import Svg exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes exposing (width, height, stroke, fill, r, transform)
import Svg.View as View exposing (..)


heatmap : HeatMap msg
heatmap =
  { tiles = List.indexedMap tile [ 1, 2, 3, 6, 8, 9, 6, 4, 2, 1, 3, 6, 8, 9, 6, 4, 2, 1, 4, 2, 1, 9, 6, 4, 2, 1, 3, 6, 8, 9, 6, 4, 2, 1, 4, 2, 1, 3, 6, 8, 9, 1, 2, 3, 6, 8, 9, 6, 4, 2, 1, 3, 6, 8, 9, 6, 4, 2, 1, 4, 2, 1, 9, 6, 4, 2, 1, 3, 6, 8, 9, 6, 4, 2, 1, 4, 2, 1, 3, 6, 8, 9,6, 4, 2, 1, 4, 2, 1, 3, 6, 8, 9, 6, 4, 2, 1, 4, 2, 1, 3, 6, 8, 9, 2, 1, 3, 6, 8, 9 ]
  , tilesPerRow = 10
  , width = 300
  , height = 300
  , color = { scale = Gradient 253 185 231, missing = "grey" }
  }


{-| -}
tile : Int -> Float -> Tile msg
tile index value =
  { content = Nothing
  , attributes = []
  , value = Just value
  , index = index
  }



main : Svg msg
main =
  svg
    [ width (toString heatmap.width)
    , height (toString heatmap.height)
    ]
    [ View.heatmap heatmap ]
