module Svg.Chart
  exposing
    ( responsive, static, frame
    , Dot, clear, empty, disconnected, aura, full, opaque
    , Shape, circle, triangle, square, diamond, plus, cross
    , scatter, linear, monotone
    , xAxis, yAxis, xArrow, yArrow
    , xGrid, yGrid
    , xTicks, xTick, yTicks, yTick
    , xLabels, yLabels, xLabel, yLabel
    , line, horizontal, vertical
    , position, positionHtml

    , eventCatcher, container, decodePoint
    , Point, toPoints, DataPoint
    , getNearest, getNearestX, getWithin, getWithinX
    , tooltip, tooltipOnTop, isXPastMiddle, middleOfY, middleOfX, closestToZero

    , viewLabel
    , Item, Items, Metric, toGroupItems, toBinItems, Bar, BarVisuals
    , histogram, bars
    )


{-| This module contains low-level SVG plotting elements.

# Series

## Sizing
@docs static, responsive, frame

## Dots
@docs Dot, clear, empty, disconnected, aura, full
@docs circle, triangle, square, diamond, plus, cross

## Interpolation
@docs scatter, linear, linearArea, monotone, monotoneArea

# Bar charts
@docs Group, bars, Bin, Bar, histogram, toBarPoints

# Straight lines
@docs line, xAxis, yAxis, xArrow, yArrow, xGrid, yGrid, horizontal, vertical

## Ticks
ProTip: Passing a negative value as the height/width of a tick renders it
mirrored on the other side of the axis!

@docs xTick, xTicks, yTick, yTicks

## Labels

@docs xLabel, xLabels, yLabel, yLabels


## Positioning anything
@docs position, positionHtml


# Events

@docs container, eventCatcher

@docs decodePoint, Point, toPoints, DataPoint

@docs getNearest, getNearestX, getWithin, getWithinX

@docs tooltip, tooltipOnTop, isXPastMiddle, middleOfY, middleOfX, closestToZero


-}

import Html exposing (Html)
import Html.Attributes as HA
import Svg exposing (Svg, Attribute, g, path, rect, text)
import Svg.Attributes as Attributes exposing (class, width, height, stroke, fill, fillOpacity, d, transform, viewBox)
import Svg.Coordinates as Coords exposing (Plane, place, toSVGX, toSVGY, toCartesianX, toCartesianY, scaleSVG, scaleCartesian, placeWithOffset)
import Svg.Commands exposing (..)
import Internal.Colors exposing (..)
import Internal.Svg exposing (..)
import Json.Decode as Json
import DOM
import Dict exposing (Dict)


{-| Set the size of your chart.
-}
static : Plane -> List (Attribute msg)
static plane =
  [ width (String.fromFloat plane.x.length)
  , height (String.fromFloat plane.y.length)
  ]


{-| Set the dimensions of your chart, but let it respond to size changes in parent.
-}
responsive : Plane -> Attribute msg
responsive plane =
  viewBox ("0 0 " ++ String.fromFloat plane.x.length ++ " " ++ String.fromFloat plane.y.length)


{-| Create an id to use in a clip path to prevent elements from going into your margins.

    svg []
      [ frame "some-id" plane
      , g [ clipPath "url(#some-id)" ] [ stuffThatShouldntGoIntoTheMargin ]
      ]
-}
frame : String -> Plane -> Svg.Svg msg
frame id plane =
  Svg.defs []
    [ Svg.clipPath
        [ Attributes.id id ]
        [ Svg.rect (areaAttributes plane) []
        ]
    ]



-- ITEMS


{-| -}
type alias Item value data =
  { datum : data
  , center : { x : Float, y : Float }
  , position : { x1 : Float, x2 : Float, y : Float }
  , values : { x1 : Float, x2 : Float, y : value }
  , metric : Metric
  }


{-| -}
type alias Items value data =
  { datum : data
  , center : { x : Float, y : Float }
  , position : { x1 : Float, x2 : Float, y : Float }
  , items : List (Item value data)
  }


{-| -}
type alias Metric =
  { label : String
  , color : String
  , unit : String
  }


{-| -}
type alias Space =
  { between : Float
  , margin : Float
  }


{-| -}
type alias Bar data =
  { value : data -> Maybe Float
  , name : Maybe String
  , unit : String
  , color : Maybe (data -> String)
  }


toGroupItems : Space -> List (Bar data) -> List data -> List (Items (Maybe Float) data)
toGroupItems space bars_ data =
  let amountOfBars =
        toFloat (List.length bars_)

      barWidth =
        (1 - space.margin * 2 - (amountOfBars - 1) * space.between) / amountOfBars

      toBarItem binIndex datum barIndex bar =
        let x1 = toFloat binIndex + 0.5 + space.margin + toFloat barIndex * barWidth + toFloat barIndex * space.between
        in
        { datum = datum
        , center =
            { x = x1 + barWidth / 2
            , y = Maybe.withDefault 0 (bar.value datum) -- TODO
            }
        , position =
            { x1 = x1
            , x2 = x1 + barWidth
            , y = Maybe.withDefault 0 (bar.value datum)
            }
        , values =
            { x1 = toFloat binIndex
            , x2 = toFloat binIndex
            , y = bar.value datum
            }
        , metric =
            { label = Maybe.withDefault "" bar.name
            , unit = bar.unit
            , color =
                case bar.color of
                  Just c -> c datum
                  Nothing -> toDefaultColor barIndex
            }
        }

      toGroupItem binIndex datum =
        let toYs = List.map .value bars_ in
        { datum = datum
        , center =
            { x = toFloat binIndex
            , y = Coords.maximum toYs [datum]
            }
        , position =
            { x1 = toFloat binIndex + 0.5
            , x2 = toFloat binIndex + 1.5
            , y = Coords.maximum toYs [datum]
            }
        , items = List.indexedMap (toBarItem binIndex datum) bars_
        }
  in
  List.indexedMap toGroupItem data


