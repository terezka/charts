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


{-| -}
type Item a =
  Item
    { details : a
    , render : Plane -> a -> Position -> Svg Never
    , limits : a -> Position
    , position : Plane -> a -> Position
    , tooltip : a -> List (Html Never)
    }


{-| -}
type alias Product config datum =
  Item
    { datum : datum
    , config : Generalizable config
    , property : Int
    , stack : Int
    , name : Maybe String
    , x1 : Float
    , x2 : Float
    , y : Maybe Float
    , toGeneral : Generalizable config -> RealConfig
    }


{-| -}
onlyBarSeries : List (Product General datum) -> List (Product S.Bar datum)
onlyBarSeries =
  List.filterMap isBarSeries


{-| -}
onlyDotSeries : List (Product General datum) -> List (Product S.Dot datum)
onlyDotSeries =
  List.filterMap isDotSeries


{-| -}
getColor : Product { a | color : String } data -> String
getColor (Item config) =
  config.details.config.color


{-| -}
getName : Product config data -> Maybe String
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


getLimits : Item x -> Position
getLimits (Item config) =
  config.limits config.details


{-| -}
getDatum : Item { config | datum : datum } -> datum
getDatum (Item config) =
  config.details.datum


{-| -} -- TODO
getInd : Item { config | x1 : Float } -> Float
getInd (Item config) =
  config.details.x1


{-| -}
getValue : Item { config | y : value } -> value
getValue (Item config) =
  config.details.y


{-| -}
render : Plane -> Item x -> Svg Never
render plane (Item config) =
  config.render plane config.details (config.position plane config.details)


renderTooltip : Item x -> List (Html Never)
renderTooltip (Item config) =
  config.tooltip config.details



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


toGeneral : (Generalizable config -> RealConfig) -> Product config datum -> Product General datum
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

    , limits = \_ -> product.limits product.details
    , position = \plane _ -> product.position plane product.details
    , tooltip = \c -> product.tooltip product.details
    , details =
        { datum = product.details.datum
        , property = product.details.property
        , stack = product.details.stack
        , x1 = product.details.x1
        , x2 = product.details.x2
        , y = product.details.y
        , name = product.details.name
        , toGeneral = .real
        , config =
            { color = product.details.config.color
            , border = product.details.config.border
            , borderWidth = product.details.config.borderWidth
            , real = generalize product.details.config
            }
        }
    }


{-| -}
isBarSeries : Product General datum -> Maybe (Product S.Bar datum)
isBarSeries (Item product) =
  case product.details.config.real of
    DotConfig _ ->
      Nothing

    BarConfig bar ->
      Just <| Item
        { render = \plane details ->
            S.bar plane (toBarAttrs details.config)
        , limits = \_ -> product.limits product.details
        , position = \plane _ -> product.position plane product.details
        , tooltip = \c -> product.tooltip product.details
        , details =
            { datum = product.details.datum
            , property = product.details.property
            , stack = product.details.stack
            , x1 = product.details.x1
            , x2 = product.details.x2
            , y = product.details.y
            , name = product.details.name
            , config = bar
            , toGeneral = BarConfig
            }
        }


isDotSeries : Product General datum -> Maybe (Product S.Dot datum)
isDotSeries (Item product) =
  case product.details.config.real of
    BarConfig _ ->
      Nothing

    DotConfig dot ->
      Just <| Item
        { render = \plane details _ ->
            case details.y of
              Nothing -> S.text ""
              Just y -> S.dot plane .x .y (toDotAttrs details.config) { x = details.x1, y = y }
        , limits = \_ -> product.limits product.details
        , position = \plane _ -> product.position plane product.details
        , tooltip = \c -> product.tooltip product.details
        , details =
            { datum = product.details.datum
            , property = product.details.property
            , stack = product.details.stack
            , x1 = product.details.x1
            , x2 = product.details.x2
            , y = product.details.y
            , name = product.details.name
            , config = dot
            , toGeneral = DotConfig
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

