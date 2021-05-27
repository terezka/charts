module Chart exposing
    ( chart, Element
    , bars, series
    , Property, stacked, bar, property, just, variation
    , xAxis, yAxis, xTicks, yTicks, xLabels, yLabels, grid
    , lowest, highest, orLower, orHigher, exactly, more, less, window, likeData, zero, middle
    , Event, event
    , Decoder, getCoords, getNearest, getNearestX, getWithin, getWithinX, map, map2, map3, map4
    , tooltip, line, title, xLabel, yLabel, xTick, yTick, rect, svgAt, htmlAt, svg, html, none
    , each, eachBin, eachStack, eachProduct
    , withPlane, withBins, withStacks, withProducts

    , marginTop, marginBottom, marginLeft, marginRight
    , paddingTop, paddingBottom, paddingLeft, paddingRight
    , range, domain, limits, pinned, dotted, noArrow, filterX, filterY, only
    , binned, amount, floatsCustom, ints, intsCustom, times, timesCustom

    , named
    )


{-| Make a chart! Documentation is still unfinished!

# Elements
@docs chart, Element
@docs series, scatter, linear, monotone, just
@docs bars, histogram, bar

## Work with limits
@docs Limit, startMin, startMax, endMin, endMax, startPad, endPad, zero, middle

# Axis
@docs xAxis, yAxis, xTicks, yTicks, xLabels, yLabels, grid
@docs amount, floats, ints, times, values, format, noArrow, start, end, pinned, only, filterX, filterY

# Events
@docs Event, event, Decoder, getCoords, getNearest, getNearestX, getWithin, getWithinX, map, map2, map3, map4
@docs Metric, Item, Single, Group
@docs getBars, getGroups, getDots, withoutUnknowns
@docs tooltip, tooltipOnTop, formatTimestamp

# Attributes
@docs width, height
@docs marginTop, marginBottom, marginLeft, marginRight
@docs paddingTop, paddingBottom, paddingLeft, paddingRight
@docs center
@docs range, domain, topped, static, id, events, htmlAttrs
@docs binWidth, binLabel, topLabel, barColor, tickLength, tickWidth, margin, spacing, rounded, roundBottom
@docs dotted, color, label, unit, dot, area, attrs

# Interop
@docs svgAt, htmlAt, svg, html, none

# Colors
@docs blue, orange, pink, green, red

-}


import Svg.Coordinates as C
import Svg as S
import Svg.Attributes as SA
import Svg.Events as SE
import Html as H
import Html.Attributes as HA
import Intervals as I
import Internal.Property as P
import Time
import Dict exposing (Dict)
import Chart.Item as Item
import Chart.Svg as CS
import Chart.Attributes as CA


-- ATTRS


{-| -}
type alias Attribute c =
  c -> c


{-| -}
marginTop : Float -> Attribute { a | marginTop : Float }
marginTop value config =
  { config | marginTop = value }


{-| -}
marginBottom : Float -> Attribute { a | marginBottom : Float }
marginBottom value config =
  { config | marginBottom = value }


{-| -}
marginLeft : Float -> Attribute { a | marginLeft : Float }
marginLeft value config =
  { config | marginLeft = value }


{-| -}
marginRight : Float -> Attribute { a | marginRight : Float }
marginRight value config =
  { config | marginRight = value }


{-| -}
paddingTop : Float -> Attribute { a | paddingTop : Float }
paddingTop value config =
  { config | paddingTop = value }


{-| -}
paddingBottom : Float -> Attribute { a | paddingBottom : Float }
paddingBottom value config =
  { config | paddingBottom = value }


{-| -}
paddingLeft : Float -> Attribute { a | paddingLeft : Float }
paddingLeft value config =
  { config | paddingLeft = value }


{-| -}
paddingRight : Float -> Attribute { a | paddingRight : Float }
paddingRight value config =
  { config | paddingRight = value }


{-| -}
range : List (Attribute C.Axis) -> Attribute { a | range : Maybe (C.Axis -> C.Axis) }
range fs config =
  { config | range = Just (\i -> List.foldl (\f b -> f b) i fs) }


{-| -}
domain : List (Attribute C.Axis) -> Attribute { a | domain : Maybe (C.Axis -> C.Axis) }
domain fs config =
  { config | domain = Just (\i -> List.foldl (\f b -> f b) i fs) }


{-| -}
limits : List (Attribute C.Axis) -> Attribute { a | limits : C.Axis -> C.Axis }
limits fs config =
  { config | limits = \i -> List.foldl (\f b -> f b) i fs }


{-| -}
pinned : x -> Attribute { a | pinned : x }
pinned value config =
  { config | pinned = value }


{-| -}
dotted : Attribute { a | dotted : Bool }
dotted config =
  { config | dotted = True }


{-| -}
noArrow : Attribute { a | arrow : Bool }
noArrow config =
  { config | arrow = False }


{-| -}
filterX : x -> Attribute { a | filterX : x }
filterX value config =
  { config | filterX = value }