toBinItems : Space -> Maybe (data -> Float) -> (data -> Float) -> List (Bar data) -> List data -> List (Items (Maybe Float) data)
toBinItems space toX0Maybe toX1 bars_ data =
  let toLength prevMaybe datum nextMaybe =
        case toX0Maybe of
          Just toX0 -> toX1 datum - toX0 datum
          Nothing ->
            case ( prevMaybe, nextMaybe ) of
              ( Just prev, _ ) -> toX1 datum - toX1 prev
              ( Nothing, Just next ) -> toX1 next - toX1 datum
              ( Nothing, Nothing ) -> 1 -- toX1 datum -- TODO use axis.min

      toBarItem length datum barIndex bar  =
        let margin_ = length * space.margin
            amountOfBars = toFloat (List.length bars_)
            width_ = (length - margin_ * 2 - (amountOfBars - 1) * space.between) / amountOfBars
            x1 = toX1 datum - length + margin_ + toFloat barIndex * width_ + toFloat barIndex * space.between
        in
        { datum = datum
        , center =
            { x = x1 + width_ / 2
            , y = Maybe.withDefault 0 (bar.value datum)
            }
        , position =
            { x1 = x1
            , x2 = x1 + width_
            , y = Maybe.withDefault 0 (bar.value datum) -- TODO perhaps leave as Maybe?
            }
        , values =
            { x1 = toX1 datum
            , x2 = toX1 datum
            , y = bar.value datum
            }
        , metric =
            { label = Maybe.withDefault "" bar.name
            , unit = bar.unit
            , color =
                case bar.color of
                  Just c -> c datum
                  Nothing -> toDefaultColor barIndex
            }
        }

      toBinItem prevMaybe datum nextMaybe =
        let length = toLength prevMaybe datum nextMaybe
            toYs = List.map .value bars_
        in
        { datum = datum
        , center =
            { x = toX1 datum - length / 2
            , y = Coords.maximum toYs [datum]
            }
        , position =
            { x1 = toX1 datum - length
            , x2 = toX1 datum
            , y = Coords.maximum toYs [datum]
            }
        , items = List.indexedMap (toBarItem length datum) bars_
        }
  in
  mapSurrounding toBinItem data


mapSurrounding : (Maybe a -> a -> Maybe a -> b) -> List a -> List b
mapSurrounding =
  let fold prev acc func ds =
        case ds of
          a :: b :: rest -> fold (Just a) (func prev a (Just b) :: acc) func (b :: rest)
          a :: rest -> fold (Just a) (func prev a Nothing :: acc) func rest
          [] -> acc
  in
  fold Nothing []



-- BARS


type alias BarVisuals data msg =
  { round : Float
  , roundBottom : Bool
  , attrs : Int -> data -> List (Attribute msg)
  }


{-| -}
bars : Plane -> BarVisuals data msg -> List (Items (Maybe Float) data) -> Svg msg
bars plane visuals groups =
  g [ class "elm-charts__bars" ] (List.map (viewBin plane visuals) groups)


{-| -}
histogram : Plane -> BarVisuals data msg -> List (Items (Maybe Float) data) -> Svg msg
histogram plane visuals bins =
  g [ class "elm-charts__histogram" ] (List.map (viewBin plane visuals) bins)


viewBin : Plane -> BarVisuals data msg -> Items (Maybe Float) data -> Svg msg
viewBin plane visuals bin =
  g [ class "elm-charts__bin" ] (List.indexedMap (viewBar plane visuals) bin.items)


