module Internal.Legend exposing (..)

import Html as H exposing (Html)
import Html.Attributes as HA
import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Svg.Coordinates as Coord exposing (Point, Position, Plane)
import Dict exposing (Dict)
import Internal.Property as P exposing (Property)
import Chart.Svg as S
import Chart.Attributes as CA


type Legend
  = BarLegend String (List (CA.Attribute S.Bar))
  | LineLegend String (List (CA.Attribute S.Interpolation)) (List (CA.Attribute S.Dot))


{-| -}
type alias Bars data =
  { spacing : Float
  , margin : Float
  , roundTop : Float
  , roundBottom : Float
  , grouped : Bool
  , x1 : Maybe (data -> Float)
  , x2 : Maybe (data -> Float)
  }


toBarLegends : List (CA.Attribute (Bars data)) -> List (Property data String () S.Bar) -> List Legend
toBarLegends barsAttrs properties =
  let barsConfig =
        apply barsAttrs
          { spacing = 0.05
          , margin = 0.1
          , roundTop = 0
          , roundBottom = 0
          , grouped = True
          , x1 = Nothing
          , x2 = Nothing
          }

      toBarLegend colorIndex prop =
        let defaultName = "Property #" ++ String.fromInt (colorIndex + 1)
            rounding = max barsConfig.roundTop barsConfig.roundBottom
            defaultAttrs = [ CA.roundTop rounding, CA.roundBottom rounding, CA.color (toDefaultColor colorIndex) ]
        in
        BarLegend (Maybe.withDefault defaultName prop.meta) (defaultAttrs ++ prop.attrs)
  in
  List.concatMap P.toConfigs properties
    |> List.indexedMap toBarLegend



toDotLegends : List (Property data String S.Interpolation S.Dot) -> List Legend
toDotLegends properties =
  let toInterConfig attrs =
        apply attrs
          { method = Nothing
          , color = CA.blue
          , width = 1
          , opacity = 0
          , design = Nothing
          , dashed = []
          }

      toDotLegend props prop colorIndex =
        let defaultOpacity = if List.length props > 1 then 0.4 else 0
            interAttr = [ CA.color (toDefaultColor colorIndex), CA.opacity defaultOpacity ] ++ prop.inter
            interConfig = toInterConfig interAttr
            defaultAttrs = [ CA.color interConfig.color, if interConfig.method == Nothing then CA.circle else identity ]
            dotAttrs = defaultAttrs ++ prop.attrs
            defaultName = "Property #" ++ String.fromInt (colorIndex + 1)
        in
        LineLegend (Maybe.withDefault defaultName prop.meta) interAttr dotAttrs
  in
  List.map P.toConfigs properties
    |> List.concatMap (\ps -> List.map (toDotLegend ps) ps)
    |> List.indexedMap (\colorIndex f -> f colorIndex)


apply : List (a -> a) -> a -> a
apply funcs default =
  let apply_ f a = f a in
  List.foldl apply_ default funcs


toDefaultColor : Int -> String
toDefaultColor =
  toDefault CA.blue [ CA.pink, CA.purple, CA.blue, CA.turquoise, CA.orange, CA.green, CA.red ]


toDefault : a -> List a -> Int -> a
toDefault default items index =
  let dict = Dict.fromList (List.indexedMap Tuple.pair items)
      numOfItems = Dict.size dict
      itemIndex = remainderBy numOfItems index
  in
  Dict.get itemIndex dict
    |> Maybe.withDefault default