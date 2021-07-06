module Chart.Events exposing
  ( Event
  , onMouseMove, onMouseLeave, onMouseUp, onMouseDown, onClick, on
  , Decoder, Point, getCoords, getNearest, getNearestX, getWithin, getWithinX
  , map, map2, map3, map4
  , Grouping, product, bar, dot, bin, stack, sameX, realValues, named
  , keep, collect
  , group, regroup

  , Product, Any, Bar, Dot
  , Group, Bin, Stack, SameX
  , getDependent, getIndependent, getDatum, getColor, getName
  , getTop, getTopLeft, getTopRight
  , getBottom, getBottomLeft, getBottomRight
  , getLeft, getRight
  , getCenter, getPosition, getLimits, isSame
  , getDefaultTooltip, getSize

  , getProducts, getCommonality, filterData
  )


{-| Add events and interact with chart "items".

# Event handlers
@docs Event
@docs onMouseMove, onMouseLeave, onMouseUp, onMouseDown, onClick, on
@docs Decoder, Point, getCoords, getNearest, getNearestX, getWithin, getWithinX
@docs map, map2, map3, map4

# Chart items
@docs Product, Group, Grouping

# Filtering
@docs keep
@docs Any, product
@docs Bar, bar
@docs Dot, dot
@docs realValues
@docs named

# Grouping
@docs collect
@docs Bin, bin
@docs Stack, stack
@docs SameX, sameX
@docs group, regroup

# Information about item
@docs getDependent, getIndependent, getDatum, getColor, getName, isSame, getSize, getDefaultTooltip

## Information about item's position
@docs getTop, getTopLeft, getTopRight
@docs getBottom, getBottomLeft, getBottomRight
@docs getLeft, getRight
@docs getCenter, getPosition, getLimits

# Information about group
@docs getProducts, getCommonality, filterData

-}

import Html as H exposing (Html)
import Html.Attributes as HA
import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Internal.Coordinates as C exposing (Point, Position, Plane)
import Chart.Attributes as CA exposing (Attribute)
import Internal.Svg as CS
import Internal.Item as I
import Internal.Helpers as Helpers
import Internal.Group as G
import Internal.Events as IE



-- EVENTS


{-| Add an click event handler.

    C.chart
      [ CE.onClick Clicked C.getCoords ]
      [ .. ]

-}
onClick : (a -> msg) -> Decoder data a -> Attribute { x | events : List (Event data msg) }
onClick onMsg decoder =
  on "click" (map onMsg decoder)


{-| Add an mouse move event handler. -}
onMouseMove : (a -> msg) -> Decoder data a -> Attribute { x | events : List (Event data msg) }
onMouseMove onMsg decoder =
  on "mousemove" (map onMsg decoder)


{-| Add an mouse up event handler. -}
onMouseUp : (a -> msg) -> Decoder data a -> Attribute { x | events : List (Event data msg) }
onMouseUp onMsg decoder =
  on "mouseup" (map onMsg decoder)


{-| Add an mouse down event handler. -}
onMouseDown : (a -> msg) -> Decoder data a -> Attribute { x | events : List (Event data msg) }
onMouseDown onMsg decoder =
  on "mousedown" (map onMsg decoder)


{-| Add an mouse leave event handler. -}
onMouseLeave : msg -> Attribute { x | events : List (Event data msg) }
onMouseLeave onMsg =
  on "mouseleave" (map (always onMsg) getCoords)


{-| Add any event handler.

    C.chart
      [ CE.on "mousemove" <|
          CE.map2 OnMouseMove
            (CE.getNearest CE.bar)
            (CE.getNearest CE.dot)

      ]
      [ .. ]

-}
on : String -> Decoder data msg -> Attribute { x | events : List (Event data msg) }
on =
  IE.on



-- DECODER


{-| -}
type alias Event data msg =
  IE.Event data msg


{-| -}
type alias Decoder data msg =
  IE.Decoder data msg


