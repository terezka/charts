module Chart exposing
    ( chart, Element, bars, histogram, bar, just
    , series, Series, scatter, linear, monotone
    , Shape, circle, triangle, square, diamond, plus, cross, size
    , Bounds, startMin, startMax, endMin, endMax, startPad, endPad, zero, middle
    , xAxis, yAxis, xTicks, yTicks, xLabels, yLabels, grid
    , ints, floats, times, format, values, amount
    , Event, event, Decoder, getCoords, getNearest, getNearestX, getWithin, getWithinX, map, map2, map3, map4
    , Metric, Item, Single, Group
    , getBars, getGroups, getDots, withoutUnknowns
    , tooltip, tooltipOnTop, when, formatTimestamp
    , svgAt, htmlAt, svg, html, none
    , width, height
    , marginTop, marginBottom, marginLeft, marginRight
    , paddingTop, paddingBottom, paddingLeft, paddingRight
    , static, id
    , range, domain, topped, events, htmlAttrs, binWidth
    , start, end, pinned, color, unit, rounded, roundBottom, margin, spacing
    , dot, dotted, area, noArrow, binLabel, topLabel, barColor, tickLength, tickWidth, center
    , filterX, filterY, only, attrs
    , blue, orange, pink, green, red

    , style, empty, detached, aura, full, name, tick
    , bin, label, fontSize, borderWidth, borderColor, xOffset, yOffset
    )


{-| Make a chart! Documentation is still unfinished!

# Elements
@docs chart, Element
@docs series, scatter, linear, monotone, just
@docs bars, histogram, bar

## Work with bounds
@docs Bounds, startMin, startMax, endMin, endMax, startPad, endPad, zero, middle

# Axis
@docs xAxis, yAxis, xTicks, yTicks, xLabels, yLabels, grid
@docs amount, floats, ints, times, values, format, noArrow, start, end, pinned, only, filterX, filterY

# Events
@docs Event, event, Decoder, getCoords, getNearest, getNearestX, getWithin, getWithinX, map, map2, map3, map4
@docs Metric, Item, Single, Group
@docs getBars, getGroups, getDots, withoutUnknowns
@docs tooltip, tooltipOnTop, when, formatTimestamp

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


import Svg.Chart as C
import Svg.Coordinates as C
import Svg as S
import Svg.Attributes as SA
import Svg.Events as SE
import Html as H
import Html.Attributes as HA
import Intervals as I
import DateFormat as F
import Time
import Dict exposing (Dict)


-- ATTRS


{-| -}
type alias Attribute c =
  c -> c


{-| -}
width : Float -> Attribute { a | width : Float }
width value config =
  { config | width = value }


{-| -}
height : Float -> Attribute { a | height : Float }
height value config =
  { config | height = value }


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
static : Attribute { a | responsive : Bool }
static config =
  { config | responsive = False }


{-| -}
id : String -> Attribute { a | id : String }
id value config =
  { config | id = value }


{-| -}
range : (Bounds -> Bounds) -> Attribute { a | range : Maybe (Bounds -> Bounds) }
range value config =
  { config | range = Just value }


{-| -}
domain : (Bounds -> Bounds) -> Attribute { a | domain : Maybe (Bounds -> Bounds) }
domain value config =
  { config | domain = Just value }


{-| -}
init : info -> Attribute { a | init : Maybe info }
init value config =
  { config | init = Just value }


{-| -}
events : List (Event data msg) -> Attribute { a | events : List (Event data msg) }
events value config =
  { config | events = value }


{-| -}
attrs : List (S.Attribute msg) -> Attribute { a | attrs : List (S.Attribute msg) }
attrs value config =
  { config | attrs = value }


{-| -}
htmlAttrs : List (H.Attribute msg) -> Attribute { a | htmlAttrs : List (H.Attribute msg) }
htmlAttrs value config =
  { config | htmlAttrs = value }


{-| -}
start : (Bounds -> Float) -> Attribute { a | start : Bounds -> Float }
start value config =
  { config | start = value }


{-| -}
end : (Bounds -> Float) -> Attribute { a | end : Bounds -> Float }
end value config =
  { config | end = value }


{-| -}
pinned : (Bounds -> Float) -> Attribute { a | pinned : Bounds -> Float }
pinned value config =
  { config | pinned = value }


{-| -}
color : String -> Attribute { a | color : Maybe String }
color value config =
  { config | color = Just value }


{-| -}
name : v -> Attribute { a | name : Maybe v }
name value config =
  { config | name = Just value }


{-| -}
unit : String -> Attribute { a | unit : String }
unit value config =
  { config | unit = value }


{-| -}
rounded : Float -> Attribute { a | rounded : Float }
rounded value config =
  { config | rounded = value }


{-| -}
roundBottom : Attribute { a | roundBottom : Bool }
roundBottom config =
  { config | roundBottom = True }


{-| -}
margin : Float -> Attribute { a | margin : Float }
margin value config =
  { config | margin = value }


{-| -}
spacing : Float -> Attribute { a | spacing : Float }
spacing value config =
  { config | spacing = value }


{-| -}
dot : x -> Attribute { a | dot : Maybe x }
dot value config =
  { config | dot = Just value }


{-| -}
size : b -> Attribute { a | size : Maybe b }
size value config =
  { config | size = Just value }


{-| -}
dotted : Attribute { a | dotted : Bool }
dotted config =
  { config | dotted = True }


{-| -}
area : Float -> Attribute { a | area : Maybe Float }
area value config =
  { config | area = Just value }


{-| -}
noArrow : Attribute { a | arrow : Bool }
noArrow config =
  { config | arrow = False }


{-| -}
filterX : (Bounds -> List Float) -> Attribute { a | filterX : Bounds -> List Float }
filterX value config =
  { config | filterX = value }


{-| -}
filterY : (Bounds -> List Float) -> Attribute { a | filterY : Bounds -> List Float }
filterY value config =
  { config | filterY = value }


{-| -}
only : (b -> Bool) -> Attribute { a | only : b -> Bool }
only value config =
  { config | only = value }


{-| -}
times : Time.Zone -> Attribute { a | values : Maybe (Values I.Time) }
times zone config =
  { config | values = Just
      { produce = I.times zone
      , value = .timestamp >> Time.posixToMillis >> toFloat
      , format = formatTime zone
      }
  }


{-| -}
ints : Attribute { a | values : Maybe (Values Int) }
ints config =
  { config | values = Just
      { produce = \i -> I.ints (I.around i)
      , value = toFloat
      , format = String.fromInt
      }
  }


{-| -}
floats : Attribute { a | values : Maybe (Values Float) }
floats config =
  { config | values = Just
      { produce = \i -> I.floats (I.around i)
      , value = identity
      , format = String.fromFloat
      }
  }


{-| -}
values : (Int -> Bounds -> List tick) -> (tick -> Float) -> (tick -> String) -> Attribute { a | values : Maybe (Values tick) }
values produce value formatter config =
  { config | values = Just
      { produce = produce
      , value = value
      , format = formatter
      }
  }


{-| -}
format : (tick -> String) -> Attribute { a | values : Maybe (Values tick) }
format formatter config =
  { config | values =
      case config.values of
        Just c -> Just { c | format = formatter }
        Nothing -> Nothing -- TODO
  }


{-| -}
amount : Int -> Attribute { a | amount : Int }
amount value config =
  { config | amount = value }


{-| -}
topped : Int -> Attribute { a | topped : Maybe Int }
topped value config =
  { config | topped = Just value }


{-| -}
binLabel : (data -> String) -> Attribute { a | binLabel : Maybe (data -> String) }
binLabel value config =
  { config | binLabel = Just value }


{-| -}
topLabel : (data -> Maybe String) -> Attribute { a | topLabel : data -> Maybe String }
topLabel value config =
  { config | topLabel = value }


{-| -}
binWidth : (data -> Float) -> Attribute { a | binWidth : Maybe (data -> Float) }
binWidth value config =
  { config | binWidth = Just value }


{-| -}
barColor : (data -> String) -> Attribute { a | color : Maybe (data -> String) }
barColor value config =
  { config | color = Just value }


{-| -}
tickLength : Float -> Attribute { a | tickLength : Float }
tickLength value config =
  { config | tickLength = value }


{-| -}
tickWidth : Float -> Attribute { a | tickWidth : Float }
tickWidth value config =
  { config | tickWidth = value }


{-| -}
center : Attribute { a | center : Bool }
center config =
  { config | center = True }




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
    , id : String
    , range : Maybe (Bounds -> Bounds)
    , domain : Maybe (Bounds -> Bounds)
    , events : List (Event data msg)
    , htmlAttrs : List (H.Attribute msg)
    , topped : Maybe Int
    , attrs : List (S.Attribute msg)
    }


