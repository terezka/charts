module Internal.Item exposing (..)

import Html as H exposing (Html)
import Html.Attributes as HA
import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Svg.Coordinates as Coord exposing (Point, Position, Plane)
import Dict exposing (Dict)
import Internal.Property as P exposing (Property)
import Chart.Svg as S
import Chart.Attributes as CA
import Internal.Helpers as Helpers



type Item a =
  Item
    { config : a
    , toLimits : a -> Position
    , toPosition : Plane -> a -> Position
    , toSvg : Plane -> a -> Position -> Svg Never
    , toHtml : a -> List (Html Never)
    }


{-| -}
type alias Product config value datum =
  Item
    { product : config
    , tooltipInfo : TooltipInfo
    , values : Values value datum
    , toAny : config -> Any
    }


{-| -}
type Any
  = Dot S.Dot
  | Bar S.Bar


{-| -}
type alias TooltipInfo =
  { property : Int
  , stack : Int
  , name : Maybe String
  , color : String
  , border : String
  , borderWidth : Float
  }


{-| -}
type alias Values value datum =
  { datum : datum
  , x1 : Float
  , x2 : Float
  , y : Maybe Float
  , yOrg : value
  }



-- ITEM


{-| -}
toSvg : Plane -> Item x -> Svg Never
toSvg plane (Item item) =
  item.toSvg plane item.config (item.toPosition plane item.config)


{-| -}
toHtml : Item x -> List (Html Never)
toHtml (Item item) =
  item.toHtml item.config


{-| -}
getPosition : Plane -> Item x -> Position
getPosition plane (Item item) =
  item.toPosition plane item.config


{-| -}
getLimits : Item x -> Position
getLimits (Item item) =
  item.toLimits item.config



-- PRODUCT


{-| -}
getColor : Product config value data -> String
getColor (Item item) =
  item.config.tooltipInfo.color


{-| -}
getName : Product config value data -> Maybe String
getName (Item item) =
  item.config.tooltipInfo.name


{-| -}
getDatum : Product config value data -> data
getDatum (Item item) =
  item.config.values.datum


{-| -} -- TODO
getIndependent : Product config value data -> Float
getIndependent (Item item) =
  item.config.values.x1


{-| -}
getDependent : Product config value data -> value
getDependent (Item item) =
  item.config.values.yOrg



-- GENERALIZATION


generalize : (a -> Any) -> Product a value datum -> Product Any value datum
generalize toAny (Item item) =
   -- TODO make sure changes are reflected in rendering
  Item
    { toLimits = \_ -> item.toLimits item.config
    , toPosition = \plane _ -> item.toPosition plane item.config
    , toSvg = \plane _ _ -> toSvg plane (Item item)
    , toHtml = \c -> toHtml (Item item)
    , config =
        { product = toAny item.config.product
        , values = item.config.values
        , tooltipInfo = item.config.tooltipInfo
        , toAny = identity
        }
    }


isBar : Product Any value datum -> Maybe (Product S.Bar value datum)
isBar (Item item) =
  case item.config.product of
    Bar bar ->
      Item
        { toLimits = \_ -> item.toLimits item.config
        , toPosition = \plane _ -> item.toPosition plane item.config
        , toSvg = \plane config -> S.bar plane (toBarAttrs config.product)
        , toHtml = \c -> item.toHtml item.config
        , config =
            { product = bar
            , values = item.config.values
            , tooltipInfo = item.config.tooltipInfo
            , toAny = Bar
            }
        }
        |> Just

    Dot _ ->
      Nothing


isDot : Product Any value datum -> Maybe (Product S.Dot value datum)
isDot (Item item) =
  case item.config.product of
    Dot dot ->
      Item
        { toLimits = \_ -> item.toLimits item.config
        , toPosition = \plane _ -> item.toPosition plane item.config
        , toSvg = \plane config pos ->
            config.values.y
              |> Maybe.map (\y -> S.dot plane .x .y (toDotAttrs config.product) { x = config.values.x1, y = y })
              |> Maybe.withDefault (S.text "")
        , toHtml = \c -> item.toHtml item.config
        , config =
            { product = dot
            , values = item.config.values
            , tooltipInfo = item.config.tooltipInfo
            , toAny = Dot
            }
        }
        |> Just

    Bar _ ->
      Nothing


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

