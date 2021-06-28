module Chart.Svg exposing
  ( Container, Event, container
  , Line, line
  , Tick, xTick, yTick
  , Label, label
  , Arrow, arrow
  , Bar, bar
  , Interpolation, interpolation, area
  , Dot, dot
  , Tooltip, tooltip
  , Rect, rect
  , decoder, getNearest, getNearestX, getWithin, getWithinX
  , isWithinPlane
  , position, positionHtml
  , Generator, generate, floats, ints, times
  , TickValue, toTickValues, formatTime

  , Legends, legendsAt
  , Legend, lineLegend, barLegend

  , Plane, Position, Point
  , fromSvg, fromCartesian
  , lengthInSvgX, lengthInSvgY
  , lengthInCartesianX, lengthInCartesianY
  )

import Html as H exposing (Html)
import Html.Attributes as HA
import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Svg.Events as SE
import Internal.Coordinates as Coord
import Internal.Commands as C exposing (..)
import Chart.Attributes as CA
import Internal.Interpolation as Interpolation
import Intervals as I
import Json.Decode as Json
import DOM
import Time
import DateFormat as F
import Dict exposing (Dict)
import Internal.Helpers as Helpers
import Internal.Svg



-- CONTAINER


{-| -}
type alias Container msg =
  { attrs : List (S.Attribute msg)
  , htmlAttrs : List (H.Attribute msg)
  , responsive : Bool
  , events : List (Event msg)
  }


{-| -}
type alias Event msg =
  { name : String
  , handler : Plane -> Point -> msg
  }


container : Plane -> List (CA.Attribute (Container msg)) -> List (Html msg) -> List (Svg msg) -> List (Html msg) -> Html msg
container plane edits =
  Internal.Svg.container plane (Helpers.apply edits Internal.Svg.defaultContainer)



-- TICK


{-| -}
type alias Tick =
  { color : String
  , width : Float
  , length : Float
  , attrs : List (S.Attribute Never)
  }


{-| -}
xTick : Plane -> List (CA.Attribute Tick) -> Point -> Svg msg
xTick plane edits =
  Internal.Svg.xTick plane (Helpers.apply edits Internal.Svg.defaultTick)


{-| -}
yTick : Plane -> List (CA.Attribute Tick) -> Point -> Svg msg
yTick plane edits =
  Internal.Svg.yTick plane (Helpers.apply edits Internal.Svg.defaultTick)


tick : Plane -> List (CA.Attribute Tick) -> Bool -> Point -> Svg msg
tick plane edits =
  Internal.Svg.tick plane (Helpers.apply edits Internal.Svg.defaultTick)



-- LINE


{-| -}
type alias Line =
  { x1 : Maybe Float
  , x2 : Maybe Float
  , y1 : Maybe Float
  , y2 : Maybe Float
  , xOff : Float
  , yOff : Float
  , color : String
  , width : Float
  , dashed : List Float
  , opacity : Float
  , break : Bool
  , attrs : List (S.Attribute Never)
  }


{-| -}
line : Plane -> List (CA.Attribute Line) -> Svg msg
line plane edits =
  Internal.Svg.line plane (Helpers.apply edits Internal.Svg.defaultLine)



{-| -}
type alias Rect =
  { x1 : Maybe Float
  , x2 : Maybe Float
  , y1 : Maybe Float
  , y2 : Maybe Float
  , color : String
  , border : String
  , borderWidth : Float
  , opacity : Float
  , attrs : List (S.Attribute Never)
  }


{-| -}
rect : Plane -> List (CA.Attribute Rect) -> Svg msg
rect plane edits =
  Internal.Svg.rect plane (Helpers.apply edits Internal.Svg.defaultRect)



-- LEGEND


type alias Legends msg =
  { alignment : CA.Alignment
  , anchor : Maybe CA.Anchor
  , spacing : Float
  , htmlAttrs : List (H.Attribute msg)
  }