{-| -}
filterY : x -> Attribute { a | filterY : x }
filterY value config =
  { config | filterY = value }


{-| -}
only : x -> Attribute { a | only : x }
only value config =
  { config | only = value }


{-| -}
floats : Attribute { a | produce : Int -> C.Axis -> List CS.TickValue }
floats config =
  { config | produce = \a -> CS.produce a CS.floats >> CS.toTickValues identity String.fromFloat }


{-| -}
floatsCustom : (Float -> String) -> Attribute { a | produce : Int -> C.Axis -> List CS.TickValue }
floatsCustom formatter config =
  { config | produce = \a -> CS.produce a CS.floats >> CS.toTickValues identity formatter }


{-| -}
ints : Attribute { a | produce : Int -> C.Axis -> List CS.TickValue }
ints =
  intsCustom String.fromInt


{-| -}
intsCustom : (Int -> String) -> Attribute { a | produce : Int -> C.Axis -> List CS.TickValue }
intsCustom formatter config =
  { config | produce = \a -> CS.produce a CS.ints >> CS.toTickValues toFloat formatter }


{-| -}
times : Time.Zone -> Attribute { a | produce : Int -> C.Axis -> List CS.TickValue }
times zone config =
  timesCustom zone (CS.formatTime zone) config


{-| -}
timesCustom : Time.Zone -> (I.Time -> String) -> Attribute { a | produce : Int -> C.Axis -> List CS.TickValue }
timesCustom zone formatter config =
  { config | produce = \a -> CS.produce a (CS.times zone) >> CS.toTickValues (toFloat << Time.posixToMillis << .timestamp) formatter }


{-| -}
amount : Int -> Attribute { a | amount : Int }
amount value config =
  { config | amount = value }



-- ELEMENTS


{-| -}
type alias Container data msg =
    { width : Float
    , height : Float
    , marginTop : Float
    , marginBottom : Float
    , marginLeft : Float
    , marginRight : Float
    , paddingTop : Float
    , paddingBottom : Float
    , paddingLeft : Float
    , paddingRight : Float
    , responsive : Bool
    , range : Maybe (Attribute C.Axis)
    , domain : Maybe (Attribute C.Axis)
    , events : List (Event data msg)
    , htmlAttrs : List (H.Attribute msg)
    , attrs : List (S.Attribute msg)
    }


{-| -}
chart : List (Container data msg -> Container data msg) -> List (Element data msg) -> H.Html msg
chart edits elements =
  let config =
        applyAttrs edits
          { width = 500
          , height = 200
          , marginTop = 0
          , marginBottom = 0
          , marginLeft = 0
          , marginRight = 0
          , paddingTop = 10
          , paddingBottom = 0
          , paddingLeft = 0
          , paddingRight = 10
          , responsive = True
          , range = Nothing
          , domain = Nothing
          , events = []
          , attrs = [ SA.style "overflow: visible;" ]
          , htmlAttrs = []
          }

      plane =
        definePlane config elements

      items =
        getItems plane elements

      tickValues =
        getTickValues plane items elements

      ( beforeEls, chartEls, afterEls ) =
        viewElements config plane tickValues items elements

      toEvent (Event event_) =
        let (Decoder decoder) = event_.decoder in
        CS.Event event_.name (decoder items)
  in
  CS.container plane
    [ CA.attrs config.attrs
    , CA.htmlAttrs config.htmlAttrs
    , if config.responsive then identity else CA.static
    , CA.events (List.map toEvent config.events)
    ]
    beforeEls
    chartEls
    afterEls



-- ELEMENTS


{-| -}
type Element data msg
  = SeriesElement
      (List C.Position)
      (List (Item.Product Item.General data))
      (C.Plane -> S.Svg msg)
  | BarsElement
      (List C.Position)
      (List (Item.Product Item.General data))
      (C.Plane -> TickValues -> TickValues)
      (C.Plane -> S.Svg msg)
  | AxisElement
      (C.Plane -> TickValues -> TickValues)
      (C.Plane -> S.Svg msg)
  | TicksElement
      (C.Plane -> TickValues -> TickValues)
      (C.Plane -> S.Svg msg)
  | TickElement
      (C.Plane -> Tick)
      (C.Plane -> Tick -> TickValues -> TickValues)
      (C.Plane -> Tick -> S.Svg msg)
  | LabelsElement
      (C.Plane -> Labels)
      (C.Plane -> Labels -> TickValues -> TickValues)
      (C.Plane -> Labels -> S.Svg msg)
  | LabelElement
      (C.Plane -> Label)
      (C.Plane -> Label -> TickValues -> TickValues)
      (C.Plane -> Label -> S.Svg msg)
  | GridElement
      (C.Plane -> TickValues -> S.Svg msg)
  | SubElements
      (C.Plane -> List (Item.Product Item.General data) -> List (Element data msg))
  | ListOfElements
      (List (Element data msg))
  | SvgElement
      (C.Plane -> S.Svg msg)
  | HtmlElement
      (C.Plane -> H.Html msg)


