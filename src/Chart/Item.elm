module Chart.Item exposing
  ( Rendered
  , getCenter, getTop, getBottom, getLeft, getRight
  , getTopLeft, getTopRight, getBottomLeft, getBottomRight
  , getPosition, getLimits, getTooltip

  , One, Any, Bar, Dot
  , getData, getDependent, getIndependent
  , getName, getColor, getSize
  , isReal, isSame, filter

  , Many, Stack, Bin
  , getMembers, getShared, getDatas, getFirstData

  , Remodel, apply, andThen
  , any, dots, bars, real
  , bins, stacks, sameX, named
  --, customs
  )


import Html exposing (Html)
import Internal.Coordinates as C exposing (Point, Position, Plane)
import Internal.Item as I
import Internal.Many as M
import Internal.Svg as CS


{-| -}
type alias Rendered x =
  I.Rendered x


{-| -}
getTooltip : Rendered x -> List (Html Never)
getTooltip =
  I.toHtml


{-| -}
getCenter : Plane -> Rendered x -> Point
getCenter p =
  I.getPosition p >> C.center


{-| -}
getLeft : Plane -> Rendered x -> Point
getLeft p =
  I.getPosition p >> C.left


{-| -}
getRight : Plane -> Rendered x -> Point
getRight p =
  I.getPosition p >> C.right


{-| -}
getTop : Plane -> Rendered x -> Point
getTop p =
  I.getPosition p >> C.top


{-| -}
getTopLeft : Plane -> Rendered x -> Point
getTopLeft p =
  I.getPosition p >> C.topLeft


{-| -}
getTopRight : Plane -> Rendered x -> Point
getTopRight p =
  I.getPosition p >> C.topRight


{-| -}
getBottom : Plane -> Rendered x -> Point
getBottom p =
  I.getPosition p >> C.bottom


{-| -}
getBottomLeft : Plane -> Rendered x -> Point
getBottomLeft p =
  I.getPosition p >> C.bottomLeft


{-| -}
getBottomRight : Plane -> Rendered x -> Point
getBottomRight p =
  I.getPosition p >> C.bottomRight


{-| -}
getPosition : Plane -> Rendered x -> Position
getPosition =
  I.getPosition


{-| In a few cases, a rendered item's "position" and "limits" aren't the same.

In the case of `Bin`, the "position" is the area which the bins bars take up, not
inclusing any margin which may be around them. Its "limits" include the margin.

-}
getLimits : Rendered x -> Position
getLimits =
  I.getLimits



-- ONE


{-| -}
type alias One data x =
  I.One data x


{-| -}
type alias Any =
  I.Any


{-| -}
type alias Bar =
  CS.Bar


{-| -}
type alias Dot =
  CS.Dot


{-| -}
getData : One data x -> data
getData =
  I.getDatum


{-| -}
getDependent : One data x -> Float
getDependent =
  I.getDependent


{-| -}
getIndependent : One data x -> Float
getIndependent =
  I.getIndependent


{-| -}
getName : One data x -> String
getName =
  I.getName


{-| -}
getColor : One data x -> String
getColor =
  I.getColor


{-| -}
getSize : One data Dot -> Float
getSize =
  I.getSize


{-| -}
isReal : One data x -> Bool
isReal =
  I.isReal


{-| -}
isSame : One data x -> One data x -> Bool
isSame =
  I.isSame


{-| -}
filter : (a -> Maybe b) -> List (One a x) -> List (One b x)
filter =
  I.filterMap



-- MANY


{-| -}
type alias Many data x =
  M.Many (One data x)


{-| -}
getMembers : Many data x -> List x
getMembers =
  M.getMembers


{-| -}
getMember : Many data x -> x
getMember =
  M.getMember


{-| -}
getDatas : Many data x -> List data
getDatas =
  M.getDatas


{-| -}
getOneData : Many data x -> data
getOneData =
  M.getData



-- REMODELLING


{-| -}
type alias Remodel a b =
  M.Remodel a b


{-| -}
apply : Remodel a b -> List a -> List b
apply =
  M.apply


{-| -}
andThen : Remodel b c -> Remodel a b -> Remodel a c
andThen =
  M.andThen


{-| -}
any : Remodel (One data Any) (One data Any)
any =
  M.any


{-| -}
dots : Remodel (One data Any) (One data Dot)
dots =
  M.dots


{-| -}
bars : Remodel (One data Any) (One data Bar)
bars =
  M.bars


{-| -}
real : Remodel (One data x) (One data x)
real =
  M.real


{-| -}
bins : Remodel (One data x) (Bin data x)
bins =
  M.bins


{-| -}
stacks : Remodel (One data x) (Stack data x)
stacks =
  M.stacks


{-| -}
sameX : Remodel (One data x) (SameX data x)
sameX =
  M.sameX


{-| -}
named : List String -> Remodel (One data x) (One data x)
named =
  M.named


--customs : Remodel (Any data) (Custom data)