viewBar : Plane -> BarVisuals data msg -> Int -> Item (Maybe Float) data -> Svg msg
viewBar plane visuals barIndex item =
  let x = item.position.x1
      y = item.position.y
      w = item.position.x2 - item.position.x1
      bs = closestToZero plane
      b = scaleSVG plane.x w * 0.5 * (clamp 0 1 visuals.round)
      ys = abs (scaleSVG plane.y y)
      rx = scaleCartesian plane.x b
      ry = scaleCartesian plane.y b
      roundBottom = visuals.roundBottom

      commands =
        if bs == y then
          []
        else if b == 0 || ys < b then
          commandsNoRound
        else
          if y < 0 then
            if roundBottom then
              commandsRoundBoth False (ry * -1)
            else
              commandsRoundTop False ry
          else
            if roundBottom then
              commandsRoundBoth True ry
            else
              commandsRoundTop True (ry * -1)

      commandsNoRound =
        [ Move x bs
        , Line x y
        , Line (x + w) y
        , Line (x + w) bs
        ]

      commandsRoundBoth outwards ry_ =
        [ Move (x + rx) bs
        , Arc b b -45 False outwards x (bs + ry_)
        , Line x (y - ry_)
        , Arc b b -45 False outwards (x + rx) y
        , Line (x + w - rx) y
        , Arc b b -45 False outwards (x + w) (y - ry_)
        , Line (x + w) (bs + ry_)
        , Arc b b -45 False outwards (x + w - rx) bs
        ]

      commandsRoundTop outwards ry_ =
        [ Move x bs
        , Line x (y + ry_)
        , Arc b b -45 False outwards (x + rx) y
        , Line (x + w - rx) y
        , Arc b b -45 False outwards (x + w) (y + ry_)
        , Line (x + w) bs
        ]

      commandsRoundBottom outwards ry_ =
        [ Move (x + rx) bs
        , Arc b b -45 False outwards x (bs + ry_)
        , Line x y
        , Line (x + w) y
        , Line (x + w) (bs + ry_)
        , Arc b b -45 False outwards (x + w - rx) bs
        ]

      attributes =
        concat
          [ fill item.metric.color
          , class "elm-charts__bar"
          ]
          (visuals.attrs barIndex item.datum)
          [ d (description plane commands) ]
  in
  path attributes []



-- STRAIGHT LINES


{-| Renders a line.

    myLine : Svg msg
    myLine =
      line plane [ stroke "pink" ] x0 y0 x1 y1
-}
line : Plane -> List (Attribute msg) -> Float -> Float -> Float -> Float -> Svg msg
line plane userAttributes x1 y1 x2 y2 =
  let
    attributes =
      concat
        [ stroke "rgb(210, 210, 210)" ]
        userAttributes
        [ d (description plane [ Move x1 y1, Line x1 y1, Line x2 y2 ]) ]
  in
    path attributes []


{-| Renders a horizontal line.

    myLine : Svg msg
    myLine =
      horizontal plane [ stroke "pink" ] y x0 x1

-}
horizontal : Plane -> List (Attribute msg) -> Float -> Float -> Float -> Svg msg
horizontal plane userAttributes y x1 x2 =
  let
    attributes =
      concat
        [ stroke "rgb(210, 210, 210)" ]
        userAttributes
        [ d (description plane [ Move x1 y, Line x1 y, Line x2 y ]) ]
  in
    path attributes []


{-| Renders a vertical line.

    myLine : Svg msg
    myLine =
      vertical plane [ stroke "pink" ] x y0 y1

-}
vertical : Plane -> List (Attribute msg) -> Float -> Float -> Float -> Svg msg
vertical plane userAttributes x y1 y2 =
  let
    attributes =
      concat
        [ stroke "rgb(210, 210, 210)" ]
        userAttributes
        [ d (description plane [ Move x y1, Line x y1, Line x y2 ]) ]
  in
    path attributes []


{-| Renders a horizontal line with the full length of the range.

    myXAxisOrGridLine : Svg msg
    myXAxisOrGridLine =
      xAxis plane [] yPosition
-}
xAxis : Plane -> List (Attribute msg) -> Float -> Svg msg
xAxis plane userAttributes y =
  horizontal plane userAttributes y plane.x.min plane.x.max


{-| Renders a horizontal line with the full length of the range.
-}
xGrid : Plane -> List (Attribute msg) -> Float -> Svg msg
xGrid plane attrs =
  xAxis plane (stroke "#EFF2FA" :: attrs)


{-| Renders a vertical line with the full length of the domain.

    myYAxisOrGridLine : Svg msg
    myYAxisOrGridLine =
      yAxis plane [] xPosition
-}
yAxis : Plane -> List (Attribute msg) -> Float -> Svg msg
yAxis plane userAttributes x =
  vertical plane userAttributes x plane.y.min plane.y.max


{-| Renders a horizontal line with the full length of the domain.
-}
yGrid : Plane -> List (Attribute msg) -> Float -> Svg msg
yGrid plane attrs =
  yAxis plane (stroke "#EFF2FA" :: attrs)


{-| Renders ticks for the horizontal axis.

    horizontalTicks : Svg msg
    horizontalTicks =
      xTicks plane height [ stroke "pink" ] axisYCoordinate tickPositions
-}
xTicks : Plane -> Float -> List (Attribute msg) -> Float -> List Float -> Svg msg
xTicks plane height userAttributes y xs =
  g [ class "elm-charts__x-ticks" ] (List.map (xTick plane height userAttributes y) xs)


{-| Renders a single tick for the horizontal axis.
-}
xTick : Plane -> Float -> List (Attribute msg) -> Float -> Float -> Svg msg
xTick plane height userAttributes y x =
  let
    attributes =
      concat
        [ class "elm-charts__tick", stroke "rgb(210, 210, 210)" ]
        userAttributes
        [ Attributes.x1 <| String.fromFloat (toSVGX plane x)
        , Attributes.x2 <| String.fromFloat (toSVGX plane x)
        , Attributes.y1 <| String.fromFloat (toSVGY plane y)
        , Attributes.y2 <| String.fromFloat (toSVGY plane y + height)
        ]
  in
    Svg.line attributes []


