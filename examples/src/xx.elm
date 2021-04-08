
-- ITEMS


{-| -}
type Item datum a =
  Item
    { a | datum : datum
    , render : () -> Svg Never
    , x1 : Float
    , x2 : Float
    , y1 : Float
    , y2 : Float
    }


{-| -}
type alias BinItem datum value =
  Item datum
    { items : List (BarItem datum value) }


{-| -}
type alias BarItem datum value =
  Item datum
    { start : Float
    , end : Float
    , y : value
    , color : String
    , name : String -- TODO id instead?
    , unit : String
    }


{-| -}
type alias DotItem value datum =
  Item datum
    { x : Float
    , y : value
    , color : String
    , name : String -- TODO id instead?
    , unit : String
    , dot : Dot
    }


{-| -}
top : Item datum x -> Point
top (Item config) =
  { x = config.x1 + (config.x2 - config.x1)
  , y = config.y2
  }


{-| -}
bottom : Item datum x -> Point
bottom (Item config) =
  { x = config.x1 + (config.x2 - config.x1)
  , y = config.y1
  }


{-| -}
left : Item datum x -> Point
left (Item config) =
  { x = config.x1
  , y = config.y1 + (config.y2 - config.y1)
  }


{-| -}
right : Item datum x -> Point
right (Item config) =
  { x = config.x2
  , y = config.y1 + (config.y2 - config.y1)
  }


{-| -}
center : Item datum x -> Point
center (Item config) =
  { x = config.x1 + (config.x2 - config.x1)
  , y = config.y1 + (config.y2 - config.y1)
  }


{-| -}
datum : Item datum x -> datum
datum (Item config) =
  config.datum


{-| -}
value : Item datum { config | y : value } -> value
value (Item config) =
  config.y



{-| -}
type alias Bin data =
  { datum : data
  , start : Float
  , end : Float
  }


{-| -}
toBinsFromConstant : (data -> Float) -> Float -> List data -> List (Bin (List data))
toBinsFromConstant toX width_ data =
  let fold datum_ acc =
        Dict.update (ceiling (toX datum_)) (updateDict datum_) acc

      updateDict datum_ prev =
        prev
          |> Maybe.map (\ds -> datum_ :: ds)
          |> Maybe.withDefault [ datum_ ]
          |> Just

      ceiling b =
        -- TODO
        let floored = toFloat (floor (b / width_)) * width_ in
        b - (b - floored) + width_
  in
  data
    |> List.foldr fold Dict.empty
    |> Dict.toList
    |> List.map (\( bin, ds ) -> { start = bin, end = bin + width_, datum = ds })



{-| -}
toBinsFromVariable : Maybe (data -> Float) -> Maybe (data -> Float) -> List data -> List (Bin data)
toBinsFromVariable start end =
  let toXs index prevM curr nextM =
        case ( start, end ) of
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

      fold index prev acc list =
        case list of
          a :: b :: rest -> fold (index + 1) (Just a) (acc ++ [toXs index prev a (Just b)]) (b :: rest)
          a :: [] -> acc ++ [toXs index prev a Nothing]
          [] -> acc
  in
  fold 0 Nothing []


{-| -}
type alias Bars =
  { spacing : Float
  , margin : Float
  , roundTop : Float
  , roundBottom : Bool
  , isGrouped : Bool
  }


{-| -}
type alias Bar =
  { color : String
  , border : String
  , borderWidth : Float
  , name : String
  , unit : String
  -- TODO aura
  -- TODO pattern
  }


toBarItems : Bars -> List (Property data Bar) -> List (Bin data) -> List (Items (Maybe Float) BarDetails data)
toBarItems barsConfig properties bins =
  let toConfig p d =
        D.apply (p.attrs ++ p.extra d)
          { color = ""
          , border = "white"
          , borderWidth = 0
          , name = ""
          , unit = ""
          -- TODO aura
          -- TODO pattern
          }

      amountOfBars =
        if isGrouped then toFloat (List.length properties) else 1

      toBinItem bin =
        let yMax = Coords.maximum (Property.toYs properties) [bin.datum]
            items = List.indexedMap (toBarItem bin) properties
        in
        { datum = bin.datum
        , render = \_ -> S.g [ SA.class "elm-charts__bin" ] (List.map render items)
        , x1 = bin.start
        , x2 = bin.end
        , y1 = 0
        , y2 = yMax
        , items = items
        }

      toBarItem bin barIndex property =
        let length_ = bin.end - bin.start
            margin_ = length_ * barsConfig.margin
            width_ = (length_ - margin_ * 2 - (amountOfBars - 1) * barsConfig.spacing) / amountOfBars
            offset = if isGrouped then toFloat barIndex * width_ + toFloat barIndex * barsConfig.spacing else 0
            x1_ = bin.end - length_ + margin_ + offset
        in
        Property.toConfigs property
          |> List.map (toBarPieceItem bin barIndex x1_ width_)
          |> List.reverse

      toBarPieceItem bin barIndex x1_ width_ property =
        let config = toConfig property bin.datum
            x2_ = x1_ + width_
            y1_ = Maybe.withDefault 0 (property.visual bin.datum) - Maybe.withDefault 0 (property.value bin.datum)
            y2_ = Maybe.withDefault 0 (property.visual bin.datum)
            color_ = if config.color == "" then toDefaultColor barIndex else config.color
            name_ = if config.name == "" then String.fromInt barIndex else config.name
        in
        { datum = bin.datum
        , render = \_ ->
            bar
              [ color color_
              , border config.border
              , borderWidth config.borderWidth
              , roundTop config.roundTop
              , roundBottom (if config.roundBottom then config.roundTop else 0)
              ]
              (Position x1_ y1_ x2_ y2_)
        , x1 = x1
        , x2 = x1 + width_
        , y1 = y1_
        , y2 = y2_
        , start = bin.start
        , end = bin.end
        , y = property.value bin.datum
        , name = name_
        , unit = config.unit
        , color = color_
        }
  in
  List.map toBinItem bins