{-| -}
chart : List (Container data msg -> Container data msg) -> List (Element data msg) -> H.Html msg
chart edits elements =
  let config =
        applyAttrs edits
          { width = 500
          , height = 200
          , marginTop = 10
          , marginBottom = 30
          , marginLeft = 30
          , marginRight = 10
          , paddingTop = 10
          , paddingBottom = 0
          , paddingLeft = 0
          , paddingRight = 10
          , responsive = True
          , id = "you-should-really-set-the-id-of-your-chart"
          , range = Nothing
          , domain = Nothing
          , topped = Nothing
          , events = []
          , attrs = []
          , htmlAttrs = []
          }

      items =
        getItems elements

      plane =
        definePlane config items

      tickValues =
        getTickValues plane elements

      ( beforeEls, chartEls, afterEls ) =
        viewElements config plane tickValues elements

      svgContainer =
        S.svg (sizingAttrs ++ List.map toEvent config.events ++ config.attrs)

      sizingAttrs =
        if config.responsive then [ C.responsive plane ] else C.static plane

      toEvent e = -- TODO
        let (Decoder func) = e.decoder in
        SE.on e.name <| C.decodePoint plane <| \pl po ->
          func items pl po

      allSvgEls =
        [ C.frame config.id plane ] ++ chartEls ++ [ C.eventCatcher plane [] ]
  in
  C.container plane config.htmlAttrs
    (beforeEls ++ [ svgContainer chartEls ] ++ afterEls)



type alias PrePlaneInfo =
  { x : Maybe Bounds
  , y : Maybe Bounds
  }


type alias PostPlaneInfo data =
  { xTicks : List Float
  , yTicks : List Float
  , collected : List (Item (Maybe Float) data)
  }



--


{-| -}
type Element data msg
  = SeriesElement
      (List (Single (Maybe Float) data))
      (String -> C.Plane -> List (Single (Maybe Float) data) -> S.Svg msg)
  | BarsElement
      (List (Group (Maybe Float) data))
      (C.Plane -> TickValues -> TickValues)
      (String -> C.Plane -> List (Group (Maybe Float) data) -> S.Svg msg)
  | HistogramElement
      (List (Group (Maybe Float) data))
      (C.Plane -> TickValues -> TickValues)
      (String -> C.Plane -> List (Group (Maybe Float) data) -> S.Svg msg)
  | AxisElement
      (C.Plane -> S.Svg msg)
  | TicksElement
      (C.Plane -> TickValues -> TickValues)
      (C.Plane -> S.Svg msg)
  | LabelsElement
      (C.Plane -> TickValues -> TickValues)
      (C.Plane -> S.Svg msg)
  | GridElement
      (C.Plane -> TickValues -> S.Svg msg)
  | SvgElement
      (C.Plane -> S.Svg msg)
  | HtmlElement
      (C.Plane -> S.Svg msg)


getItems : List (Element data msg) -> List (Item (Maybe Float) data)
getItems elements =
  let toItems el acc =
        case el of
          SeriesElement items _ -> acc ++ List.map ItemDot items
          BarsElement items _ _ -> acc ++ List.map ItemGroup items
          HistogramElement items _ _ -> acc ++ List.map ItemGroup items
          AxisElement _ -> acc
          TicksElement _ _ -> acc
          LabelsElement _ _ -> acc
          GridElement _ -> acc
          SvgElement _ -> acc
          HtmlElement _ -> acc
  in
  List.foldl toItems [] elements


definePlane : Container data msg -> List (Item (Maybe Float) data) -> C.Plane
definePlane config items =
  -- TODO apply edits
  let toPoints item acc =
        case item of
          ItemBar value -> value.position :: acc
          ItemDot value -> value.position :: acc
          ItemGroup value -> value.position :: acc

      points =
        List.foldl toPoints [] items

      xRange =
        { min = C.minimum [.x1 >> Just] points
        , max = C.maximum [.x2 >> Just] points
        }

      yRange =
        { min = C.minimum [.y >> Just] points
        , max = C.maximum [.y >> Just] points
        }

      calcRange =
        case config.range of
          Just edit -> edit xRange
          Nothing -> xRange

      calcDomain =
        case config.domain of
          Just edit -> edit yRange
          Nothing -> startMin 0 yRange

      scalePadX =
        C.scaleCartesian
          { marginLower = config.marginLeft
          , marginUpper = config.marginRight
          , length = max 1 (config.width - config.paddingLeft - config.paddingRight)
          , data = calcRange
          , min = calcRange.min
          , max = calcRange.max
          }

      scalePadY =
        C.scaleCartesian
          { marginUpper = config.marginTop
          , marginLower = config.marginBottom
          , length = max 1 (config.height - config.paddingBottom - config.paddingTop)
          , data = calcDomain
          , min = calcDomain.min
          , max = calcDomain.max
          }
  in
  { x =
      { marginLower = config.marginLeft
      , marginUpper = config.marginRight
      , length = config.width
      , data = xRange
      , min = calcRange.min - scalePadX config.paddingLeft
      , max = calcRange.max + scalePadX config.paddingRight
      }
  , y =
      { marginUpper = config.marginTop
      , marginLower = config.marginBottom
      , length = config.height
      , data = yRange
      , min = calcDomain.min - scalePadY config.paddingBottom
      , max = calcDomain.max + scalePadY config.paddingTop
      }
  }


{-| -}
type alias TickValues =
  { xs : List Float
  , ys : List Float
  }


getTickValues : C.Plane -> List (Element data msg) -> TickValues
getTickValues plane elements =
  let toValues el acc =
        case el of
          SeriesElement _ _ -> acc
          BarsElement _ func _ -> func plane acc
          HistogramElement _ func _ -> func plane acc
          AxisElement _ -> acc
          TicksElement func _ -> func plane acc
          LabelsElement func _ -> func plane acc
          GridElement _ -> acc
          SvgElement _ -> acc
          HtmlElement _ -> acc
  in
  List.foldl toValues (TickValues [] []) elements