{-| Renders ticks for the vertical axis.

    verticalTicks : Svg msg
    verticalTicks =
      yTicks plane width [ stroke "pink" ] axisXCoordinate tickPositions
-}
yTicks : Plane -> Float -> List (Attribute msg) -> Float -> List Float -> Svg msg
yTicks plane width userAttributes x ys =
  g [ class "elm-charts__y-ticks" ] (List.map (yTick plane width userAttributes x) ys)


{-| Renders a single tick for the vertical axis.
-}
yTick : Plane -> Float -> List (Attribute msg) -> Float -> Float -> Svg msg
yTick plane width userAttributes x y =
  let
    attributes =
      concat
        [ class "elm-charts__tick", stroke "rgb(210, 210, 210)" ]
        userAttributes
        [ Attributes.x1 <| String.fromFloat (toSVGX plane x)
        , Attributes.x2 <| String.fromFloat (toSVGX plane x - width)
        , Attributes.y1 <| String.fromFloat (toSVGY plane y)
        , Attributes.y2 <| String.fromFloat (toSVGY plane y)
        ]
  in
    Svg.line attributes []


{-| Renders labels for the horizontal axis.

    horizontalLabels : Svg msg
    horizontalLabels =
      xLabels plane (xLabel "blue" .timestamp format) axisYCoordinate data
-}
xLabels : Plane -> (Plane -> Float -> data -> Svg msg) -> (data -> Float) -> List data -> Svg msg
xLabels plane toLabel toY ds =
  g [ class "elm-charts__x-labels" ] (List.map (\d -> toLabel plane (toY d) d) ds)


{-| Renders a label for the horizontal axis.

    horizontalLabel : Svg msg
    horizontalLabel =
      xLabel "blue" .timestamp format plane y datum
-}
xLabel : List (Attribute msg) -> (data -> Float) -> (data -> String) -> Plane -> Float -> data -> Svg msg
xLabel attrs toX toString plane y datum =
  Svg.g
    [ placeWithOffset plane (toX datum) y 0 20
    , Attributes.style "text-anchor: middle;"
    ]
    [ viewLabel attrs (toString datum) ]


{-| Renders labels for the vertical axis.

    verticalLabels : Svg msg
    verticalLabels =
      yLabels plane (yLabel "blue" .age format) axisXCoordinate data
-}
yLabels : Plane -> (Plane -> Float -> data -> Svg msg) -> (data -> Float) -> List data -> Svg msg
yLabels plane toLabel toX ds =
  g [ class "elm-charts__y-labels" ] (List.map (\d -> toLabel plane (toX d) d) ds)


{-| Renders a label for the vertical axis.

    verticalLabel : Svg msg
    verticalLabel =
      yLabel "blue" .age format plane x y
-}
yLabel : List (Attribute msg) -> (data -> Float) -> (data -> String) -> Plane -> Float -> data -> Svg msg
yLabel attrs toY toString plane x datum =
  Svg.g
    [ placeWithOffset plane x (toY datum) -10 4
    , Attributes.style "text-anchor: end;"
    ]
    [ viewLabel attrs (toString datum) ]


viewLabel : List (Attribute msg) -> String -> Svg msg
viewLabel userAttributes string =
  let attributes =
        concat
          [ class "elm-charts__label"
          , Attributes.stroke "white"
          , Attributes.strokeWidth "0.2"
          , Attributes.fill "#808BAB"
          , Attributes.style "pointer-events: none;"
          ]
          userAttributes
          []
  in
  Svg.text_ attributes
    [ Svg.tspan [] [ Svg.text string ] ]


viewXLabel : Plane -> List (Attribute msg) -> String -> Float -> Float -> Float -> Float -> Svg msg
viewXLabel plane userAttributes string x y xOff yOff =
  Svg.g
    [ placeWithOffset plane x y xOff yOff
    , Attributes.style "text-anchor: middle;"
    ]
    [ viewLabel [] string ]


{-| Place an arrow pointing to the right somewhere.

      xArrow plane color x y xOff yOff

-}
xArrow : Plane -> String -> Float -> Float -> Float -> Float -> Svg msg
xArrow plane color x y xOff yOff =
    g [ position plane x y xOff yOff ]
      [ Svg.polygon
          [ fill color
          , Attributes.points "0,0 50,0 25.0,43.3"
          , transform "translate(6 0) scale(0.15) rotate(150)"
          ]
          []
      ]


{-| Place an arrow pointing up somewhere.

      yArrow plane color x y xOff yOff

-}
yArrow : Plane -> String -> Float -> Float -> Float -> Float -> Svg msg
yArrow plane color x y xOff yOff =
    g [ position plane x y xOff yOff ]
      [ Svg.polygon
          [ fill color
          , Attributes.points "0,0 50,0 25.0,43.3"
          , transform "translate(0 -6) scale(0.15) rotate(60)"
          ]
          []
      ]



-- SERIES


{-| -}
type alias Dot msg =
  (Plane -> Float -> Float -> Svg msg)


