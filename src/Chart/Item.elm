module Chart.Item exposing
  ( Item, Product, Stack, Bin
  , onlyBarSeries, onlyDotSeries, only
  , General, RealConfig(..), toGeneral
  , Group, Grouping, groupBy
  , isSameSeries, isSameBin, isSameStack, isSame
  , getProducts, getCommonality
  , getValue, getDatum, getColor, getName
  , getTop, getCenter, getX1, getX2, getY2, getY1, getPosition, getBounds
  , Property, Bars, toBarSeries, toDotSeries, render
  )


import Html as H exposing (Html)
import Html.Attributes as HA
import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Svg.Coordinates as Coord exposing (Point, Position, Plane, scaleCartesian)
import Dict exposing (Dict)
import Internal.Property as P exposing (Property)
import Chart.Svg as S
import Chart.Attributes as CA


-- TODO clean up plane
-- TODO clean up property
-- TODO rename series to scatter
-- TODO add element index


{-| -}
type Item a =
  Item
    { details : a
    , render : Plane -> a -> Position -> Svg Never
    , bounds : a -> Position
    , position : Plane -> a -> Position
    }


{-| -}
type alias Product config datum =
  Item
    { datum : datum
    , config : config
    , property : Int
    , stack : Int
    , name : String
    , x1 : Float
    , x2 : Float
    , y : Maybe Float
    }


{-| -}
type alias Group inter config datum =
  Item
    { config : inter
    , items : List (Product config datum)
    }


{-| -}
groupBy : Grouping inter config datum -> List (Product config datum) -> List (Group inter config datum)
groupBy (Grouping { grouping, toPosition, toBounds }) products_ =
  let toGroup ( config, items ) =
        Item
          { details =
              { config = config
              , items = items
              }
          , bounds = \c ->
              toBounds c.config c.items
          , position = \plane c ->
              toPosition plane c.config c.items
          , render = \plane c _ ->
              S.g [ SA.class "elm-charts__collection" ] (List.map (render plane) c.items)
          }
  in
  List.map toGroup (grouping products_)


{-| -}
getProducts : Group a config datum -> List (Product config datum)
getProducts (Item item) =
  item.details.items


{-| -}
getCommonality : Group a config datum -> a
getCommonality (Item item) =
  item.details.config


{-| -}
isSameSeries : Grouping String config datum
isSameSeries =
  collector
    { commonality = \(Item { details }) -> details.name
    , grouping = (==)
    , bounds = \_ products_ ->
        { x1 = Coord.minimum [ getBounds >> .x1 >> Just ] products_
        , x2 = Coord.maximum [ getBounds >> .x2 >> Just ] products_
        , y1 = Coord.minimum [ getBounds >> .y1 >> Just ] products_
        , y2 = Coord.maximum [ getBounds >> .y2 >> Just ] products_
        }
    , position = \plane _ products_ ->
        { x1 = Coord.minimum [ getX1 plane >> Just ] products_
        , x2 = Coord.maximum [ getX2 plane >> Just ] products_
        , y1 = Coord.minimum [ getY1 plane >> Just ] products_
        , y2 = Coord.maximum [ getY2 plane >> Just ] products_
        }
    }


{-| -}
isSameBin : Grouping (Bin datum) config datum
isSameBin =
  collector
    { commonality = \(Item { details }) ->
        { start = details.x1
        , end = details.x2
        , datum = details.datum
        }
    , grouping = \a b -> a.start == b.start && a.end == b.end && a.datum == b.datum
    , bounds = \bin products_ ->
        { x1 = bin.start
        , x2 = bin.end
        , y1 = Coord.minimum [ getBounds >> .y1 >> Just ] products_
        , y2 = Coord.maximum [ getBounds >> .y2 >> Just ] products_
        }
    , position = \plane bin products_ ->
        { x1 = bin.start
        , x2 = bin.end
        , y1 = Coord.minimum [ getY1 plane >> Just ] products_
        , y2 = Coord.maximum [ getY2 plane >> Just ] products_
        }
    }


{-| -}
type alias Stack datum =
  { datum : datum
  , start : Float
  , end : Float
  , index : Int
  }


