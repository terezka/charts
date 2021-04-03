module Svg.Chart
  exposing
    ( responsive, static, frame
    , Dot, Variety
    , Shape, circle, triangle, square, diamond, plus, cross
    , linear, monotone
    , xAxis, yAxis, xArrow, yArrow
    , xGrid, yGrid
    , xTicks, xTick, yTicks, yTick
    , xLabels, yLabels, xLabel, yLabel
    , line, horizontal, vertical
    , position, positionHtml

    , eventCatcher, container, decodePoint
    , Point, toBreaks, DataPoint
    , getNearest, getNearestX, getWithin, getWithinX
    , tooltip, tooltipOnTop, isXPastMiddle, middleOfY, middleOfX, closestToZero

    , viewLabel
    , Item, Items, toBarItems, Bar, BarVisuals, toSeriesItems
    , bars, toBins, Bin

    , dots, area, interpolation, Interpolation, BarDetails, DotDetails
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

@docs decodePoint, Point, toBreaks, DataPoint

@docs getNearest, getNearestX, getWithin, getWithinX

@docs tooltip, tooltipOnTop, isXPastMiddle, middleOfY, middleOfX, closestToZero


-}

import Html exposing (Html)
import Html.Attributes as HA
import Svg exposing (Svg, Attribute, g, path, rect, text)
import Svg.Attributes as Attributes exposing (class, width, height, stroke, fill, fillOpacity, d, transform, viewBox)
import Svg.Coordinates as Coords exposing (Plane, place, toSVGX, toSVGY, toCartesianX, toCartesianY, scaleSVG, scaleCartesian, placeWithOffset)
import Svg.Commands exposing (..)
import Internal.Interpolation as Interpolation exposing (Interpolation)
import Internal.Colors exposing (..)
import Internal.Svg exposing (..)
import Internal.Property as Property exposing (Property)
import Internal.Default as D
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
type alias Item value details data =
  { datum : data
  , center : { x : Float, y : Float }
  , position : { x1 : Float, x2 : Float, y1 : Float, y2 : Float }
  , values : { x1 : Float, x2 : Float, y : value }
  , details : details
  }


{-| -}
type alias Items value details data =
  { datum : data
  , center : { x : Float, y : Float }
  , position : { x1 : Float, x2 : Float, y1 : Float, y2 : Float }
  , items : List (List (Item value details data))
  }


{-| -}
type alias DotDetails =
  { name : String
  , unit : String
  , color : String
  , dot : Dot
  }


{-| -}
type alias BarDetails =
  { name : String
  , unit : String
  , color : String
  -- TODO pattern
  }



-- SERIES


{-| -}
type alias Series =
  { interpolation : Maybe Interpolation
  , area : Maybe Float -- TODO use Color
  , color : Maybe String -- TODO use Color
  , dot : Maybe Dot
  , size : D.Constant Float
  , name : D.Constant String
  , unit : D.Constant String
  }


toSeriesItems : (data -> Float) -> List (Property data Series) -> List data -> Plane -> List (List (Item (Maybe Float) DotDetails data))
toSeriesItems toX properties data plane =
  let toConfig p d =
        D.apply (p.attrs ++ p.extra d)
          { interpolation = Nothing
          , area = Nothing
          , color = Nothing
          , dot = Nothing
          , size = D.Default 6
          , name = D.Default ""
          , unit = D.Default ""
          }

      toDot index config =
        case config.dot of
          Nothing -> Standard (D.value config.size) (toDefaultShape index) Full
          Just d -> d

      toRadius_ index config =
        case config.dot of
          Nothing -> toRadius (toDefaultShape index) (D.value config.size)
          Just (Standard _ shape _) -> toRadius shape (D.value config.size)
          Just (Custom _) -> D.value config.size
          Just NoDot -> D.value config.size

      toDotItem index property datum =
        let config = toConfig property datum
            dot = toDot index config
            radius = toRadius_ index config
        in
        { datum = datum
        , center =
            { x = toX datum
            , y = Maybe.withDefault 0 (property.visual datum)
            }
        , position =
            { x1 = toX datum - scaleCartesian plane.x radius
            , x2 = toX datum + scaleCartesian plane.x radius
            , y1 = Maybe.withDefault 0 (property.visual datum) - scaleCartesian plane.y radius
            , y2 = Maybe.withDefault 0 (property.visual datum) + scaleCartesian plane.y radius
            }
        , values =
            { x1 = toX datum -- TODO
            , x2 = toX datum
            , y = property.value datum
            }
        , details =
            { name = D.value config.name
            , unit = D.value config.unit
            , color = Maybe.withDefault (toDefaultColor index) config.color
            , dot = dot
            }
        }

      toLineItems index config =
        List.map (toDotItem index config) data
  in
  List.map Property.toConfigs properties
    |> List.concat
    |> List.indexedMap toLineItems