{-| A dot without visual representation.
-}
clear : Dot msg
clear _ _ _ =
  Svg.text ""


{-| Make a regular shape.

    someDot : Svg msg
    someDot =
      full radius circle "blue" plane x y
-}
full : Float -> Shape -> String -> Dot msg
full radius shape color =
  viewShape radius Full shape color


{-| Make a shape with a little translucent border.

    someDot : Svg msg
    someDot =
      aura radius width opacity circle "blue" plane x y
-}
aura : Float -> Float -> Float -> Shape -> String -> Dot msg
aura radius width opacity shape color =
  viewShape radius (Aura width opacity) shape color



{-| Make a shape with a little translucent middle.

    someDot : Svg msg
    someDot =
      aura radius width borderWidth opacity circle "blue" plane x y
-}
opaque : Float -> Float -> Float -> Shape -> String -> Dot msg
opaque radius width opacity shape color =
  viewShape radius (Opaque width opacity) shape color


{-| Make a shape with a white border.

    someDot : Svg msg
    someDot =
      disconnected radius width circle "blue" plane x y
-}
disconnected : Float -> Float -> Shape -> String -> Dot msg
disconnected radius width shape color =
  viewShape radius (Disconnected width) shape color


{-| Make a shape with a white core.

    someDot : Svg msg
    someDot =
      empty radius width circle "blue" plane x y
-}
empty : Float -> Float -> Shape -> String -> Dot msg
empty radius width shape color =
  viewShape radius (Empty width) shape color


{-| -}
type alias Shape =
  Internal.Svg.Shape


{-| -}
circle : Shape
circle =
  Circle


{-| -}
triangle : Shape
triangle =
  Triangle


{-| -}
square : Shape
square =
  Square


{-| -}
diamond : Shape
diamond =
  Diamond


{-| -}
plus : Shape
plus =
  Plus


{-| -}
cross : Shape
cross =
  Cross


{-| Series with no interpolation.

    someScatter : Svg msg
    someScatter =
      scatter plane .x .y (full 6 circle "blue") points
-}
scatter : Plane -> (data -> Float) -> (data -> Maybe Float) -> (data -> Dot msg) -> List data -> Svg msg
scatter plane toX toY dot data =
  viewSeries plane toX toY dot data (text "-- No interpolation --")


{-| Series with linear interpolation.
-}
linear : Plane -> (data -> Float) -> (data -> Maybe Float) -> List (Attribute msg) -> Maybe Float -> (data -> Dot msg) -> List data -> Svg msg
linear plane toX toY attributes areaMaybe dot data =
  let points = toPoints toX toY data in
  viewSeries plane toX toY dot data <|
    viewInterpolations plane areaMaybe attributes points (linearInterpolation points)


{-| Series with monotone interpolation.
-}
monotone : Plane -> (data -> Float) -> (data -> Maybe Float) -> List (Attribute msg) -> Maybe Float -> (data -> Dot msg) -> List data -> Svg msg
monotone plane toX toY attributes areaMaybe dot data =
  let points = toPoints toX toY data in
  viewSeries plane toX toY dot data <|
    viewInterpolations plane areaMaybe attributes points (monotoneInterpolation points)



-- INTERNAL


viewSeries : Plane -> (data -> Float) -> (data -> Maybe Float) -> (data -> Dot msg) -> List data -> Svg msg -> Svg msg
viewSeries plane toX toY dot data interpolation =
  let viewDot datum =
        case toY datum of
          Just y -> Just (dot datum plane (toX datum) y)
          Nothing -> Nothing
  in
  g [ class "elm-charts__serie" ]
    [ interpolation
    , g [ class "elm-charts__dots" ] (List.filterMap viewDot data)
    ]


viewInterpolations : Plane -> Maybe Float -> List (Attribute msg) -> List (List Point) -> List (List Command) -> Svg msg
viewInterpolations plane areaMaybe userAttributes points commands =
  g [ class "elm-charts__interpolations" ] <| List.concat <|
    List.map2 (\ps cs -> viewInterpolation plane areaMaybe userAttributes ps cs) points commands


viewInterpolation : Plane -> Maybe Float -> List (Attribute msg) -> List Point -> List Command -> List (Svg msg)
viewInterpolation plane areaMaybe userAttributes points commands =
  case ( points, areaMaybe ) of
    ( [], _ ) ->
      [ text "-- No data --" ]

    ( first :: rest, Nothing ) ->
      [ viewLine plane userAttributes commands first rest ]

    ( first :: rest, Just opacity ) ->
      [ viewArea plane (userAttributes ++ [ stroke "transparent", fillOpacity (String.fromFloat opacity) ]) commands first rest
      , viewLine plane (userAttributes ++ [ fill "transparent" ]) commands first rest
      ]


viewLine : Plane -> List (Attribute msg) -> List Command -> Point -> List Point -> Svg msg
viewLine plane userAttributes interpolation first rest =
  let
    commands =
      concat [ Move first.x first.y ] interpolation []

    attributes =
      concat
        [ class "elm-charts__line", stroke pinkStroke ]
        userAttributes
        [ d (description plane commands), fill transparent ]
  in
  path attributes []