legendsAt : Plane -> Float -> Float -> Float -> Float -> List (CA.Attribute (Legends msg)) -> List (Html msg) -> Html msg
legendsAt plane x y xOff yOff edits =
  Internal.Svg.legendsAt plane x y xOff yOff  (Helpers.apply edits Internal.Svg.defaultLegends)



type alias Legend msg =
  { xOff : Float
  , yOff : Float
  , width : Float
  , height : Float
  , fontSize : Maybe Int
  , color : String
  , spacing : Float
  , title : String
  , htmlAttrs : List (H.Attribute msg)
  }


barLegend : List (CA.Attribute (Legend msg)) -> List (CA.Attribute Bar) ->  Html msg
barLegend edits barAttrs =
  Internal.Svg.barLegend
    (Helpers.apply edits Internal.Svg.defaultBarLegend)
    (Helpers.apply barAttrs Internal.Svg.defaultBar)


lineLegend : List (CA.Attribute (Legend msg)) -> List (CA.Attribute Interpolation) -> List (CA.Attribute Dot) -> Html msg
lineLegend edits interAttrs dotAttrs =
  Internal.Svg.lineLegend
    (Helpers.apply edits Internal.Svg.defaultLineLegend)
    (Helpers.apply interAttrs Internal.Svg.defaultInterpolation)
    (Helpers.apply dotAttrs Internal.Svg.defaultDot)



-- LABEL


{-| -}
type alias Label =
  { xOff : Float
  , yOff : Float
  , border : String
  , borderWidth : Float
  , fontSize : Maybe Int
  , color : String
  , anchor : Maybe CA.Anchor
  , rotate : Float
  , attrs : List (S.Attribute Never)
  }


{-| -}
label : Plane -> List (CA.Attribute Label) -> List (Svg msg) -> Point -> Svg msg
label plane edits =
  Internal.Svg.label plane (Helpers.apply edits Internal.Svg.defaultLabel)



-- ARROW


{-| -}
type alias Arrow =
  { xOff : Float
  , yOff : Float
  , color : String
  , width : Float
  , length : Float
  , rotate : Float
  , attrs : List (S.Attribute Never)
  }


{-| -}
arrow : Plane -> List (CA.Attribute Arrow) -> Point -> Svg msg
arrow plane edits =
  Internal.Svg.arrow plane (Helpers.apply edits Internal.Svg.defaultArrow)



-- BAR


{-| -}
type alias Bar =
  { roundTop : Float
  , roundBottom : Float
  , color : String
  , border : String
  , borderWidth : Float
  , opacity : Float
  , design : Maybe CA.Design
  , attrs : List (S.Attribute Never)
  , highlight : Float
  , highlightWidth : Float
  }


{-| -}
bar : Plane -> List (CA.Attribute Bar) -> Position -> Svg msg
bar plane edits =
  Internal.Svg.bar plane (Helpers.apply edits Internal.Svg.defaultBar)



-- SERIES


{-| -}
type alias Interpolation =
  { method : Maybe CA.Method
  , color : String
  , width : Float
  , opacity : Float
  , design : Maybe CA.Design
  , dashed : List Float
  , attrs : List (S.Attribute Never)
  }


{-| -}
interpolation : Plane -> (data -> Float) -> (data -> Maybe Float) -> List (CA.Attribute Interpolation) -> List data -> Svg msg
interpolation plane toX toY edits =
  Internal.Svg.interpolation plane toX toY (Helpers.apply edits Internal.Svg.defaultInterpolation)


{-| -}
area : Plane -> (data -> Float) -> Maybe (data -> Maybe Float) -> (data -> Maybe Float) -> List (CA.Attribute Interpolation) -> List data -> Svg msg
area plane toX toY2M toY edits =
  Internal.Svg.area plane toX toY2M toY (Helpers.apply edits Internal.Svg.defaultArea)



-- DOTS


{-| -}
type alias Dot =
  { color : String
  , opacity : Float
  , size : Float
  , border : String
  , borderWidth : Float
  , highlight : Float
  , highlightWidth : Float
  , shape : Maybe CA.Shape
  }


