module Internal.Produce exposing (..)

import Html as H exposing (Html)
import Html.Attributes as HA
import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Internal.Coordinates as Coord exposing (Point, Position, Plane)
import Dict exposing (Dict)
import Internal.Property as P exposing (Property)
import Chart.Svg as S
import Chart.Attributes as CA
import Internal.Helpers as Helpers
import Internal.Group as G
import Internal.Item as I


{-| -}
type alias Bars data =
  { spacing : Float
  , margin : Float
  , roundTop : Float
  , roundBottom : Float
  , grouped : Bool
  , grid : Bool
  , x1 : Maybe (data -> Float)
  , x2 : Maybe (data -> Float)
  }


toBarSeries : List (CA.Attribute (Bars data)) -> List (P.Property data String () S.Bar) -> List data -> List (G.Group () S.Bar (Maybe Float) data)
toBarSeries barsAttrs properties data =
  let barsConfig =
        Helpers.apply barsAttrs
          { spacing = 0.05
          , margin = 0.1
          , roundTop = 0
          , roundBottom = 0
          , grouped = True
          , grid = True
          , x1 = Nothing
          , x2 = Nothing
          }

      toBarConfig attrs =
        Helpers.apply attrs
          { roundTop = 0
          , roundBottom = 0
          , color = CA.blue
          , border = "white"
          , borderWidth = 0
          , opacity = 1
          , design = Nothing
          }

      toBin index prevM curr nextM =
        case ( barsConfig.x1, barsConfig.x2 ) of
          ( Nothing, Nothing ) ->
            { datum = curr, start = toFloat (index + 1) - 0.5, end = toFloat (index + 1) + 0.5 }

          ( Just toStart, Nothing ) ->
            case ( prevM, nextM ) of
              ( _, Just next ) ->
                { datum = curr, start = toStart curr, end = toStart next }
              ( Just prev, Nothing ) ->
                { datum = curr, start = toStart curr, end = toStart curr + (toStart curr - toStart prev) }
              ( Nothing, Nothing ) ->
                { datum = curr, start = toStart curr, end = toStart curr + 1 }

          ( Nothing, Just toEnd ) ->
            case ( prevM, nextM ) of
              ( Just prev, _ ) ->
                { datum = curr, start = toEnd prev, end = toEnd curr }
              ( Nothing, Just next ) ->
                { datum = curr, start = toEnd curr - (toEnd next - toEnd curr), end = toEnd curr }
              ( Nothing, Nothing ) ->
                { datum = curr, start = toEnd curr - 1, end = toEnd curr }

          ( Just toStart, Just toEnd ) ->
            { datum = curr, start = toStart curr, end = toEnd curr }


      toSeriesItem bins sections barIndex sectionIndex section colorIndex =
        I.Item
          { config =
              { config = ()
              , items = List.map (toBarItem sections barIndex sectionIndex section colorIndex) bins
              }
          , toLimits = \c -> Coord.foldPosition I.getLimits c.items
          , toPosition = \plane c -> Coord.foldPosition (I.getPosition plane) c.items
          , toSvg = \plane config _ -> S.g [ SA.class "elm-charts__bar-series" ] (List.map (I.toSvg plane) config.items)
          , toHtml = \c -> [ H.table [ HA.style "margin" "0" ] (List.concatMap I.toHtml c.items) ]
          }


      toBarItem sections barIndex sectionIndex section colorIndex bin =
        let numOfBars = if barsConfig.grouped then toFloat (List.length properties) else 1
            numOfSections = toFloat (List.length sections)

            start = bin.start
            end = bin.end
            visual = section.visual bin.datum
            value = section.value bin.datum

            length = end - start
            margin = length * barsConfig.margin
            spacing = length * barsConfig.spacing
            width = (length - margin * 2 - (numOfBars - 1) * spacing) / numOfBars
            offset = if barsConfig.grouped then toFloat barIndex * width + toFloat barIndex * spacing else 0

            x1 = start + margin + offset
            x2 = start + margin + offset + width
            minY = if numOfSections > 1 then max 0 else identity
            y1 = minY <| Maybe.withDefault 0 visual - Maybe.withDefault 0 value
            y2 = minY <| Maybe.withDefault 0 visual

            isFirst = sectionIndex == 0
            isLast = toFloat sectionIndex == numOfSections - 1
            isSingle = numOfSections == 1

            roundTop = if isSingle || isLast then barsConfig.roundTop else 0
            roundBottom = if isSingle || isFirst then barsConfig.roundBottom else 0
            color = Helpers.toDefaultColor colorIndex
            defaultAttrs = [ CA.roundTop roundTop, CA.roundBottom roundBottom, CA.color color ]
            attrs = defaultAttrs ++ section.attrs ++ section.extra barIndex sectionIndex section.meta bin.datum
            product = toBarConfig attrs
        in
        I.Item
          { config =
              { product = product
              , values =
                  { datum = bin.datum
                  , x1 = start
                  , x2 = end
                  , yOrg = value
                  , y = value
                  }
              , tooltipInfo =
                  { property = barIndex
                  , stack = sectionIndex
                  , name = section.meta
                  , color = product.color
                  , border = product.border
                  , borderWidth = product.borderWidth
                  }
              , toAny = I.Bar
              }
          , toLimits = \config -> { x1 = x1, x2 = x2, y1 = min y1 y2, y2 = max y1 y2 }
          , toPosition = \_ config -> { x1 = x1, x2 = x2, y1 = y1, y2 = y2 }
          , toSvg = \plane config position -> S.bar plane attrs position
          , toHtml = \c -> [ tooltipRow c.tooltipInfo.color (toDefaultName colorIndex c.tooltipInfo.name) value ]
          }
  in
  Helpers.withSurround data toBin |> \bins ->
    List.map P.toConfigs properties
      |> List.indexedMap (\barIndex props -> List.indexedMap (toSeriesItem bins props barIndex) (List.reverse props))
      |> List.concat
      |> List.indexedMap (\colorIndex f -> f colorIndex)