definePlane : Container data msg -> List (Element data msg) -> C.Plane
definePlane config elements =
  let collectLimits el acc =
        case el of
          SeriesElement lims _ _ -> acc ++ lims
          BarsElement lims _ _ _ -> acc ++ lims
          AxisElement _ _ -> acc
          TicksElement _ _ -> acc
          TickElement _ _ _ -> acc
          LabelsElement _ _ _ -> acc
          LabelElement _ _ _ -> acc
          GridElement _ -> acc
          SubElements _ -> acc
          ListOfElements _ -> acc
          SvgElement _ -> acc
          HtmlElement _ -> acc

      limits_ =
        List.foldl collectLimits [] elements
          |> C.foldPosition identity
          |> \pos -> { x = toLimit pos.x1 pos.x2, y = toLimit pos.y1 pos.y2 }
          |> \{ x, y } -> { x = fixSingles x, y = fixSingles y }

      toLimit min max =
        { min = min, max = max, dataMin = min, dataMax = max }

      fixSingles bs =
        if bs.min == bs.max then { bs | max = bs.min + 10 } else bs

      calcRange =
        case config.range of
          Just edit -> edit limits_.x
          Nothing -> limits_.x

      calcDomain =
        case config.domain of
          Just edit -> edit limits_.y
          Nothing -> lowest 0 orLower limits_.y

      margin =
        { top = config.marginTop
        , right = config.marginRight
        , left = config.marginLeft
        , bottom = config.marginBottom
        }

      unpadded =
        { width = max 1 (config.width - config.paddingLeft - config.paddingRight)
        , height = max 1 (config.height - config.paddingBottom - config.paddingTop)
        , margin = margin
        , x = calcRange
        , y = calcDomain
        }

      scalePadX =
        C.scaleCartesianX unpadded

      scalePadY =
        C.scaleCartesianY unpadded
  in
  { width = config.width
  , height = config.height
  , margin = margin
  , x =
      { calcRange
      | min = calcRange.min - scalePadX config.paddingLeft
      , max = calcRange.max + scalePadX config.paddingRight
      }
  , y =
      { calcDomain
      | min = calcDomain.min - scalePadY config.paddingBottom
      , max = calcDomain.max + scalePadY config.paddingTop
      }
  }


getItems : C.Plane -> List (Element data msg) -> List (Item.Product Item.General data)
getItems plane elements =
  let toItems el acc =
        case el of
          SeriesElement _ items _ -> acc ++ items
          BarsElement _ items _ _ -> acc ++ items
          AxisElement func _ -> acc
          TicksElement _ _ -> acc
          TickElement _ _ _ -> acc
          LabelsElement _ _ _ -> acc
          LabelElement _ _ _ -> acc
          GridElement _ -> acc
          SubElements _ -> acc -- TODO add phantom type to only allow decorative els in this
          ListOfElements _ -> acc
          SvgElement _ -> acc
          HtmlElement _ -> acc
  in
  List.foldl toItems [] elements


{-| -}
type alias TickValues =
  { xAxis : List Float
  , yAxis : List Float
  , xs : List Float
  , ys : List Float
  }


getTickValues : C.Plane -> List (Item.Product Item.General data) -> List (Element data msg) -> TickValues
getTickValues plane items elements =
  let toValues el acc =
        case el of
          SeriesElement _ _ _ -> acc
          BarsElement _ _ func _ -> func plane acc
          AxisElement func _ -> func plane acc
          TicksElement func _ -> func plane acc
          TickElement toC func _ -> func plane (toC plane) acc
          LabelsElement toC func _ -> func plane (toC plane) acc
          LabelElement toC func _ -> func plane (toC plane) acc
          GridElement _ -> acc
          SubElements func -> List.foldl toValues acc (func plane items)
          ListOfElements _ -> acc
          SvgElement _ -> acc
          HtmlElement _ -> acc
  in
  List.foldl toValues (TickValues [] [] [] []) elements


viewElements : Container data msg -> C.Plane -> TickValues -> List (Item.Product Item.General data) -> List (Element data msg) -> ( List (H.Html msg), List (S.Svg msg), List (H.Html msg) )
viewElements config plane tickValues allItems elements =
  let viewOne el ( before, chart_, after ) =
        case el of
          SeriesElement _ _ view    -> ( before, view plane :: chart_, after )
          BarsElement _ _ _ view    -> ( before, view plane :: chart_, after )
          AxisElement _ view        -> ( before, view plane :: chart_, after )
          TicksElement _ view       -> ( before, view plane :: chart_, after )
          TickElement toC _ view    -> ( before, view plane (toC plane) :: chart_, after )
          LabelsElement toC _ view  -> ( before, view plane (toC plane) :: chart_, after )
          LabelElement toC _ view   -> ( before, view plane (toC plane) :: chart_, after )
          GridElement view          -> ( before, view plane tickValues :: chart_, after )
          SubElements func          -> List.foldr viewOne ( before, chart_, after ) (func plane allItems)
          ListOfElements els        -> List.foldr viewOne ( before, chart_, after ) els
          SvgElement view           -> ( before, view plane :: chart_, after )
          HtmlElement view          ->
            ( if List.length chart_ > 0 then before else view plane :: before
            , chart_
            , if List.length chart_ > 0 then view plane :: after else after
            )
  in
  List.foldr viewOne ([], [], []) elements



