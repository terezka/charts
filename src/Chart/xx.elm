





-- ITEM API


type Item details =
  Item
    { details : details
    , position : Plane -> details -> Position
    , render : Plane -> details -> Position -> Svg Never
    }


render : Plane -> Item details -> Svg msg
render plane (Item item) =
  item.render plane item.details (item.position plane item.details)


center : Plane -> Item details -> Svg msg
center plane (Item item) =
  let pos = item.position plane item.details in ..


type alias BarsItem meta datum =
  Item
    { properties : List (Property datum meta Bar)
    , bins : List (BinItem meta datum)
    }


type BinItem meta datum =
  Item
    { meta : meta
    , datum : datum
    , start : Float
    , end : Float
    , bars : List (BarItem datum)
    }


type BarItem meta datum =
  Item
    { meta : meta
    , datum : datum
    , sections : List (SectionItem datum)
    }


type SectionItem meta datum =
  Item
    { meta : meta
    , datum : datum
    , independent : Float
    , dependent : Maybe Float
    , config : Bar
    }


render : Plane -> Item meta config -> Svg msg



-- PRODUCTION


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


toBarItems : List (Attribute (Bars data)) -> List (Property data meta () Bar) -> List data -> BarsItem meta data
toBarItems barsAttrs properties data =
  let barsConfig : Bars data
      barsConfig =
        apply barsAttrs
          { spacing = 0.01
          , margin = 0.1
          , roundTop = 0
          , roundBottom = 0
          , grouped = False
          , x1 = Nothing
          , x2 = Nothing
          }

      toBin : Int -> Maybe data -> data -> Maybe data -> Bin data
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

      toBinItem : Bin data -> BinItem meta data
      toBinItem bin =
        Item
          { details =
              { datum = bin.datum
              , start = bin.start
              , end = bin.end
              , bars = List.indexedMap (toBarItem bin) properties
              }
          , position = \plane config ->
              { x1 = bin.start
              , x2 = bin.end
              , y1 = 0
              , y2 = C.maximum (List.map (getY2 plane) config.bars)
              }
          , render = \plane config _ ->
              S.g [ SA.class "elm-charts__bin" ] (List.map (render plane) config.bars)
          }

      toBinItem : Bin data -> Int -> Property data meta () Bar -> BinItem meta data
      toBarItem bin barIndex prop =
        let sections = P.toConfigs prop in
        List.indexedMap (toSectionItem bin sections barIndex) (List.reverse sections)

      toSectionItem : Bin data -> Int -> List (P.Config data meta Bar) -> Int -> Int -> P.Config data meta Bar -> BinItem meta data
      toSectionItem bin sections barIndex sectionIndex section =
        let numOfBars = if config.grouped then List.length properties else 1
            numOfSections = List.length sections

            start = bin.start
            end = bin.end
            visual = section.visual bin.datum
            value = section.value bin.datum

            length = end - start
            margin = length * config.margin
            width = (length - margin * 2 - (config.numOfBars - 1) * config.spacing) / config.numOfBars
            offset = toFloat config.barIndex * width_ + toFloat config.barIndex * config.spacing

            x1 = start + margin + offset
            x2 = start + margin + offset + width
            y1 = Maybe.withDefault 0 visual - Maybe.withDefault 0 value
            y2 = Maybe.withDefault 0 visual

            isFirst = config.sectionIndex == 0
            isLast = config.sectionIndex == config.numOfSections - 1
            isSingle = config.numOfSections == 1

            roundTop = if isSingle || isLast then config.roundTop else 0
            roundBottom = if isSingle || isFirst then config.roundBottom else 0
            color = toDefaultColor (config.barIndex + config.sectionIndex)
            defaultAttrs = [ CA.roundTop roundTop, CA.roundBottom roundBottom, CA.color color ]
            attrs = defaultAttrs ++ section.attrs ++ section.extra bin.datum
        in
        Item
          { details =
              { meta = meta
              , datum = datum
              , start = start
              , end = end
              , value = value
              , visual = visual
              , config =
                  apply attrs
                    { roundTop = 0
                    , roundBottom = 0
                    , color = CA.blue
                    , border = CA.white
                    , borderWidth = 0
                    }
              }
          , position = \_ _ ->
              { x1 = x1, x2 = x2, y1 = y1, y2 = y2 }
          , render = \plane config position ->
              S.bar plane config.attrs position
          }
  in
  Item
    { details =
        { properties = properties
        , bins = List.map toBinItem (withSurround data toBin)
        }
    , position = \plane config ->
        { x1 = C.minimum (List.map (getX1 plane) config.bins)
        , x2 = C.maximum (List.map (getX2 plane) config.bins)
        , y1 = C.minimum (List.map (getY1 plane) config.bins)
        , y2 = C.maximum (List.map (getY2 plane) config.bins)
        }
    , render = \plane config _ ->
        S.g [ SA.class "elm-charts__bins" ] (List.map (render plane) config.bins)
    }