-- BARS


{-| -}
type alias Bin data =
  { datum : data
  , start : Float
  , end : Float
  }


{-| -}
toBins : Maybe (data -> Float) -> Maybe (data -> Float) -> List data -> List (Bin data)
toBins start end =
  let toXs index prevM curr nextM =
        case ( start, end ) of
          ( Nothing, Nothing ) ->
            { datum = curr, start = toFloat (index + 1) - 0.5, end = toFloat (index + 1) + 0.5 }

          ( Just toStart, Nothing ) ->
            case ( prevM, nextM ) of
              ( _, Just next ) ->
                { datum = curr, start = toStart curr, end = toStart next }
              ( Just prev, Nothing ) ->
                { datum = curr, start = toStart curr, end = toStart curr + (toStart curr - toStart prev) }
              ( Nothing, Nothing ) ->
                { datum = curr, start = toStart curr, end = toStart curr + 1 }

          ( Nothing, Just toEnd ) ->
            case ( prevM, nextM ) of
              ( Just prev, _ ) ->
                { datum = curr, start = toEnd prev, end = toEnd curr }
              ( Nothing, Just next ) ->
                { datum = curr, start = toEnd curr - (toEnd next - toEnd curr), end = toEnd curr }
              ( Nothing, Nothing ) ->
                { datum = curr, start = toEnd curr - 1, end = toEnd curr }

          ( Just toStart, Just toEnd ) ->
            { datum = curr, start = toStart curr, end = toEnd curr }

      fold index prev acc list =
        case list of
          a :: b :: rest -> fold (index + 1) (Just a) (acc ++ [toXs index prev a (Just b)]) (b :: rest)
          a :: [] -> acc ++ [toXs index prev a Nothing]
          [] -> acc
  in
  fold 0 Nothing []


{-| -}
type alias Space =
  { between : Float
  , margin : Float
  }


{-| -}
type alias Bar =
  { name : D.Constant String
  , unit : D.Constant String
  , color : Maybe String
  -- TODO , pattern : Constant Pattern
  }


{-| -}
toBarItems : Bool -> Space -> List (Property data Bar) -> List (Bin data) -> List (Items (Maybe Float) BarDetails data)
toBarItems isGrouped space properties bins =
  let toConfig p d =
        D.apply (p.attrs ++ p.extra d)
          { name = D.Default ""
          , unit = D.Default ""
          , color = Nothing
          }

      amountOfBars =
        if isGrouped then toFloat (List.length properties) else 1

      toBarItem length bin barIndex property =
        let margin_ = length * space.margin
            width_ = (length - margin_ * 2 - (amountOfBars - 1) * space.between) / amountOfBars
            x1 =
              if isGrouped then
                bin.end - length + margin_ + toFloat barIndex * width_ + toFloat barIndex * space.between
              else
                bin.end - length + margin_
        in
        List.map (toBarPieceItem bin barIndex x1 width_) (Property.toConfigs property)
          |> List.reverse

      toBarPieceItem bin barIndex x1 width_ property =
        let config = toConfig property bin.datum in
        { datum = bin.datum
        , center =
            { x = x1 + width_ / 2
            , y = Maybe.withDefault 0 (property.visual bin.datum)
            }
        , position =
            { x1 = x1
            , x2 = x1 + width_
            , y1 = Maybe.withDefault 0 (property.visual bin.datum) - Maybe.withDefault 0 (property.value bin.datum)
            , y2 = Maybe.withDefault 0 (property.visual bin.datum)
            }
        , values =
            { x1 = bin.start
            , x2 = bin.end
            , y = property.value bin.datum
            }
        , details =
            { name = D.value config.name
            , unit = D.value config.unit
            , color = Maybe.withDefault (toDefaultColor barIndex) config.color
            }
        }

      toBinItem bin =
        let length = bin.end - bin.start
            yMax = Coords.maximum (Property.toYs properties) [bin.datum]
        in
        { datum = bin.datum
        , center =
            { x = bin.end - length / 2
            , y = yMax
            }
        , position =
            { x1 = bin.end - length
            , x2 = bin.end
            , y1 = 0
            , y2 = yMax
            }
        , items = List.indexedMap (toBarItem length bin) properties
        }
  in
  List.map toBinItem bins