-- BOUNDS


{-| -}
lowest : Float -> (Float -> Float -> Float -> Float) -> Attribute C.Axis
lowest x edit b =
  { b | min = edit x b.min b.dataMin }


{-| -}
highest : Float -> (Float -> Float -> Float -> Float) -> Attribute C.Axis
highest x edit b =
  { b | max = edit x b.max b.dataMax }


{-| -}
likeData : Attribute C.Axis
likeData b =
  { b | min = b.dataMin, max = b.dataMax }


{-| -}
window : Float -> Float -> Attribute C.Axis
window min_ max_ b =
  { b | min = min_, max = max_ }


{-| -}
exactly : Float -> Float -> Float -> Float
exactly exact _ _ =
  exact


{-| -}
orLower : Float -> Float -> Float -> Float
orLower least real _ =
  if real > least then least else real


{-| -}
orHigher : Float -> Float -> Float -> Float
orHigher most real _ =
  if real < most then most else real


{-| -}
more : Float -> Float -> Float -> Float
more v x _ =
  x + v


{-| -}
less : Float -> Float -> Float -> Float
less v x _ =
  x - v


{-| -}
zero : C.Axis -> Float
zero b =
  clamp b.min b.max 0


{-| -}
middle : C.Axis -> Float
middle b =
  b.min + (b.max - b.min) / 2


stretch : Maybe C.Axis -> C.Axis -> Maybe C.Axis
stretch old new =
  case old of
    Just b ->
      Just
        { min = min b.min new.min
        , max = max b.max new.max
        , dataMin = min b.dataMin new.dataMin
        , dataMax = max b.dataMax new.dataMax
        }

    Nothing ->
      Just new



-- EVENT / DECODER


{-| -}
type Event data msg =
  Event
    { name : String
    , decoder : Decoder data msg
    }


{-| -}
event : String -> Decoder data msg -> Event data msg
event name_ decoder =
  Event { name = name_, decoder = decoder }


{-| -}
type Decoder data msg =
  Decoder (List (Item.Product Item.General data) -> C.Plane -> C.Point -> msg)


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



{-| -}
getCoords : Decoder data C.Point
getCoords =
  Decoder <| \_ plane searched ->
    { x = C.toCartesianX plane searched.x
    , y = C.toCartesianY plane searched.y
    }


{-| -}
getNearest : (C.Plane -> a -> C.Point) -> (List (Item.Product Item.General data) -> List a) -> Decoder data (List a)
getNearest toPoint filterItems =
  Decoder <| \items plane ->
    CS.getNearest (toPoint plane) (filterItems items) plane


{-| -}
getWithin : Float -> (C.Plane -> a -> C.Point) -> (List (Item.Product Item.General data) -> List a) -> Decoder data (List a)
getWithin radius toPoint filterItems =
  Decoder <| \items plane ->
    CS.getWithin radius (toPoint plane) (filterItems items) plane


{-| -}
getNearestX : (C.Plane -> a -> C.Point) -> (List (Item.Product Item.General data) -> List a) -> Decoder data (List a)
getNearestX toPoint filterItems =
  Decoder <| \items plane ->
    CS.getNearestX (toPoint plane) (filterItems items) plane



{-| -}
getWithinX : Float -> (C.Plane -> a -> C.Point) -> (List (Item.Product Item.General data) -> List a) -> Decoder data (List a)
getWithinX radius toPoint filterItems =
  Decoder <| \items plane ->
    CS.getWithinX radius (toPoint plane) (filterItems items) plane



 -- TOOLTIP


type alias Tooltip =
  { direction : Maybe CA.Direction
  , height : Float
  , width : Float
  , offset : Float
  , pointer : Bool
  , border : String
  , background : String
  }


{-| -}
tooltip : Item.Item a -> List (Attribute Tooltip) -> List (H.Attribute Never) -> List (H.Html Never) -> Element data msg
tooltip i edits attrs_ content =
  html <| \p ->
    let pos = Item.getLimits i in
    if CS.isWithinPlane p pos.x1 pos.y2 -- TODO
    then CS.tooltip p (Item.getPosition p i) edits attrs_ content
    else H.text ""



-- AXIS


{-| -}
type alias Axis =
    { limits : C.Axis -> C.Axis
    , pinned : C.Axis -> Float
    , arrow : Bool
    , color : String -- TODO use Color
    }


