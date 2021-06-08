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
  Decoder (List (I.Product I.General data) -> Plane -> Point -> msg)


{-| -}
getCoords : Decoder data Point
getCoords =
  Decoder <| \_ plane searched ->
    { x = C.toCartesianX plane searched.x
    , y = C.toCartesianY plane searched.y
    }


{-| -}
getNearest : Grouping data (Item result) -> Decoder data (List (Item result))
getNearest (G.Grouping toPos _ as grouping) =
  Decoder <| \items plane ->
    let groups = group grouping items in
    CS.getNearest (toPos plane) groups plane


{-| -}
getWithin : Float -> Grouping data (Item result) -> Decoder data (List (Item result))
getWithin radius (G.Grouping toPos _ as grouping) =
  Decoder <| \items plane ->
    let groups = group grouping items in
    CS.getWithin radius (toPos plane) groups plane


{-| -}
getNearestX : Grouping data (Item result) -> Decoder data (List (Item result))
getNearestX (G.Grouping toPos _ as grouping) =
  Decoder <| \items plane ->
    let groups = group grouping items in
    CS.getNearestX (toPos plane) groups plane


{-| -}
getWithinX : Float -> Grouping data (Item result) -> Decoder data (List (Item result))
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


type alias Product config data =
  I.Product config data


getDependent : Product config data -> Maybe Float
getDependent =
  I.getValue


getIndependent : Product config data -> Float
getIndependent =
  I.getInd


getDatum : Item { config | datum : datum } -> datum
getDatum =
  I.getDatum


getName : Product config data -> Maybe String
getName =
  I.getName


getColor : Product { a | color : String } data -> String
getColor =
  I.getColor



-- GROUP


type alias Group inter config data =
  G.Group inter config data



getProducts : Group inter config data -> List (Product I.General data)
getProducts =
  G.getProducts


getCommonality : Group inter config data -> inter
getCommonality =
  G.getCommonality



-- GROUPING


type alias Grouping data result =
  G.Grouping data result


group : Grouping data result -> List (Product I.General data) -> List result
group =
  G.group


regroup : Grouping data result -> Group i a data -> List result
regroup =
  G.regroup


only : Grouping data (Product next data) -> Grouping data (Group inter config data) -> Grouping data (Group inter next data)
only =
  G.only


product : Grouping data (Product I.General data)
product =
  G.product


dot : Grouping data (Product CS.Dot data)
dot =
  G.dot


bar : Grouping data (Product CS.Bar data)
bar =
  G.bar


{-| -}
type alias SameX =
  G.SameX


sameX : Grouping data (Group SameX I.General data)
sameX =
  G.sameX


{-| -}
type alias Stack datum =
  G.Stack datum


stack : Grouping data (Group (Stack data) I.General data)
stack =
  G.stack


{-| -}
type alias Bin data =
  G.Bin data


bin : Grouping data (Group (Bin data) I.General data)
bin =
  G.bin


named : List String -> Grouping data (Product config data) -> Grouping data (Product config data)
named =
  G.named


custom : (Plane -> result -> Position) -> (List (Product I.General data) -> List result) -> Grouping data result
custom =
  G.Grouping



-- ITEM


type alias Item a =
  I.Item a


getCenter : Plane -> Item a -> Point
getCenter =
  I.getCenter


getLeft : Plane -> Item a -> Point
getLeft =
  I.getLeft


getRight : Plane -> Item a -> Point
getRight =
  I.getRight


getTop : Plane -> Item a -> Point
getTop =
  I.getTop


getBottom : Plane -> Item a -> Point
getBottom =
  I.getBottom


getPosition : Plane -> Item a -> Position
getPosition =
  I.getPosition


getLimits : Item a -> Position
getLimits =
  I.getLimits