viewElements : Container data msg -> C.Plane -> TickValues -> List (Element data msg) -> ( List (H.Html msg), List (S.Svg msg), List (H.Html msg) )
viewElements config plane tickValues elements =
  let viewOne el ( before, chart_, after ) =
        case el of
          SeriesElement items view -> ( before, view config.id plane items :: chart_, after )
          BarsElement items _ view -> ( before, view config.id plane items :: chart_, after )
          HistogramElement items _ view -> ( before, view config.id plane items :: chart_, after )
          AxisElement view -> ( before, view plane :: chart_, after )
          TicksElement _ view -> ( before, view plane :: chart_, after )
          LabelsElement _ view -> ( before, view plane :: chart_, after )
          GridElement view -> ( before, view plane tickValues :: chart_, after )
          SvgElement view -> ( before, view plane :: chart_, after )
          HtmlElement view ->
            ( if List.length chart_ > 0 then before else view plane :: before
            , chart_
            , if List.length chart_ > 0 then view plane :: after else after
            )
  in
  List.foldl viewOne ([], [], []) elements
    |> \( b, c, a ) -> ( List.reverse b, List.reverse c, List.reverse a )



-- BOUNDS


{-| -}
type alias Bounds =
    { min : Float, max : Float }


{-| -}
fromData : List (data -> Maybe Float) -> List data -> Bounds
fromData toValues data =
  { min = C.minimum toValues data
  , max = C.maximum toValues data
  }


{-| -}
startMin : Float -> Bounds -> Bounds
startMin value bounds =
  { bounds | min = min value bounds.min }


{-| -}
startMax : Float -> Bounds -> Bounds
startMax value bounds =
  { bounds | min = max value bounds.min }


{-| -}
endMin : Float -> Bounds -> Bounds
endMin value bounds =
  { bounds | max = max value bounds.max }


{-| -}
endMax : Float -> Bounds -> Bounds
endMax value bounds =
  { bounds | max = min value bounds.max }


{-| -}
endPad : Float -> Bounds -> Bounds
endPad value bounds =
  { bounds | max = bounds.max + value }


{-| -}
startPad : Float -> Bounds -> Bounds
startPad value bounds =
  { bounds | min = bounds.min - value }


{-| -}
zero : Bounds -> Float
zero bounds =
  clamp bounds.min bounds.max 0


{-| -}
middle : Bounds -> Float
middle bounds =
    bounds.min + (bounds.max - bounds.min) / 2


stretch : Maybe Bounds -> Bounds -> Maybe Bounds
stretch ma b =
  Just <|
    case ma of
      Just a -> { min = min a.min b.min, max = max a.max b.max }
      Nothing -> b



-- EVENTS


{-| -}
type alias Event data msg =
  { name : String
  , decoder : Decoder data msg
  }


{-| -}
event : String -> Decoder data msg -> Event data msg
event =
  Event



-- EVENT / DECODER



{-| -}
type Item value data
  = ItemBar (Single value data)
  | ItemDot (Single value data)
  | ItemGroup (Group value data)


{-| -}
type alias Metric =
  { label : String
  , color : String
  , unit : String
  }


{-| -}
type alias Single value data =
  { datum : data
  , center : { x : Float, y : Float }
  , position : { x1 : Float, x2 : Float, y : Float }
  , values : { x1 : Float, x2 : Float, y : value }
  , metric : Metric
  }


{-| -}
type alias Group value data =
  { datum : data
  , center : { x : Float, y : Float }
  , position : { x1 : Float, x2 : Float, y : Float }
  , items : List (Single value data)
  }


{-| -}
getBars : List (Item value data) -> List (Single value data)
getBars =
  let filter item =
        case item of
          ItemBar i -> Just [i]
          ItemGroup i -> Just i.items
          _ -> Nothing
  in
  List.concat << List.filterMap filter


{-| -}
getGroups : List (Item value data) -> List (Group value data)
getGroups =
  List.filterMap <| \item ->
    case item of
      ItemGroup i -> Just i
      _ -> Nothing


{-| -}
getDots : List (Item value data) -> List (Single value data)
getDots =
  List.filterMap <| \item ->
    case item of
      ItemDot i -> Just i
      _ -> Nothing


{-| -}
withoutUnknowns : List (Item (Maybe Float) data) -> List (Item Float data)
withoutUnknowns =
  let onlyKnowns i =
        case i.values.y of
          Just y -> Just (Single i.datum i.center i.position { x1 = i.values.x1, x2 = i.values.x2, y = y } i.metric)
          Nothing -> Nothing
  in
  List.filterMap <| \item ->
    case item of
      ItemBar i ->
        Maybe.map ItemBar (onlyKnowns i)

      ItemDot i ->
        Maybe.map ItemDot (onlyKnowns i)

      ItemGroup i ->
        Just <| ItemGroup
          { datum = i.datum
          , center = i.center
          , position = i.position
          , items = List.filterMap onlyKnowns i.items
          }


{-| -}
type Decoder data item
  = Decoder (List (Item (Maybe Float) data) -> C.Plane -> C.Point -> item)


{-| -}
map : (a -> item) -> Decoder data a -> Decoder data item
map f (Decoder a) =
  Decoder <| \ps s p -> f (a ps s p)


{-| -}
map2 : (a -> b -> item) -> Decoder data a -> Decoder data b -> Decoder data item
map2 f (Decoder a) (Decoder b) =
  Decoder <| \ps s p -> f (a ps s p) (b ps s p)


{-| -}
map3 : (a -> b -> c -> item) -> Decoder data a -> Decoder data b -> Decoder data c -> Decoder data item
map3 f (Decoder a) (Decoder b) (Decoder c) =
  Decoder <| \ps s p -> f (a ps s p) (b ps s p) (c ps s p)


{-| -}
map4 : (a -> b -> c -> d -> item) -> Decoder data a -> Decoder data b -> Decoder data c -> Decoder data d -> Decoder data item
map4 f (Decoder a) (Decoder b) (Decoder c) (Decoder d) =
  Decoder <| \ps s p -> f (a ps s p) (b ps s p) (c ps s p) (d ps s p)


{-| -}
getCoords : Decoder data C.Point
getCoords =
  Decoder <| \_ plane point ->
    let searched =
          { x = C.toCartesianX plane point.x
          , y = C.toCartesianY plane point.y
          }
    in
    searched


{-| -}
getNearest : (List (Item (Maybe Float) data) -> List (C.DataPoint item)) -> Decoder data (List (C.DataPoint item))
getNearest filter =
  Decoder (C.getNearest filter)


{-| -}
getWithin : (List (Item (Maybe Float) data) -> List (C.DataPoint item)) -> Float -> Decoder data (List (C.DataPoint item))
getWithin filter radius =
  Decoder (C.getWithin radius filter)


{-| -}
getNearestX : (List (Item (Maybe Float) data) -> List (C.DataPoint item)) -> Decoder data (List (C.DataPoint item))
getNearestX filter =
  Decoder (C.getNearestX filter)


{-| -}
getWithinX : (List (Item (Maybe Float) data) -> List (C.DataPoint item)) -> Float -> Decoder data (List (C.DataPoint item))
getWithinX filter radius =
  Decoder (C.getWithinX radius filter)


{-| -}
tooltip : (Bounds -> Float) -> (Bounds -> Float) -> List (H.Attribute msg) -> List (H.Html msg) -> Element data msg
tooltip toX toY att content =
  html <| \p -> C.tooltip p (toX <| toBounds .x p) (toY <| toBounds .y p) att content


{-| -}
tooltipOnTop : (Bounds -> Float) -> (Bounds -> Float) -> List (H.Attribute msg) -> List (H.Html msg) -> Element data msg
tooltipOnTop toX toY att content =
  html <| \p -> C.tooltipOnTop p (toX <| toBounds .x p) (toY <| toBounds .y p) att content