{-| -}
isSameStack : Grouping (Stack datum) config datum
isSameStack =
  collector
    { commonality = \(Item { details }) ->
        { start = details.x1
        , end = details.x2
        , datum = details.datum
        , index = details.property
        }
    , grouping = \a b -> a.index == b.index && a.start == b.start && a.end == b.end && a.datum == b.datum
    , bounds = \_ products_ ->
        { x1 = Coord.minimum [ getBounds >> .x1 >> Just ] products_
        , x2 = Coord.maximum [ getBounds >> .x2 >> Just ] products_
        , y1 = Coord.minimum [ getBounds >> .y1 >> Just ] products_
        , y2 = Coord.maximum [ getBounds >> .y2 >> Just ] products_
        }
    , position = \plane _ products_ ->
        { x1 = Coord.minimum [ getX1 plane >> Just ] products_
        , x2 = Coord.maximum [ getX2 plane >> Just ] products_
        , y1 = Coord.minimum [ getY1 plane >> Just ] products_
        , y2 = Coord.maximum [ getY2 plane >> Just ] products_
        }
    }


{-| -}
isSame : (Product config datum -> a) -> Grouping a config datum
isSame toCommon =
  collector
    { commonality = toCommon
    , grouping = (==)
    , bounds = \_ products_ ->
        { x1 = Coord.minimum [ getBounds >> .x1 >> Just ] products_
        , x2 = Coord.maximum [ getBounds >> .x2 >> Just ] products_
        , y1 = Coord.minimum [ getBounds >> .y1 >> Just ] products_
        , y2 = Coord.maximum [ getBounds >> .y2 >> Just ] products_
        }
    , position = \plane _ products_ ->
        { x1 = Coord.minimum [ getX1 plane >> Just ] products_
        , x2 = Coord.maximum [ getX2 plane >> Just ] products_
        , y1 = Coord.minimum [ getY1 plane >> Just ] products_
        , y2 = Coord.maximum [ getY2 plane >> Just ] products_
        }
    }


{-| -}
type Grouping inter config datum =
  Grouping
    { grouping : List (Product config datum) -> List ( inter, List (Product config datum) )
    , toBounds : inter -> List (Product config datum) -> Position
    , toPosition : Plane -> inter -> List (Product config datum) -> Position
    }


{-| -}
collector :
  { commonality : Product config datum -> inter
  , grouping : inter -> inter -> Bool
  , bounds : inter -> List (Product config datum) -> Position
  , position : Plane -> inter -> List (Product config datum) -> Position
  } -> Grouping inter config datum
collector config =
  Grouping
    { grouping =
        List.map (\i -> ( config.commonality i, i ))
          >> gatherWith (\(a, _) (b, _) -> config.grouping a b)
          >> List.map (\(( inter, first ), rest ) -> ( inter, first :: List.map Tuple.second rest ))
    , toBounds = config.bounds
    , toPosition = config.position
    }


{-| -}
onlyBarSeries : List (Product General datum) -> List (Product S.Bar datum)
onlyBarSeries =
  List.filterMap toBar


{-| -}
onlyDotSeries : List (Product General datum) -> List (Product S.Dot datum)
onlyDotSeries =
  List.filterMap toDot


{-| -}
only : List String -> List (Product config datum) -> List (Product config datum)
only names =
  List.filter (\i -> List.member (getName i) names)


{-| -}
getColor : Product { a | color : String } data -> String
getColor (Item config) =
  config.details.config.color


{-| -}
getName : Product config data -> String
getName (Item config) =
  config.details.name


{-| -}
getPosition : Plane -> Item x -> Position
getPosition plane (Item config) =
  config.position plane config.details


{-| -}
getTop : Plane -> Item x -> Point
getTop plane (Item config) =
  let pos = config.position plane config.details in
  { x = pos.x1 + (pos.x2 - pos.x1) / 2
  , y = pos.y2
  }


{-| -}
getBottom : Plane -> Item x -> Point
getBottom plane (Item config) =
  let pos = config.position plane config.details in
  { x = pos.x1 + (pos.x2 - pos.x1) / 2
  , y = pos.y1
  }


{-| -}
getLeft : Plane -> Item x -> Point
getLeft plane (Item config) =
  let pos = config.position plane config.details in
  { x = pos.x1
  , y = pos.y1 + (pos.y2 - pos.y1) / 2
  }


{-| -}
getRight : Plane -> Item x -> Point
getRight plane (Item config) =
  let pos = config.position plane config.details in
  { x = pos.x2
  , y = pos.y1 + (pos.y2 - pos.y1) / 2
  }


{-| -}
getCenter : Plane -> Item x -> Point
getCenter plane (Item config) =
  let pos = config.position plane config.details in
  { x = pos.x1 + (pos.x2 - pos.x1) / 2
  , y = pos.y1 + (pos.y2 - pos.y1) / 2
  }