{-| -}
type alias Point =
  { x : Float
  , y : Float
  }


{-| Decode to get the cartesian coordinates of the event.

-}
getCoords : Decoder data Point
getCoords =
  IE.getCoords


{-| Decode to get the nearest item to the event.

-}
getNearest : Grouping (Product Any (Maybe Float) data) (Item result) -> Decoder data (List (Item result))
getNearest =
  IE.getNearest


{-| Decode to get the nearest item within certain radius to the event.

-}
getWithin : Float -> Grouping (Product Any (Maybe Float) data) (Item result) -> Decoder data (List (Item result))
getWithin =
  IE.getWithin


{-| Like `getNearest`, but only takes x coordiante into account
-}
getNearestX : Grouping (Product Any (Maybe Float) data) (Item result) -> Decoder data (List (Item result))
getNearestX =
  IE.getNearestX


{-| Like `getWithin`, but only takes x coordiante into account
-}
getWithinX : Float -> Grouping (Product Any (Maybe Float) data) (Item result) -> Decoder data (List (Item result))
getWithinX =
  IE.getWithinX


{-| -}
map : (a -> msg) -> Decoder data a -> Decoder data msg
map =
  IE.map


{-| -}
map2 : (a -> b -> msg) -> Decoder data a -> Decoder data b -> Decoder data msg
map2 =
  IE.map2


{-| -}
map3 : (a -> b -> c -> msg) -> Decoder data a -> Decoder data b -> Decoder data c -> Decoder data msg
map3 =
  IE.map3


{-| -}
map4 : (a -> b -> c -> d -> msg) -> Decoder data a -> Decoder data b -> Decoder data c -> Decoder data d -> Decoder data msg
map4 =
  IE.map4



-- PRODUCT


{-| A product is an item produced by a bar or dot series.

    CE.Product CE.Any value data -- A product of either a bar or dot series
    CE.Product CE.Dot value data -- A product of a dot series
    CE.Product CE.Bar value data -- A product of a bar series

You may have used `C.scatterMaybe` or `C.barMaybe` to represent
missing data on your chart. The second type value represent
whether this product could be a representation of a missing data
point.

    CE.Product CE.Any Float data
      -- A product of a bar or dot series which is always
      -- a real data point.

    CE.Product CE.Any (Maybe Float) data
      -- A product of a bar or dot series which may or
      -- may not be a real data point.

-}
type alias Product config value data =
  I.Product config value data


{-| Get the independent (x) value.

-}
getIndependent : Product config value data -> Float
getIndependent =
  I.getIndependent


{-| Get the dependent (y) value.

-}
getDependent : Product config value data -> value
getDependent =
  I.getDependent


{-| Get the datum which produced this product.

-}
getDatum : Product config value data -> data
getDatum =
  I.getDatum


{-| Get the name of the series which produced the product.

-}
getName : Product config value data -> String
getName =
  I.getName


{-| Get the color of the product.

-}
getColor : Product config value data -> String
getColor =
  I.getColor


{-| Is this product the exact same as this other one?

-}
isSame : Product config value data -> Product config value data -> Bool
isSame =
  I.isSame


{-| Get the size of the product (only if a dot).

-}
getSize : Product Dot value data -> Float
getSize =
  I.getSize



-- GROUP


{-| A group is a collection of products which have certain characteristics
in common. For example, a stacked bar is produced from the same data point
and has the same x value.

    Group (Stack data) Bar value data -- representation of a stack of bars
    Group (Bin data) Bar value data -- representation of a bin of bars

-}
type alias Group inter config value data =
  G.Group inter config value data



{-| Get the products of a group.

-}
getProducts : Group inter config value data -> List (Product Any value data)
getProducts =
  G.getProducts


{-| Get the commonality of a group.

-}
getCommonality : Group inter config value data -> inter
getCommonality =
  G.getCommonality