-- SERIES


{-| -}
toDotSeries : (data -> Float) -> List (Property data String S.Interpolation S.Dot) -> List data -> List (G.Group S.Interpolation S.Dot (Maybe Float) data)
toDotSeries toX properties data =
  let toInterConfig attrs =
        Helpers.apply attrs
          { method = Nothing
          , color = Helpers.blue
          , width = 1
          , opacity = 0
          , design = Nothing
          , dashed = []
          }

      toDotConfig attrs =
        Helpers.apply attrs
          { color = Helpers.blue
          , opacity = 1
          , size = 6
          , border = "white"
          , borderWidth = 0
          , aura = 0
          , auraWidth = 10
          , shape = Nothing
          }

      toSeriesItem lineIndex props sublineIndex prop colorIndex =
        let dotItems = List.map (toDotItem lineIndex sublineIndex colorIndex prop interConfig) data
            defaultOpacity = if List.length props > 1 then 0.4 else 0
            interAttr = [ CA.color (Helpers.toDefaultColor colorIndex), CA.opacity defaultOpacity ] ++ prop.inter
            interConfig = toInterConfig interAttr
        in
        I.Item
          { config =
              { items = dotItems
              , config = interConfig
              }
          , toSvg = \plane _ _ ->
              let toBottom datum_ =
                    Maybe.map2 (\real visual -> visual - real) (prop.value datum_) (prop.visual datum_)
              in
              S.g
                [ SA.class "elm-charts__series" ]
                [ S.area plane toX (Just toBottom) prop.visual interAttr data
                , S.interpolation plane toX prop.visual interAttr data
                , S.g [ SA.class "elm-charts__dots" ] (List.map (I.toSvg plane) dotItems)
                ]
          , toLimits = \c -> Coord.foldPosition I.getLimits c.items
          , toPosition = \plane c -> Coord.foldPosition (I.getPosition plane) c.items
          , toHtml = \c -> [ H.table [ HA.style "margin" "0" ] (List.concatMap I.toHtml c.items) ]
          }

      toDotItem lineIndex sublineIndex colorIndex prop interConfig datum_ =
        let defaultAttrs = [ CA.color interConfig.color, CA.border interConfig.color, if interConfig.method == Nothing then CA.circle else identity ]
            dotAttrs = defaultAttrs ++ prop.attrs ++ prop.extra lineIndex sublineIndex prop.meta datum_
            config = toDotConfig dotAttrs
            x_ = toX datum_
            y_ = Maybe.withDefault 0 (prop.visual datum_)
        in
        I.Item
          { toSvg = \plane _ _ ->
              case prop.value datum_ of
                Nothing -> S.text ""
                Just _ -> S.dot plane .x .y dotAttrs { x = x_, y = y_ }
          , toHtml = \c -> [ tooltipRow c.tooltipInfo.color (toDefaultName colorIndex c.tooltipInfo.name) (prop.value datum_) ]
          , toLimits = \_ -> { x1 = x_, x2 = x_, y1 = y_, y2 = y_ }
          , toPosition = \plane _ ->
              let radius = Maybe.withDefault 0 <| Maybe.map (S.toRadius config.size) config.shape
                  radiusX_ = Coord.scaleCartesianX plane radius
                  radiusY_ = Coord.scaleCartesianY plane radius
              in
              { x1 = x_ - radiusX_
              , x2 = x_ + radiusX_
              , y1 = y_ - radiusY_
              , y2 = y_ + radiusY_
              }
          , config =
              { product = config
              , values =
                  { datum = datum_
                  , x1 = x_
                  , x2 = x_
                  , yOrg = prop.value datum_
                  , y = prop.value datum_
                  }
              , tooltipInfo =
                  { property = lineIndex
                  , stack = sublineIndex
                  , name = prop.meta
                  , color =
                      case config.color of
                        "white" -> interConfig.color
                        _ -> config.color
                  , border = config.border
                  , borderWidth = config.borderWidth
                  }
              , toAny = I.Dot
              }
          }
  in
  List.map P.toConfigs properties
    |> List.indexedMap (\lineIndex ps -> List.indexedMap (toSeriesItem lineIndex ps) ps)
    |> List.concat
    |> List.indexedMap (\colorIndex f -> f colorIndex)



-- RENDER


tooltipRow : String -> String -> Maybe Float -> H.Html msg
tooltipRow color title maybeValue =
  H.tr
    []
    [ H.td
        [ HA.style "color" color
        , HA.style "padding" "0"
        , HA.style "padding-right" "3px"
        ]
        [ H.text (title ++ ":") ]
    , H.td
        [ HA.style "text-align" "right"
        , HA.style "padding" "0"
        ]
        [ H.text (Maybe.withDefault "N/A" <| Maybe.map String.fromFloat maybeValue) ]
    ]


toDefaultName : Int -> Maybe String -> String
toDefaultName index name =
  Maybe.withDefault ("Property #" ++ String.fromInt (index + 1)) name