{-| -}
when : List a -> (a -> List a -> Element data msg) -> Element data msg
when maybeA view =
  case maybeA of
    a :: rest -> view a rest
    [] -> none



-- AXIS


{-| -}
type alias Axis msg =
    { start : Bounds -> Float
    , end : Bounds -> Float
    , pinned : Bounds -> Float
    , arrow : Bool
    , color : Maybe String -- TODO use Color
    , attrs : List (S.Attribute msg)
    }


{-| -}
xAxis : List (Axis msg -> Axis msg) -> Element item msg
xAxis edits =
  let config =
        applyAttrs edits
          { start = .min
          , end = .max
          , pinned = zero
          , color = Nothing
          , arrow = True
          , attrs = []
          }

      color_ =
        Maybe.withDefault "rgb(210, 210, 210)" config.color
  in
  AxisElement <| \p ->
    S.g [ SA.class "elm-charts__x-axis" ]
      [ C.horizontal p ([ SA.stroke color_ ] ++ config.attrs) (config.pinned <| toBounds .y p) (config.start <| toBounds .x p) (config.end <| toBounds .x p)
      , if config.arrow then
          C.xArrow p color_ (config.end <| toBounds .x p) (config.pinned <| toBounds .y p) 0 0
        else
          S.text ""
      ]


{-| -}
yAxis : List (Axis msg -> Axis msg) -> Element item msg
yAxis edits =
  let config =
        applyAttrs edits
          { start = .min
          , end = .max
          , pinned = zero
          , color = Nothing
          , arrow = True
          , attrs = []
          }

      color_ =
        Maybe.withDefault "rgb(210, 210, 210)" config.color
  in
  AxisElement <| \p ->
    S.g [ SA.class "elm-charts__y-axis" ]
      [ C.vertical p ([ SA.stroke color_ ] ++ config.attrs) (config.pinned <| toBounds .x p) (config.start <| toBounds .y p) (config.end <| toBounds .y p)
      , if config.arrow then
          C.yArrow p color_ (config.pinned <| toBounds .x p) (config.end <| toBounds .y p) 0 0
        else
          S.text ""
      ]


type alias Ticks tick msg =
    { color : Maybe String -- TODO use Color -- TODO allow custom color by tick value
    , height : Float
    , width : Float
    , pinned : Bounds -> Float
    , start : Bounds -> Float
    , end : Bounds -> Float
    , only : Float -> Bool
    , amount : Int
    , values : Maybe (Values tick)
    , attrs : List (S.Attribute msg)
    }

type alias Values tick =
  { produce : Int -> Bounds -> List tick
  , value : tick -> Float
  , format : tick -> String
  }


{-| -}
xTicks : List (Ticks tick msg -> Ticks tick msg) -> Element item msg
xTicks edits =
  let config =
        applyAttrs edits
          { color = Nothing
          , start = .min
          , end = .max
          , pinned = zero
          , amount = 5
          , only = \_ -> True
          , values = Nothing
          , height = 5
          , width = 1
          , attrs = []
          }

      color_ =
        Maybe.withDefault "rgb(210, 210, 210)" config.color

      xBounds p =
        let b = toBounds .x p in
        { min = config.start b
        , max = config.end b
        }

      toTicks p =
        List.filter config.only <|
          case config.values of
            Just { value, produce } -> List.map value (produce config.amount <| xBounds p)
            Nothing -> I.floats (I.around config.amount) (xBounds p)

      tickAttrs =
        [ SA.stroke color_
        , SA.strokeWidth (String.fromFloat config.width)
        ] ++ config.attrs

      addTickValues p ts =
        { ts | xs = ts.xs ++ toTicks p }
  in
  TicksElement addTickValues <| \p ->
    C.xTicks p config.height tickAttrs (config.pinned <| toBounds .y p) (toTicks p)


{-| -}
yTicks : List (Ticks tick msg -> Ticks tick msg) -> Element item msg
yTicks edits =
  let config =
        applyAttrs edits
          { color = Nothing
          , start = .min
          , end = .max
          , pinned = zero
          , only = \_ -> True
          , amount = 5
          , values = Nothing
          , height = 5
          , width = 1
          , attrs = []
          --, offset = 0
          }

      color_ =
        Maybe.withDefault "rgb(210, 210, 210)" config.color

      yBounds p =
        let b = toBounds .y p in
        { min = config.start b
        , max = config.end b
        }

      toTicks p =
        List.filter config.only <|
          case config.values of
            Just { value, produce } -> List.map value (produce config.amount <| yBounds p)
            Nothing -> I.floats (I.around config.amount) (yBounds p)

      tickAttrs =
        [ SA.stroke color_
        , SA.strokeWidth (String.fromFloat config.width)
        ] ++ config.attrs

      addTickValues p ts =
        { ts | ys = ts.ys ++ toTicks p }
  in
  TicksElement addTickValues <| \p ->
    C.yTicks p config.height tickAttrs (config.pinned <| toBounds .x p) (toTicks p)



type alias Labels tick msg =
    { color : Maybe String -- TODO use Color
    , pinned : Bounds -> Float
    , start : Bounds -> Float
    , end : Bounds -> Float
    , only : Float -> Bool
    , xOffset : Float
    , yOffset : Float
    , amount : Int
    , values : Maybe (Values tick)
    , center : Bool
    , attrs : List (S.Attribute msg)
    }


type alias Pair =
  { value : Float
  , label : String
  }


{-| -}
xLabels : List (Labels tick msg -> Labels tick msg) -> Element item msg
xLabels edits =
  let config =
        applyAttrs edits
          { color = Nothing
          , start = .min
          , end = .max
          , only = \_ -> True
          , pinned = zero
          , amount = 5
          , values = Nothing
          , xOffset = 0
          , yOffset = 0
          , center = False
          , attrs = []
          }

      color_ =
        Maybe.withDefault "#808BAB" config.color

      xBounds p =
        let b = toBounds .x p in
        { min = config.start b
        , max = config.end b
        }

      toTicks p =
        List.filter (config.only << .value) <|
          case config.values of
            Just c ->
              c.produce config.amount (xBounds p)
                |> List.map (\i -> Pair (c.value i) (c.format i))

            Nothing ->
              I.floats (I.around config.amount) (xBounds p)
                |> List.map (\i -> Pair i (String.fromFloat i))

      repositionIfCenter pairs =
        if config.center
          then List.filterMap identity (mapWithPrev toCenterTick pairs)
          else pairs

      toCenterTick maybePrev curr =
        case maybePrev of
          Just prev -> Just <| Pair (prev.value + (curr.value - prev.value) / 2) prev.label
          Nothing -> Nothing

      labelAttrs =
        [ SA.fill color_
        , SA.transform ("translate(" ++ String.fromFloat config.xOffset ++ " " ++ String.fromFloat config.yOffset ++ ")")
        ] ++ config.attrs

      toTickValues p ts =
        { ts | xs = ts.xs ++ List.map .value (toTicks p) }
  in
  LabelsElement toTickValues <| \p ->
    C.xLabels p (C.xLabel labelAttrs .value .label) (config.pinned <| toBounds .y p) (repositionIfCenter <| toTicks p)