getX1 : Plane -> Item x -> Float
getX1 plane (Item config) =
  let pos = config.position plane config.details in
  pos.x1


getX2 : Plane -> Item x -> Float
getX2 plane (Item config) =
  let pos = config.position plane config.details in
  pos.x2


getY1 : Plane -> Item x -> Float
getY1 plane (Item config) =
  let pos = config.position plane config.details in
  pos.y1


getY2 : Plane -> Item x -> Float
getY2 plane (Item config) =
  let pos = config.position plane config.details in
  pos.y2


getBounds : Item x -> Position
getBounds (Item config) =
  config.bounds config.details


{-| -}
getDatum : Item { config | datum : datum } -> datum
getDatum (Item config) =
  config.details.datum


{-| -}
getValue : Item { config | y : value } -> value
getValue (Item config) =
  config.details.y


{-| -}
render : Plane -> Item x -> Svg Never
render plane (Item config) =
  config.render plane config.details (config.position plane config.details)



-- PROPERTY


{-| -}
type alias Property data meta inter deco =
  P.Property data meta inter deco



-- BAR


{-| -}
type alias Bin data =
  { datum : data
  , start : Float
  , end : Float
  }


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


toBarSeries : List (CA.Attribute (Bars data)) -> List (Property data String () S.Bar) -> List data -> List (Group () S.Bar data)
toBarSeries barsAttrs properties data =
  let barsConfig =
        apply barsAttrs
          { spacing = 0.01
          , margin = 0.1
          , roundTop = 0
          , roundBottom = 0
          , grouped = False
          , x1 = Nothing
          , x2 = Nothing
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

      toSeriesItem bins sections barIndex sectionIndex section =
        Item
          { details =
              { config = ()
              , items = List.map (toBarItem sections barIndex sectionIndex section) bins
              }
          , bounds = \c ->
              { x1 = Coord.minimum [ getBounds >> .x1 >> Just ] c.items
              , x2 = Coord.maximum [ getBounds >> .x2 >> Just ] c.items
              , y1 = Coord.minimum [ getBounds >> .y1 >> Just ] c.items
              , y2 = Coord.maximum [ getBounds >> .y2 >> Just ] c.items
              }
          , position = \plane c ->
              { x1 = Coord.minimum [ getX1 plane >> Just ] c.items
              , x2 = Coord.maximum [ getX2 plane >> Just ] c.items
              , y1 = Coord.minimum [ getY1 plane >> Just ] c.items
              , y2 = Coord.maximum [ getY2 plane >> Just ] c.items
              }
          , render = \plane config _ ->
              S.g [ SA.class "elm-charts__bar-series" ] (List.map (render plane) config.items)
          }

      toBarItem sections barIndex sectionIndex section bin =
        let numOfBars = if barsConfig.grouped then toFloat (List.length properties) else 1
            numOfSections = toFloat (List.length sections)

            start = bin.start
            end = bin.end
            visual = section.visual bin.datum
            value = section.value bin.datum

            length = end - start
            margin = length * barsConfig.margin
            width = (length - margin * 2 - (numOfBars - 1) * barsConfig.spacing) / numOfBars
            offset = toFloat barIndex * width + toFloat barIndex * barsConfig.spacing

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
            color = toDefaultColor (barIndex + sectionIndex)
            defaultAttrs = [ CA.roundTop roundTop, CA.roundBottom roundBottom, CA.color color ]
            attrs = defaultAttrs ++ section.attrs ++ section.extra bin.datum
        in
        Item
          { details =
              { name = section.meta
              , datum = bin.datum
              , property = barIndex
              , stack = sectionIndex
              , x1 = start
              , x2 = end
              , y = value
              , config =
                  apply attrs
                    { roundTop = 0
                    , roundBottom = 0
                    , color = "blue" -- TODO
                    , border = "white"
                    , borderWidth = 0
                    , opacity = 1
                    , design = Nothing
                    }
              }
          , bounds = \config ->
              { x1 = x1, x2 = x2, y1 = min y1 y2, y2 = max y1 y2 }
          , position = \_ config ->
              { x1 = x1, x2 = x2, y1 = y1, y2 = y2 }
          , render = \plane config position ->
              S.bar plane attrs position
          }
  in
  withSurround data toBin |> \bins ->
    List.map P.toConfigs properties
      |> List.indexedMap (\barIndex props -> List.indexedMap (toSeriesItem bins props barIndex) (List.reverse props))
      |> List.concat



-- SERIES


{-| -}
toDotSeries : (data -> Float) -> List (Property data String S.Interpolation S.Dot) -> List data -> List (Group S.Interpolation S.Dot data)
toDotSeries toX properties data =
  let toInterConfig attrs =
        apply attrs
          { method = Nothing
          , color = CA.blue
          , width = 1
          , opacity = 0
          , design = Nothing
          }

      toDotConfig attrs =
        apply attrs
          { color = CA.blue
          , opacity = 1
          , size = 6
          , border = "white"
          , borderWidth = 1
          , aura = 0
          , auraWidth = 10
          , shape = Nothing
          }

      toSeriesItem lineIndex sublineIndex prop =
        let dotItems = List.map (toDotItem lineIndex sublineIndex prop interConfig) data
            interAttr = [ CA.color (toDefaultColor lineIndex) ] ++ prop.inter
            interConfig = toInterConfig interAttr
        in
        Item
          { details =
              { items = dotItems
              , config = interConfig
              }
          , render = \plane _ _ ->
              let toBottom datum_ =
                    Maybe.map2 (\real visual -> visual - real) (prop.value datum_) (prop.visual datum_)
              in
              S.g
                [ SA.class "elm-charts__series" ]
                [ S.area plane toX (Just toBottom) prop.visual interAttr data
                , S.interpolation plane toX prop.visual interAttr data
                , S.g [ SA.class "elm-charts__dots" ] (List.map (render plane) dotItems)
                ]
          , bounds = \c ->
              { x1 = Coord.minimum [ getBounds >> .x1 >> Just ] c.items
              , x2 = Coord.maximum [ getBounds >> .x2 >> Just ] c.items
              , y1 = Coord.minimum [ getBounds >> .y1 >> Just ] c.items
              , y2 = Coord.maximum [ getBounds >> .y2 >> Just ] c.items
              }
          , position = \plane c ->
              { x1 = Coord.minimum [ getX1 plane >> Just ] c.items
              , x2 = Coord.maximum [ getX2 plane >> Just ] c.items
              , y1 = Coord.minimum [ getY1 plane >> Just ] c.items
              , y2 = Coord.maximum [ getY2 plane >> Just ] c.items
              }
          }

      toDotItem lineIndex sublineIndex prop interConfig datum_ =
        let defaultAttrs = [ CA.color interConfig.color, if interConfig.method == Nothing then CA.circle else identity ]
            dotAttrs = defaultAttrs ++ prop.attrs ++ prop.extra datum_
            config = toDotConfig dotAttrs
            x_ = toX datum_
            y_ = Maybe.withDefault 0 (prop.visual datum_)
        in
        Item
          { render = \plane _ _ ->
              case prop.value datum_ of
                Nothing -> S.text ""
                Just _ -> S.dot plane .x .y dotAttrs { x = x_, y = y_ }
          , bounds = \_ ->
              { x1 = x_
              , x2 = x_
              , y1 = y_
              , y2 = y_
              }
          , position = \plane _ ->
              let radius = Maybe.withDefault 0 <| Maybe.map (S.toRadius config.size) config.shape
                  radiusX_ = scaleCartesian plane.x radius
                  radiusY_ = scaleCartesian plane.y radius
              in
              { x1 = x_ - radiusX_
              , x2 = x_ + radiusX_
              , y1 = y_ - radiusY_
              , y2 = y_ + radiusY_
              }
          , details =
              { datum = datum_
              , property = lineIndex
              , stack = sublineIndex
              , x1 = x_
              , x2 = x_
              , y = prop.value datum_
              , name = prop.meta
              , config = config
              }
          }
  in
  List.map P.toConfigs properties
    |> List.indexedMap (\lineIndex ps -> List.indexedMap (toSeriesItem lineIndex) ps)
    |> List.concat



-- TOOLTIP

--type alias Tooltip

--tooltip : Tooltip -> Html msg


-- HELPERS


apply : List (a -> a) -> a -> a
apply funcs default =
  let apply_ f a = f a in
  List.foldl apply_ default funcs


withSurround : List a -> (Int -> Maybe a -> a -> Maybe a -> b) -> List b
withSurround all func =
  let fold index prev acc list =
        case list of
          a :: b :: rest -> fold (index + 1) (Just a) (acc ++ [func index prev a (Just b)]) (b :: rest)
          a :: [] -> acc ++ [func index prev a Nothing]
          [] -> acc
  in
  fold 0 Nothing [] all


gatherWith : (a -> a -> Bool) -> List a -> List ( a, List a )
gatherWith testFn list =
    let helper scattered gathered =
          case scattered of
            [] -> List.reverse gathered
            toGather :: population ->
                let ( gathering, remaining ) = List.partition (testFn toGather) population in
                helper remaining <| ( toGather, gathering ) :: gathered
    in
    helper list []



-- DEFAULTS


toDefaultColor : Int -> String
toDefaultColor =
  toDefault S.blue [ S.blue, S.pink, S.orange, S.green, S.purple, S.red ]


toDefault : a -> List a -> Int -> a
toDefault default items index =
  let dict = Dict.fromList (List.indexedMap Tuple.pair items)
      numOfItems = Dict.size dict
      itemIndex = remainderBy numOfItems index
  in
  Dict.get itemIndex dict
    |> Maybe.withDefault default




-- GENERALIZATION


{-| -}
type alias Generalizable a =
  { a
    | color : String
    , border : String
    , borderWidth : Float
  }


{-| -}
type alias General =
  { color : String
  , border : String
  , borderWidth : Float
  , real : RealConfig
  }


{-| -}
type RealConfig
  = BarConfig S.Bar
  | DotConfig S.Dot


toGeneral : (Generalizable config -> RealConfig) -> Product (Generalizable config) datum -> Product General datum
toGeneral generalize (Item product) =
  Item
    { render = \plane details position ->
        case details.y of
          Nothing ->
            S.text ""

          Just y ->
            case details.config.real of
              BarConfig bar -> S.bar plane (toBarAttrs bar) position
              DotConfig dot -> S.dot plane .x .y (toDotAttrs dot) { x = details.x1, y = y }

    , bounds = \_ -> product.bounds product.details
    , position = \plane _ -> product.position plane product.details
    , details =
        { datum = product.details.datum
        , property = product.details.property
        , stack = product.details.stack
        , x1 = product.details.x1
        , x2 = product.details.x2
        , y = product.details.y
        , name = product.details.name
        , config =
            { color = product.details.config.color
            , border = product.details.config.border
            , borderWidth = product.details.config.borderWidth
            , real = generalize product.details.config
            }
        }
    }


toBar : Product General datum -> Maybe (Product S.Bar datum)
toBar (Item product) =
  case product.details.config.real of
    DotConfig _ ->
      Nothing

    BarConfig bar ->
      Just <| Item
        { render = \plane details ->
            S.bar plane (toBarAttrs details.config)
        , bounds = \_ -> product.bounds product.details
        , position = \plane _ -> product.position plane product.details
        , details =
            { datum = product.details.datum
            , property = product.details.property
            , stack = product.details.stack
            , x1 = product.details.x1
            , x2 = product.details.x2
            , y = product.details.y
            , name = product.details.name
            , config = bar
            }
        }


toDot : Product General datum -> Maybe (Product S.Dot datum)
toDot (Item product) =
  case product.details.config.real of
    BarConfig _ ->
      Nothing

    DotConfig dot ->
      Just <| Item
        { render = \plane details _ ->
            case details.y of
              Nothing -> S.text ""
              Just y -> S.dot plane .x .y (toDotAttrs details.config) { x = details.x1, y = y }
        , bounds = \_ -> product.bounds product.details
        , position = \plane _ -> product.position plane product.details
        , details =
            { datum = product.details.datum
            , property = product.details.property
            , stack = product.details.stack
            , x1 = product.details.x1
            , x2 = product.details.x2
            , y = product.details.y
            , name = product.details.name
            , config = dot
            }
        }


toBarAttrs : S.Bar -> List (CA.Attribute S.Bar)
toBarAttrs bar =
  [ CA.color bar.color
  , CA.roundTop bar.roundTop
  , CA.roundBottom bar.roundBottom
  , CA.border bar.border
  , CA.borderWidth bar.borderWidth
  ]


toDotAttrs : S.Dot -> List (CA.Attribute S.Dot)
toDotAttrs dot =
  [ CA.color dot.color
  , CA.opacity dot.opacity
  , CA.size dot.size
  , CA.border dot.border
  , CA.borderWidth dot.borderWidth
  , CA.aura dot.aura
  , CA.auraWidth dot.auraWidth
  , CA.shape dot.shape
  ]

