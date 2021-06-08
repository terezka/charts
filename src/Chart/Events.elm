module Chart.Events exposing
  ( Event(..)
  , onMouseMove, onMouseLeave, onMouseUp, onMouseDown, onClick, on
  , Decoder(..), getCoords, getNearest, getNearestX, getWithin, getWithinX
  , product, dot, bin, stack, bar, only
  , SameX, sameX
  , map, map2, map3, map4

  , Product, Group, Bin, Stack
  , getDependent, getIndependent, getDatum, getColor, getName
  , getTop, getCenter, getLeft, getRight, getPosition, getLimits
  , getProducts, getCommonality, group, regroup, named
  , noMissing, noMissingG
  )

-- TODO
-- Rename General to Any
-- stacked tooltip issue
-- Auto examples
-- Remove tiles
-- move things to internal
-- find out what to expose in Svg
-- stepped inter
-- specify center of item for tooltip placement


import Html as H exposing (Html)
import Html.Attributes as HA
import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Svg.Coordinates as C exposing (Point, Position, Plane)
import Chart.Svg as CS
import Chart.Attributes as CA exposing (Attribute)
import Internal.Item as I
import Internal.Helpers as Helpers
import Internal.Group as G


-- EVENTS


onClick : (a -> msg) -> Decoder data a -> Attribute { x | events : List (Event data msg) }
onClick onMsg decoder =
  on "click" (map onMsg decoder)


onMouseMove : (a -> msg) -> Decoder data a -> Attribute { x | events : List (Event data msg) }
onMouseMove onMsg decoder =
  on "mousemove" (map onMsg decoder)


onMouseUp : (a -> msg) -> Decoder data a -> Attribute { x | events : List (Event data msg) }
onMouseUp onMsg decoder =
  on "mouseup" (map onMsg decoder)


onMouseDown : (a -> msg) -> Decoder data a -> Attribute { x | events : List (Event data msg) }
onMouseDown onMsg decoder =
  on "mousedown" (map onMsg decoder)


onMouseLeave : msg -> Attribute { x | events : List (Event data msg) }
onMouseLeave onMsg =
  on "mouseleave" (map (always onMsg) getCoords)


on : String -> Decoder data msg -> Attribute { x | events : List (Event data msg) }
on name decoder config =
  { config | events = Event { name = name, decoder = decoder } :: config.events }



-- DECODER


{-| -}
type Event data msg =
  Event
    { name : String
    , decoder : Decoder data msg
    }


type Decoder data msg =
  Decoder (List (I.Product I.Any (Maybe Float) data) -> Plane -> Point -> msg)


{-| -}
getCoords : Decoder data Point
getCoords =
  Decoder <| \_ plane searched ->
    { x = C.toCartesianX plane searched.x
    , y = C.toCartesianY plane searched.y
    }


{-| -}
getNearest : Grouping data (Maybe Float) (Item result) -> Decoder data (List (Item result))
getNearest (G.Grouping toPos _ as grouping) =
  Decoder <| \items plane ->
    let groups = group grouping items in
    CS.getNearest (toPos plane) groups plane


{-| -}
getWithin : Float -> Grouping data (Maybe Float) (Item result) -> Decoder data (List (Item result))
getWithin radius (G.Grouping toPos _ as grouping) =
  Decoder <| \items plane ->
    let groups = group grouping items in
    CS.getWithin radius (toPos plane) groups plane


{-| -}
getNearestX : Grouping data (Maybe Float) (Item result) -> Decoder data (List (Item result))
getNearestX (G.Grouping toPos _ as grouping) =
  Decoder <| \items plane ->
    let groups = group grouping items in
    CS.getNearestX (toPos plane) groups plane


{-| -}
getWithinX : Float -> Grouping data (Maybe Float) (Item result) -> Decoder data (List (Item result))
getWithinX radius (G.Grouping toPos _ as grouping) =
  Decoder <| \items plane ->
    let groups = group grouping items in
    CS.getWithinX radius (toPos plane) groups plane


{-| -}
map : (a -> msg) -> Decoder data a -> Decoder data msg
map f (Decoder a) =
  Decoder <| \ps s p -> f (a ps s p)


{-| -}
map2 : (a -> b -> msg) -> Decoder data a -> Decoder data b -> Decoder data msg
map2 f (Decoder a) (Decoder b) =
  Decoder <| \ps s p -> f (a ps s p) (b ps s p)