{-| -}
xAxis : List (CA.Attribute Axis) -> Element item msg
xAxis edits =
  let config =
        applyAttrs edits
          { limits = identity
          , pinned = zero
          , color = ""
          , arrow = True
          }

      addTickValues p ts =
        { ts | yAxis = config.pinned p.y :: ts.yAxis }
  in
  AxisElement addTickValues <| \p ->
    let xLimit = config.limits p.x in
    S.g
      [ SA.class "elm-charts__x-axis" ]
      [ CS.line p
          [ CA.color config.color
          , CA.y1 (config.pinned p.y)
          , CA.x1 (max p.x.min xLimit.min)
          , CA.x2 (min p.x.max xLimit.max)
          ]
      , if config.arrow then
          CS.arrow p [ CA.color config.color ]
            { x = xLimit.max
            , y = config.pinned p.y
            }
        else
          S.text ""
      ]


{-| -}
yAxis : List (Attribute Axis) -> Element item msg
yAxis edits =
  let config =
        applyAttrs edits
          { limits = identity
          , pinned = zero
          , color = ""
          , arrow = True
          }

      addTickValues p ts =
        { ts | xAxis = config.pinned p.x :: ts.xAxis }
  in
  AxisElement addTickValues <| \p ->
    let yLimit = config.limits p.y in
    S.g
      [ SA.class "elm-charts__y-axis" ]
      [ CS.line p
          [ CA.color config.color
          , CA.x1 (config.pinned p.x)
          , CA.y1 (max p.y.min yLimit.min)
          , CA.y2 (min p.y.max yLimit.max)
          ]
      , if config.arrow then
          CS.arrow p [ CA.color config.color, CA.rotate -90 ]
            { x = config.pinned p.x
            , y = yLimit.max
            }
        else
          S.text ""
      ]


type alias Ticks =
    { color : String -- TODO use Color -- TODO allow custom color by tick value
    , height : Float
    , width : Float
    , pinned : C.Axis -> Float
    , limits : C.Axis -> C.Axis
    , only : Float -> Bool
    , amount : Int
    , flip : Bool
    , produce : Int -> C.Axis -> List CS.TickValue
    }


{-| -}
xTicks : List (Attribute Ticks) -> Element item msg
xTicks edits =
  let config =
        applyAttrs ([ floats ] ++ edits)
          { color = ""
          , limits = identity
          , pinned = zero
          , amount = 5
          , only = \_ -> True
          , produce = \a b -> []
          , height = 5
          , flip = False
          , width = 1
          }

      toTicks p =
        config.produce config.amount (config.limits p.x)
          |> List.map .value
          |> List.filter config.only

      addTickValues p ts =
        { ts | xs = ts.xs ++ toTicks p }
  in
  TicksElement addTickValues <| \p ->
    let toTick x =
          CS.xTick p
            [ CA.color config.color
            , CA.length (if config.flip then -config.height else config.height)
            , CA.width config.width
            ]
            { x = x
            , y = config.pinned p.y
            }
    in
    S.g [ SA.class "elm-charts__x-ticks" ] <| List.map toTick (toTicks p)


{-| -}
yTicks : List (Attribute Ticks) -> Element item msg
yTicks edits =
  let config =
        applyAttrs ([ floats ] ++ edits)
          { color = ""
          , limits = identity
          , pinned = zero
          , only = \_ -> True
          , amount = 5
          , produce = \a b -> []
          , height = 5
          , flip = False
          , width = 1
          }

      toTicks p =
        config.produce config.amount (config.limits p.y)
          |> List.map .value
          |> List.filter config.only

      addTickValues p ts =
        { ts | ys = ts.ys ++ toTicks p }
  in
  TicksElement addTickValues <| \p ->
    let toTick y =
          CS.yTick p
            [ CA.color config.color
            , CA.length (if config.flip then -config.height else config.height)
            , CA.width config.width
            ]
            { x = config.pinned p.x
            , y = y
            }
    in
    S.g [ SA.class "elm-charts__y-ticks" ] <| List.map toTick (toTicks p)



type alias Labels =
    { color : String -- TODO use Color
    , pinned : C.Axis -> Float
    , limits : C.Axis -> C.Axis
    , only : Float -> Bool
    , xOff : Float
    , yOff : Float
    , flip : Bool
    , amount : Int
    , anchor : CA.Anchor
    , produce : Int -> C.Axis -> List CS.TickValue
    }


{-| -}
xLabels : List (Attribute Labels) -> Element item msg
xLabels edits =
  let toConfig p =
        applyAttrs ([ floats ] ++ edits)
          { color = "#808BAB"
          , limits = identity
          , only = \_ -> True
          , pinned = zero
          , amount = 5
          , produce = \a b -> []
          , flip = False
          , anchor = CA.Middle
          , xOff = 0
          , yOff = 18
          }

      toTicks p config =
        config.produce config.amount (config.limits p.x)
          |> List.filter (config.only << .value)

      toTickValues p config ts =
        { ts | xs = ts.xs ++ List.map .value (toTicks p config) }
  in
  LabelsElement toConfig toTickValues <| \p config ->
    let toLabel item =
          CS.label p
            [ CA.color config.color
            , CA.xOff config.xOff
            , CA.yOff (if config.flip then -config.yOff + 10 else config.yOff)
            , case config.anchor of
                CA.Middle -> identity
                CA.End -> CA.alignLeft
                CA.Start -> CA.alignRight
            ]
            [ S.text item.label ]
            { x = item.value
            , y = config.pinned p.y
            }
    in
    S.g [ SA.class "elm-charts__x-labels" ] (List.map toLabel (toTicks p config))


