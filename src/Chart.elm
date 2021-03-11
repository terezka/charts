module Chart exposing
    ( chart, Element, series, scatter, linear, monotone, bars, histogram, bar, just
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
    , start, end, pinned, color, name, unit, rounded, roundBottom, margin, spacing
    , dot, dotted, area, noArrow, binLabel, topLabel, barColor, tickLength, tickWidth, center
    , filterX, filterY, only, attrs
    , blue, orange, pink, green, red
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
@docs dotted, color, name, unit, dot, area, attrs

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
color : String -> Attribute { a | color : String }
color value config =
  { config | color = value }


{-| -}
name : String -> Attribute { a | name : String }
name value config =
  { config | name = value }


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
dot : (data -> C.Dot msg) -> Attribute { a | dot : Maybe (data -> C.Dot msg) }
dot value config =
  { config | dot = Just value }


{-| -}
dotted : Attribute { a | dotted : Bool }
dotted config =
  { config | dotted = True }


{-| -}
area : String -> Attribute { a | area : Maybe String }
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

      toPrePlaneInfo els acc =
        case els of
          Element el :: rest -> toPrePlaneInfo rest (el.prePlane acc)
          [] -> acc

      prePlaneInfo =
        toPrePlaneInfo elements
          { x = Nothing
          , y = Nothing
          }

      calcRange =
        case config.range of
          Just edit -> edit (Maybe.withDefault { min = 0, max = 1 } prePlaneInfo.x)
          Nothing -> Maybe.withDefault { min = 0, max = 1 } prePlaneInfo.x

      calcDomain =
        case config.domain of
          Just edit -> edit (Maybe.withDefault { min = 0, max = 1 } prePlaneInfo.y)
          Nothing -> startMin 0 (Maybe.withDefault { min = 0, max = 1 } prePlaneInfo.y)

      scalePadX =
        C.scaleCartesian
          { marginLower = config.marginLeft
          , marginUpper = config.marginRight
          , length = max 1 (config.width - config.paddingLeft - config.paddingRight)
          , data = calcRange
          , min = calcRange.min
          , max = calcRange.max
          }

      toppedDomain =
        case config.topped of
          Just num ->
            let fs = I.floats (I.around num) calcDomain
                interval =
                  case fs of
                    first :: second :: _ -> second - first
                    _ -> 0
            in
            { calcDomain | max = calcDomain.max + interval }

          Nothing ->
            calcDomain

      scalePadY =
        C.scaleCartesian
          { marginUpper = config.marginTop
          , marginLower = config.marginBottom
          , length = max 1 (config.height - config.paddingBottom - config.paddingTop)
          , data = toppedDomain
          , min = toppedDomain.min
          , max = toppedDomain.max
          }

      plane = -- TODO use config / system directly instead
        { x =
            { marginLower = config.marginLeft
            , marginUpper = config.marginRight
            , length = config.width
            , data = calcRange
            , min = calcRange.min - scalePadX config.paddingLeft
            , max = calcRange.max + scalePadX config.paddingRight
            }
        , y =
            { marginUpper = config.marginTop
            , marginLower = config.marginBottom
            , length = config.height
            , data = toppedDomain
            , min = toppedDomain.min - scalePadY config.paddingBottom
            , max = toppedDomain.max + scalePadY config.paddingTop
            }
        }

      -- POST PLANE

      toPostPlaneInfo els acc isBeforeChart before svgs after =
        case els of
          Element el :: rest ->
            if el.isHtml then
              toPostPlaneInfo rest (el.postPlane plane acc) isBeforeChart
                (if isBeforeChart then before ++ [ el.view ] else before)
                svgs
                (if isBeforeChart then after else after ++ [ el.view ])

            else
              toPostPlaneInfo rest (el.postPlane plane acc)
                False before (svgs ++ [ el.view ]) after

          [] ->
            ( acc, ( before, svgs, after ) )

      ( info, ( hBefore, chartEls, hAfter ) ) =
        toPostPlaneInfo elements { xTicks = [], yTicks = [], collected = [] } True [] [] []

      svgContainer =
        S.svg (sizingAttrs ++ List.map toEvent config.events ++ config.attrs)

      sizingAttrs =
        if config.responsive
        then [ C.responsive plane ]
        else C.static plane

      toEvent e =
        let (Decoder func) = e.decoder in
        SE.on e.name <| C.decodePoint plane <| \pl po ->
          func info.collected pl po

      allSvgEls =
        [ C.frame config.id plane ] ++ (List.map applyInfo chartEls) ++ [ C.eventCatcher plane [] ]

      applyInfo v =
        v config.id plane info
  in
  C.container plane config.htmlAttrs <|
    List.map applyInfo hBefore ++ [ svgContainer allSvgEls ] ++ List.map applyInfo hAfter



type alias PrePlaneInfo =
  { x : Maybe Bounds
  , y : Maybe Bounds
  }


type alias PostPlaneInfo data =
  { xTicks : List Float
  , yTicks : List Float
  , collected : List (Item (Maybe Float) data)
  }


-- TODO
{-| -}
type Element data msg =
  Element
    { isHtml : Bool
    , prePlane : PrePlaneInfo -> PrePlaneInfo
    , postPlane : C.Plane -> PostPlaneInfo data -> PostPlaneInfo data
    , view : String -> C.Plane -> PostPlaneInfo data -> H.Html msg
    }



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
  { name : String
  , color : String
  , unit : String
  }


{-| -}
type alias Single value data =
  { datum : data
  , position : C.Point
  , values : { x : Float, y : value }
  , metric : Metric
  }


{-| -}
type alias Group value data =
  { datum : data
  , position : C.Point
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
          Just y -> Just (Single i.datum i.position { x = i.values.x, y = y } i.metric)
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
    , color : String -- TODO use Color
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
          , color = "rgb(210, 210, 210)"
          , arrow = True
          , attrs = []
          }
  in
  Element
    { isHtml = False
    , prePlane = identity
    , postPlane = always identity
    , view = \_ p _ ->
        S.g [ SA.class "elm-charts__x-axis" ]
          [ C.horizontal p ([ SA.stroke config.color ] ++ config.attrs) (config.pinned <| toBounds .y p) (config.start <| toBounds .x p) (config.end <| toBounds .x p)
          , if config.arrow then
              C.xArrow p config.color (config.end <| toBounds .x p) (config.pinned <| toBounds .y p) 0 0
            else
              S.text ""
          ]
    }


{-| -}
yAxis : List (Axis msg -> Axis msg) -> Element item msg
yAxis edits =
  let config =
        applyAttrs edits
          { start = .min
          , end = .max
          , pinned = zero
          , color = "rgb(210, 210, 210)"
          , arrow = True
          , attrs = []
          }
  in
  Element
    { isHtml = False
    , prePlane = identity
    , postPlane = always identity
    , view = \_ p _ ->
        S.g [ SA.class "elm-charts__y-axis" ]
          [ C.vertical p ([ SA.stroke config.color ] ++ config.attrs) (config.pinned <| toBounds .x p) (config.start <| toBounds .y p) (config.end <| toBounds .y p)
          , if config.arrow then
              C.yArrow p config.color (config.pinned <| toBounds .x p) (config.end <| toBounds .y p) 0 0
            else
              S.text ""
          ]
    }


type alias Tick tick msg =
    { color : String -- TODO use Color -- TODO allow custom color by tick value
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
xTicks : List (Tick tick msg -> Tick tick msg) -> Element item msg
xTicks edits =
  let config =
        applyAttrs edits
          { color = "rgb(210, 210, 210)"
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
        [ SA.stroke config.color
        , SA.strokeWidth (String.fromFloat config.width)
        ] ++ config.attrs
  in
  Element
    { isHtml = False
    , prePlane = identity
    , postPlane = \p ts -> { ts | xTicks = ts.xTicks ++ toTicks p }
    , view = \_ p _ -> C.xTicks p config.height tickAttrs (config.pinned <| toBounds .y p) (toTicks p)
    }


{-| -}
yTicks : List (Tick tick msg -> Tick tick msg) -> Element item msg
yTicks edits =
  let config =
        applyAttrs edits
          { color = "rgb(210, 210, 210)"
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
        [ SA.stroke config.color
        , SA.strokeWidth (String.fromFloat config.width)
        ] ++ config.attrs
  in
  Element
    { isHtml = False
    , prePlane = identity
    , postPlane = \p ts -> { ts | yTicks = ts.yTicks ++ toTicks p }
    , view = \_ p _ -> C.yTicks p config.height tickAttrs (config.pinned <| toBounds .x p) (toTicks p)
    }



type alias Label tick msg =
    { color : String -- TODO use Color
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
xLabels : List (Label tick msg -> Label tick msg) -> Element item msg
xLabels edits =
  let config =
        applyAttrs edits
          { color = "#808BAB"
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
        [ SA.fill config.color
        , SA.transform ("translate(" ++ String.fromFloat config.xOffset ++ " " ++ String.fromFloat config.yOffset ++ ")")
        ] ++ config.attrs
  in
  Element
    { isHtml = False
    , prePlane = identity
    , postPlane = \p ts -> { ts | xTicks = ts.xTicks ++ List.map .value (toTicks p) }
    , view = \_ p _ -> C.xLabels p (C.xLabel labelAttrs .value .label) (config.pinned <| toBounds .y p) (repositionIfCenter <| toTicks p)
    }


{-| -}
yLabels : List (Label tick msg -> Label tick msg) -> Element item msg
yLabels edits =
  let config =
        applyAttrs edits
          { color = "#808BAB"
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
        [ SA.fill config.color
        , SA.transform ("translate(" ++ String.fromFloat config.xOffset ++ " " ++ String.fromFloat config.yOffset ++ ")")
        ] ++ config.attrs
  in
  Element
    { isHtml = False
    , prePlane = identity
    , postPlane = \p ts -> { ts | yTicks = ts.yTicks ++ List.map .value (toTicks p) }
    , view = \_ p _ -> C.yLabels p (C.yLabel labelAttrs .value .label) (config.pinned <| toBounds .x p) (repositionIfCenter <| toTicks p)
    }



type alias Grid msg =
    { color : String -- TODO use Color
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
          { color = "#EFF2FA"
          , filterX = zero >> List.singleton
          , filterY = zero >> List.singleton
          , width = 1
          , attrs = []
          , dotted = False
          }

      gridAttrs =
        [ SA.stroke config.color
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
        else Just <| C.full config.width C.circle config.color p x y
  in
  Element
    { isHtml = False
    , prePlane = identity
    , postPlane = always identity
    , view = \_ p info ->
        S.g [ SA.class "elm-charts__grid" ] <|
          if config.dotted then
            List.concatMap (\x -> List.filterMap (toDot p x) info.yTicks) info.xTicks
          else
            [ S.g [ SA.class "elm-charts__x-grid" ] (List.filterMap (toXGrid p) info.xTicks)
            , S.g [ SA.class "elm-charts__y-grid" ] (List.filterMap (toYGrid p) info.yTicks)
            ]
    }




-- SERIES


type alias Bars data msg =
  { rounded : Float
  , roundBottom : Bool
  , attrs : List (S.Attribute msg)
  , margin : Float
  , spacing : Float
  , tickLength : Float
  , tickWidth : Float
  , binLabel : Maybe (data -> String)
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
          , binLabel = Nothing
          , tickLength = 0
          , tickWidth = 1
          , attrs = []
          }

      toBinLabel i d =
        case config.binLabel of
          Just func -> func d
          Nothing -> ""

      numOfBars =
        toFloat (List.length metrics)

      binMargin =
        config.margin * 2

      barSpacing =
        (numOfBars - 1) * config.spacing

      toBarColor m d =
        case m.color of
          Just func -> func d
          Nothing -> blue -- TODO nice default

      toBar p chartName i d (Bar value metric) =
        { attributes = [ SA.stroke "transparent", SA.fill (toBarColor metric d), clipPath chartName ] ++ config.attrs
        , label = metric.topLabel d
        , width = (1 - barSpacing - binMargin) / numOfBars
        , rounded = config.rounded
        , roundBottom = config.roundBottom
        , value = Maybe.withDefault (C.closestToZero p) (value d)
        }

      toBin p chartName i d =
        { label = toBinLabel i d
        , spacing = config.spacing
        , tickLength = config.tickLength
        , tickWidth = config.tickWidth
        , bars = List.map (toBar p chartName i d) metrics
        }

      -- CALC

      ys =
        List.map (\(Bar value _) -> value) metrics

      toGroupItem p i d =
        { datum = d
        , position = { x = toFloat i + 1, y = .max (fromData ys [d]) }
        , items =
            let barPoints = C.toBarPoints p (toDataPointBin p i d) in
            List.map2 (toBarItem d i) barPoints (List.reverse metrics)
        }

      toDataPointBin p i d =
        { label = ""
        , start = toFloat i + 0.5
        , end = toFloat i + 1.5
        , spacing = config.spacing
        , tickLength = 0
        , tickWidth = 0
        , bars = List.map (toBar p "" i d) metrics
        }

      toBarItem datum i point (Bar value m) =
        { datum = datum
        , metric =
            case m.color of
              Just toColor -> Metric m.name (toColor datum) m.unit
              Nothing -> Metric m.name blue m.unit
        , values = { x = toFloat i, y = value datum }
        , position = point
        }
  in
  Element
    { isHtml = False
    , prePlane = \info ->
        { info
          | x = stretch info.x { min = 0.5, max = toFloat (List.length data) + 0.5 }
          , y = stretch info.y (fromData ys data)
        }
    , postPlane = \p info ->
        { info | collected =
            data
              |> List.indexedMap (toGroupItem p)
              |> List.foldl (\g a -> a ++ [ItemGroup g]) info.collected
        }
    , view = \chartName p _ -> C.bars p (List.indexedMap (toBin p chartName) data)
    }



type alias Histogram data msg =
  { binWidth : Maybe (data -> Float)
  , rounded : Float
  , roundBottom : Bool
  , margin : Float
  , spacing : Float
  , binLabel : Maybe (data -> String)
  , tickLength : Float
  , tickWidth : Float
  , attrs : List (S.Attribute msg)
  }


{-| -}
histogram : (data -> Float) -> List (Histogram data msg -> Histogram data msg) -> List (Bar data msg) -> List data -> Element data msg
histogram toX edits metrics data =
  let config =
        applyAttrs edits
          { binWidth = Nothing
          , rounded = 0
          , roundBottom = False
          , spacing = 0.01
          , margin = 0.05
          , binLabel = Nothing
          , tickLength = 0
          , tickWidth = 1
          , attrs = []
          }

      numOfBars =
        toFloat (List.length metrics)

      barMargin =
        config.margin * 2

      barSpacing =
        (numOfBars - 1) * config.spacing

      toBinWidth p d maybePrev =
        case config.binWidth of
          Just toWidth -> toWidth d
          Nothing ->
            case maybePrev of
              Just prev -> toX d - toX prev
              Nothing -> toX d - p.x.min

      toBinLabel d =
        case config.binLabel of
          Just func -> func d
          Nothing -> ""

      toBarColor m d =
        case m.color of
          Just func -> func d
          Nothing -> blue

      toBar chartName p d (Bar value metric) =
        { attributes = [ SA.stroke "transparent", SA.fill (toBarColor metric d), clipPath chartName ] ++ config.attrs
        , label = metric.topLabel d
        , width = (1 - barSpacing - barMargin) / numOfBars
        , rounded = config.rounded
        , roundBottom = config.roundBottom
        , value = Maybe.withDefault (C.closestToZero p) (value d)
        }

      toBin chartName p maybePrev d =
        { label = toBinLabel d
        , start = toX d - toBinWidth p d maybePrev
        , end = toX d
        , spacing = config.spacing
        , tickLength = config.tickLength
        , tickWidth = config.tickWidth
        , bars = List.map (toBar chartName p d) metrics
        }

      -- CALC

      ys =
        List.map (\(Bar value _) -> value) metrics

      toXEnd d =
        case config.binWidth of
          Just w -> toX d - w d
          Nothing -> toX d - 1

      toGroupItem p maybePrev d =
        { datum = d
        , position =
            { x = toX d - (toBinWidth p d maybePrev) / 2
            , y = .max (fromData ys [d])
            }
        , items =
            let barPoints = C.toBarPoints p (toBin "" p maybePrev d) in
            List.map2 (toBarItem d) barPoints (List.reverse metrics)
        }

      toBarItem datum point (Bar value m) =
        { datum = datum
        , metric =
            case m.color of
              Just toColor -> Metric m.name (toColor datum) m.unit
              Nothing -> Metric m.name blue m.unit
        , values = { x = toX datum, y = value datum }
        , position = point
        }
  in
  Element
    { isHtml = False
    , prePlane = \info ->
        { info
        | x = stretch info.x (fromData [toX >> Just, toXEnd >> Just] data)
        , y = stretch info.y (fromData ys data)
        }
    , postPlane = \p info ->
        { info | collected =
            mapWithPrev (toGroupItem p) data
              |> List.foldl (\g a -> a ++ [ItemGroup g]) info.collected
        }
    , view = \chartName p _ -> C.histogram p (mapWithPrev (toBin chartName p) data)
    }



{-| -}
type Bar data msg =
  Bar (data -> Maybe Float) (BarConfig data msg)


type alias BarConfig data msg =
  { name : String
  , unit : String
  , color : Maybe (data -> String)
  , topLabel : data -> Maybe String
  , attrs : List (S.Attribute msg)
  }


{-| -}
bar : (data -> Maybe Float) -> List (BarConfig data msg -> BarConfig data msg) -> Bar data msg
bar toY edits =
  let config =
        applyAttrs edits
          { name = ""
          , unit = ""
          , color = Nothing
          , topLabel = \_ -> Nothing
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
  = Series (List data -> (data -> Float) -> String -> Element data msg)


{-| -}
series : (data -> Float) -> List (Series data msg) -> List data -> Element data msg
series toX series_ data =
  let timesOver =
        List.length series_ // List.length colors

      defaultColors =
        List.concat (List.repeat (timesOver + 1) colors)

      elements =
        List.map2 (\(Series s) -> s data toX) series_ defaultColors
  in
  Element
    { isHtml = False
    , prePlane = \info -> List.foldl (\(Element s) i -> s.prePlane i) info elements
    , postPlane = \p info -> List.foldl (\(Element s) i -> s.postPlane p i) info elements
    , view = \chartName p i ->
        S.g [ SA.class "elm-charts__series", clipPath chartName ]
            (List.map (\(Element s) -> s.view chartName p i) elements)
    }


type alias Scatter data msg =
    { color : String -- TODO use Color
    , name : String
    , unit : String
    , dot : Maybe (data -> C.Dot msg)
    }


{-| -}
scatter : (data -> Maybe Float) -> List (Scatter data msg -> Scatter data msg) -> Series data msg
scatter toY edits =
  Series <| \data toX defaultColor ->
    let config =
          applyAttrs edits
            { color = defaultColor
            , name = ""
            , unit = ""
            , dot = Nothing
            }

        finalDot =
           -- TODO use inheritance for color instead?
          case config.dot of
            Nothing -> always (C.disconnected 6 1 C.cross config.color)
            Just d -> d
    in
    Element
      { isHtml = False
      , prePlane = \info ->
          { info
          | x = stretch info.x (fromData [toX >> Just] data)
          , y = stretch info.y (fromData [toY] data)
          }
      , postPlane = \p info ->
          let metric = Metric config.name config.color config.unit in
          { info | collected = info.collected ++ List.map (toDotItem p metric toX toY) data }
      , view = \_ p _ ->
          S.g
            [ SA.class "elm-charts__scatter" ]
            [ C.scatter p toX toY finalDot data ]
      }


type alias Interpolation data msg =
    { area : Maybe String -- TODO use Color
    , width : Float
    , color : String -- TODO use Color
    , name : String
    , unit : String
    , dot : Maybe (data -> C.Dot msg)
    , attrs : List (S.Attribute msg)
    }


{-| -}
monotone : (data -> Maybe Float) -> List (Interpolation data msg -> Interpolation data msg) -> Series data msg
monotone toY edits =
  Series <| \data toX defaultColor ->
    let config =
          applyAttrs edits
            { color = defaultColor
            , area = Nothing
            , width = 1
            , dot = Nothing
            , name = ""
            , unit = ""
            , attrs = []
            }

        interAttrs =
          [ SA.stroke config.color
          , SA.strokeWidth (String.fromFloat config.width)
          ] ++ config.attrs

        finalDot =
          case config.dot of -- TODO use inheritance instead?
            Nothing -> always (C.disconnected 6 1 C.cross config.color)
            Just d -> d
    in
    Element
      { isHtml = False
      , prePlane = \info ->
          { info
          | x = stretch info.x (fromData [toX >> Just] data)
          , y = stretch info.y (fromData [toY] data)
          }
      , postPlane = \p info ->
          let metric = Metric config.name config.color config.unit in
          { info | collected = info.collected ++ List.map (toDotItem p metric toX toY) data }
      , view = \_ p _ ->
          case config.area of
            Just fill ->
              S.g [ SA.class "elm-charts__monotone-area" ]
                [ C.monotoneArea p toX toY (interAttrs ++ [ SA.stroke "transparent", SA.fill fill ]) finalDot data
                , C.monotone p toX toY interAttrs finalDot data
                ]

            Nothing ->
              S.g
                [ SA.class "elm-charts__monotone" ]
                [ C.monotone p toX toY interAttrs finalDot data ]
      }



{-| -}
linear : (data -> Maybe Float) -> List (Interpolation data msg -> Interpolation data msg) -> Series data msg
linear toY edits =
  Series <| \data toX defaultColor ->
    let config =
          applyAttrs edits
            { color = defaultColor
            , area = Nothing
            , width = 1
            , name = ""
            , unit = ""
            , dot = Nothing
            , attrs = []
            }

        interAttrs =
          [ SA.stroke config.color
          , SA.strokeWidth (String.fromFloat config.width)
          ] ++ config.attrs

        finalDot =
          case config.dot of
            Nothing -> always (C.disconnected 6 1 C.cross config.color)
            Just d -> d
    in
    Element
      { isHtml = False
      , prePlane = \info ->
          { info
          | x = stretch info.x (fromData [toX >> Just] data)
          , y = stretch info.y (fromData [toY] data)
          }
      , postPlane = \p info ->
          let metric = Metric config.name config.color config.unit in
          { info | collected = info.collected ++ List.map (toDotItem p metric toX toY) data }
      , view = \_ p _ ->
        case config.area of
          Just fill ->
            S.g [ SA.class "elm-charts__linear-area" ]
              [ C.linearArea p toX toY (interAttrs ++ [ SA.stroke "transparent", SA.fill fill ]) finalDot data
              , C.linear p toX toY interAttrs finalDot data
              ]

          Nothing ->
            S.g
              [ SA.class "elm-charts__linear" ]
              [ C.linear p toX toY interAttrs finalDot data ]
      }


toDotItem : C.Plane -> Metric -> (data -> Float) -> (data -> Maybe Float) -> data -> Item (Maybe Float) data
toDotItem p metric toX toY datum =
  ItemDot
    { datum = datum
    , position = { x = toX datum, y = Maybe.withDefault (C.closestToZero p) (toY datum) }
    , values = { x = toX datum, y = toY datum }
    , metric = metric
    }


{-| -}
svg : (C.Plane -> S.Svg msg) -> Element data msg
svg func =
  Element
    { isHtml = False
    , prePlane = identity
    , postPlane = always identity
    , view = \_ p _-> func p
    }


{-| -}
html : (C.Plane -> H.Html msg) -> Element data msg
html func =
  Element
    { isHtml = True
    , prePlane = identity
    , postPlane = always identity
    , view = \_ p _-> func p
    }


{-| -}
svgAt : (Bounds -> Float) -> (Bounds -> Float) -> Float -> Float -> List (S.Svg msg) -> Element data msg
svgAt toX toY xOff yOff view =
  Element
    { isHtml = False
    , prePlane = identity
    , postPlane = always identity
    , view = \_ p _ ->
        S.g [ C.position p (toX <| toBounds .x p) (toY <| toBounds .y p) xOff yOff ] view
    }


{-| -}
htmlAt : (Bounds -> Float) -> (Bounds -> Float) -> Float -> Float -> List (H.Attribute msg) -> List (H.Html msg) -> Element data msg
htmlAt toX toY xOff yOff att view =
  Element
    { isHtml = True
    , prePlane = identity
    , postPlane = always identity
    , view = \_ p _ ->
        C.positionHtml p (toX <| toBounds .x p) (toY <| toBounds .y p) xOff yOff att view
    }


{-| -}
none : Element data msg
none =
  Element
    { isHtml = True
    , prePlane = identity
    , postPlane = always identity
    , view = \_ _ _-> H.text ""
    }



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
clipPath chartName =
  SA.clipPath <| "url(#" ++ chartName ++ ")"


colors : List String
colors =
  [ blue, orange, green, pink, purple, red ]


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

