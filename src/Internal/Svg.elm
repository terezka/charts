module Internal.Svg exposing (Shape(..), Variety(..), viewShape)

import Svg exposing (Svg, Attribute)
import Svg.Attributes as Attributes
import Svg.Coordinates exposing (Plane, place, toSVGX, toSVGY, placeWithOffset)


{-| -}
type Shape
  = Circle
  | Triangle
  | Square
  | Diamond
  | Cross
  | Plus


{-| -}
type Variety
  = Empty Float
  | Disconnected Float
  | Aura Float Float
  | Opaque Float Float
  | Full


viewShape : Float -> Variety -> Shape -> String -> Plane -> Float -> Float -> Svg msg
viewShape radius variety shape color plane x y =
  let size = 2 * pi * radius
      view_ =
        case shape of
          Circle   -> viewCircle
          Triangle -> viewTriangle
          Square   -> viewSquare
          Diamond  -> viewDiamond
          Cross    -> viewCross
          Plus     -> viewPlus
  in
  view_ [] variety color size (toSVGX plane x) (toSVGY plane y)


viewCircle : List (Svg.Attribute msg) -> Variety -> String -> Float -> Float -> Float -> Svg msg
viewCircle events variety color area x y =
  let
    radius = sqrt (area / pi)
    attributes =
      [ Attributes.cx (String.fromFloat x)
      , Attributes.cy (String.fromFloat y)
      , Attributes.r (String.fromFloat radius)
      ]
  in
  Svg.circle (events ++ attributes ++ varietyAttributes color variety) []


viewTriangle : List (Svg.Attribute msg) -> Variety -> String -> Float -> Float -> Float -> Svg msg
viewTriangle events variety color area x y =
  let
    attributes =
      [ Attributes.d (pathTriangle area x y) ]
  in
  Svg.path (events ++ attributes ++ varietyAttributes color variety) []


viewSquare : List (Svg.Attribute msg) -> Variety -> String -> Float -> Float -> Float -> Svg msg
viewSquare events variety color area x y =
  let
    side = sqrt area
    attributes =
      [ Attributes.x <| String.fromFloat (x - side / 2)
      , Attributes.y <| String.fromFloat (y - side / 2)
      , Attributes.width <| String.fromFloat side
      , Attributes.height <| String.fromFloat side
      ]
  in
  Svg.rect (events ++ attributes ++ varietyAttributes color variety) []


viewDiamond : List (Svg.Attribute msg) -> Variety -> String -> Float -> Float -> Float -> Svg msg
viewDiamond events variety color area x y =
  let
    side = sqrt area
    rotation = "rotate(45 " ++ String.fromFloat x ++ " " ++ String.fromFloat y  ++ ")"
    attributes =
      [ Attributes.x <| String.fromFloat (x - side / 2)
      , Attributes.y <| String.fromFloat (y - side / 2)
      , Attributes.width <| String.fromFloat side
      , Attributes.height <| String.fromFloat side
      , Attributes.transform rotation
      ]
  in
  Svg.rect (events ++ attributes ++ varietyAttributes color variety) []


viewPlus : List (Svg.Attribute msg) -> Variety -> String -> Float -> Float -> Float -> Svg msg
viewPlus events variety color area x y =
  let
    attributes =
      [ Attributes.d (pathPlus area x y) ]
  in
  Svg.path (events ++ attributes ++ varietyAttributes color variety) []


viewCross : List (Svg.Attribute msg) -> Variety -> String -> Float -> Float -> Float -> Svg msg
viewCross events variety color area x y =
  let
    rotation = "rotate(45 " ++ String.fromFloat x ++ " " ++ String.fromFloat y  ++ ")"
    attributes =
      [ Attributes.d (pathPlus area x y)
      , Attributes.transform rotation
      ]
  in
  Svg.path (events ++ attributes ++ varietyAttributes color variety) []



-- INTERNAL / PATHS


pathTriangle : Float -> Float -> Float -> String
pathTriangle area x y =
  let
    side = sqrt <| area * 4 / (sqrt 3)
    height = (sqrt 3) * side / 2
    fromMiddle = height - tan (degrees 30) * side / 2

    commands =
      [ "M" ++ String.fromFloat x ++ " " ++ String.fromFloat (y - fromMiddle)
      , "l" ++ String.fromFloat (-side / 2) ++ " " ++ String.fromFloat height
      , "h" ++ String.fromFloat side
      , "z"
      ]
  in
  String.join " " commands


pathPlus : Float -> Float -> Float ->  String
pathPlus area x y =
  let
    side = sqrt (area / 5)
    r3 = side
    r6 = side / 2

    commands =
      [ "M" ++ String.fromFloat (x - r6) ++ " " ++ String.fromFloat (y - r3 - r6)
      , "v" ++ String.fromFloat r3
      , "h" ++ String.fromFloat -r3
      , "v" ++ String.fromFloat r3
      , "h" ++ String.fromFloat r3
      , "v" ++ String.fromFloat r3
      , "h" ++ String.fromFloat r3
      , "v" ++ String.fromFloat -r3
      , "h" ++ String.fromFloat r3
      , "v" ++ String.fromFloat -r3
      , "h" ++ String.fromFloat -r3
      , "v" ++ String.fromFloat -r3
      , "h" ++ String.fromFloat -r3
      , "v" ++ String.fromFloat r3
      ]
  in
  String.join " " commands



-- INTERNAL / STYLE ATTRIBUTES


varietyAttributes : String -> Variety -> List (Svg.Attribute msg)
varietyAttributes color variety =
  case variety of
    Empty width ->
      [ Attributes.stroke color
      , Attributes.strokeWidth (String.fromFloat width)
      , Attributes.fill "white"
      ]

    Aura width opacity ->
      [ Attributes.stroke color
      , Attributes.strokeWidth (String.fromFloat width)
      , Attributes.strokeOpacity (String.fromFloat opacity)
      , Attributes.fill color
      ]

    Disconnected width ->
      [ Attributes.stroke "white"
      , Attributes.strokeWidth (String.fromFloat width)
      , Attributes.fill color
      ]

    Opaque width opacity ->
      [ Attributes.stroke color
      , Attributes.strokeWidth (String.fromFloat width)
      , Attributes.fill color
      , Attributes.fillOpacity (String.fromFloat opacity)
      ]

    Full ->
      [ Attributes.fill color ]