viewArea : Plane -> List (Attribute msg) -> List Command -> Point -> List Point -> Svg msg
viewArea plane userAttributes interpolation first rest =
  let
    commands =
      concat
        [ Move first.x (closestToZero plane), Line first.x first.y ]
        interpolation
        [ Line (Maybe.withDefault first (last rest) |> .x) (closestToZero plane) ]

    attributes =
      concat
        [ class "elm-charts__area", stroke pinkStroke ]
        userAttributes
        [ d (description plane commands) ]
  in
    path attributes []



-- LINEAR INTERPOLATION


linearInterpolation : List (List Point) -> List (List Command)
linearInterpolation =
  List.map (List.map (\{ x, y } -> Line x y))



-- MONOTONE INTERPOLATION


monotoneInterpolation : List (List Point) -> List (List Command)
monotoneInterpolation sections =
  List.foldr monotoneSection ( First, [] ) sections
    |> Tuple.second


monotoneSection : List Point -> ( Tangent, List (List Command) ) -> ( Tangent, List (List Command) )
monotoneSection points ( tangent, acc ) =
  let
    ( t0, commands ) =
      case points of
        p0 :: rest ->
          monotonePart (p0 :: rest) ( tangent, [ Line p0.x p0.y ] )

        [] ->
          ( tangent, [] )
  in
  ( t0, commands :: acc )


type Tangent
  = First
  | Previous Float


monotonePart : List Point -> ( Tangent, List Command ) -> ( Tangent, List Command )
monotonePart points ( tangent, commands ) =
  case ( tangent, points ) of
    ( First, p0 :: p1 :: p2 :: rest ) ->
      let t1 = slope3 p0 p1 p2
          t0 = slope2 p0 p1 t1
      in
      ( Previous t1
      , commands ++ [ monotoneCurve p0 p1 t0 t1 ]
      )
      |> monotonePart (p1 :: p2 :: rest)

    ( Previous t0, p0 :: p1 :: p2 :: rest ) ->
      let t1 = slope3 p0 p1 p2 in
      ( Previous t1
      , commands ++ [ monotoneCurve p0 p1 t0 t1 ]
      )
      |> monotonePart (p1 :: p2 :: rest)

    ( First, [ p0, p1 ] ) ->
      let t1 = slope3 p0 p1 p1 in
      ( Previous t1
      , commands ++ [ monotoneCurve p0 p1 t1 t1, Line p1.x p1.y ]
      )

    ( Previous t0, [ p0, p1 ] ) ->
      let t1 = slope3 p0 p1 p1 in
      ( Previous t1
      , commands ++ [ monotoneCurve p0 p1 t0 t1, Line p1.x p1.y ]
      )

    ( _, _ ) ->
      ( tangent
      , commands
      )


monotoneCurve : Point -> Point -> Float -> Float -> Command
monotoneCurve point0 point1 tangent0 tangent1 =
  let
    dx =
      (point1.x - point0.x) / 3
  in
  CubicBeziers
      (point0.x + dx)
      (point0.y + dx * tangent0)
      (point1.x - dx)
      (point1.y - dx * tangent1)
      point1.x
      point1.y


{-| Calculate the slopes of the tangents (Hermite-type interpolation) based on
 the following paper: Steffen, M. 1990. A Simple Method for Monotonic
 Interpolation in One Dimension
-}
slope3 : Point -> Point -> Point -> Float
slope3 point0 point1 point2 =
  let
    h0 = point1.x - point0.x
    h1 = point2.x - point1.x
    s0h = toH h0 h1
    s1h = toH h1 h0
    s0 = (point1.y - point0.y) / s0h
    s1 = (point2.y - point1.y) / s1h
    p = (s0 * h1 + s1 * h0) / (h0 + h1)
    slope = (sign s0 + sign s1) * (min (min (abs s0) (abs s1)) (0.5 * abs p))
  in
    if isNaN slope then 0 else slope


toH : Float -> Float -> Float
toH h0 h1 =
  if h0 == 0
    then if h1 < 0 then 0 * -1 else h1
    else h0


{-| Calculate a one-sided slope.
-}
slope2 : Point -> Point -> Float -> Float
slope2 point0 point1 t =
  let h = point1.x - point0.x in
    if h /= 0
      then (3 * (point1.y - point0.y) / h - t) / 2
      else t


sign : Float -> Float
sign x =
  if x < 0
    then -1
    else 1



-- HELPERS


last : List a -> Maybe a
last list =
  List.head (List.drop (List.length list - 1) list)


concat : List a -> List a -> List a -> List a
concat first second third =
  first ++ second ++ third


{-| -}
closestToZero : Plane -> Float
closestToZero plane =
  clamp plane.y.min plane.y.max 0



{-| Place some SVG on specific coordinates.

-}
position : Plane -> Float -> Float -> Float -> Float -> Svg.Attribute msg
position plane x y xOff yOff =
  transform <| "translate(" ++ String.fromFloat (toSVGX plane x + xOff) ++ "," ++ String.fromFloat (toSVGY plane y + yOff) ++ ")"



-- EVENTS


