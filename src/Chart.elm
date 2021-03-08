module Chart exposing
    ( chart, Element, series, scatter, linear, monotone, bars, histogram, bar
    , Bounds, startMin, startMax, endMin, endMax, startPad, endPad, zero, middle
    , xAxis, yAxis, xTicks, yTicks, xLabels, yLabels, grid
    , ints, times, format, ticks, amount
    , Event, event, Decoder, map, map2, map3, getPoint, getNearest, getNearestX, getWithin, getWithinX, tooltip, formatTimestamp
    , svgAt, htmlAt, svg, html, none
    , width, height
    , marginTop, marginBottom, marginLeft, marginRight
    , paddingTop, paddingBottom, paddingLeft, paddingRight
    , static, id
    , range, domain, topped, events, htmlAttrs, binWidth
    , start, end, pinned, color, rounded, roundBottom, margin, spacing
    , dot, dotted, area, noArrow, binLabel, barLabel, tickLength, tickWidth, center
    , filterX, filterY, only, attrs
    , blue, orange, pink, green, red
    )


{-| Make a chart! Documentation is still unfinished!

# Elements
@docs chart, Element
@docs series, scatter, linear, monotone
@docs bars, histogram, bar

## Work with bounds
@docs Bounds, startMin, startMax, endMin, endMax, startPad, endPad, zero, middle

# Axis
@docs xAxis, yAxis, xTicks, yTicks, xLabels, yLabels, grid
@docs amount, ints, times, ticks, format, noArrow, start, end, pinned, only, filterX, filterY

# Events
@docs Event, event, Decoder, map, map2, map3, getPoint, getNearest, getNearestX, getWithin, getWithinX, tooltip, formatTimestamp

# Attributes
@docs width, height
@docs marginTop, marginBottom, marginLeft, marginRight
@docs paddingTop, paddingBottom, paddingLeft, paddingRight
@docs center
@docs range, domain, topped, static, id, events, htmlAttrs
@docs binWidth, binLabel, barLabel, tickLength, tickWidth, margin, spacing, rounded, roundBottom
@docs dotted, color, dot, area, attrs

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
times : Time.Zone -> Attribute { a | produce : Maybe (Int -> Bounds -> List I.Time), value : I.Time -> Float, format : I.Time -> String }
times zone config =
  { config | produce = Just <| I.times zone, value = .timestamp >> Time.posixToMillis >> toFloat, format = formatTime zone }


{-| -}
ints : Attribute { a | produce : Maybe (Int -> Bounds -> List Int), value : Int -> Float, format : Int -> String }
ints config =
  { config | produce = Just <| \i -> I.ints (I.around i), value = toFloat, format = String.fromInt }


{-| -}
ticks : (Int -> Bounds -> List tick) -> (tick -> Float) -> (tick -> String) -> Attribute { a | produce : Maybe (Int -> Bounds -> List tick), value : tick -> Float, format : tick -> String }
ticks produce value format_ config =
  { config | produce = Just produce, value = value, format = format_ }


{-| -}
format : (tick -> String) -> Attribute { a | format : tick -> String }
format value config =
  { config | format = value }


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
barLabel : (data -> Maybe String) -> Attribute { a | barLabel : Maybe (data -> Maybe String) }
barLabel value config =
  { config | barLabel = Just value }


{-| -}
binWidth : (data -> Float) -> Attribute { a | binWidth : Maybe (data -> Float) }
binWidth value config =
  { config | binWidth = Just value }


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
        toPostPlaneInfo elements { xTicks = [], yTicks = [], points = [] } True [] [] []

      svgContainer =
        S.svg (sizingAttrs ++ List.map toEvent config.events ++ config.attrs)

      sizingAttrs =
        if config.responsive
        then [ C.responsive plane ]
        else C.static plane

      toEvent e =
        let (Decoder func) = e.msg in
        SE.on e.name (C.decodePoint plane (func info.points))

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
  , points : List (C.DataPoint data)
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
fromData : List (data -> Float) -> List data -> Bounds
fromData values data =
  { min = C.minimum values data
  , max = C.maximum values data
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
  , msg : Decoder data msg
  }


{-| -}
event : String -> Decoder data msg -> Event data msg
event =
  Event


{-| -}
type Decoder data msg
  = Decoder (List (C.DataPoint data) -> C.Plane -> C.Point -> msg)


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
getPoint : Decoder data C.Point
getPoint =
  Decoder <| \_ plane point ->
    let searched =
          { x = C.toCartesianX plane point.x
          , y = C.toCartesianY plane point.y
          }
    in
    searched


{-| -}
getNearest : Decoder data (Maybe data)
getNearest =
  Decoder <| \points plane point ->
    C.getNearest points plane point


{-| -}
getWithin : Float -> Decoder data (Maybe data)
getWithin radius =
  Decoder <| \points plane point ->
    C.getWithin radius points plane point


{-| -}
getNearestX : Decoder data (List data)
getNearestX =
  Decoder <| \points plane point ->
    C.getNearestX points plane point


{-| -}
getWithinX : Float -> Decoder data (List data)
getWithinX radius =
  Decoder <| \points plane point ->
    C.getWithinX radius points plane point


{-| -}
tooltip : (Bounds -> Float) -> (Bounds -> Float) -> List (H.Attribute msg) -> List (H.Html msg) -> Element data msg
tooltip toX toY att content =
  html <| \p -> C.tooltip p (toX <| toBounds .x p) (toY <| toBounds .y p) att content



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
xAxis : List (Axis msg -> Axis msg) -> Element data msg
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
yAxis : List (Axis msg -> Axis msg) -> Element data msg
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
    , attrs : List (S.Attribute msg)
    , amount : Int
    , produce : Maybe (Int -> Bounds -> List tick)
    , value : tick -> Float
    , format : tick -> String
    }


