module Internal.Item exposing (..)

import Html as H exposing (Html)
import Html.Attributes as HA
import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Internal.Coordinates as Coord exposing (Point, Position, Plane)
import Dict exposing (Dict)
import Internal.Property as P exposing (Property)
import Internal.Svg as S
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
  , data : Int
  , index : Int
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
getName : Product config value data -> String
getName (Item item) =
  case item.config.tooltipInfo.name of
    Just name -> name
    Nothing -> "Property #" ++ String.fromInt (item.config.tooltipInfo.index + 1)


{-| -}
getDatum : Product config value data -> data
getDatum (Item item) =
  item.config.values.datum


{-| -}
getIndependent : Product config value data -> Float
getIndependent (Item item) =
  item.config.values.x1


{-| -}
getDependent : Product config value data -> value
getDependent (Item item) =
  item.config.values.yOrg


{-| -}
getPropertyIndex : Product config value data -> Int
getPropertyIndex (Item item) =
  item.config.tooltipInfo.property


{-| -}
getStackIndex : Product config value data -> Int
getStackIndex (Item item) =
  item.config.tooltipInfo.stack


{-| -}
getDataIndex : Product config value data -> Int
getDataIndex (Item item) =
  item.config.tooltipInfo.data


{-| -}
getSize : Product S.Dot value data -> Float
getSize (Item item) =
  item.config.product.size


{-| -}
map : (a -> b) -> Product config value a -> Product config value b
map func (Item item) =
  Item
    { toLimits = \_ -> item.toLimits item.config
    , toPosition = \plane _ -> item.toPosition plane item.config
    , toSvg = \plane _ _ -> toSvg plane (Item item)
    , toHtml = \_ -> toHtml (Item item)
    , config =
        { product = item.config.product
        , values =
            { datum = func item.config.values.datum
            , x1 = item.config.values.x1
            , x2 = item.config.values.x2
            , y = item.config.values.y
            , yOrg = item.config.values.yOrg
            }
        , tooltipInfo = item.config.tooltipInfo
        , toAny = item.config.toAny
        }
    }


{-| -}
filterMap : (a -> Maybe b) -> List (Product config value a) -> List (Product config value b)
filterMap func =
  List.filterMap <| \(Item item) ->
    case func item.config.values.datum of
      Just b ->
        Item
          { toLimits = \_ -> item.toLimits item.config
          , toPosition = \plane _ -> item.toPosition plane item.config
          , toSvg = \plane _ _ -> toSvg plane (Item item)
          , toHtml = \_ -> toHtml (Item item)
          , config =
              { product = item.config.product
              , values =
                  { datum = b
                  , x1 = item.config.values.x1
                  , x2 = item.config.values.x2
                  , y = item.config.values.y
                  , yOrg = item.config.values.yOrg
                  }
              , tooltipInfo = item.config.tooltipInfo
              , toAny = item.config.toAny
              }
          }
          |> Just

      Nothing ->
        Nothing



-- CHANGE VALUE


toNonMissing : Product a (Maybe Float) datum -> Maybe (Product a Float datum)
toNonMissing (Item item) =
  case item.config.values.yOrg of
    Just yOrg ->
      Item
        { toLimits = \_ -> item.toLimits item.config
        , toPosition = \plane _ -> item.toPosition plane item.config
        , toSvg = \plane _ _ -> toSvg plane (Item item)
        , toHtml = \c -> toHtml (Item item)
        , config =
            { product = item.config.product
            , values =
                { datum = item.config.values.datum
                , x1 = item.config.values.x1
                , x2 = item.config.values.x2
                , y = item.config.values.y
                , yOrg = yOrg
                }
            , tooltipInfo = item.config.tooltipInfo
            , toAny = item.config.toAny
            }
        }
        |> Just

    Nothing ->
      Nothing



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
        , toSvg = \plane config -> S.bar plane config.product
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
              |> Maybe.map (\y -> S.dot plane .x .y config.product { x = config.values.x1, y = y })
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
