module Chart.Item exposing
  ( Item(..), BinItem, BarItem
  , render, value, center, datum, top, getColor, getName, getBars
  , Property, property, stacked, Metric
  , Bars, bars, toBinsFromVariable, toBinItems
  , Series, series, toSeriesItems
  )


import Html as H exposing (Html)
import Html.Attributes as HA
import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Svg.Coordinates as Coord exposing (Point, Plane, scaleCartesian)
import Dict exposing (Dict)
import Internal.Property as P exposing (Property)
import Chart.Svg as S
import Chart.Attributes as CA


-- TODO clean up plane
-- TODO clean up property


{-| -}
type Item a =
  Item
    { a | render : Plane -> Svg Never
    , x1 : Float
    , x2 : Float
    , y1 : Float
    , y2 : Float
    }


{-| -}
type alias BinItem datum value =
  Item
    { datum : datum
    , items : List (BarItem datum value)
    }


{-| -}
type alias BarItem datum value =
  Item
    { datum : datum
    , start : Float
    , end : Float
    , y : value
    , color : String
    , name : String -- TODO id instead?
    , unit : String
    }


{-| -}
type alias SeriesItem datum value =
  Item
    { items : List (DotItem datum value)
    , method : Maybe CA.Method
    , area : Float
    , width : Float
    , color : String
    }


{-| -}
type alias DotItem datum value =
  Item
    { datum : datum
    , x : Float
    , y : value
    , color : String
    , name : String -- TODO id instead?
    , unit : String
    , dot : List (CA.Attribute S.Dot)
    }


{-| -}
top : Item x -> Point
top (Item config) =
  { x = config.x1 + (config.x2 - config.x1) / 2
  , y = config.y2
  }


{-| -}
bottom : Item x -> Point
bottom (Item config) =
  { x = config.x1 + (config.x2 - config.x1) / 2
  , y = config.y1
  }


{-| -}
left : Item x -> Point
left (Item config) =
  { x = config.x1
  , y = config.y1 + (config.y2 - config.y1) / 2
  }


{-| -}
right : Item x -> Point
right (Item config) =
  { x = config.x2
  , y = config.y1 + (config.y2 - config.y1) / 2
  }


{-| -}
center : Item x -> Point
center (Item config) =
  { x = config.x1 + (config.x2 - config.x1) / 2
  , y = config.y1 + (config.y2 - config.y1) / 2
  }


{-| -}
datum : Item { config | datum : datum } -> datum
datum (Item config) =
  config.datum


{-| -}
value : Item { config | y : value } -> value
value (Item config) =
  config.y


-- TODO everything should be getX
{-| -}
getColor : Item { config | color : String } -> String
getColor (Item config) =
  config.color


{-| -}
getName : Item { config | name : String } -> String
getName (Item config) =
  config.name


{-| -}
render : Plane -> Item x -> Svg Never
render plane (Item config) =
  config.render plane


{-| -}
getBars : BinItem datum value -> List (BarItem datum value)
getBars (Item config) =
  config.items



-- PROPERTY

{-| -}
type alias Metric =
  { name : String
  , unit : String
  }


{-| -}
type alias Property data meta inter deco =
  P.Property data meta inter deco


{-| -}
property : (data -> Maybe Float) -> Metric -> List (CA.Attribute inter) -> List (CA.Attribute deco) -> (data -> List (CA.Attribute deco)) -> Property data Metric inter deco
property =
  P.property


{-| -}
stacked : List (Property data meta inter deco) -> Property data meta inter deco
stacked =
  P.stacked