{-| -}
yLabels : List (Labels tick msg -> Labels tick msg) -> Element item msg
yLabels edits =
  let config =
        applyAttrs edits
          { color = Nothing
          , start = .min
          , end = .max
          , pinned = zero
          , only = \_ -> True
          , amount = 5 -- TODO
          , values = Nothing
          , xOffset = 0
          , yOffset = 0
          , center = False
          , attrs = []
          }

      color_ =
        Maybe.withDefault "#808BAB" config.color

      yBounds p =
        let b = toBounds .y p in
        { min = config.start b
        , max = config.end b
        }

      toTicks p =
        List.filter (config.only << .value) <|
          case config.values of
            Just c ->
              c.produce config.amount (yBounds p)
                |> List.map (\i -> Pair (c.value i) (c.format i))

            Nothing ->
              I.floats (I.around config.amount) (yBounds p)
                |> List.map (\i -> Pair i (String.fromFloat i))

      repositionIfCenter pairs =
        if config.center
          then List.filterMap identity (mapWithPrev toCenterTick pairs)
          else pairs

      toCenterTick maybePrev curr =
        case maybePrev of
          Just prev -> Just <| Pair (prev.value + (curr.value - prev.value) / 2) prev.label
          Nothing -> Nothing

      labelAttrs =
        [ SA.fill color_
        , SA.transform ("translate(" ++ String.fromFloat config.xOffset ++ " " ++ String.fromFloat config.yOffset ++ ")")
        ] ++ config.attrs

      toTickValues p ts =
        { ts | ys = ts.ys ++ List.map .value (toTicks p) }
  in
  LabelsElement toTickValues <| \p ->
    C.yLabels p (C.yLabel labelAttrs .value .label) (config.pinned <| toBounds .x p) (repositionIfCenter <| toTicks p)



type alias Grid msg =
    { color : Maybe String -- TODO use Color
    , width : Float
    , dotted : Bool
    , filterX : Bounds -> List Float
    , filterY : Bounds -> List Float
    , attrs : List (S.Attribute msg)
    }


{-| -}
grid : List (Grid msg -> Grid msg) -> Element item msg
grid edits =
  let config =
        applyAttrs edits
          { color = Nothing
          , filterX = zero >> List.singleton
          , filterY = zero >> List.singleton
          , width = 1
          , attrs = []
          , dotted = False
          }

      color_ =
        Maybe.withDefault "#EFF2FA" config.color

      gridAttrs =
        [ SA.stroke color_
        , SA.strokeWidth (String.fromFloat config.width)
        ] ++ config.attrs

      notTheseX p =
        config.filterX (toBounds .x p)

      notTheseY p =
        config.filterY (toBounds .y p)

      toXGrid p v =
        if List.member v (notTheseY p)
        then Nothing else Just <| C.yGrid p gridAttrs v

      toYGrid p v =
        if List.member v (notTheseX p)
        then Nothing else Just <| C.xGrid p gridAttrs v

      toDot p x y =
        if List.member x (notTheseX p) || List.member y (notTheseY p)
        then Nothing
        else Just <| C.full config.width C.circle color_ p x y
  in
  GridElement <| \p vs ->
    S.g [ SA.class "elm-charts__grid" ] <|
      if config.dotted then
        List.concatMap (\x -> List.filterMap (toDot p x) vs.ys) vs.xs
      else
        [ S.g [ SA.class "elm-charts__x-grid" ] (List.filterMap (toXGrid p) vs.xs)
        , S.g [ SA.class "elm-charts__y-grid" ] (List.filterMap (toYGrid p) vs.ys)
        ]




-- SERIES


type alias Bars data msg =
  { rounded : Float
  , roundBottom : Bool
  , attrs : List (S.Attribute msg)
  , margin : Float
  , spacing : Float
  , tick : List (Attribute (Tick msg))
  , bin : List (Attribute (Bin data msg))
  }


{-| -}
bars : List (Bars data msg -> Bars data msg) -> List (Bar data msg) -> List data -> Element data msg
bars edits metrics data =
  let config =
        applyAttrs edits
          { rounded = 0
          , roundBottom = False
          , spacing = 0.01
          , margin = 0.05
          , bin = []
          , tick = []
          , attrs = []
          }

      tickConfig =
        applyAttrs config.tick
          { color = Nothing
          , width = Nothing
          , height = 5
          , attributes = []
          }

      binConfig =
        applyAttrs config.bin
          { name = Nothing
          , label = Nothing
          , width = Nothing
          }

      binLabelConfig =
        applyAttrs (Maybe.withDefault [] binConfig.label)
          { color = Nothing
          , fontSize = Nothing
          , borderWidth = 0.1
          , borderColor = "white"
          , xOffset = 0
          , yOffset = 15
          , flipped = False
          , attributes = []
          }

      barLabelConfig metric v =
        applyAttrs (Maybe.withDefault [] metric.label)
          { color = Nothing
          , fontSize = Nothing
          , borderWidth = 0.1
          , borderColor = "white"
          , xOffset = 0
          , yOffset = if v < 0 then -12 else -4
          , flipped = v < 0
          , attributes = []
          }

      toBinLabel p d =
        case binConfig.name of
          Just func -> Just <| xLabel binLabelConfig p (func d)
          Nothing -> Nothing

      toBarLabel p metric d v =
        case ( v, metric.label ) of
          ( Just v_, Just _ ) ->
            Just (xLabel (barLabelConfig metric v_) p (String.fromFloat v_))

          _ ->
            Nothing

      numOfBars =
        toFloat (List.length metrics)

      binMargin =
        config.margin * 2

      barSpacing =
        (numOfBars - 1) * config.spacing

      toBarColor barIndex m d =
        case m.color of
          Just func -> func d
          Nothing -> toDefaultColor barIndex -- TODO nice default

      toBar p id_ d barIndex (Bar value metric) =
        { attributes = [ SA.stroke "transparent", SA.fill (toBarColor barIndex metric d), clipPath id_ ] ++ config.attrs
        , label = toBarLabel p metric d (value d)
        , width = (1 - barSpacing - binMargin) / numOfBars
        , rounded = config.rounded
        , roundBottom = config.roundBottom
        , value = Maybe.withDefault (C.closestToZero p) (value d)
        }

      toBin p id_ i d =
        { label = toBinLabel p d
        , spacing = config.spacing
        , tickLength = tickConfig.height
        , tickWidth = Maybe.withDefault 1 tickConfig.width
        , bars = List.indexedMap (toBar p id_ d) metrics
        }

      -- CALC

      groupItems =
        toGroupItems { margin = config.margin, between = config.spacing } metrics data

      toTicks p acc =
        { acc | xs = List.concatMap (\i -> [i.position.x1, i.position.x2]) groupItems }
  in
  BarsElement groupItems toTicks <| \id_ p _ ->
    -- TODO use items
    C.bars p (List.indexedMap (toBin p id_) data)



type alias Histogram data msg =
  { rounded : Float
  , roundBottom : Bool
  , margin : Float
  , spacing : Float
  , bin : List (Attribute (Bin data msg))
  , tick : List (Attribute (Tick msg))
  , attrs : List (S.Attribute msg)
  }


type alias Bin data msg =
  { name : Maybe (data -> String)
  , label : Maybe (List (Attribute (Label msg)))
  , width : Maybe (data -> Float)
  }


{-| -}
bin : v -> Attribute { a | bin : v }
bin v config =
  { config | bin = v }


