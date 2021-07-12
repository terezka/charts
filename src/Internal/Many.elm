module Internal.Many exposing (..)

import Html as H exposing (Html)
import Html.Attributes as HA
import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Internal.Coordinates as Coord exposing (Point, Position, Plane)
import Dict exposing (Dict)
import Internal.Property as P exposing (Property)
import Chart.Svg as S
import Internal.Item as I
import Internal.Helpers as Helpers


{-| -}
type alias Many shared x =
  I.Rendered
    { config : shared
    , items : ( x, List x )
    }


{-| -}
getMembers : Many shared x -> List x
getMembers (I.Rendered group_) =
  group_.config.items |> \(x, xs) -> x :: xs


{-| -}
getGenerals : Many shared (I.One data x) -> List (I.One data I.Any)
getGenerals group_ =
  let generalize (I.Rendered item) =
        I.generalize item.config.toAny (I.Rendered item)
  in
  List.map generalize (getMembers group_)


{-| -}
getCommonality : Many shared x -> shared
getCommonality (I.Rendered item) =
  item.config.config


{-| -}
getDatas : Many shared (I.One data x) -> ( data, List data )
getDatas (I.Rendered group_) =
  group_.config.items |> \(x, xs) -> ( I.getDatum x, List.map I.getDatum xs )


{-| -}
getData : Many shared (I.One data x) -> data
getData (I.Rendered group_) =
  group_.config.items |> \(x, xs) -> I.getDatum x


mapData : (a -> b) -> Many shared (I.One a x) -> Many shared (I.One b x)
mapData func (I.Rendered group_) =
  let ( x, xs ) = group_.config.items in
  toGroup group_.config.config (I.map func x) (List.map (I.map func) xs)



-- GROUPING


type Remodel a b =
  Remodel
    (Plane -> b -> Position)
    (List a -> List b)


apply : Remodel a b -> List a -> List b
apply (Remodel _ func) items =
  func items


continue : Remodel x y -> Remodel a x -> Remodel a y
continue (Remodel toPos2 func2) (Remodel toPos1 func1) =
  Remodel toPos2 <| \items -> func2 (func1 items)



-- BASIC GROUPING


any : Remodel (I.One data I.Any) (I.One data I.Any)
any =
  Remodel I.getPosition identity


dots : Remodel (I.One data I.Any) (I.One data S.Dot)
dots =
  let centerPosition plane item =
        fromPoint (I.getPosition plane item |> Coord.center)
  in
  Remodel centerPosition (List.filterMap I.isDot)


bars : Remodel (I.One data I.Any) (I.One data S.Bar)
bars =
  Remodel I.getPosition (List.filterMap I.isBar)


real : Remodel (I.One data config) (I.One data config)
real =
  Remodel I.getPosition (List.filter I.isReal)


named : List String -> Remodel (I.One data config) (I.One data config)
named names =
  let onlyAcceptedNames i =
        List.member (I.getName i) names
  in
  Remodel I.getPosition (List.filter onlyAcceptedNames)



-- SAME X


{-| -}
type alias SameX =
  { x1 : Float
  , x2 : Float
  }


sameX : Remodel (I.One data x) (Many SameX (I.One data x))
sameX =
  let fullVertialPosition plane item =
        I.getPosition plane item
          |> \pos -> { pos | y1 = plane.y.min, y2 = plane.y.max }
  in
  Remodel fullVertialPosition <|
    groupingHelp
      { shared = \config -> { x1 = config.values.x1, x2 = config.values.x2 }
      , equality = \a b -> a.x1 == b.x1 && a.x2 == b.x2
      , edits = identity
      }



-- SAME STACK


{-| -}
type alias Stack =
  { x1 : Float
  , x2 : Float
  , seriesIndex : Int
  , stackIndex : Int
  }


stacks : Remodel (I.One data x) (Many Stack (I.One data x))
stacks =
  Remodel I.getPosition <|
    groupingHelp
      { shared = \config ->
          { x1 = config.values.x1
          , x2 = config.values.x2
          , seriesIndex = config.tooltipInfo.index
          , stackIndex = config.tooltipInfo.stack
          }
      , equality = \a b -> a.x1 == b.x1 && a.x2 == b.x2 && a.seriesIndex == b.seriesIndex && a.stackIndex == b.stackIndex
      , edits = identity
      }



-- SAME BIN


{-| -}
type alias Bin =
  { x1 : Float
  , x2 : Float
  , seriesIndex : Int
  , dataIndex : Int
  }


bins : Remodel (I.One data x) (Many Bin (I.One data x))
bins =
  Remodel I.getPosition <|
    groupingHelp
      { shared = \config ->
          { x1 = config.values.x1
          , x2 = config.values.x2
          , seriesIndex = config.tooltipInfo.index
          , dataIndex = config.tooltipInfo.data
          }
      , equality = \a b -> a.x1 == b.x1 && a.x2 == b.x2 && a.seriesIndex == b.seriesIndex && a.dataIndex == b.dataIndex
      , edits = editLimits (\c pos -> { pos | x1 = c.config.x1, x2 = c.config.x2 })
      }



-- HELPERS


groupingHelp { shared, equality, edits } items =
  let toInter (I.Rendered item) = shared item.config
      toEquality aO bO = equality (toInter aO) (toInter bO)
      toNewGroup ( i, is ) = toGroup (toInter i) i is |> edits
  in
  List.map toNewGroup (Helpers.gatherWith toEquality items)


editLimits edit (I.Rendered group_) =
  I.Rendered { group_ | toLimits = \c -> group_.toLimits c |> edit c }


toGroup : shared -> I.One data x -> List (I.One data x) -> Many shared (I.One data x)
toGroup shared first rest =
  let concatTuple ( x, xs ) = x :: xs in
  I.Rendered
    { config = { config = shared, items = ( first, rest ) }
    , toLimits = \c -> Coord.foldPosition I.getLimits (concatTuple c.items)
    , toPosition = \p c -> Coord.foldPosition (I.getPosition p) (concatTuple c.items)
    , toSvg = \p c _ -> S.g [ SA.class "elm-charts__group" ] (List.map (I.toSvg p) (concatTuple c.items))
    , toHtml = \c -> [ H.table [] (List.concatMap I.toHtml (concatTuple c.items)) ]
    }


fromPoint : Point -> Position
fromPoint point =
  { x1 = point.x, y1 = point.y, x2 = point.x, y2 = point.y }