{-| -}
type alias BarVisuals data msg =
  { round : Float
  , roundBottom : Bool
  , attrs : Int -> data -> List (Attribute msg)
  }


{-| -}
bars : Plane -> BarVisuals data msg -> List (Items (Maybe Float) BarDetails data) -> Svg msg
bars plane visuals groups =
  g [ class "elm-charts__bars" ] (List.map (viewBin plane visuals) groups)


viewBin : Plane -> BarVisuals data msg -> Items (Maybe Float) BarDetails data -> Svg msg
viewBin plane visuals bin =
  g [ class "elm-charts__bin" ] <| List.concat <|
      List.indexedMap (\barIndex sections -> List.indexedMap (viewBar plane visuals sections barIndex) sections) bin.items


viewBar : Plane -> BarVisuals data msg -> List (Item (Maybe Float) BarDetails data) -> Int -> Int -> Item (Maybe Float) BarDetails data -> Svg msg
viewBar plane visuals sections barIndex sectionIndex item =
  -- TODO round via clipPath
  let x = item.position.x1
      y = item.position.y2
      w = item.position.x2 - item.position.x1
      bs = item.position.y1
      b = scaleSVG plane.x w * 0.5 * (clamp 0 1 visuals.round)
      ys = abs (scaleSVG plane.y y)
      rx = scaleCartesian plane.x b
      ry = scaleCartesian plane.y b

      hasNoValue it =
        (it.position.y2 - it.position.y1) == 0

      isLastWithValue =
        List.all hasNoValue (List.drop (sectionIndex + 1) sections)

      ( allowRoundTop, allowRoundBottom ) =
        if b == 0 || ys < b then
          ( False, False )
        else if List.length sections > 1 && sectionIndex == 0 && isLastWithValue then
          ( True, True )
        else if List.length sections > 1 && sectionIndex == 0 then
          ( False, visuals.roundBottom )
        else if List.length sections > 1 && (sectionIndex == List.length sections - 1 || isLastWithValue) then
          ( True, False )
        else if List.length sections > 1 then
          ( False, False )
        else
          ( True, visuals.roundBottom )

      commands =
        if bs == y then
          []
        else
          case ( allowRoundTop, allowRoundBottom ) of
            ( False, False ) ->
              commandsNoRound

            ( True, False ) ->
              if y < 0
              then commandsRoundTop False ry
              else commandsRoundTop True (ry * -1)

            ( False, True ) ->
              if y < 0
              then commandsRoundBottom False (ry * -1)
              else commandsRoundBottom True ry

            ( True, True ) ->
              if y < 0
              then commandsRoundBoth False (ry * -1)
              else commandsRoundBoth True ry

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
          [ fill item.details.color
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


type Dot
  = Standard Float Shape Variety
  | Custom (Svg Never)
  | NoDot


{-| -}
type alias Variety =
  Internal.Svg.Variety


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


{-| -}
type alias Interpolation =
  Interpolation.Interpolation


{-| -}
linear : Float -> Interpolation
linear =
  Interpolation.Linear


{-| -}
monotone : Float -> Interpolation
monotone =
  Interpolation.Monotone


{-| -}
dots : Plane -> List (Item (Maybe Float) DotDetails data) -> Svg msg
dots plane items =
  let viewDot item =
        case item.values.y of
          Just y ->
            case item.details.dot of
              Custom view ->
                Just <| g [ place plane item.center.x item.center.y ] [ Svg.map never view ]

              Standard radius shape_ style_ ->
                Just <| viewShape radius style_ shape_ item.details.color plane item.center.x item.center.y

              NoDot ->
                Nothing

          Nothing ->
            Nothing
  in
  g [ class "elm-charts__dots" ] (List.filterMap viewDot items)


interpolation : Plane -> Series -> List (Item (Maybe Float) DotDetails data) -> Svg msg
interpolation plane series items =
  let breaks = toBreaks items
      toCommands =
        case series.interpolation of
          Nothing -> always []
          Just (Interpolation.Linear _) -> Interpolation.linear
          Just (Interpolation.Monotone _) -> Interpolation.monotone

      width_ =
        case series.interpolation of
          Nothing -> 0
          Just (Interpolation.Linear w) -> w
          Just (Interpolation.Monotone w) -> w

      view_ points commands =
        case points of
          [] -> text "-- No data --"
          first :: rest ->
            viewLine plane
              [ Attributes.stroke (Maybe.withDefault "blue" series.color) -- TODO
              , Attributes.strokeWidth (String.fromFloat width_)
              , Attributes.fill (Maybe.withDefault "blue" series.color) -- TODO
              ]
              commands first rest
  in
  g [ class "elm-charts__interpolations" ] (List.map2 view_ breaks (toCommands breaks))


area : Plane -> List ( Series, List (Item (Maybe Float) DotDetails data) ) -> List (Svg msg)
area plane series =
  let toCommands config =
        case config.interpolation of
          Nothing -> always []
          Just (Interpolation.Linear _) -> Interpolation.linear
          Just (Interpolation.Monotone _) -> Interpolation.monotone

  in
  withSurround series <| \index prevM (currC, currI) nextM ->
    case currC.area of
      Nothing ->
        text ""

      Just opacity ->
        let currPoints =
              toBreaks currI

            currCmds =
              toCommands currC currPoints

            nextCmds =
              case nextM of
                Just (nextC, nextI) ->
                  withBorder (List.concat (toBreaks nextI)) <| \start end ->
                    [ Move plane.x.min plane.y.max, Line plane.x.min start.y ]
                    ++ (List.concat <| toCommands nextC [List.concat <| toBreaks nextI])
                    ++ [ Line plane.x.max end.y, Line plane.x.max plane.y.max ]

                Nothing ->
                  Nothing

            view ps cs =
              withBorder ps <| \start end ->
                path
                  [ Attributes.clipPath ("url(#area-def" ++ String.fromInt index ++ ")")
                  , Attributes.fill (Maybe.withDefault "blue" currC.color) -- TODO
                  , Attributes.fillOpacity (String.fromFloat opacity)
                  , d (description plane <| [ Move start.x 0, Line start.x start.y ] ++ cs ++ [ Line end.x 0 ])
                  ]
                  []
        in
        g [ class "elm-charts__area" ] <|
          case nextCmds of
            Just clipper ->
              [ Svg.defs []
                  [ Svg.clipPath
                      [ Attributes.id ("area-def" ++ String.fromInt index) ]
                      [ path [ d (description plane clipper) ] []
                      ]
                  ]
              , g [] <| List.filterMap identity (List.map2 view currPoints currCmds)
              ]

            Nothing ->
              List.filterMap identity (List.map2 view currPoints currCmds)



-- INTERNAL


viewLine : Plane -> List (Attribute msg) -> List Command -> Point -> List Point -> Svg msg
viewLine plane userAttributes cmds first rest =
  let
    commands =
      concat [ Move first.x first.y ] cmds []

    attributes =
      concat
        [ class "elm-charts__line", stroke pinkStroke ]
        userAttributes
        [ d (description plane commands), fill transparent ]
  in
  path attributes []


viewArea : Plane -> List (Attribute msg) -> List Command -> Point -> List Point -> Svg msg
viewArea plane userAttributes cmds first rest =
  let
    commands =
      concat
        [ Move first.x (closestToZero plane), Line first.x first.y ]
        cmds
        [ Line (Maybe.withDefault first (last rest) |> .x) (closestToZero plane) ]

    attributes =
      concat
        [ class "elm-charts__area" ]
        userAttributes
        [ d (description plane commands) ]
  in
    path attributes []




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
toBreaks : List (Item (Maybe Float) details data) -> List (List Point)
toBreaks =
  let fold item acc =
        case item.values.y of
          Just y ->
            case acc of
              latest :: rest -> (latest ++ [item.center]) :: rest
              [] -> ([item.center] :: acc)

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


{-| -}
withBorder : List a -> (a -> a -> b) -> Maybe b
withBorder stuff func =
  case stuff of
    first :: rest ->
      Just (func first (Maybe.withDefault first (last rest)))

    _ ->
      Nothing


{-| -}
withSurround : List a -> (Int -> Maybe a -> a -> Maybe a -> b) -> List b
withSurround all func =
  let fold index prev acc list =
        case list of
          a :: b :: rest -> fold (index + 1) (Just a) (acc ++ [func index prev a (Just b)]) (b :: rest)
          a :: [] -> acc ++ [func index prev a Nothing]
          [] -> acc
  in
  fold 0 Nothing [] all



-- DEFAULTS


toDefaultShape : Int -> Shape
toDefaultShape index =
  let numOfItems = Dict.size shapes
      itemIndex = remainderBy numOfItems index
  in
  Dict.get itemIndex shapes
    |> Maybe.withDefault circle


shapes : Dict Int Shape
shapes =
  [ circle, triangle, square, diamond, plus, cross ]
    |> List.indexedMap Tuple.pair
    |> Dict.fromList


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