{-| -}
histogram : (data -> Float) -> List (Histogram data msg -> Histogram data msg) -> List (Bar data msg) -> List data -> Element data msg
histogram toX edits metrics data =
  let config =
        applyAttrs edits
          { rounded = 0
          , roundBottom = False
          , spacing = 0.01
          , margin = 0.05
          , bin = []
          , tick = []
          , attrs = []
          }

      tickConfig =
        applyAttrs config.tick
          { color = Nothing
          , width = Nothing
          , height = 5
          , attributes = []
          }

      binConfig =
        applyAttrs config.bin
          { name = Nothing
          , label = Nothing
          , width = Nothing
          }

      binLabelConfig =
        applyAttrs (Maybe.withDefault [] binConfig.label)
          { color = Nothing
          , fontSize = Nothing
          , borderWidth = 0.1
          , borderColor = "white"
          , xOffset = 0
          , yOffset = 15
          , flipped = False
          , attributes = []
          }

      toBarLabel p metric d v =
        case ( v, metric.label ) of
          ( Just v_, Just _ ) ->
            Just (xLabel (barLabelConfig metric v_) p (String.fromFloat v_))

          _ ->
            Nothing

      barLabelConfig metric v =
        applyAttrs (Maybe.withDefault [] metric.label)
          { color = Nothing
          , fontSize = Nothing
          , borderWidth = 0.1
          , borderColor = "white"
          , xOffset = 0
          , yOffset = if v < 0 then -12 else -4
          , flipped = v < 0
          , attributes = []
          }

      numOfBars =
        toFloat (List.length metrics)

      barMargin =
        config.margin * 2

      barSpacing =
        (numOfBars - 1) * config.spacing

      toBinWidth p d maybePrev =
        case binConfig.width of
          Just toWidth -> toWidth d
          Nothing ->
            case maybePrev of
              Just prev -> toX d - toX prev
              Nothing -> toX d - p.x.min

      toBinLabel p d =
        case binConfig.name of
          Just func -> Just <| xLabel binLabelConfig p (func d)
          Nothing -> Nothing

      toBarColor m d =
        case m.color of
          Just func -> func d
          Nothing -> blue

      toBar id_ p d (Bar value metric) =
        { attributes = [ SA.stroke "transparent", SA.fill (toBarColor metric d), clipPath id_ ] ++ config.attrs
        , label = toBarLabel p metric d (value d)
        , width = (1 - barSpacing - barMargin) / numOfBars
        , rounded = config.rounded
        , roundBottom = config.roundBottom
        , value = Maybe.withDefault (C.closestToZero p) (value d)
        }

      toBin id_ p maybePrev d =
        { label = toBinLabel p d
        , start = toX d - toBinWidth p d maybePrev
        , end = toX d
        , spacing = config.spacing
        , tickLength = tickConfig.height -- TODO add color too
        , tickWidth = Maybe.withDefault 1 tickConfig.width
        , bars = List.map (toBar id_ p d) metrics
        }

      -- CALC

      binItems =
        toBinItems { margin = config.margin, between = config.spacing } toX toX2 metrics data

      toX2 =
        case binConfig.width of
          Just toWidth -> Just (\d -> toX d + toWidth d)
          Nothing -> Nothing

      toTicks p acc =
        { acc | xs = List.concatMap (\i -> [i.position.x1, i.position.x2]) binItems }
  in
  HistogramElement binItems toTicks <| \id_ p _ ->
    -- TODO use items
    C.histogram p (mapWithPrev (toBin id_ p) data)



{-| -}
type Bar data msg =
  Bar (data -> Maybe Float) (BarConfig data msg)


type alias BarConfig data msg =
  { name : Maybe String
  , unit : String
  , color : Maybe (data -> String)
  , label : Maybe (List (Attribute (Label msg)))
  , attrs : List (S.Attribute msg)
  }


{-| -}
bar : (data -> Maybe Float) -> List (BarConfig data msg -> BarConfig data msg) -> Bar data msg
bar toY edits =
  let config =
        applyAttrs edits
          { name = Nothing
          , unit = ""
          , color = Nothing
          , label = Nothing
          , attrs = [] -- TODO use
          }
  in
  Bar toY config


{-| -}
just : (data -> Float) -> (data -> Maybe Float)
just toY =
  toY >> Just



-- DOTTED SERIES


type Series data msg
  = Series (data -> Maybe Float) String String (Maybe String)
      (Int -> (data -> Float) -> List data -> C.Plane -> String -> S.Svg msg)


{-| -}
series : (data -> Float) -> List (Series data msg) -> List data -> Element data msg
series toX series_ data =
  let metrics =
        List.indexedMap (\i (Series toY l u cM _) ->
            ( Metric l (Maybe.withDefault (toDefaultColor i) cM) u, toY )
          )
        series_

      items =
        toDotItems toX metrics data
  in
  SeriesElement items <| \id_ p _ ->
    -- TODO use items
    S.g
      [ SA.class "elm-charts__series", clipPath id_ ] <|
      List.indexedMap (\i (Series _ _ _ _ view) -> view i toX data p (toDefaultColor i)) series_



type alias Scatter data msg =
    { color : Maybe String -- TODO use Color
    , name : Maybe String
    , unit : String
    , size : Maybe (data -> Float)
    , style : Maybe (data -> Style)
    , dot : Maybe (data -> S.Svg msg)
    }


{-| -}
scatter : (data -> Maybe Float) -> List (Scatter data msg -> Scatter data msg) -> Series data msg
scatter toY edits =
  -- TODO seperate dot style and color from shape
  let config =
        applyAttrs edits
          { color = Nothing
          , name = Nothing
          , unit = ""
          , size = Nothing
          , style = Nothing
          , dot = Nothing
          }

      toSize d =
        case config.size of
          Just func -> func d
          Nothing -> 6

      finalDot i c d =
        case config.dot of
          Just toDot -> \p x y ->
            S.g [ C.position p x y 0 0 ] [ toDot d ]

          Nothing ->
            case Maybe.map (\f -> f d) config.style of
              Nothing -> C.disconnected (toSize d) 1 (toDefaultShape i) c
              Just Full -> C.full (toSize d) (toDefaultShape i) c
              Just (Empty s) -> C.empty (toSize d) s (toDefaultShape i) c
              Just (Aura a b) -> C.aura (toSize d) a b (toDefaultShape i) c
              Just (Detached a) -> C.disconnected (toSize d) a (toDefaultShape i) c
  in
  Series toY (Maybe.withDefault "" config.name) config.unit config.color <| \i toX data p c ->
    C.scatter p toX toY (finalDot i c) data


type alias Interpolation data msg =
    { area : Maybe Float -- TODO use Color
    , color : Maybe String -- TODO use Color
    , size : Maybe (data -> Float)
    , width : Float
    , name : Maybe String
    , unit : String
    , style : Maybe (data -> Style)
    , dot : Maybe (data -> S.Svg msg)
    , attrs : List (S.Attribute msg)
    }


{-| -}
monotone : (data -> Maybe Float) -> List (Interpolation data msg -> Interpolation data msg) -> Series data msg
monotone toY edits =
  let config =
        applyAttrs edits
          { color = Nothing
          , area = Nothing
          , size = Nothing
          , width = 1
          , dot = Nothing
          , style = Nothing
          , name = Nothing
          , unit = ""
          , attrs = []
          }

      interAttrs c =
        [ SA.stroke c
        , SA.strokeWidth (String.fromFloat config.width)
        , SA.fill c
        ] ++ config.attrs

      toSize d =
        case config.size of
          Just func -> func d
          Nothing -> 6

      finalDot i c d =
        case config.dot of
          Just toDot -> \p x y ->
            S.g [ C.position p x y 0 0 ] [ toDot d ]

          Nothing ->
            case Maybe.map (\f -> f d) config.style of
              Nothing -> C.disconnected (toSize d) 1 (toDefaultShape i) c
              Just Full -> C.full (toSize d) (toDefaultShape i) c
              Just (Empty s) -> C.empty (toSize d) s (toDefaultShape i) c
              Just (Aura a b) -> C.aura (toSize d) a b (toDefaultShape i) c
              Just (Detached a) -> C.disconnected (toSize d) a (toDefaultShape i) c
  in
  Series toY (Maybe.withDefault "" config.name) config.unit config.color <| \i toX data p c ->
    C.monotone p toX toY (interAttrs c) config.area (finalDot i c) data



