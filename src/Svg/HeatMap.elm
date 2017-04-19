module Svg.HeatMap exposing (HeatMap, Tile, ColorScale(..), heatmap)

{-| _Disclaimer:_ If you're looking to a plotting library, then
use [elm-plot](https://github.com/terezka/elm-plot) instead, as this library is not
made to be user friendly. If you feel like you're missing something in elm-plot,
you're welcome to open an issue in the repo and I'll see what I can do
to accommodate your needs!

---

View for creating a SVG heatmap. Note that this return a SVG element not yet wrapped
in the `svg` tag.

# Definitions
@docs HeatMap, Tile, ColorScale

# View
@docs heatmap
-}

import Svg exposing (Svg, Attribute, g, path, rect, text)
import Svg.Attributes as Attributes exposing (class, width, height, stroke, fill, d, transform)
import Array exposing (Array)



-- HEAT MAPS


{-| -}
type alias HeatMap msg =
  { tiles : List (Tile msg)
  , tilesPerRow : Int
  , width : Float
  , height : Float
  , color :
      { scale : ColorScale
      , missing : String
      }
  }


{-| -}
type alias Tile msg =
  { content : Maybe (Svg msg)
  , attributes : List (Attribute msg)
  , value : Maybe Float
  , index : Int
  }


{-| -}
type ColorScale
  = Gradient Int Int Int
  | Chunks (Array String)


{-| -}
heatmap : HeatMap msg -> Svg msg
heatmap { tiles, tilesPerRow, width, height, color } =
  let
    lowestValue =
      List.filterMap .value tiles
        |> List.minimum
        |> Maybe.withDefault 0

    highestValue =
      List.filterMap .value tiles
        |> List.maximum
        |> Maybe.withDefault lowestValue

    tileWidth =
      width / toFloat tilesPerRow

    tilesPerColumn =
      ceiling (toFloat (List.length tiles) / toFloat tilesPerRow)

    tileHeight =
      height / toFloat tilesPerColumn

    proportion value =
      (value - lowestValue) / (highestValue - lowestValue)

    tileColor value =
      case value of
        Just float ->
          case color.scale of
            Gradient r g b ->
              rgba r g b (proportion float)

            Chunks colors ->
              chunkColor colors (proportion float)

        Nothing ->
          color.missing

    tileXCoord index =
      toString <| tileWidth * toFloat (index % tilesPerRow)

    tileYCoord index =
      toString <| tileHeight * toFloat (index // tilesPerRow)

    tileAttributes { value, index, attributes } =
      [ Attributes.stroke "white"
      , Attributes.strokeWidth "1px"
      ]
      ++ attributes ++
      [ Attributes.width (toString tileWidth)
      , Attributes.height (toString tileHeight)
      , Attributes.fill (tileColor value)
      , Attributes.x (tileXCoord index)
      , Attributes.y (tileYCoord index)
      ]

    viewTile tile =
      g [ Attributes.class "elm-plot__heat-map__tile" ]
        [ rect (tileAttributes tile) [] ]
  in
    g [ Attributes.class "elm-plot__heat-map" ] (List.map viewTile tiles)



-- BORING FUNCTIONS


rgba : Int -> Int -> Int -> Float -> String
rgba r g b opacity =
  "rgba("
  ++ toString r
  ++ ", "
  ++ toString g
  ++ ", "
  ++ toString b
  ++ ", "
  ++ toString opacity
  ++ ")"


chunkColor : Array String -> Float -> String
chunkColor colors proportion =
  Array.get (chunkColorIndex colors proportion) colors
    |> Maybe.withDefault "grey"


chunkColorIndex : Array String -> Float -> Int
chunkColorIndex colors proportion =
  proportion * toFloat (Array.length colors)
    |> round
    |> max 0
    |> min (Array.length colors - 1)