-- BAR


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
toBinItems : List (CA.Attribute Bars) -> List (Property data Metric () S.Bar) -> List (Bin data) -> List (BinItem data (Maybe Float))
toBinItems barsEdits properties bins =
  let barsConfig =
        apply barsEdits
          { spacing = 0.01
          , margin = 0.1
          , roundTop = 0
          , roundBottom = 0
          , grouped = False
          }

      toBarConfig defaultRoundTop defaultRoundBottom prop datum_  =
        apply (prop.attrs ++ prop.extra datum_)
          { color = ""
          , border = "white"
          , roundTop = defaultRoundTop
          , roundBottom = defaultRoundBottom
          , borderWidth = 0
          -- TODO aura
          -- TODO pattern
          }

      amountOfBars =
        if barsConfig.grouped then toFloat (List.length properties) else 1

      toBinItem bin =
        let yMax = Coord.maximum (P.toYs properties) [ bin.datum ]
            items = List.concat (List.indexedMap (toBarItem bin) properties)
        in
        Item
          { datum = bin.datum
          , render = \plane -> S.g [ SA.class "elm-charts__bin" ] (List.map (render plane) items)
          , x1 = bin.start
          , x2 = bin.end
          , y1 = 0
          , y2 = yMax
          , items = items
          }

      toBarItem bin barIndex prop =
        let length_ = bin.end - bin.start
            margin_ = length_ * barsConfig.margin
            width_ = (length_ - margin_ * 2 - (amountOfBars - 1) * barsConfig.spacing) / amountOfBars
            offset = if barsConfig.grouped then toFloat barIndex * width_ + toFloat barIndex * barsConfig.spacing else 0
            x1_ = bin.end - length_ + margin_ + offset
            pieceProperties = P.toConfigs prop
        in
        pieceProperties
          |> List.reverse
          |> List.indexedMap (toBarPieceItem bin barIndex x1_ width_ (List.length pieceProperties))

      toBarPieceItem bin barIndex x1_ width_ piecesTotal pieceIndex prop =
        -- TODO check next / prev piece for null values for rounding
        let roundTop_ =
              if barsConfig.roundTop > 0 && (pieceIndex == piecesTotal - 1 || piecesTotal == 1)
              then barsConfig.roundTop else 0

            roundBottom_ =
              if barsConfig.roundBottom > 0 && (pieceIndex == 0 || piecesTotal == 1)
              then barsConfig.roundBottom else 0

            config = toBarConfig roundTop_ roundBottom_ prop bin.datum

            x2_ = x1_ + width_
            y1_ = Maybe.withDefault 0 (prop.visual bin.datum) - Maybe.withDefault 0 (prop.value bin.datum)
            y2_ = Maybe.withDefault 0 (prop.visual bin.datum)
            index = barIndex + pieceIndex
            color_ = if config.color == "" then toDefaultColor index else config.color
            name_ = if prop.meta.name == "" then String.fromInt index else prop.meta.name
        in
        Item
          { datum = bin.datum
          , render = \plane ->
              S.bar plane (
                [ CA.roundTop roundTop_
                , CA.roundBottom roundBottom_
                , CA.color (toDefaultColor index)
                ] ++ prop.attrs ++ prop.extra bin.datum
                )
                { x1 = x1_, x2 = x2_, y1 = y1_, y2 = y2_ }
          , x1 = x1_
          , x2 = x2_
          , y1 = y1_
          , y2 = y2_
          , start = bin.start
          , end = bin.end
          , y = prop.value bin.datum
          , name = name_
          , unit = prop.meta.unit
          , color = color_
          }
  in
  List.map toBinItem bins


{-| -}
type alias Bars =
  { spacing : Float
  , margin : Float
  , roundTop : Float
  , roundBottom : Float
  , grouped : Bool
  }


{-| -}
bars : Plane -> Maybe (data -> Float) -> Maybe (data -> Float) -> List (CA.Attribute Bars) -> List (Property data Metric () S.Bar) -> List data -> Svg msg
bars plane toStart toEnd barsEdits properties data =
  data
    |> toBinsFromVariable toStart toEnd
    |> toBinItems barsEdits properties
    |> List.map (render plane)
    |> S.g [ SA.class "elm-charts__bins" ]
    |> S.map never



-- SERIES


{-| -}
type alias Series =
  { method : Maybe CA.Method
  , area : Float
  , color : String
  , width : Float
  , size : Float
  , opacity : Float
  , border : String
  , borderWidth : Float
  , aura : Float
  , auraWidth : Float
  , shape : Maybe CA.Shape
  }