{-| -}
linear : (data -> Maybe Float) -> List (Interpolation data msg -> Interpolation data msg) -> Series data msg
linear toY edits =
  let config =
        applyAttrs edits
          { color = Nothing
          , area = Nothing
          , size = Nothing
          , width = 1
          , name = Nothing
          , unit = ""
          , dot = Nothing
          , style = Nothing
          , attrs = []
          }

      interAttrs c =
        [ SA.stroke c
        , SA.strokeWidth (String.fromFloat config.width)
        , SA.fill c
        ] ++ config.attrs

      toSize d =
        case config.size of
          Just func -> func d
          Nothing -> 6

      finalDot i c d =
        case config.dot of
          Just toDot -> \p x y ->
            S.g [ C.position p x y 0 0 ] [ toDot d ]

          Nothing ->
            case Maybe.map (\f -> f d) config.style of
              Nothing -> C.disconnected (toSize d) 1 (toDefaultShape i) c
              Just Full -> C.full (toSize d) (toDefaultShape i) c
              Just (Empty s) -> C.empty (toSize d) s (toDefaultShape i) c
              Just (Aura a b) -> C.aura (toSize d) a b (toDefaultShape i) c
              Just (Detached a) -> C.disconnected (toSize d) a (toDefaultShape i) c
  in
  Series toY (Maybe.withDefault "" config.name) config.unit config.color <| \i toX data p c ->
    C.linear p toX toY (interAttrs c) config.area (finalDot i c) data


{-| -}
svg : (C.Plane -> S.Svg msg) -> Element data msg
svg func =
  SvgElement <| \p -> func p


{-| -}
html : (C.Plane -> H.Html msg) -> Element data msg
html func =
  HtmlElement <| \p -> func p


{-| -}
svgAt : (Bounds -> Float) -> (Bounds -> Float) -> Float -> Float -> List (S.Svg msg) -> Element data msg
svgAt toX toY xOff yOff view =
  SvgElement <| \p ->
    S.g [ C.position p (toX <| toBounds .x p) (toY <| toBounds .y p) xOff yOff ] view


{-| -}
htmlAt : (Bounds -> Float) -> (Bounds -> Float) -> Float -> Float -> List (H.Attribute msg) -> List (H.Html msg) -> Element data msg
htmlAt toX toY xOff yOff att view =
  HtmlElement <| \p ->
    C.positionHtml p (toX <| toBounds .x p) (toY <| toBounds .y p) xOff yOff att view


{-| -}
none : Element data msg
none =
  HtmlElement <| \_ -> H.text ""



-- HELPERS


toBounds : (C.Plane -> C.Axis) -> C.Plane -> Bounds
toBounds toA plane =
  let { min, max } = toA plane
  in { min = min, max = max }


toDataBounds : (C.Plane -> C.Axis) -> C.Plane -> Bounds
toDataBounds toA plane =
  let axis = toA plane
  in axis.data


mapWithPrev : (Maybe a -> a -> b) -> List a -> List b
mapWithPrev =
  let fold prev acc func ds =
        case ds of
          a :: rest -> fold (Just a) (func prev a :: acc) func rest
          [] -> acc
  in
  fold Nothing []


applyAttrs : List (a -> a) -> a -> a
applyAttrs funcs default =
  let apply f a = f a in
  List.foldl apply default funcs


clipPath : String -> S.Attribute msg
clipPath id_ =
  SA.clipPath <| "url(#" ++ id_ ++ ")"



-- ITEMS


toDotItems : (data -> Float) -> List ( Metric, data -> Maybe Float ) -> List data -> List (Single (Maybe Float) data)
toDotItems toX metrics data =
  let toDotItem datum (metric, value) =
        { datum = datum
        , center =
            { x = toX datum
            , y = Maybe.withDefault 0 (value datum)
            }
        , position =
            { x1 = toX datum
            , x2 = toX datum
            , y = Maybe.withDefault 0 (value datum)
            }
        , values =
            { x1 = toX datum
            , x2 = toX datum
            , y = value datum
            }
        , metric = metric
        }

      toLineItems datum =
        List.map (toDotItem datum) metrics
  in
  List.concatMap toLineItems data


type alias Space =
  { between : Float
  , margin : Float
  }


toGroupItems : Space -> List (Bar data msg) -> List data -> List (Group (Maybe Float) data)
toGroupItems space bars_ data =
  let amountOfBars =
        toFloat (List.length bars_)

      barWidth =
        (1 - space.margin * 2 - (amountOfBars - 1) * space.between) / amountOfBars

      toBarItem binIndex datum barIndex (Bar value metric) =
        { datum = datum
        , center =
            { x = toFloat binIndex + 0.5 + space.margin + toFloat barIndex * barWidth + barWidth / 2
            , y = Maybe.withDefault 0 (value datum)
            }
        , position =
            { x1 = toFloat binIndex + 0.5 + space.margin + toFloat barIndex * barWidth
            , x2 = toFloat binIndex + 0.5 + space.margin + toFloat barIndex * barWidth + barWidth
            , y = Maybe.withDefault 0 (value datum)
            }
        , values =
            { x1 = toFloat binIndex
            , x2 = toFloat binIndex
            , y = value datum
            }
        , metric =
            { label = Maybe.withDefault "" metric.name
            , unit = metric.unit
            , color =
                case metric.color of
                  Just c -> c datum
                  Nothing -> toDefaultColor barIndex
            }
        }

      toGroupItem binIndex datum =
        let toYs = List.map (\(Bar value metric) -> value) bars_ in
        { datum = datum
        , center =
            { x = toFloat binIndex
            , y = C.maximum toYs [datum]
            }
        , position =
            { x1 = toFloat binIndex + 0.5
            , x2 = toFloat binIndex + 1.5
            , y = C.maximum toYs [datum]
            }
        , items = List.indexedMap (toBarItem binIndex datum) bars_
        }
  in
  List.indexedMap toGroupItem data


toBinItems : Space -> (data -> Float) -> Maybe (data -> Float) -> List (Bar data msg) -> List data -> List (Group (Maybe Float) data)
toBinItems space toX1 toX2Maybe bars_ data =
  let toLength prevMaybe datum =
        case toX2Maybe of
          Just toX2 -> toX1 datum - toX2 datum -- TODO maybe use actual x2 instead of width?
          Nothing ->
            case prevMaybe of
              Just prev -> toX1 datum - toX1 prev
              Nothing -> 1 -- toX1 datum -- TODO use axis.min

      toBarItem prevMaybe datum barIndex (Bar value metric) =
        let length = toLength prevMaybe datum
            margin_ = length * space.margin
            amountOfBars = toFloat (List.length bars_)
            width_ = (length - margin_ * 2 - (amountOfBars - 1) * space.between) / amountOfBars
        in
        { datum = datum
        , center =
            { x = toX1 datum + margin_ + toFloat barIndex * width_ - width_ / 2
            , y = Maybe.withDefault 0 (value datum)
            }
        , position =
            { x1 = toX1 datum + margin_ + toFloat barIndex * width_ - width_
            , x2 = toX1 datum + margin_ + toFloat barIndex * width_
            , y = Maybe.withDefault 0 (value datum) -- TODO perhaps leave as Maybe?
            }
        , values =
            { x1 = toX1 datum
            , x2 = toX1 datum + width_
            , y = value datum
            }
        , metric =
            { label = Maybe.withDefault "" metric.name
            , unit = metric.unit
            , color =
                case metric.color of
                  Just c -> c datum
                  Nothing -> toDefaultColor barIndex
            }
        }

      toBinItem prevMaybe datum =
        let toYs = List.map (\(Bar value metric) -> value) bars_ in
        { datum = datum
        , center =
            { x = toX1 datum + toLength prevMaybe datum / 2
            , y = C.maximum toYs [datum]
            }
        , position =
            { x1 = toX1 datum
            , x2 = toX1 datum + toLength prevMaybe datum
            , y = C.maximum toYs [datum]
            }
        , items = List.indexedMap (toBarItem prevMaybe datum) bars_
        }
  in
  mapWithPrev toBinItem data