{-| -}
eventCatcher : Plane -> List (Svg.Attribute msg) -> Svg msg
eventCatcher plane events =
  Svg.rect
    (areaAttributes plane ++ events)
    []


{-| Container for your chart, in case you use the `eventCatcher`.
Without this, your coordinates from the events will be wrong!

-}
container : Plane -> List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
container plane attrs =
  Html.div <|
    [ HA.style "position" "relative"
    ] ++ attrs



{-| -}
type alias Point =
  { x : Float
  , y : Float
  }


{-| -}
toPoints : (data -> Float) -> (data -> Maybe Float) -> List data -> List (List Point)
toPoints toX toY =
  let fold d acc =
        case toY d of
          Just y ->
            case acc of
              latest :: rest -> (latest ++ [{ x = toX d, y = y }]) :: rest
              [] -> ([{ x = toX d, y = y }] :: acc)

          Nothing ->
            [] :: acc
  in
  List.foldl fold [] >> List.reverse


{-| -}
type alias DataPoint item =
  { item | center : Point }



{-| Get the data coordinates nearest to the event.
Returns `Nothing` if you have no data showing.

-}
getNearest : (info -> List (DataPoint item)) -> info -> Plane -> Point -> List (DataPoint item)
getNearest toItems info plane searchedSvg =
  let searched =
        { x = toCartesianX plane searchedSvg.x
        , y = toCartesianY plane searchedSvg.y
        }
  in
  getNearestHelp (toItems info) plane searched


{-| Get the data coordinates nearest of the event within the radius
you provide in the first argument.

-}
getWithin : Float -> (info -> List (DataPoint item)) -> info -> Plane -> Point -> List (DataPoint item)
getWithin radius toItems info plane searchedSvg =
    let
      searched =
        { x = toCartesianX plane searchedSvg.x
        , y = toCartesianY plane searchedSvg.y
        }

      keepIfEligible closest =
        withinRadius plane radius searched closest.center
    in
    getNearestHelp (toItems info) plane searched
      |> List.filter keepIfEligible


{-| Get the data coordinates horizontally nearest to the event.
-}
getNearestX : (info -> List (DataPoint item)) -> info ->  Plane -> Point -> List (DataPoint item)
getNearestX toItems info plane searchedSvg =
    let
      searched =
        { x = toCartesianX plane searchedSvg.x
        , y = toCartesianY plane searchedSvg.y
        }
    in
    getNearestXHelp (toItems info) plane searched


{-| Finds the data coordinates horizontally nearest to the event, within the
distance you provide in the first argument.

-}
getWithinX : Float -> (info -> List (DataPoint item)) -> info -> Plane -> Point -> List (DataPoint item)
getWithinX radius toItems info plane searchedSvg =
    let
      searched =
        { x = toCartesianX plane searchedSvg.x
        , y = toCartesianY plane searchedSvg.y
        }

      keepIfEligible =
          withinRadiusX plane radius searched << .center
    in
    getNearestXHelp (toItems info) plane searched
      |> List.filter keepIfEligible



-- COORDINATE HELPERS


getNearestHelp : List (DataPoint item) -> Plane -> Point -> List (DataPoint item)
getNearestHelp points plane searched =
  let
      distance_ =
          distance plane searched

      getClosest point allClosest =
        case List.head allClosest of
          Just closest ->
            if closest.center == point.center then point :: allClosest
            else if distance_ closest.center > distance_ point.center then [ point ]
            else allClosest

          Nothing ->
            [ point ]
  in
  List.foldl getClosest [] points


getNearestXHelp : List (DataPoint item) -> Plane -> Point -> List (DataPoint item)
getNearestXHelp points plane searched =
  let
      distanceX_ =
          distanceX plane searched

      getClosest point allClosest =
        case List.head allClosest of
          Just closest ->
              if closest.center.x == point.center.x then point :: allClosest
              else if distanceX_ closest.center > distanceX_ point.center then [ point ]
              else allClosest

          Nothing ->
            [ point ]
  in
  List.foldl getClosest [] points


distanceX : Plane -> Point -> Point -> Float
distanceX plane searched dot =
    abs <| toSVGX plane dot.x - toSVGX plane searched.x


distanceY : Plane -> Point -> Point -> Float
distanceY plane searched dot =
    abs <| toSVGY plane dot.y - toSVGY plane searched.y


distance : Plane -> Point -> Point -> Float
distance plane searched dot =
    sqrt <| distanceX plane searched dot ^ 2 + distanceY plane searched dot ^ 2


withinRadius : Plane -> Float -> Point -> Point -> Bool
withinRadius plane radius searched dot =
    distance plane searched dot <= radius


withinRadiusX : Plane -> Float -> Point -> Point -> Bool
withinRadiusX plane radius searched dot =
    distanceX plane searched dot <= radius



-- DECODER


