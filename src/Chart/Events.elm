module Chart.Events exposing
  ( Event(..)
  , onMouseMove, onMouseLeave, onMouseUp, onMouseDown, onClick, on
  , Decoder(..), getCoords, getNearest, getNearestX, getWithin, getWithinX
  , product, dot, bin, stack, bar
  , map, map2, map3, map4

  , Group, Bin, Stack, Product
  , getDependent, getIndependent, getDatum, getColor, getName
  , getTop, getCenter, getLeft, getRight, getPosition, getLimits
  , getProducts, getCommonality, group, ungroup, regroup, named
  )

-- TODO
-- Rename General to Any

import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Svg.Coordinates as C exposing (Point, Position, Plane)
import Chart.Svg as CS
import Chart.Attributes as CA exposing (Attribute)
import Internal.Item as I


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
getNearest (Grouping toPos _ as grouping) =
  Decoder <| \items plane ->
    let groups = group grouping items in
    CS.getNearest (toPos plane) groups plane


{-| -}
getWithin : Float -> Grouping data (Item result) -> Decoder data (List (Item result))
getWithin radius (Grouping toPos _ as grouping) =
  Decoder <| \items plane ->
    let groups = group grouping items in
    CS.getWithin radius (toPos plane) groups plane


{-| -}
getNearestX : Grouping data (Item result) -> Decoder data (List (Item result))
getNearestX (Grouping toPos _ as grouping) =
  Decoder <| \items plane ->
    let groups = group grouping items in
    CS.getNearestX (toPos plane) groups plane


{-| -}
getWithinX : Float -> Grouping data (Item result) -> Decoder data (List (Item result))
getWithinX radius (Grouping toPos _ as grouping) =
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
  I.Group inter config data


getProducts : Group inter config data -> List (Product config data)
getProducts =
  I.getProducts


getCommonality : Group inter config data -> inter
getCommonality =
  I.getCommonality


group : Grouping data result -> List (Product I.General data) -> List result
group (Grouping _ func) items =
  func items


ungroup : Group inter config data -> List (Product config data)
ungroup =
  I.getProducts


regroup : Grouping data result -> Group i a data -> List result
regroup (Grouping _ func) (I.Item config as group_) =
  func (List.map config.details.toGeneral <| I.getProducts group_)



-- GROUPING


type Grouping data result =
  Grouping
    (Plane -> result -> Position)
    (List (Product I.General data) -> List result)


product : Grouping data (Product I.General data)
product =
  Grouping getPosition identity


dot : Grouping data (Product CS.Dot data)
dot =
  Grouping (\p -> getCenter p >> fromPoint) I.onlyDotSeries


bar : Grouping data (Product CS.Bar data)
bar =
  Grouping getPosition I.onlyBarSeries


{-| -}
type alias Stack datum =
  { datum : datum
  , start : Float
  , end : Float
  , index : Int
  }


stack : Grouping data (Group (Stack data) I.General data)
stack =
  Grouping getPosition <| \items ->
    let toConfig (I.Item { details }) =
          { start = details.x1
          , end = details.x2
          , datum = details.datum
          , index = details.property
          }

        isSame ai bi =
          let ( a, b ) = ( toConfig ai, toConfig bi ) in
          a.index == b.index && a.start == b.start && a.end == b.end && a.datum == b.datum

        toGroup ( i, is ) =
          I.Item
            { details = { config = toConfig i, items = i :: is, toGeneral = identity }
            , limits = \c -> C.foldPosition getLimits c.items
            , position = \plane c -> C.foldPosition (getPosition plane) c.items
            , render = \plane c _ -> S.g [ SA.class "elm-charts__group" ] (List.map (I.render plane) c.items)
            }
    in
    List.map toGroup (gatherWith isSame items)


{-| -}
type alias Bin data =
  { datum : data
  , start : Float
  , end : Float
  }


bin : Grouping data (Group (Bin data) I.General data)
bin =
  Grouping getPosition <| \items ->
    let toConfig (I.Item { details }) =
          { start = details.x1
          , end = details.x2
          , datum = details.datum
          }

        isSame ai bi =
          let ( a, b ) = (toConfig ai, toConfig bi ) in
          a.start == b.start && a.end == b.end && a.datum == b.datum

        toGroup ( i, is ) =
          I.Item
            { details = { config = toConfig i, items = i :: is, toGeneral = identity }
            , limits = \c ->
                let pos = C.foldPosition getLimits c.items in
                { pos | x1 = c.config.start, x2 = c.config.end }
            , position = \plane c -> C.foldPosition (getPosition plane) c.items
            , render = \plane c _ -> S.g [ SA.class "elm-charts__group" ] (List.map (I.render plane) c.items)
            }
    in
    gatherWith isSame items
      |> List.map toGroup



named : List String -> Grouping data (Product config data) -> Grouping data (Product config data)
named names (Grouping toPos filter) =
  let onlyAcceptedNames i =
        case getName i of
          Just name -> List.member name names
          Nothing -> False
  in
  Grouping toPos (filter >> List.filter onlyAcceptedNames)



-- TODO custom : todo -> Grouping inter config datum


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


-- TODO getDetails : Item a -> a


-- HELPERS

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


fromPoint : Point -> Position
fromPoint point =
  { x1 = point.x, y1 = point.y, x2 = point.x, y2 = point.y }