{-| -}
toSeriesItems : (data -> Float) -> List (Property data Metric () Series) -> List data -> Plane -> List (SeriesItem data (Maybe Float))
toSeriesItems toX properties data plane =
  let toConfig propAttrs =
        apply propAttrs
          { method = Nothing
          , area = 0
          , color = ""
          , width = 1
          , size = 6
          , opacity = 1
          , border = "white"
          , borderWidth = 0
          , aura = 0.25
          , auraWidth = 0
          , shape = Nothing
          }

      toLineItem index prop =
        let config = toConfig prop.attrs
            dotItems = List.map (toDotItem index prop) data
            color_ = if config.color == "" then toDefaultColor index else config.color
        in
        Item
          { render = \plane_ ->
              let toBottom datum_ =
                    Maybe.map2 (\real visual -> visual - real) (prop.value datum_) (prop.visual datum_)

                  methodAttr =
                    case config.method of
                      Just CA.Linear   -> CA.linear
                      Just CA.Monotone -> CA.monotone
                      Nothing       -> \c -> { c | method = Nothing }
              in
              S.g
                [ SA.class "elm-charts__series" ]
                [ S.area plane_ toX (Just toBottom) prop.visual [ methodAttr, CA.opacity config.area, CA.color color_ ] data
                , S.interpolation plane_ toX prop.visual [ methodAttr, CA.width config.width, CA.color color_ ] data
                , S.g [ SA.class "elm-charts__dots" ] (List.map (render plane_) dotItems)
                ]
          , x1 = 0 -- TODO
          , x2 = 0 -- TODO
          , y1 = 0 -- TODO
          , y2 = 0 -- TODO
          , items = dotItems
          , method = config.method
          , color = config.color
          , area = config.area
          , width = config.width
          }

      toDotItem index prop datum_ =
        let config = toConfig (prop.attrs ++ prop.extra datum_)
            x_ = toX datum_
            y_ = Maybe.withDefault 0 (prop.visual datum_)
            radius = Maybe.withDefault 0 <| Maybe.map (S.toRadius config.size) config.shape
            radiusX_ = scaleCartesian plane.x radius
            radiusY_ = scaleCartesian plane.y radius
            color_ = if config.color == "" then toDefaultColor index else config.color
            name_ = if prop.meta.name == "" then String.fromInt index else prop.meta.name
            attrs =
              [ CA.color color_
              , CA.border config.border
              , CA.borderWidth config.borderWidth
              , CA.opacity config.opacity
              , CA.aura config.aura
              , CA.auraWidth config.auraWidth
              , CA.size config.size
              , case config.shape of
                  Just CA.Circle -> CA.circle
                  Just CA.Triangle -> CA.triangle
                  Just CA.Square -> CA.square
                  Just CA.Diamond -> CA.diamond
                  Just CA.Cross -> CA.cross
                  Just CA.Plus -> CA.plus
                  Nothing -> \c -> { c | shape = Nothing }
              ]
        in
        Item
          { datum = datum_
          , render = \plane_ ->
              case prop.value datum_ of
                Nothing -> S.text ""
                Just _ -> S.dot plane_ .x .y attrs { x = x_, y = y_ }
          , x1 = x_ - radiusX_
          , x2 = x_ + radiusX_
          , y1 = y_ - radiusY_
          , y2 = y_ + radiusY_
          , x = x_
          , y = prop.value datum_
          , name = name_
          , unit = prop.meta.unit
          , color = color_
          , dot = attrs
          }
  in
  List.map P.toConfigs properties
    |> List.indexedMap (\i ps -> List.map (toLineItem i) ps)
    |> List.concat


{-| -}
series : Plane -> (data -> Float) -> List (Property data Metric () Series) -> List data -> Svg msg
series plane toX properties data =
  toSeriesItems toX properties data plane
    |> List.map (render plane)
    |> S.g [ SA.class "elm-charts__series-group" ]
    |> S.map never


-- TOOLTIP

--type alias Tooltip

--tooltip : Tooltip -> Html msg


-- HELPERS


apply : List (a -> a) -> a -> a
apply funcs default =
  let apply_ f a = f a in
  List.foldl apply_ default funcs



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