{-| -}
yLabels : List (Attribute Labels) -> Element item msg
yLabels edits =
  let toConfig p =
        applyAttrs ([ floats ] ++ edits)
          { color = "#808BAB"
          , limits = identity
          , pinned = zero
          , only = \_ -> True
          , amount = 5
          , produce = \a b -> []
          , anchor = CA.Middle
          , flip = False
          , xOff = -8
          , yOff = 3
          }

      toTicks p config =
        config.produce config.amount (config.limits p.y)
          |> List.filter (config.only << .value)

      toTickValues p config ts =
        { ts | ys = ts.ys ++ List.map .value (toTicks p config) }
  in
  LabelsElement toConfig toTickValues <| \p config ->
    let toLabel item =
          CS.label p
            [ CA.color config.color
            , CA.xOff (if config.flip then -config.xOff else config.xOff)
            , CA.yOff config.yOff
            , case config.anchor of
                CA.Middle -> identity
                CA.End -> CA.alignLeft
                CA.Start -> CA.alignRight
            ]
            [ S.text item.label ]
            { x = config.pinned p.x
            , y = item.value
            }
    in
    S.g [ SA.class "elm-charts__y-labels" ] (List.map toLabel (toTicks p config))


{-| -}
type alias Label =
  { x : Float
  , y : Float
  , xOff : Float
  , yOff : Float
  , border : String
  , borderWidth : Float
  , fontSize : Maybe Int
  , color : String
  , anchor : CA.Anchor
  , rotate : Float
  , flip : Bool
  }


{-| -}
xLabel : List (Attribute Label) -> List (S.Svg msg) -> Element data msg
xLabel edits inner =
  let toConfig p =
        applyAttrs edits
          { x = middle p.x
          , y = zero p.y
          , xOff = 0
          , yOff = 20
          , border = "white"
          , borderWidth = 0.1
          , fontSize = Nothing
          , color = "#808BAB"
          , anchor = CA.Middle
          , rotate = 0
          , flip = False
          }

      toTickValues p config ts =
        { ts | xs = ts.xs ++ [ config.x ] }
  in
  LabelElement toConfig toTickValues <| \p config ->
    let string =
          if inner == []
          then [ S.text (String.fromFloat config.x) ]
          else inner
    in
    CS.label p
      [ CA.xOff config.xOff
      , CA.yOff (if config.flip then -config.yOff + 10 else config.yOff)
      , CA.border config.border
      , CA.borderWidth config.borderWidth
      , case config.fontSize of
          Just s -> CA.fontSize s
          Nothing -> identity
      , CA.color config.color
      , case config.anchor of
          CA.Middle -> identity
          CA.End -> CA.alignRight
          CA.Start -> CA.alignLeft
      , CA.rotate config.rotate
      ]
      string
      { x = config.x, y = config.y }


{-| -}
yLabel : List (Attribute Label) -> List (S.Svg msg) -> Element data msg
yLabel edits inner =
  let toConfig p =
        applyAttrs edits
          { x = zero p.x
          , y = middle p.y
          , xOff = -8
          , yOff = 3
          , border = "white"
          , borderWidth = 0.1
          , fontSize = Nothing
          , color = "#808BAB"
          , anchor = CA.Start
          , rotate = 0
          , flip = False
          }

      toTickValues p config ts =
        { ts | ys = ts.ys ++ [ config.y ] }
  in
  LabelElement toConfig toTickValues <| \p config ->
    let string =
          if inner == []
          then [ S.text (String.fromFloat config.y) ]
          else inner
    in
    CS.label p
      [ CA.xOff (if config.flip then -config.xOff else config.xOff)
      , CA.yOff config.yOff
      , CA.border config.border
      , CA.borderWidth config.borderWidth
      , case config.fontSize of
          Just s -> CA.fontSize s
          Nothing -> identity
      , CA.color config.color
      , case config.anchor of
          CA.Middle -> identity
          CA.End -> CA.alignRight
          CA.Start -> CA.alignLeft
      , CA.rotate config.rotate
      ]
      string
      { x = config.x, y = config.y }



{-| -}
type alias Tick =
  { x : Float
  , y : Float
  , color : String
  , width : Float
  , length : Float
  , flip : Bool
  }