{-| Keep products of certain data types.

-}
filterData : (a -> Maybe b) -> List (Product config value a) -> List (Product config value b)
filterData =
  I.filterMap



-- GROUPING


{-| The representation of a method of grouping.

-}
type alias Grouping a b =
  G.Grouping a b


{-| Apply a grouping method to a list of items.

-}
group : Grouping a b -> List a -> List b
group =
  G.group


{-| Given a group, apply a new grouping method to the products of the group.

-}
regroup : Grouping (Product a v data) b -> Group i a v data -> List b
regroup =
  G.regroup


{-| Filter a set of products.

    CE.getNearest (CE.keep CE.realValues CE.bar)
    -- get nearest bar which is not a representation of missing data

-}
keep : Grouping (Product b v data) (Product c x data) -> Grouping a (Product b v data) -> Grouping a (Product c x data)
keep =
  G.keep


{-| Collect groups from a set of products.

    CE.getNearest (CE.collect CE.bins CE.bar)
    -- collect all bars into bins and get the nearest one.

-}
collect : Grouping b c -> Grouping a b -> Grouping a c
collect =
  G.collect


{-| -}
type alias Any =
  I.Any


{-| -}
product : Grouping (Product Any value data) (Product Any value data)
product =
  G.product


{-| -}
type alias Dot =
  CS.Dot


{-| -}
dot : Grouping (Product Any value data) (Product Dot value data)
dot =
  G.dot


{-| -}
type alias Bar =
  CS.Bar


{-| -}
bar : Grouping (Product Any value data) (Product Bar value data)
bar =
  G.bar


{-| -}
realValues : Grouping (Product config (Maybe Float) data) (Product config Float data)
realValues =
  G.realValues


{-| -}
named : List String -> Grouping (Product config value data) (Product config value data)
named =
  G.named


{-| -}
type alias SameX =
  G.SameX


{-| -}
sameX : Grouping (Product config value data) (Group SameX config value data)
sameX =
  G.sameX


{-| -}
type alias Stack datum =
  G.Stack datum


{-| -}
stack : Grouping (Product config value data) (Group (Stack data) config value data)
stack =
  G.stack


{-| -}
type alias Bin data =
  G.Bin data


{-| -}
bin : Grouping (Product config value data) (Group (Bin data) config value data)
bin =
  G.bin


{-| -}
custom : (Plane -> b -> Position) -> (List a -> List b) -> Grouping a b
custom =
  G.Grouping



-- ITEM


{-| -}
type alias Item a =
  I.Item a


{-| -}
getCenter : Plane -> Item a -> Point
getCenter p =
  I.getPosition p >> C.center


{-| -}
getLeft : Plane -> Item a -> Point
getLeft p =
  I.getPosition p >> C.left


{-| -}
getRight : Plane -> Item a -> Point
getRight p =
  I.getPosition p >> C.right


{-| -}
getTop : Plane -> Item a -> Point
getTop p =
  I.getPosition p >> C.top


{-| -}
getTopLeft : Plane -> Item a -> Point
getTopLeft p =
  I.getPosition p >> C.topLeft


{-| -}
getTopRight : Plane -> Item a -> Point
getTopRight p =
  I.getPosition p >> C.topRight


{-| -}
getBottom : Plane -> Item a -> Point
getBottom p =
  I.getPosition p >> C.bottom


{-| -}
getBottomLeft : Plane -> Item a -> Point
getBottomLeft p =
  I.getPosition p >> C.bottomLeft


{-| -}
getBottomRight : Plane -> Item a -> Point
getBottomRight p =
  I.getPosition p >> C.bottomRight


{-| -}
getPosition : Plane -> Item a -> Position
getPosition =
  I.getPosition


{-| -}
getLimits : Item a -> Position
getLimits =
  I.getLimits


{-| -}
getDefaultTooltip : Item a -> List (Html Never)
getDefaultTooltip =
  I.toHtml