toSeriesItems : (data -> Float) -> List (Property data meta Interpolation Dot) -> List data -> Plane -> List (SeriesItem data (Maybe Float))
toSeriesItems toX properties data plane =
  let toLineItem index prop =
        Item
          { details =
              { property = prop
              , dots = List.map (toDotItem index prop) data
              }
          , position = \plane config ->
              { x1 = C.minimum (List.map (getX1 plane) config.dots)
              , x2 = C.maximum (List.map (getX2 plane) config.dots)
              , y1 = C.minimum (List.map (getY1 plane) config.dots)
              , y2 = C.maximum (List.map (getY2 plane) config.dots)
              }
          , render = \plane config _ ->
              let toBottom datum = Maybe.map2 (\real visual -> visual - real) (prop.value datum) (prop.visual datum)
                  attrs = [ CA.color (toDefaultColor index) ] ++ prop.inter
              in
              S.g
                [ SA.class "elm-charts__series" ]
                [ S.area plane toX (Just toBottom) prop.visual attrs data
                , S.interpolation plane toX prop.visual attrs data
                , S.g [ SA.class "elm-charts__dots" ] (List.map (render plane) config.items)
                ]
          }

      toDotItem index prop datum =
        let x = toX datum
            y = Maybe.withDefault 0 (prop.visual datum)
            attrs = [ CA.color (toDefaultColor index) ] ++ section.attrs ++ section.extra bin.datum
        in
        Item
          { details =
              { meta = meta
              , datum = datum
              , x = x
              , value = prop.value datum
              , visual = prop.visual datum
              , config =
                  apply attrs
                    { color = blue
                    , opacity = 1
                    , size = 6
                    , border = "white"
                    , borderWidth = 1
                    , aura = 0
                    , auraWidth = 10
                    , shape = Just CA.Circle
                    }
              }
          , position = \plane config ->
              let radius =
                    config.shape
                      |> Maybe.map (S.toRadius config.size)
                      |> Maybe.withDefault 0

                  radiusX = scaleCartesian plane.x radius
                  radiusY = scaleCartesian plane.y radius
              in
              { x1 = x - radiusX
              , x2 = x + radiusX
              , y1 = y - radiusY
              , y2 = y + radiusY
            }
          , render = \plane config position ->
              case prop.value datum of
                Nothing -> S.text ""
                Just _ -> S.dot plane_ .x .y attrs { x = x, y = y_ }
          }
  in
  List.map P.toConfigs properties
    |> List.indexedMap (\i ps -> List.map (toLineItem i) ps)
    |> List.concat


series : (data -> Float) -> List (Property data meta Series) -> List data -> List (SeriesItem data meta)

dot : data -> (data -> Float) -> (data -> Float) -> List (Attribute Dot) -> meta -> Item data Dot meta





-- INTERNAL


withSurround : List a -> (Int -> Maybe a -> a -> Maybe a -> b) -> List b
withSurround all func =
  let fold index prev acc list =
        case list of
          a :: b :: rest -> fold (index + 1) (Just a) (acc ++ [func index prev a (Just b)]) (b :: rest)
          a :: [] -> acc ++ [func index prev a Nothing]
          [] -> acc
  in
  fold 0 Nothing []


barItem : datum -> (datum -> Float) -> (datum -> Float) -> (datum -> Float) -> (datum -> Float) -> List (CA.Attribute Bar) -> meta -> Item datum Bar meta


main =
  let toX =
        .x
          |> withGroupOf 3
          |> withBarMargin 0.1
          |> withBarSpacing 0.01
  in
  S.bars []
    [ S.property .y
        [ C.roundTop 0.1
        , C.color C.blue
        , C.borderWidth 2
        ]
        { name = "cats"
        , unit = "km/h"
        , unknown = True
        }
        (always [])
    ]
    [ datum ]

    { }
    |> S.render plane





main =
  S.barItem datum .x1 .y1 .x2 .y2
    [ C.roundTop 0.1
    , C.color C.blue
    , C.borderWidth 2
    ]
    { name = "cats"
    , unit = "km/h"
    , unknown = True
    }


bar : Plane -> Item datum config meta -> Svg msg