{-| -}
xTick : List (Attribute Tick) -> Element data msg
xTick edits =
  let toConfig p =
        applyAttrs edits
          { x = middle p.x
          , y = zero p.y
          , length = 5
          , color = "rgb(210, 210, 210)"
          , width = 1
          , flip = False
          }

      toTickValues p config ts =
        { ts | xs = ts.xs ++ [ config.x ] }
  in
  TickElement toConfig toTickValues <| \p config ->
    CS.xTick p
      [ CA.length (if config.flip then -config.length else config.length)
      , CA.color config.color
      , CA.width config.width
      ]
      { x = config.x, y = config.y }


{-| -}
yTick : List (Attribute Tick) -> Float -> Element data msg
yTick edits val =
  let toConfig p =
        applyAttrs edits
          { x = middle p.x
          , y = zero p.y
          , length = 5
          , color = "rgb(210, 210, 210)"
          , width = 1
          , flip = False
          }

      toTickValues p config ts =
        { ts | ys = ts.ys ++ [ config.y ] }
  in
  TickElement toConfig toTickValues <| \p config ->
    CS.yTick p
      [ CA.length (if config.flip then -config.length else config.length)
      , CA.color config.color
      , CA.width config.width
      ]
      { x = config.x, y = config.y }



type alias Grid =
    { color : String -- TODO use Color
    , width : Float
    , dotted : Bool
    , filterX : C.Axis -> List Float
    , filterY : C.Axis -> List Float
    }


{-| -}
grid : List (Attribute Grid) -> Element item msg
grid edits =
  let config =
        applyAttrs edits
          { color = "#EFF2FA"
          , filterX = always []
          , filterY = always []
          , width = 1
          , dotted = False
          }

      notTheseX vs p =
        config.filterX p.x ++ vs.xAxis

      notTheseY vs p =
        config.filterY p.y ++ vs.yAxis

      toXGrid vs p v =
        if List.member v (notTheseX vs p)
        then Nothing else Just <|
          CS.line p [ CA.color config.color, CA.width config.width, CA.x1 v ]

      toYGrid vs p v =
        if List.member v (notTheseY vs p)
        then Nothing else Just <|
          CS.line p [ CA.color config.color, CA.width config.width, CA.y1 v ]

      toDot vs p x y =
        if List.member x (notTheseX vs p) || List.member y (notTheseY vs p)
        then Nothing
        else Just <| CS.dot p .x .y [ CA.color config.color, CA.size config.width, CA.circle ] { x = x, y = y }
  in
  GridElement <| \p vs ->
    S.g [ SA.class "elm-charts__grid" ] <|
      if config.dotted then
        List.concatMap (\x -> List.filterMap (toDot vs p x) vs.ys) vs.xs
      else
        [ S.g [ SA.class "elm-charts__x-grid" ] (List.filterMap (toXGrid (Debug.log "here" vs) p) vs.xs)
        , S.g [ SA.class "elm-charts__y-grid" ] (List.filterMap (toYGrid vs p) vs.ys)
        ]




-- BARS


{-| -}
type alias Property data meta inter deco =
  P.Property data meta inter deco


{-| -}
property : (data -> Maybe Float) -> List (Attribute inter) -> List (Attribute deco) -> Property data String inter deco
property y_ =
  P.property y_


{-| -}
named : String -> Property data String inter deco -> Property data String inter deco
named name =
  P.meta name


{-| -}
bar : (data -> Maybe Float) -> List (Attribute deco) -> Property data String inter deco
bar y_ =
  P.property y_ []


{-| -}
variation : (data -> List (Attribute deco)) -> Property data String inter deco -> Property data String inter deco
variation =
  P.variation


{-| -}
stacked : List (Property data meta inter deco) -> Property data meta inter deco
stacked =
  P.stacked


{-| -}
just : (data -> Float) -> (data -> Maybe Float)
just toY =
  toY >> Just


{-| -}
type alias Bars data =
  { spacing : Float
  , margin : Float
  , roundTop : Float
  , roundBottom : Float
  , grouped : Bool
  , x1 : Maybe (data -> Float)
  , x2 : Maybe (data -> Float)
  }


{-| -}
bars : List (Attribute (Bars data)) -> List (Property data String () CS.Bar) -> List data -> Element data msg
bars edits properties data =
  let items =
        Item.toBarSeries edits properties data

      generalized =
        items
          |> List.concatMap Item.getProducts
          |> List.map (Item.toGeneral Item.BarConfig)

      bins =
        items
          |> List.concatMap Item.getProducts
          |> Item.groupBy Item.isSameBin

      toTicks plane acc =
        { acc | xs = List.concatMap (\i -> [ Item.getX1 plane i, Item.getX2 plane i ]) bins }

      toLimits =
        List.map Item.getLimits bins
  in
  BarsElement toLimits generalized toTicks <| \ plane ->
    S.g [ SA.class "elm-charts__bar-series" ] (List.map (Item.render plane) items)
      |> S.map never



-- SERIES