{-| -}
dot : Plane -> (data -> Float) -> (data -> Float) -> List (CA.Attribute Dot) -> data -> Svg msg
dot plane toX toY edits =
  Internal.Svg.dot plane toX toY (Helpers.apply edits Internal.Svg.defaultDot)



-- TOOLTIP


{-| -}
type alias Tooltip =
  { direction : Maybe CA.Direction
  , focal : Maybe (Position -> Position)
  , height : Float
  , width : Float
  , offset : Float
  , arrow : Bool
  , border : String
  , background : String
  }


{-| -}
tooltip : Plane -> Position -> List (CA.Attribute Tooltip) -> List (H.Attribute Never) -> List (H.Html Never) -> H.Html msg
tooltip plane pos edits =
  Internal.Svg.tooltip plane pos (Helpers.apply edits Internal.Svg.defaultTooltip)


-- POSITIONING


{-| -}
position : Plane -> Float -> Float -> Float -> Float -> Float -> S.Attribute msg
position =
  Internal.Svg.position


{-| -}
positionHtml : Plane -> Float -> Float -> Float -> Float -> List (H.Attribute msg) -> List (H.Html msg) -> H.Html msg
positionHtml =
  Internal.Svg.positionHtml



-- EVENTS


{-| -}
getNearest : (a -> Position) -> List a -> Plane -> Point -> List a
getNearest =
  Internal.Svg.getNearest


{-| -}
getWithin : Float -> (a -> Position) -> List a -> Plane -> Point -> List a
getWithin =
  Internal.Svg.getWithin


{-| -}
getNearestX : (a -> Position) -> List a -> Plane -> Point -> List a
getNearestX =
  Internal.Svg.getNearestX


{-| -}
getWithinX : Float -> (a -> Position) -> List a -> Plane -> Point -> List a
getWithinX =
  Internal.Svg.getWithinX


{-| -}
decoder : Plane -> (Plane -> Point -> msg) -> Json.Decoder msg
decoder =
  Internal.Svg.decoder


{-| -}
isWithinPlane : Plane -> Float -> Float -> Bool
isWithinPlane =
  Internal.Svg.isWithinPlane



-- INTERVALS


type alias Generator a
  = Internal.Svg.Generator a


floats : Generator Float
floats =
  Internal.Svg.floats


ints : Generator Int
ints =
  Internal.Svg.ints


times : Time.Zone -> Generator I.Time
times =
  Internal.Svg.times


generate : Int -> Generator a -> Coord.Axis -> List a
generate =
  Internal.Svg.generate


type alias TickValue =
  { value : Float
  , label : String
  }


toTickValues : (a -> Float) -> (a -> String) -> List a -> List TickValue
toTickValues =
  Internal.Svg.toTickValues



-- FORMATTING


formatTime : Time.Zone -> I.Time -> String
formatTime =
  Internal.Svg.formatTime



-- SYSTEM


type alias Plane =
  Coord.Plane


type alias Point =
  { x : Float
  , y : Float
  }


type alias Position =
  { x1 : Float
  , x2 : Float
  , y1 : Float
  , y2 : Float
  }


fromSvg : Plane -> Point -> Point
fromSvg =
  Internal.Svg.fromSvg


fromCartesian : Plane -> Point -> Point
fromCartesian =
  Internal.Svg.fromCartesian


lengthInSvgX : Plane -> Float -> Float
lengthInSvgX =
  Internal.Svg.lengthInSvgX


lengthInSvgY : Plane -> Float -> Float
lengthInSvgY =
  Internal.Svg.lengthInSvgY


lengthInCartesianX : Plane -> Float -> Float
lengthInCartesianX =
  Internal.Svg.lengthInCartesianX


lengthInCartesianY : Plane -> Float -> Float
lengthInCartesianY =
  Internal.Svg.lengthInCartesianY
