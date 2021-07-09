module Chart.Events exposing
  ( Attribute, Event
  , onMouseMove, onMouseLeave, onMouseUp, onMouseDown, onClick, on
  , Decoder, Point, getCoords, getNearest, getNearestX, getWithin, getWithinX
  , map, map2, map3, map4
  , Grouping, product, bar, dot, bin, stack, sameX, realValues, named
  , keep, collect
  , group, regroup

  , Item, Product, Any, Bar, Dot
  , Group, Bin, Stack, SameX
  , getDependent, getIndependent, getDatum, getColor, getName
  , getTop, getTopLeft, getTopRight
  , getBottom, getBottomLeft, getBottomRight
  , getLeft, getRight
  , getCenter, getPosition, getLimits, isSame
  , getDefaultTooltip, getSize

  , getProducts, getCommonality, filterData
  )


{-| Add events and interact with [chart items](https://package.elm-lang.org/packages/terezka/charts/latest/Chart-Events#Item).

# Event handlers
@docs Attribute, Event
@docs onMouseMove, onMouseLeave, onMouseUp, onMouseDown, onClick, on

## Decoders
@docs Decoder, Point, getCoords, getNearest, getNearestX, getWithin, getWithinX
@docs map, map2, map3, map4

# Chart items
@docs Item, Product, Group

## Working with chart items
@docs Grouping

# Filtering
@docs keep
## Filter products
@docs Any, product
## Filter bars
@docs Bar, bar
## Filter dots
@docs Dot, dot
## Other qualities
@docs realValues, named

# Collecting
@docs collect
## Group bins
@docs Bin, bin
## Group stack
@docs Stack, stack
## Group same x value
@docs SameX, sameX
## Group helpers
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


{-| An attribute for adding events.
-}
type alias Attribute x data msg =
  { x | events : List (Event data msg) } -> { x | events : List (Event data msg) }


{-| Add an click event handler.

    C.chart
      [ CE.onClick Clicked C.getCoords ]
      [ .. ]

-}
onClick : (a -> msg) -> Decoder data a -> Attribute x data msg
onClick onMsg decoder =
  on "click" (map onMsg decoder)


{-| Add an mouse move event handler.

    C.chart
      [ CE.onMouseMove (CE.getNearest CE.bar) ]
      [ .. ]

See example at [elm-charts.org](https://www.elm-charts.org/documentation/interactivity/basic-bar-tooltip).
-}
onMouseMove : (a -> msg) -> Decoder data a -> Attribute x data msg
onMouseMove onMsg decoder =
  on "mousemove" (map onMsg decoder)


{-| Add an mouse up event handler. See example at [elm-charts.org](https://www.elm-charts.org/documentation/interactivity/zoom).
-}
onMouseUp : (a -> msg) -> Decoder data a -> Attribute x data msg
onMouseUp onMsg decoder =
  on "mouseup" (map onMsg decoder)


{-| Add an mouse down event handler. See example at [elm-charts.org](https://www.elm-charts.org/documentation/interactivity/zoom).
-}
onMouseDown : (a -> msg) -> Decoder data a -> Attribute x data msg
onMouseDown onMsg decoder =
  on "mousedown" (map onMsg decoder)


{-| Add an mouse leave event handler. See example at [elm-charts.org](https://www.elm-charts.org/documentation/interactivity/basic-bar-tooltip).
-}
onMouseLeave : msg -> Attribute x data msg
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

See example at [elm-charts.org](https://www.elm-charts.org/documentation/interactivity/multiple-tooltips).

-}
on : String -> Decoder data msg -> Attribute x data msg
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

    type alias Model =
      { hovering : List (CE.Product CE.Bar (Maybe Float) Datum) }

    init : Model
    init =
      { hovering = [] }

    type Msg
      = OnHover (List (CE.Product CE.Bar (Maybe Float) Datum))

    update : Msg -> Model -> Model
    update msg model =
      case msg of
        OnHover hovering ->
          { model | hovering = hovering }

    view : Model -> H.Html Msg
    view model =
      C.chart
        [ CA.height 300
        , CA.width 300
        , CE.onMouseMove OnHover (CE.getNearest CE.bar)
        , CE.onMouseLeave (OnHover [])
        ]
        [ C.xLabels []
        , C.yLabels []
        , C.bars []
            [ C.bar .z []
            , C.bar .y []
            ]
            data

        , C.each model.hovering <| \p bar ->
            [ C.tooltip bar [] [] [] ]
        ]

See example at [elm-charts.org](https://www.elm-charts.org/documentation/interactivity/basic-bar-tooltip).
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


{-| A product is an item produced by a bar series, or a dot series (line or scatter).

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
getProducts : Group inter config value data -> List (Product config value data)
getProducts =
  G.getProducts


{-| Get the generalized products of a group.

-}
getGenerals : Group a config value datum -> List (I.Product Any value datum)
getGenerals =
  G.getGenerals


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


{-| Say we have an event handler like so:

    CE.onMouseMove (CE.getNearest CE.bar)

The function `getNearest` takes a `Grouping` as the first argument. A
`Grouping` is essentially a method for filtering or collecting items.

For example, the grouping `bar` takes a list of `Product Any value data`
and filters it, such that there are only bar products left, that is a
list of `Product Bar value data`.

On the other hand, the grouping `bin` takes a list of `Product config value data`
and bundles all the products made from the same `data` point together. This results
in a list of `Group (Bin data) config value data`.


If you'd like to combine the two and collect all bins of bars, you can do it like so.

    CE.collect CE.bin CE.bar

This will result in a list of `Group (Bin data) Bar value data`.

Check out the many examples on [elm-charts.org](https://www.elm-charts.org/documentation/interactivity).


-}
type alias Grouping a b =
  G.Grouping a b


{-| Low level api for applying a `Grouping`.

    C.withProducts <| \p products ->
        let grouping : Grouping (Product Any (Maybe Float) Datum) (Group (Bin Datum) Bar Float Datum)
            grouping =
              CE.bar
                |> CE.keep CE.realValues
                |> CE.collect CE.bin

            toBinLabel : Group (Bin Datum) Bar Float Datum -> Element msg Datum
            toBinLabel bin =
              let datum = (CE.getCommonality bin).datum in
              C.label [] [ S.text datum.country ] (CE.getTop p bin)
        in
        List.map toBinLabel (CE.group grouping products).

-}
group : Grouping a b -> List a -> List b
group =
  G.group


{-| Low level helper to applying a new grouping to a group. Same as saying:

    CE.group (CE.getProducts myGroup)

-}
regroup : Grouping (Product a v data) b -> Group i a v data -> List b
regroup =
  G.regroup


{-| Filter a set of products.

    CE.keep CE.realValues CE.bar
    -- Keeps all bars which are not a representation of missing data.

-}
keep : Grouping (Product b v data) (Product c x data) -> Grouping a (Product b v data) -> Grouping a (Product c x data)
keep =
  G.keep


{-| Collect groups from a set of products.

    CE.collect CE.bin CE.bar
    -- collect all bars into bins.

-}
collect : Grouping b c -> Grouping a b -> Grouping a c
collect =
  G.collect


{-| The configuration of either a dot or a bar.

-}
type alias Any =
  I.Any


{-| All products.

    CE.getNearest CE.product
    -- gets nearest product (bar or dot)

-}
product : Grouping (Product Any value data) (Product Any value data)
product =
  G.product


{-| The configuration of a dot.

-}
type alias Dot =
  CS.Dot


{-| All dots.

    CE.getNearest CE.dot
    -- gets nearest dot

-}
dot : Grouping (Product Any value data) (Product Dot value data)
dot =
  G.dot


{-| The configuration of a bar.

-}
type alias Bar =
  CS.Bar


{-| All bars.

    CE.getNearest CE.bar
    -- gets nearest bar

-}
bar : Grouping (Product Any value data) (Product Bar value data)
bar =
  G.bar


{-| All real values. If you have used `Chart.barMaybe` or the like,
you may have representations of missing data in your chart. This can filter
those out.

    CE.getNearest CE.realValues
    -- gets nearest product which is not a representation of missing data.

-}
realValues : Grouping (Product config (Maybe Float) data) (Product config Float data)
realValues =
  G.realValues


{-| All values produced from a particular set of series.

    CE.getNearest (CE.named [ "cats", "dogs" ])
    -- gets nearest product from the cats or dogs series.

-}
named : List String -> Grouping (Product config value data) (Product config value data)
named =
  G.named


{-| -}
type alias SameX =
  { x1 : Float
  , x2 : Float
  }


{-| All values with the same x values.

    CE.getNearest CE.sameX
    -- gets nearest set of products from any series, sharing the same x values.

-}
sameX : Grouping (Product config value data) (Group SameX config value data)
sameX =
  G.sameX


{-| -}
type alias Stack datum =
  { datum : datum
  , start : Float
  , end : Float
  , index : Int
  }


{-| Collect values of the same stack into groups. A stack is produced using `C.stacked`.

    CE.getNearest CE.stack
    -- gets nearest stack.

-}
stack : Grouping (Product config value data) (Group (Stack data) config value data)
stack =
  G.stack


{-| -}
type alias Bin data =
  { datum : data
  , start : Float
  , end : Float
  }


{-| Collect values of the same bin into groups. Two products are in the same bin if
they are produced from the same `data` from your `List data` in your bar or dot series.

    CE.getNearest CE.bin
    -- gets nearest bin.

-}
bin : Grouping (Product config value data) (Group (Bin data) config value data)
bin =
  G.bin


{-| Make your own grouping.

    sameColor : Grouping (Product config value data) (Group String config value data)
    sameColor =
      CE.custom CE.getPosition <| \products ->
        List.Extra.gatherEqualsBy CE.getColor products
          |> \( color, productsOfColor ) -> CE.customGroup color productsOfColor


-}
custom : (Plane -> b -> Position) -> (List a -> List b) -> Grouping a b
custom =
  G.Grouping



{-| Make a group. Useful in combination with `custom`.

-}
customGroup : inter -> List (Product config value datum) -> Group inter config value datum
customGroup =
  G.toGroup



-- ITEM


{-| An item is anything on the chart which is produced from data elements,
that is bar, line, and scatter charts.

It may be a single one of such items (a `Product`), or a group of such items (a `Group`).

-}
type alias Item a =
  I.Item a


{-| Get center of item.

-}
getCenter : Plane -> Item a -> Point
getCenter p =
  I.getPosition p >> C.center


{-| Get the center left of item.

-}
getLeft : Plane -> Item a -> Point
getLeft p =
  I.getPosition p >> C.left


{-| Get the center right of item.

-}
getRight : Plane -> Item a -> Point
getRight p =
  I.getPosition p >> C.right


{-| Get the center top of item.

-}
getTop : Plane -> Item a -> Point
getTop p =
  I.getPosition p >> C.top


{-| Get the top left of item.

-}
getTopLeft : Plane -> Item a -> Point
getTopLeft p =
  I.getPosition p >> C.topLeft


{-| Get the top right of item.

-}
getTopRight : Plane -> Item a -> Point
getTopRight p =
  I.getPosition p >> C.topRight


{-| Get the center bottom of item.

-}
getBottom : Plane -> Item a -> Point
getBottom p =
  I.getPosition p >> C.bottom


{-| Get the bottom left of item.

-}
getBottomLeft : Plane -> Item a -> Point
getBottomLeft p =
  I.getPosition p >> C.bottomLeft


{-| Get the bottom right of item.

-}
getBottomRight : Plane -> Item a -> Point
getBottomRight p =
  I.getPosition p >> C.bottomRight


{-| Get full position of item.

-}
getPosition : Plane -> Item a -> Position
getPosition =
  I.getPosition


{-| In a few cases, an item's "position" and "limits" aren't the same.

In the case of bins, the "position" is the area which the bins bars take up, not
inclusing any margin which may be around them. Its "limits" include the margin.

-}
getLimits : Item a -> Position
getLimits =
  I.getLimits


{-| Render the default tooltip of an item.

-}
getDefaultTooltip : Item a -> List (Html Never)
getDefaultTooltip =
  I.toHtml