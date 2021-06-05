module Chart.Events exposing
  ( Event(..)
  , onMouseMove, onMouseLeave, onMouseUp, onMouseDown, onClick, on
  , Decoder(..), getCoords, getNearest, getNearestX, getWithin, getWithinX
  , product, dot, bin, stack, bar
  , map, map2, map3, map4

  , Group, Bin, Stack
  , getDependent, getIndependent, getDatum, getColor, getName
  , getTop, getCenter, getLeft, getRight, getPosition, getLimits
  , getProducts, getCommonality, group, ungroup, regroup
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
getNearest : Grouping inter b data -> Decoder data (List (Group inter b data))
getNearest grouping =
  Decoder <| \items plane ->
    let groups = group grouping items in
    CS.getNearest (getPosition plane) groups plane


{-| -}
getWithin : Float -> Grouping inter b data -> Decoder data (List (Group inter b data))
getWithin radius grouping =
  Decoder <| \items plane ->
    let groups = group grouping items in
    CS.getWithin radius (getPosition plane) groups plane


{-| -}
getNearestX : Grouping inter b data -> Decoder data (List (Group inter b data))
getNearestX grouping =
  Decoder <| \items plane ->
    let groups = group grouping items in
    CS.getNearestX (getPosition plane) groups plane


{-| -}
getWithinX : Float -> Grouping inter b data -> Decoder data (List (Group inter b data))
getWithinX radius grouping =
  Decoder <| \items plane ->
    let groups = group grouping items in
    CS.getWithinX radius (getPosition plane) groups plane


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


getDatum : Product I.General data -> data
getDatum =
  I.getDatum


getName : Product I.General data -> Maybe String
getName =
  I.getName


getColor : Product I.General data -> String
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


group : Grouping inter config data -> List (Product I.General data) -> List (Group inter config data)
group (Grouping func) items =
  func items


ungroup : Group inter config data -> List (Product config data)
ungroup =
  I.getProducts


regroup : Grouping inter b data -> Group i a data -> List (Group inter b data)
regroup (Grouping func) (I.Item config as group_) =
  func (List.map config.details.toGeneral <| I.getProducts group_)



-- GROUPING


type Grouping inter config data =
  Grouping (List (Product I.General data) -> List (Group inter config data))


product : Grouping () I.General data
product =
  Grouping <| \items ->
    let func item =
          I.Item
            { details = { config = (), items = [ item ], toGeneral = identity }
            , limits = \c -> C.foldPosition getLimits c.items
            , position = \plane c -> C.foldPosition (getPosition plane) c.items
            , render = \plane c _ -> S.g [ SA.class "elm-charts__group" ] (List.map (I.render plane) c.items)
            }
    in
    List.map func items


dot : Grouping () CS.Dot data
dot =
  Grouping <| \items ->
    let func item =
          I.Item
            { details = { config = (), items = [ item ], toGeneral = I.toGeneral I.DotConfig }
            , limits = \c -> C.foldPosition getLimits c.items
            , position = \plane c -> C.foldPosition (getPosition plane) c.items
            , render = \plane c _ -> S.g [ SA.class "elm-charts__group" ] (List.map (I.render plane) c.items)
            }
    in
    List.map func (I.onlyDotSeries items)


bar : Grouping () CS.Bar data
bar =
  Grouping <| \items ->
    let func item =
          I.Item
            { details = { config = (), items = [ item ], toGeneral = I.toGeneral I.BarConfig }
            , limits = \c -> C.foldPosition getLimits c.items
            , position = \plane c -> C.foldPosition (getPosition plane) c.items
            , render = \plane c _ -> S.g [ SA.class "elm-charts__group" ] (List.map (I.render plane) c.items)
            }
    in
    List.map func (I.onlyBarSeries items)


{-| -}
type alias Stack datum =
  { datum : datum
  , start : Float
  , end : Float
  , index : Int
  }


stack : Grouping (Stack data) I.General data
stack =
  Grouping <| \items ->
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


bin : Grouping (Bin data) I.General data
bin =
  Grouping <| \items ->
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
            , position = \plane c ->
                let pos = C.foldPosition (getPosition plane) c.items in
              { pos | x1 = c.config.start, x2 = c.config.end }
            , render = \plane c _ -> S.g [ SA.class "elm-charts__group" ] (List.map (I.render plane) c.items)
            }
    in
    gatherWith isSame items
      |> List.map toGroup



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
