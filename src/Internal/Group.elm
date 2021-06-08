module Internal.Group exposing (..)

import Html as H exposing (Html)
import Html.Attributes as HA
import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Svg.Coordinates as Coord exposing (Point, Position, Plane)
import Dict exposing (Dict)
import Internal.Property as P exposing (Property)
import Chart.Svg as S
import Chart.Attributes as CA
import Internal.Item as I
import Internal.Helpers as Helpers


{-| -}
type alias Group inter config value datum =
  I.Item
    { config : inter -- TODO rename
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


type Grouping data value result =
  Grouping
    (Plane -> result -> Position)
    (List (I.Product I.Any value data) -> List result)


group : Grouping data value result -> List (I.Product I.Any value data) -> List result
group (Grouping _ func) items =
  func items


regroup : Grouping data value result -> Group i a value data -> List result
regroup (Grouping _ func) group_ =
  func (getProducts group_)


only : Grouping data value (I.Product next value data) -> Grouping data value (Group inter config value data) -> Grouping data value (Group inter next value data)
only (Grouping _ filterProducts) (Grouping _ formGroups) = -- TODO position?
  Grouping I.getPosition <| \items ->
    let onlyValid group_ =
          case filterProducts (getProducts group_) of
            [] -> Nothing
            some -> Just (toGroup (getCommonality group_) some)
    in
    List.filterMap onlyValid (formGroups items)



-- BASIC GROUPING


product : Grouping data value (I.Product I.Any value data)
product =
  Grouping I.getPosition identity


dot : Grouping data value (I.Product S.Dot value data)
dot =
  let centerPosition plane item =
        fromPoint (I.getPosition plane item |> Coord.center)
  in
  Grouping centerPosition (List.filterMap I.isDot)


bar : Grouping data value (I.Product S.Bar value data)
bar =
  Grouping I.getPosition (List.filterMap I.isBar)


named : List String -> Grouping data value (I.Product config value data) -> Grouping data value (I.Product config value data)
named names (Grouping toPos filter) =
  let onlyAcceptedNames i =
        case I.getName i of
          Just name -> List.member name names
          Nothing -> False
  in
  Grouping toPos (filter >> List.filter onlyAcceptedNames)


noMissing : Grouping data (Maybe Float) (I.Product config (Maybe Float) data) -> Grouping data (Maybe Float) (I.Product config Float data)
noMissing (Grouping toPos filter) =
  Grouping I.getPosition (filter >> List.filterMap I.toNonMissing)



-- SAME X


{-| -}
type alias SameX =
  { x1 : Float
  , x2 : Float
  }


sameX : Grouping data value (Group SameX I.Any value data)
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


stack : Grouping data value (Group (Stack data) I.Any value data)
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


bin : Grouping data value (Group (Bin data) I.Any value data)
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