{-| Decode position of mouse when tracking events. The `Plane` may
change due to size changes of the viewport, so make sure to use the
one given in the second argument. Also, make sure to wrap your chart
in `container` otherwise your read coordinates maybe wrong!

-}
decodePoint : Plane -> (Plane -> Point -> msg) -> Json.Decoder msg
decodePoint ({x, y} as plane) toMsg =
  let
    handle mouseX mouseY { left, top, height, width } =
      let
        widthPercent = width / plane.x.length
        heightPercent = height / plane.y.length

        newPlane =
          { x =
              { x | length = width
              , marginLower = plane.x.marginLower * widthPercent
              , marginUpper = plane.x.marginUpper * widthPercent
              }
          , y =
              { y | length = height
              , marginLower = plane.y.marginLower * heightPercent
              , marginUpper = plane.y.marginUpper * heightPercent
              }
          }
      in
      toMsg newPlane { x = mouseX - left, y = mouseY - top }
  in
  Json.map3 handle
    (Json.field "pageX" Json.float)
    (Json.field "pageY" Json.float)
    (DOM.target decodePosition)


decodePosition : Json.Decoder DOM.Rectangle
decodePosition =
  Json.oneOf
    [ DOM.boundingClientRect
    , Json.lazy (\_ -> DOM.parentElement decodePosition)
    ]



-- SHOW TOOLTIP


{-| A basic tooltip.

      tooltip plane x y
        [ style "font-size" "14px" ]
        [ Html.text "I'm a tooltip!" ]
-}
tooltip : Plane -> Float -> Float -> List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
tooltip plane x y attrs =
    let
        xOff = if isXPastMiddle plane x then -15 else 15
    in
    positionHtml plane x y xOff 0 <|
      [ if isXPastMiddle plane x
          then HA.style "transform" "translate(-100%, -50%)"
          else HA.style "transform" "translate(0, -50%)"
      , HA.style "padding" "5px 10px"
      , HA.style "background" "rgba(255, 255, 255, 0.8)"
      , HA.style "border" "1px solid #EFF2FA"
      , HA.style "border-radius" "3px"
      , HA.style "pointer-events" "none"
      ] ++ attrs


{-| -}
tooltipOnTop : Plane -> Float -> Float -> List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
tooltipOnTop plane x y attrs content =
  let stylesheet =
        """
        .elm-charts__tooltip:before, .elm-charts__tooltip:after {
          content: "";
          position: absolute;
          border-left: 5px solid transparent;
          border-right: 5px solid transparent;
          top: 100%;
          left: 50%;
          margin-left: -5px;
        }

        .elm-charts__tooltip:after{
          border-top: 5px solid white;
          margin-top: -1px;
          z-index: 1;
        }

        .elm-charts__tooltip:before {
          border-top: 5px solid #D8D8D8;
        }

        """

      attributes =
        [ HA.class "elm-charts__tooltip"
        , HA.style "transform" "translate(-50%, -100%)"
        , HA.style "padding" "5px 10px"
        , HA.style "background" "white"
        , HA.style "border" "1px solid #D8D8D8"
        , HA.style "border-radius" "3px"
        , HA.style "pointer-events" "none"
        ] ++ attrs

      children =
        Html.node "style" [] [ Html.text stylesheet ] :: content
  in
    positionHtml plane x y 0 -10 attributes children


{-| Place some Html on specific coordinates. You must wrap your chart
in `container` for it to work! Remember also to put your html elements outside
your `svg` element, otherwise they won't work!

      positionHtml plane x y xOff yOff
        [ style "font-size" "14px" ]
        [ text "Hello!" ]

-}
positionHtml : Plane -> Float -> Float -> Float -> Float -> List (Html.Attribute msg) -> List (Html msg) -> Html msg
positionHtml plane x y xOff yOff attrs content =
    let
        xPercentage = (toSVGX plane x + xOff) * 100 / plane.x.length
        yPercentage = (toSVGY plane y + yOff) * 100 / plane.y.length

        posititonStyles =
            [ HA.style "left" (String.fromFloat xPercentage ++ "%")
            , HA.style "top" (String.fromFloat yPercentage ++ "%")
            , HA.style "margin-right" "-400px"
            , HA.style "position" "absolute"
            ]
    in
    Html.div (posititonStyles ++ attrs) content


{-| Is x past the middle of the chart?

-}
isXPastMiddle : Plane -> Float -> Bool
isXPastMiddle plane x =
    x - plane.x.min > plane.x.max - x


{-| Get the midmost y coordinate.

-}
middleOfY : Plane -> Float
middleOfY plane =
    plane.y.min + (plane.y.max - plane.y.min) / 2


{-| Get the midmost x coordinate.

-}
middleOfX : Plane -> Float
middleOfX plane =
    plane.x.min + (plane.x.max - plane.x.min) / 2




-- HELPERS


areaAttributes : Plane -> List (Svg.Attribute msg)
areaAttributes plane =
  [ Attributes.x (String.fromFloat plane.x.marginLower)
  , Attributes.y (String.fromFloat plane.y.marginUpper)
  , Attributes.width (String.fromFloat (plane.x.length - plane.x.marginLower - plane.x.marginUpper))
  , Attributes.height (String.fromFloat (plane.y.length - plane.y.marginLower - plane.y.marginUpper))
  , Attributes.fill "transparent"
  ]


{-| -}
withFirst : List a -> (a -> List a -> b) -> Maybe b
withFirst stuff process =
  case stuff of
    first :: rest ->
      Just (process first rest)

    _ ->
      Nothing



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

