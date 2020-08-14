module Svg.Tiles exposing (Map, Tile, view, tileWidth, tileHeight, tileXCoord, tileYCoord, proportion)

{-| View for creating tiled maps like heatmaps or choropleths. Note that this return a SVG element not yet wrapped
in the `svg` tag.

# Composing
@docs Map, Tile, view

# Helpers
@docs tileWidth, tileHeight, tileXCoord, tileYCoord, proportion

-}

import Svg exposing (Svg, Attribute, g, path, rect, text)
import Svg.Attributes as Attributes exposing (class, width, height, stroke, transform, style)



-- TILES


{-| (You can use the helpers for calculating most of these properties. You're welcome.)
-}
type alias Map msg =
  { tiles : List (Tile msg)
  , tilesPerRow : Int
  , tileWidth : Float
  , tileHeight : Float
  }


{-| -}
type alias Tile msg =
  { content : Maybe (Svg msg)
  , attributes : List (Attribute msg)
  , index : Int
  }


{-| View a map!
-}
view : Map msg -> Svg msg
view map =
  let
    xCoord =
      tileXCoord map.tileWidth map.tilesPerRow

    yCoord =
      tileYCoord map.tileHeight map.tilesPerRow

    tileAttributes { index, attributes } =
      [ Attributes.stroke "white"
      , Attributes.strokeWidth "1px"
      ]
      ++ attributes ++
      [ Attributes.width (String.fromFloat map.tileWidth)
      , Attributes.height (String.fromFloat map.tileHeight)
      , Attributes.x (String.fromFloat <| xCoord index)
      , Attributes.y (String.fromFloat <| yCoord index)
      ]

    viewContent index view_ =
      g [ style "text-anchor: middle;"
        , transform <|
            translate
              (xCoord index + map.tileWidth / 2)
              (yCoord index + map.tileHeight / 2 + 5)
        ]
        [  view_ ]

    viewTile tile =
      g [ Attributes.class "elm-plot__heat-map__tile" ]
        [ rect (tileAttributes tile) []
        , Maybe.map (viewContent tile.index) tile.content |> Maybe.withDefault (text "")
        ]
  in
    g [ Attributes.class "elm-plot__heat-map" ] (List.map viewTile map.tiles)



-- HELPERS


{-| Pass the __width__ of your map, and the __amount of
 tiles in a row__, and it gives you back the width of
 a single tile.
 -}
tileWidth : Int -> Int -> Int
tileWidth width tilesPerRow =
  floor (toFloat width / toFloat tilesPerRow)


{-| Pass the __height__ of your map, the __amount of
 tiles in a row__, and the __total number of tiles__,
 and it gives you back the height of a single tile.
 -}
tileHeight : Int -> Int -> Int -> Int
tileHeight height tilesPerRow numberOfTiles =
  floor (toFloat height / toFloat (tilesPerColumn numberOfTiles tilesPerRow))


tilesPerColumn : Int -> Int -> Int
tilesPerColumn numberOfTiles tilesPerRow =
  ceiling (toFloat numberOfTiles / toFloat tilesPerRow)


{-| Pass the __tile width__, the __amount of tiles in a row__, and
 the __tile's index__ and it'll get you it's x-coordinate.
-}
tileXCoord : Float -> Int -> Int -> Float
tileXCoord tileWidth_ tilesPerRow index =
  tileWidth_ * toFloat (modBy tilesPerRow index)


{-| Pass the __tile height__, the __amount of tiles in a row__ and
 the __tile's index__ and it'll get you it's y-coordinate.
-}
tileYCoord : Float -> Int -> Int -> Float
tileYCoord tileHeight_ tilesPerRow index =
  tileHeight_ * toFloat (index // tilesPerRow)


{-| For heatmaps. It calculates a value's value relative to all values.
-}
proportion : (a -> Float) -> List a -> Float -> Float
proportion toValue tiles value =
  let
    lowestValue =
      List.map toValue tiles
        |> List.minimum
        |> Maybe.withDefault 0

    highestValue =
      List.map toValue tiles
        |> List.maximum
        |> Maybe.withDefault lowestValue
  in
    (value - lowestValue) / (highestValue - lowestValue)



-- BORING FUNCTIONS


translate : Float -> Float -> String
translate x y =
  "translate(" ++ String.fromFloat x ++ ", " ++ String.fromFloat y ++ ")"
