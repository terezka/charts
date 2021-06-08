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
type alias Group inter config datum =
  I.Item
    { config : inter -- TODO rename
    , items : List (I.Product config datum)
    }


{-| -}
getProducts : Group a config datum -> List (I.Product I.General datum)
getProducts (I.Item group_) =
  let toGeneral (I.Item product_) =
        I.toGeneral product_.details.toGeneral (I.Item product_)
  in
  List.map toGeneral group_.details.items


{-| -}
getCommonality : Group a config datum -> a
getCommonality (I.Item item) =
  item.details.config



-- GROUPING


type Grouping data result =
  Grouping
    (Plane -> result -> Position)
    (List (I.Product I.General data) -> List result)


group : Grouping data result -> List (I.Product I.General data) -> List result
group (Grouping _ func) items =
  func items


regroup : Grouping data result -> Group i a data -> List result
regroup (Grouping _ func) group_ =
  func (getProducts group_)


only : Grouping data (I.Product next data) -> Grouping data (Group inter config data) -> Grouping data (Group inter next data)
only (Grouping _ filterProducts) (Grouping _ formGroups) = -- TODO position?
  Grouping I.getPosition <| \items ->
    let onlyValid group_ =
          case filterProducts (getProducts group_) of
            [] -> Nothing
            some -> Just (toGroup (getCommonality group_) some)
    in
    List.filterMap onlyValid (formGroups items)



-- BASIC GROUPING


product : Grouping data (I.Product I.General data)
product =
  Grouping I.getPosition identity


dot : Grouping data (I.Product S.Dot data)
dot =
  let centerPosition plane item =
        fromPoint (I.getCenter plane item)
  in
  Grouping centerPosition (List.filterMap I.isDotSeries)


bar : Grouping data (I.Product S.Bar data)
bar =
  Grouping I.getPosition (List.filterMap I.isBarSeries)


named : List String -> Grouping data (I.Product config data) -> Grouping data (I.Product config data)
named names (Grouping toPos filter) =
  let onlyAcceptedNames i =
        case I.getName i of
          Just name -> List.member name names
          Nothing -> False
  in
  Grouping toPos (filter >> List.filter onlyAcceptedNames)



-- SAME X


{-| -}
type alias SameX =
  { x1 : Float
  , x2 : Float
  }


sameX : Grouping data (Group SameX I.General data)
sameX =
  let fullVertialPosition plane item =
        I.getPosition plane item
          |> \pos -> { pos | y1 = plane.y.min, y2 = plane.y.max }
  in
  Grouping fullVertialPosition <|
    groupingHelp
      { inter = \details -> { x1 = details.x1, x2 = details.x2 }
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


stack : Grouping data (Group (Stack data) I.General data)
stack =
  Grouping I.getPosition <|
    groupingHelp
      { inter = \details ->
          { start = details.x1
          , end = details.x2
          , datum = details.datum
          , index = details.property
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


bin : Grouping data (Group (Bin data) I.General data)
bin =
  Grouping I.getPosition <|
    groupingHelp
      { inter = \details -> { start = details.x1, end = details.x2, datum = details.datum }
      , equality = \a b -> a.start == b.start && a.end == b.end && a.datum == b.datum
      , edits = editLimits (\c pos -> { pos | x1 = c.config.start, x2 = c.config.end })
      }



-- HELPERS


groupingHelp { inter, equality, edits } items =
  let toInter (I.Item item) = inter item.details
      toEquality aO bO = equality (toInter aO) (toInter bO)
      toNewGroup ( i, is ) = toGroup (toInter i) (i :: is) |> edits
  in
  List.map toNewGroup (Helpers.gatherWith toEquality items)

editLimits edit (I.Item group_) =
  I.Item { group_ | limits = \c -> group_.limits c |> edit c }


toGroup : inter -> List (I.Product config datum) -> Group inter config datum
toGroup inter products =
  I.Item
    { details = { config = inter, items = products }
    , limits = \c -> Coord.foldPosition I.getLimits c.items
    , position = \p c -> Coord.foldPosition (I.getPosition p) c.items
    , render = \p c _ -> S.g [ SA.class "elm-charts__group" ] (List.map (I.render p) c.items)
    , tooltip = \c -> [ H.table [] (List.concatMap I.renderTooltip c.items) ]
    }


fromPoint : Point -> Position
fromPoint point =
  { x1 = point.x, y1 = point.y, x2 = point.x, y2 = point.y }
