module Internal.Group exposing (..)

import Html as H exposing (Html)
import Html.Attributes as HA
import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Internal.Coordinates as Coord exposing (Point, Position, Plane)
import Dict exposing (Dict)
import Internal.Property as P exposing (Property)
import Chart.Svg as S
import Chart.Attributes as CA
import Internal.Item as I
import Internal.Helpers as Helpers


{-| -}
type alias Group inter config value datum =
  I.Item
    { config : inter
    , items : List (I.Product config value datum)
    }


{-| -}
getProducts : Group a config value datum -> List (I.Product I.Any value datum)
getProducts (I.Item group_) =
  let generalize (I.Item item) =
        I.generalize item.config.toAny (I.Item item)
  in
  List.map generalize group_.config.items


{-| -}
getCommonality : Group a config value datum -> a
getCommonality (I.Item item) =
  item.config.config



-- GROUPING


type Grouping a b =
  Grouping
    (Plane -> b -> Position)
    (List a -> List b)


group : Grouping a b -> List a -> List b
group (Grouping _ func) items =
  func items


regroup : Grouping (I.Product a v data) b -> Group i a v data -> List b
regroup (Grouping _ func) (I.Item item) =
  func item.config.items


keep : Grouping (I.Product b v data) (I.Product c x data) -> Grouping a (I.Product b v data) -> Grouping a (I.Product c x data)
keep (Grouping toPos2 func2) (Grouping toPos1 func1) =
  Grouping toPos2 <| \items ->
    func2 (func1 items)


collect : Grouping b c -> Grouping a b -> Grouping a c
collect (Grouping toPos2 func2) (Grouping toPos1 func1)  =
  Grouping toPos2 (func1 >> func2)



-- BASIC GROUPING


product : Grouping (I.Product I.Any value data) (I.Product I.Any value data)
product =
  Grouping I.getPosition identity


dot : Grouping (I.Product I.Any value data) (I.Product S.Dot value data)
dot =
  let centerPosition plane item =
        fromPoint (I.getPosition plane item |> Coord.center)
  in
  Grouping centerPosition (List.filterMap I.isDot)


bar : Grouping (I.Product I.Any value data) (I.Product S.Bar value data)
bar =
  Grouping I.getPosition (List.filterMap I.isBar)


realValues : Grouping (I.Product config (Maybe Float) data) (I.Product config Float data)
realValues =
  Grouping I.getPosition (List.filterMap I.toNonMissing)


named : List String -> Grouping (I.Product config value data) (I.Product config value data)
named names =
  let onlyAcceptedNames i =
        List.member (I.getName i) names
  in
  Grouping I.getPosition (List.filter onlyAcceptedNames)



-- SAME X


{-| -}
type alias SameX =
  { x1 : Float
  , x2 : Float
  }


sameX : Grouping (I.Product config value data) (Group SameX config value data)
sameX =
  let fullVertialPosition plane item =
        I.getPosition plane item
          |> \pos -> { pos | y1 = plane.y.min, y2 = plane.y.max }
  in
  Grouping fullVertialPosition <|
    groupingHelp
      { inter = \config -> { x1 = config.values.x1, x2 = config.values.x2 }
      , equality = \a b -> a.x1 == b.x1 && a.x2 == b.x2
      , edits = identity
      }



-- SAME STACK


{-| -}
type alias Stack datum =
  { datum : datum
  , start : Float
  , end : Float
  , index : Int
  }


stack : Grouping (I.Product config value data) (Group (Stack data) config value data)
stack =
  Grouping I.getPosition <|
    groupingHelp
      { inter = \config ->
          { start = config.values.x1
          , end = config.values.x2
          , datum = config.values.datum
          , index = config.tooltipInfo.property
          }
      , equality = \a b -> a.index == b.index && a.start == b.start && a.end == b.end && a.datum == b.datum
      , edits = identity
      }



-- SAME BIN


{-| -}
type alias Bin data =
  { datum : data
  , start : Float
  , end : Float
  }


bin : Grouping (I.Product config value data) (Group (Bin data) config value data)
bin =
  Grouping I.getPosition <|
    groupingHelp
      { inter = \config -> { start = config.values.x1, end = config.values.x2, datum = config.values.datum }
      , equality = \a b -> a.start == b.start && a.end == b.end && a.datum == b.datum
      , edits = editLimits (\c pos -> { pos | x1 = c.config.start, x2 = c.config.end })
      }



-- HELPERS


groupingHelp { inter, equality, edits } items =
  let toInter (I.Item item) = inter item.config
      toEquality aO bO = equality (toInter aO) (toInter bO)
      toNewGroup ( i, is ) = toGroup (toInter i) (i :: is) |> edits
  in
  List.map toNewGroup (Helpers.gatherWith toEquality items)

editLimits edit (I.Item group_) =
  I.Item { group_ | toLimits = \c -> group_.toLimits c |> edit c }


toGroup : inter -> List (I.Product config value datum) -> Group inter config value datum
toGroup inter products =
  I.Item
    { config = { config = inter, items = products }
    , toLimits = \c -> Coord.foldPosition I.getLimits c.items
    , toPosition = \p c -> Coord.foldPosition (I.getPosition p) c.items
    , toSvg = \p c _ -> S.g [ SA.class "elm-charts__group" ] (List.map (I.toSvg p) c.items)
    , toHtml = \c -> [ H.table [] (List.concatMap I.toHtml c.items) ]
    }


fromPoint : Point -> Position
fromPoint point =
  { x1 = point.x, y1 = point.y, x2 = point.x, y2 = point.y }