{-| -}
xTicks : List (Tick tick msg -> Tick tick msg) -> Element data msg
xTicks edits =
  let config =
        applyAttrs edits
          { color = "rgb(210, 210, 210)"
          , start = .min
          , end = .max
          , pinned = zero
          , amount = 5
          , only = \_ -> True
          , produce = Nothing
          , value = \_ -> 0
          , format = \_ -> ""
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
          case config.produce of
            Just produce -> List.map config.value (produce config.amount <| xBounds p)
            Nothing -> I.floats (I.around config.amount) <| xBounds p

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
yTicks : List (Tick tick msg -> Tick tick msg) -> Element data msg
yTicks edits =
  let config =
        applyAttrs edits
          { color = "rgb(210, 210, 210)"
          , start = .min
          , end = .max
          , pinned = zero
          , only = \_ -> True
          , amount = 5
          , produce = Nothing
          , value = \_ -> 0
          , format = \_ -> ""
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
          case config.produce of
            Just produce -> List.map config.value (produce config.amount <| yBounds p)
            Nothing -> (I.floats (I.around config.amount) <| yBounds p)

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
    , produce : Maybe (Int -> Bounds -> List tick)
    , value : tick -> Float
    , format : tick -> String
    , center : Bool
    , attrs : List (S.Attribute msg)
    }


type alias Pair =
  { value : Float
  , label : String
  }


{-| -}
xLabels : List (Label tick msg -> Label tick msg) -> Element data msg
xLabels edits =
  let config =
        applyAttrs edits
          { color = "#808BAB"
          , start = .min
          , end = .max
          , only = \_ -> True
          , pinned = zero
          , amount = 5
          , produce = Nothing
          , value = \_ -> 0
          , format = \_ -> ""
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
          case config.produce of
            Just produce -> List.map (\i -> Pair (config.value i) (config.format i)) (produce config.amount <| xBounds p)
            Nothing -> List.map (\i -> Pair i (String.fromFloat i)) (I.floats (I.around config.amount) <| xBounds p)

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
yLabels : List (Label tick msg -> Label tick msg) -> Element data msg
yLabels edits =
  let config =
        applyAttrs edits
          { color = "#808BAB"
          , start = .min
          , end = .max
          , pinned = zero
          , only = \_ -> True
          , amount = 5 -- TODO
          , produce = Nothing
          , value = \_ -> 0
          , format = \_ -> ""
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
          case config.produce of
            Just produce ->
              List.map (\i -> { value = config.value i, label = config.format i }) (produce config.amount <| yBounds p)

            Nothing ->
              List.map (\i -> { value = i, label = String.fromFloat i }) (I.floats (I.around config.amount) <| yBounds p)

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
grid : List (Grid msg -> Grid msg) -> Element data msg
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

      toBarLabel i m d =
        case m.label of
          Just func -> func d
          Nothing -> Nothing

      numOfBars =
        toFloat (List.length metrics)

      binMargin =
        config.margin * 2

      barSpacing =
        (numOfBars - 1) * config.spacing

      toBar name i d (Bar value metric) =
        { attributes = [ SA.stroke "transparent", SA.fill metric.color, clipPath name ] ++ config.attrs
        , label = toBarLabel i metric d
        , width = (1 - barSpacing - binMargin) / numOfBars
        , rounded = config.rounded
        , roundBottom = config.roundBottom
        , value = value d
        }

      toBin name i d =
        { label = toBinLabel i d
        , spacing = config.spacing
        , tickLength = config.tickLength
        , tickWidth = config.tickWidth
        , bars = List.map (toBar name i d) metrics
        }

      -- CALC

      ys =
        List.map (\(Bar value _) -> value) metrics

      toYs d =
        List.map (\y -> y d) ys

      toDataPoints i d =
        List.map (toDataPoint i d) (toYs d)

      toDataPoint i d v =
        C.DataPoint d { x = toFloat (i + 1), y = v }
  in
  Element
    { isHtml = False
    , prePlane = \info ->
        let length = toFloat (List.length data) in
        { info
        | x = stretch info.x { min = 0.5, max = length + 0.5 }
        , y = stretch info.y (fromData ys data)
        }
    , postPlane = \p info -> { info | points = info.points ++ List.concat (List.indexedMap toDataPoints data) }
    , view = \name p _ -> C.bars p (List.indexedMap (toBin name) data)
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

      toBarLabel m d =
        case m.label of
          Just func -> func d
          Nothing -> Nothing

      toBar name d (Bar value metric) =
        { attributes = [ SA.stroke "transparent", SA.fill metric.color, clipPath name ] ++ config.attrs
        , label = toBarLabel metric d
        , width = (1 - barSpacing - barMargin) / numOfBars
        , rounded = config.rounded
        , roundBottom = config.roundBottom
        , value = value d
        }

      toBin name p maybePrev d =
        { label = toBinLabel d
        , start = toX d - toBinWidth p d maybePrev
        , end = toX d
        , spacing = config.spacing
        , tickLength = config.tickLength
        , tickWidth = config.tickWidth
        , bars = List.map (toBar name d) metrics
        }

      -- CALC

      ys =
        List.map (\(Bar value _) -> value) metrics

      toYs d =
        List.map (\y -> y d) ys

      toXEnd d =
        case config.binWidth of
          Just w -> toX d - w d
          Nothing -> toX d - 1

      toDataPoints p maybePrev d =
        let bw = toBinWidth p d maybePrev in
        List.map (toDataPoint bw d) (toYs d)

      toDataPoint bw d v =
        C.DataPoint d { x = toX d - bw / 2, y = v }
  in
  Element
    { isHtml = False
    , prePlane = \info ->
        { info
        | x = stretch info.x (fromData [toX, toXEnd] data)
        , y = stretch info.y (fromData ys data)
        }
    , postPlane = \p info -> { info | points = info.points ++ List.concat (mapWithPrev (toDataPoints p) data) }
    , view = \name p _ -> C.histogram p (mapWithPrev (toBin name p) data)
    }



{-| -}
type Bar data msg =
  Bar (data -> Float) (BarConfig data msg)


type alias BarConfig data msg =
  { attrs : List (S.Attribute msg)
  , color : String
  , label : Maybe (data -> Maybe String)
  }


{-| -}
bar : (data -> Float) -> List (BarConfig data msg -> BarConfig data msg) -> Bar data msg
bar toY edits =
  let config =
        applyAttrs edits
          { label = Nothing
          , color = blue -- TODO
          , attrs = []
          }
  in
  Bar toY config




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
    , view = \name p i ->
        S.g [ SA.class "elm-charts__series", clipPath name ]
            (List.map (\(Element s) -> s.view name p i) elements)
    }




type alias Scatter data msg =
    { color : String -- TODO use Color
    , dot : Maybe (data -> C.Dot msg)
    }


{-| -}
scatter : (data -> Float) -> List (Scatter data msg -> Scatter data msg) -> Series data msg
scatter toY edits =
  Series <| \data toX defaultColor ->
    let config =
          applyAttrs edits
            { color = defaultColor
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
          | x = stretch info.x (fromData [toX] data)
          , y = stretch info.y (fromData [toY] data)
          }
      , postPlane = \p info -> { info | points = info.points ++ C.toDataPoints toX toY data }
      , view = \name p _ ->
          S.g
            [ SA.class "elm-charts__scatter" ]
            [ C.scatter p toX toY finalDot data ]
      }


type alias Interpolation data msg =
    { color : String -- TODO use Color
    , area : Maybe String -- TODO use Color
    , width : Float
    , dot : Maybe (data -> C.Dot msg)
    , attrs : List (S.Attribute msg)
    }


{-| -}
monotone : (data -> Float) -> List (Interpolation data msg -> Interpolation data msg) -> Series data msg
monotone toY edits =
  Series <| \data toX defaultColor ->
    let config =
          applyAttrs edits
            { color = defaultColor
            , area = Nothing
            , width = 1
            , dot = Nothing
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
          | x = stretch info.x (fromData [toX] data)
          , y = stretch info.y (fromData [toY] data)
          }
      , postPlane = \p info -> { info | points = info.points ++ C.toDataPoints toX toY data }
      , view = \name p _ ->
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
linear : (data -> Float) -> List (Interpolation data msg -> Interpolation data msg) -> Series data msg
linear toY edits =
  Series <| \data toX defaultColor ->
    let config =
          applyAttrs edits
            { color = defaultColor
            , area = Nothing
            , width = 1
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
          | x = stretch info.x (fromData [toX] data)
          , y = stretch info.y (fromData [toY] data)
          }
      , postPlane = \p info -> { info | points = info.points ++ C.toDataPoints toX toY data }
      , view = \name p _ ->
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
clipPath name =
  SA.clipPath <| "url(#" ++ name ++ ")"


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