{-| -}
map3 : (a -> b -> c -> msg) -> Decoder data a -> Decoder data b -> Decoder data c -> Decoder data msg
map3 f (Decoder a) (Decoder b) (Decoder c) =
  Decoder <| \ps s p -> f (a ps s p) (b ps s p) (c ps s p)


{-| -}
map4 : (a -> b -> c -> d -> msg) -> Decoder data a -> Decoder data b -> Decoder data c -> Decoder data d -> Decoder data msg
map4 f (Decoder a) (Decoder b) (Decoder c) (Decoder d) =
  Decoder <| \ps s p -> f (a ps s p) (b ps s p) (c ps s p) (d ps s p)



-- PRODUCT


type alias Product config value data =
  I.Product config value data



getDependent : Product config value data -> value
getDependent =
  I.getDependent


getIndependent : Product config value data -> Float
getIndependent =
  I.getIndependent


getDatum : Product config value data -> data
getDatum =
  I.getDatum


getName : Product config value data -> Maybe String
getName =
  I.getName


getColor : Product config value data -> String
getColor =
  I.getColor



-- GROUP


type alias Group inter config value data =
  G.Group inter config value data



getProducts : Group inter config value data -> List (Product I.Any value data)
getProducts =
  G.getProducts


getCommonality : Group inter config value data -> inter
getCommonality =
  G.getCommonality



-- GROUPING


type alias Grouping data value result =
  G.Grouping data value result


group : Grouping data value result -> List (Product I.Any value data) -> List result
group =
  G.group


regroup : Grouping data value result -> Group i a value data -> List result
regroup =
  G.regroup


only : Grouping data value (Product next value data) -> Grouping data value (Group inter config value data) -> Grouping data value (Group inter next value data)
only =
  G.only


product : Grouping data value (Product I.Any value data)
product =
  G.product


dot : Grouping data value (Product CS.Dot value data)
dot =
  G.dot


bar : Grouping data value (Product CS.Bar value data)
bar =
  G.bar


noMissing : Grouping data (Maybe Float) (I.Product config (Maybe Float) data) -> Grouping data (Maybe Float) (I.Product config Float data)
noMissing =
  G.noMissing


noMissingG : Grouping data (Maybe Float) (G.Group inter config (Maybe Float) data) -> Grouping data (Maybe Float) (G.Group inter config Float data)
noMissingG (G.Grouping toPos formGroups) =
  G.Grouping I.getPosition <| \items ->
    let onlyValid : G.Group inter config (Maybe Float) data -> Maybe (G.Group inter config Float data)
        onlyValid (I.Item item as group_) =
          case List.filterMap I.toNonMissing item.config.items of
            [] -> Nothing
            some -> Just (G.toGroup (getCommonality group_) some)
    in
    List.filterMap onlyValid (formGroups items)



{-| -}
type alias SameX =
  G.SameX


sameX : Grouping data value (Group SameX I.Any value data)
sameX =
  G.sameX


{-| -}
type alias Stack datum =
  G.Stack datum


stack : Grouping data value (Group (Stack data) I.Any value data)
stack =
  G.stack


{-| -}
type alias Bin data =
  G.Bin data


bin : Grouping data value (Group (Bin data) I.Any value data)
bin =
  G.bin


named : List String -> Grouping data value (Product config value data) -> Grouping data value (Product config value data)
named =
  G.named


custom : (Plane -> result -> Position) -> (List (Product I.Any value data) -> List result) -> Grouping data value result
custom =
  G.Grouping



-- ITEM


type alias Item a =
  I.Item a


getCenter : Plane -> Item a -> Point
getCenter p =
  I.getPosition p >> C.center


getLeft : Plane -> Item a -> Point
getLeft p =
  I.getPosition p >> C.left


getRight : Plane -> Item a -> Point
getRight p =
  I.getPosition p >> C.right


getTop : Plane -> Item a -> Point
getTop p =
  I.getPosition p >> C.top


getBottom : Plane -> Item a -> Point
getBottom p =
  I.getPosition p >> C.bottom


getPosition : Plane -> Item a -> Position
getPosition =
  I.getPosition


getLimits : Item a -> Position
getLimits =
  I.getLimits