-- DEFAULTS


toDefaultShape : Int -> C.Shape
toDefaultShape index =
  let numOfItems = Dict.size shapes
      itemIndex = remainderBy numOfItems index
  in
  Dict.get itemIndex shapes
    |> Maybe.withDefault C.circle


shapes : Dict Int C.Shape
shapes =
  [ C.circle, C.triangle, C.square, C.diamond, C.plus, C.cross ]
    |> List.indexedMap Tuple.pair
    |> Dict.fromList



{-| -}
type alias Shape =
  C.Shape


{-| -}
circle : Shape
circle =
  C.circle


{-| -}
triangle : Shape
triangle =
  C.triangle


{-| -}
square : Shape
square =
  C.square


{-| -}
diamond : Shape
diamond =
  C.diamond


{-| -}
plus : Shape
plus =
  C.plus


{-| -}
cross : Shape
cross =
  C.cross



-- STYLE


{-| -}
type Style
  = Full
  | Empty Float
  | Aura Float Float
  | Detached Float


-- TODO remove this attr
style : x -> Attribute { a | style : Maybe x }
style v config =
  { config | style = Just v }


{-| -}
full : Style
full =
  Full


{-| -}
empty : Float -> Style
empty =
  Empty


{-| -}
aura : Float -> Float -> Style
aura =
  Aura


{-| -}
detached : Float -> Style
detached =
  Detached



-- DEFAULTS / COLOR


toDefaultColor : Int -> String
toDefaultColor index =
  let numOfColors = Dict.size colors
      colorIndex = remainderBy numOfColors index
  in
  Dict.get colorIndex colors
    |> Maybe.withDefault blue


colors : Dict Int String
colors =
  [ blue, orange, green, pink, purple, red ]
    |> List.indexedMap Tuple.pair
    |> Dict.fromList


{-| -}
blue : String
blue =
  "rgb(5,142,218)"


{-| -}
orange : String
orange =
  "rgb(244, 149, 69)"


{-| -}
pink : String
pink =
  "rgb(253, 121, 168)"


{-| -}
green : String
green =
  "rgb(68, 201, 72)"


{-| -}
red : String
red =
  "rgb(215, 31, 10)"


{-| -}
purple : String
purple =
  "rgb(170, 80, 208)"



-- FORMATTING


{-| -}
formatTimestamp : Time.Zone -> Float -> String
formatTimestamp zone ts =
  formatFullTime zone (Time.millisToPosix (round ts))


formatTime : Time.Zone -> I.Time -> String
formatTime zone time =
    case Maybe.withDefault time.unit time.change of
        I.Millisecond ->
            formatClock zone time.timestamp

        I.Second ->
            formatClock zone time.timestamp

        I.Minute ->
            formatClock zone time.timestamp

        I.Hour ->
            formatClock zone time.timestamp

        I.Day ->
            if time.multiple == 7
            then formatWeekday zone time.timestamp
            else formatDate zone time.timestamp

        I.Month ->
            formatMonth zone time.timestamp

        I.Year ->
            formatYear zone time.timestamp


formatFullTime : Time.Zone -> Time.Posix -> String
formatFullTime =
    F.format
        [ F.monthNumber
        , F.text "/"
        , F.dayOfMonthNumber
        , F.text "/"
        , F.yearNumberLastTwo
        , F.text " "
        , F.hourMilitaryFixed
        , F.text ":"
        , F.minuteFixed
        ]


formatFullDate : Time.Zone -> Time.Posix -> String
formatFullDate =
    F.format
        [ F.monthNumber
        , F.text "/"
        , F.dayOfMonthNumber
        , F.text "/"
        , F.yearNumberLastTwo
        ]


formatDate : Time.Zone -> Time.Posix -> String
formatDate =
    F.format
        [ F.monthNumber
        , F.text "/"
        , F.dayOfMonthNumber
        ]


formatClock : Time.Zone -> Time.Posix -> String
formatClock =
    F.format
        [ F.hourMilitaryFixed
        , F.text ":"
        , F.minuteFixed
        ]


formatMonth : Time.Zone -> Time.Posix -> String
formatMonth =
    F.format
        [ F.monthNameAbbreviated
        ]


formatYear : Time.Zone -> Time.Posix -> String
formatYear =
    F.format
        [ F.yearNumber
        ]


formatWeekday : Time.Zone -> Time.Posix -> String
formatWeekday =
    F.format
        [ F.dayOfWeekNameFull ]





-- LABEL


type alias Label msg =
  { color : Maybe String
  , fontSize : Maybe Float
  , borderWidth : Float
  , borderColor : String
  , xOffset : Float
  , yOffset : Float
  , flipped : Bool
  , attributes : List (S.Attribute msg)
  }


label : value -> Attribute { a | label : Maybe value }
label value config =
  { config | label = Just value }


fontSize : value -> Attribute { a | fontSize : Maybe value }
fontSize value config =
  { config | fontSize = Just value }


borderWidth : value -> Attribute { a | borderWidth : value }
borderWidth value config =
  { config | borderWidth = value }


borderColor : value -> Attribute { a | borderColor : value }
borderColor value config =
  { config | borderColor = value }


xOffset : Float -> Attribute { a | xOffset : Float }
xOffset value config =
  { config | xOffset = config.xOffset + value }


yOffset : Float -> Attribute { a | yOffset : Float }
yOffset value config =
  { config | yOffset = config.yOffset + value }



-- TICK


type alias Tick msg =
  { color : Maybe String
  , width : Maybe Float
  , height : Float
  , attributes : List (S.Attribute msg)
  }


tick : value -> Attribute { a | tick : value }
tick value config =
  { config | tick = value }



-- VIEWS


xLabel : Label msg -> C.Plane -> String -> Float -> Float -> S.Svg msg
xLabel config plane value x y =
  let borderAttrs =
        if config.borderWidth == 0 then []
        else [ SA.strokeWidth (String.fromFloat config.borderWidth), SA.stroke config.borderColor ]

      colorAttrs =
        [ SA.fill (Maybe.withDefault "#808BAB" config.color) ]

      styleAttrs =
        [ SA.style <| "font-size: " ++ toFontSize ++ ";" ]

      toFontSize =
        case config.fontSize of
          Just size_ -> String.fromFloat size_ ++ "px"
          Nothing -> "inherit"
  in
  S.g
    [ C.position plane x y config.xOffset (config.yOffset * if config.flipped then -1 else 1)
    , SA.style "text-anchor: middle;"
    , SA.class "elm-charts__x-label"
    ]
    [ C.viewLabel (borderAttrs ++ colorAttrs ++ styleAttrs ++ config.attributes) value ]