{-| -}
series : (data -> Float) -> List (Property data String CS.Interpolation CS.Dot) -> List data -> Element data msg
series toX properties data =
  let items =
        Item.toDotSeries toX properties data

      generalized =
        items
          |> List.concatMap Item.getProducts
          |> List.map (Item.toGeneral Item.DotConfig)

      toLimits =
        List.map Item.getLimits items
  in
  SeriesElement toLimits generalized <| \p ->
    S.g [ SA.class "elm-charts__dot-series" ] (List.map (Item.render p) items)
      |> S.map never



-- OTHER


{-| -}
withPlane : (C.Plane -> List (Element data msg)) -> Element data msg
withPlane func =
  SubElements <| \p is -> func p


{-| -}
withBins : (C.Plane -> List (Item.Group (Item.Bin data) Item.General data) -> List (Element data msg)) -> Element data msg
withBins func =
  SubElements <| \p is -> func p (Item.groupBy Item.isSameBin is)


{-| -}
withStacks : (C.Plane -> List (Item.Group (Item.Stack data) Item.General data) -> List (Element data msg)) -> Element data msg
withStacks func =
  SubElements <| \p is -> func p (Item.groupBy Item.isSameStack is)


{-| -}
withProducts : (C.Plane -> List (Item.Product Item.General data) -> List (Element data msg)) -> Element data msg
withProducts func =
  SubElements <| \p is -> func p is


{-| -}
each : (C.Plane -> List a) -> (C.Plane -> a -> List (Element data msg)) -> Element data msg
each toItems func =
  SubElements <| \p _ -> List.concatMap (func p) (toItems p)


{-| -}
eachBin : (C.Plane -> Item.Group (Item.Bin data) Item.General data -> List (Element data msg)) -> Element data msg
eachBin func =
  SubElements <| \p is -> List.concatMap (func p) (Item.groupBy Item.isSameBin is)


{-| -}
eachStack : (C.Plane -> Item.Group (Item.Stack data) Item.General data -> List (Element data msg)) -> Element data msg
eachStack func =
  SubElements <| \p is -> List.concatMap (func p) (Item.groupBy Item.isSameStack is)


{-| -}
eachProduct : (C.Plane -> Item.Product Item.General data -> List (Element data msg)) -> Element data msg
eachProduct func =
  SubElements <| \p is -> List.concatMap (func p) is


{-| -}
title : List (Attribute CS.Label) -> List (S.Svg msg) -> C.Point -> Element data msg
title attrs inner point =
  SvgElement <| \p -> CS.label p attrs inner point


{-| -}
line : List (Attribute CS.Line) -> Element data msg
line attrs =
  SvgElement <| \p -> CS.line p attrs


{-| -}
rect : List (Attribute CS.Rect) -> Element data msg
rect attrs =
  SvgElement <| \p -> CS.rect p attrs


{-| -}
svg : (C.Plane -> S.Svg msg) -> Element data msg
svg func =
  SvgElement <| \p -> func p


{-| -}
html : (C.Plane -> H.Html msg) -> Element data msg
html func =
  HtmlElement <| \p -> func p


{-| -}
svgAt : (C.Axis -> Float) -> (C.Axis -> Float) -> Float -> Float -> List (S.Svg msg) -> Element data msg
svgAt toX toY xOff yOff view =
  SvgElement <| \p ->
    S.g [ CS.position p 0 (toX p.x) (toY p.y) xOff yOff ] view


{-| -}
htmlAt : (C.Axis -> Float) -> (C.Axis -> Float) -> Float -> Float -> List (H.Attribute msg) -> List (H.Html msg) -> Element data msg
htmlAt toX toY xOff yOff att view =
  HtmlElement <| \p ->
    CS.positionHtml p (toX p.x) (toY p.y) xOff yOff att view


{-| -}
none : Element data msg
none =
  HtmlElement <| \_ -> H.text ""



-- HELPERS


mapWithPrev : (Maybe a -> a -> b) -> List a -> List b
mapWithPrev =
  let fold prev acc func ds =
        case ds of
          a :: rest -> fold (Just a) (func prev a :: acc) func rest
          [] -> acc
  in
  fold Nothing []


mapSurrounding : (Maybe a -> a -> Maybe a -> b) -> List a -> List b
mapSurrounding =
  let fold prev acc func ds =
        case ds of
          a :: b :: rest -> fold (Just a) (func prev a (Just b) :: acc) func rest
          a :: rest -> fold (Just a) (func prev a Nothing :: acc) func rest
          [] -> acc
  in
  fold Nothing []


applyAttrs : List (a -> a) -> a -> a
applyAttrs funcs default =
  let apply f a = f a in
  List.foldl apply default funcs



-- HELPERS


binned : Float -> (data -> Float) -> List data -> List { bin : Float, data : List data }
binned w func =
  let fold datum acc =
        Dict.update (ceiling (func datum)) (Maybe.map (\ds -> datum :: ds) >> Maybe.withDefault [datum] >> Just) acc

      ceiling b =
        let floored = toFloat (floor (b / w)) * w in
        b - (b - floored) + w
  in
  List.foldr fold Dict.empty
    >> Dict.toList
    >> List.map (\(bin, ds) -> { bin = bin, data = ds })

