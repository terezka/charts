module Chart exposing
  ( chart

  , Element, bars, barsMap, series, seriesMap
  , Property, bar, scatter, interpolated, stacked, named, variation, amongst

  , xAxis, yAxis, xTicks, yTicks, xLabels, yLabels, grid

  , xLabel, yLabel, xTick, yTick
  , label, labelAt, tooltip, line, rect
  , legendsAt

  , svgAt, htmlAt, svg, html, none

  , each, eachBin, eachStack, eachBar, eachDot, eachProduct
  , withPlane, withBins, withStacks, withBars, withDots, withProducts

  , generate, floats, ints, times

  , binned
  )


{-| Make a chart!

@docs chart, Element

# Data elements
@docs bars, series
@docs Property, bar, scatter, interpolated, stacked, named, variation, amongst

# Navigation elements
@docs xAxis, yAxis, xTicks, yTicks, xLabels, yLabels, grid

@docs xLabel, yLabel, xTick, yTick
@docs generate, floats, ints, times

@docs label, labelAt, tooltip, line, rect

@docs legendsAt

# Arbitrary elements
@docs svgAt, htmlAt, svg, html, none

# Advanced elements
@docs each, eachBin, eachStack, eachBar, eachDot, eachProduct
@docs withPlane, withBins, withStacks, withBars, withDots, withProducts

# Data helper
@docs binned

-}


import Internal.Coordinates as C
import Svg as S
import Svg.Attributes as SA
import Svg.Events as SE
import Html as H
import Html.Attributes as HA
import Intervals as I
import Internal.Property as P
import Time
import Dict exposing (Dict)
import Internal.Item as Item
import Internal.Produce as Produce
import Internal.Legend as Legend
import Internal.Group as Group
import Internal.Helpers as Helpers
import Internal.Svg as IS
import Chart.Svg as CS
import Chart.Attributes as CA
import Chart.Events as CE


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
  , range : List (CA.Attribute C.Axis)
  , domain : List (CA.Attribute C.Axis)
  , events : List (CE.Event data msg)
  , htmlAttrs : List (H.Attribute msg)
  , attrs : List (S.Attribute msg)
  }


{-| -}
chart : List (CA.Attribute (Container data msg)) -> List (Element data msg) -> H.Html msg
chart edits unindexedElements =
  let config =
        Helpers.apply edits
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
          , range = []
          , domain = []
          , events = []
          , attrs = [ SA.style "overflow: visible;" ]
          , htmlAttrs = []
          }

      elements =
        let toIndexedEl el ( acc, index ) =
              case el of
                Indexed toElAndIndex ->
                  let ( newEl, newIndex ) = toElAndIndex index in
                  ( acc ++ [ newEl ], newIndex )

                _ ->
                  ( acc ++ [ el ], index )
        in
        List.foldl toIndexedEl ( [], 0 ) unindexedElements
          |> Tuple.first

      plane =
        definePlane config elements

      items =
        getItems plane elements

      legends_ =
        getLegends elements

      tickValues =
        getTickValues plane items elements

      ( beforeEls, chartEls, afterEls ) =
        viewElements config plane tickValues items legends_ elements

      toEvent (CE.Event event_) =
        let (CE.Decoder decoder) = event_.decoder in
        IS.Event event_.name (decoder items)
  in
  IS.container plane
    { attrs = config.attrs
    , htmlAttrs = config.htmlAttrs
    , responsive = config.responsive
    , events = List.map toEvent config.events
    }
    beforeEls
    chartEls
    afterEls



-- ELEMENTS


{-| -}
type Element data msg
  = Indexed (Int -> ( Element data msg, Int ))
  | SeriesElement
      (List C.Position)
      (List (Item.Product CE.Any (Maybe Float) data))
      (List Legend.Legend)
      (C.Plane -> S.Svg msg)
  | BarsElement
      (List C.Position)
      (List (Item.Product CE.Any (Maybe Float) data))
      (List Legend.Legend)
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
      (C.Plane -> List (Item.Product CE.Any (Maybe Float) data) -> List (Element data msg))
  | ListOfElements
      (List (Element data msg))
  | SvgElement
      (C.Plane -> S.Svg msg)
  | HtmlElement
      (C.Plane -> List Legend.Legend -> H.Html msg)


definePlane : Container data msg -> List (Element data msg) -> C.Plane
definePlane config elements =
  let collectLimits el acc =
        case el of
          Indexed _ -> acc
          SeriesElement lims _ _ _ -> acc ++ lims
          BarsElement lims _ _ _ _ -> acc ++ lims
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
          [] -> limits_.x
          some -> List.foldl (\f b -> f b) limits_.x some

      calcDomain =
        case config.domain of
          [] -> CA.lowest 0 CA.orLower limits_.y
          some -> List.foldl (\f b -> f b) limits_.y some

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

      xMin = calcRange.min - scalePadX config.paddingLeft
      xMax = calcRange.max + scalePadX config.paddingRight

      yMin = calcDomain.min - scalePadY config.paddingBottom
      yMax = calcDomain.max + scalePadY config.paddingTop
  in
  { width = config.width
  , height = config.height
  , margin = margin
  , x =
      { calcRange
      | min = min xMin xMax
      , max = max xMin xMax
      }
  , y =
      { calcDomain
      | min = min yMin yMax
      , max = max yMin yMax
      }
  }


getItems : C.Plane -> List (Element data msg) -> List (Item.Product CE.Any (Maybe Float) data)
getItems plane elements =
  let toItems el acc =
        case el of
          Indexed _ -> acc
          SeriesElement _ items _ _ -> acc ++ items
          BarsElement _ items _ _ _ -> acc ++ items
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


getLegends : List (Element data msg) -> List Legend.Legend
getLegends elements =
  let toLegends el acc =
        case el of
          Indexed _ -> acc
          SeriesElement _ _ legends_ _ -> acc ++ legends_
          BarsElement _ _ legends_ _ _ -> acc ++ legends_
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
  in
  List.foldl toLegends [] elements



{-| -}
type alias TickValues =
  { xAxis : List Float
  , yAxis : List Float
  , xs : List Float
  , ys : List Float
  }


getTickValues : C.Plane -> List (Item.Product CE.Any (Maybe Float) data) -> List (Element data msg) -> TickValues
getTickValues plane items elements =
  let toValues el acc =
        case el of
          Indexed _ -> acc
          SeriesElement _ _ _ _     -> acc
          BarsElement _ _ _ func _  -> func plane acc
          AxisElement func _        -> func plane acc
          TicksElement func _       -> func plane acc
          TickElement toC func _    -> func plane (toC plane) acc
          LabelsElement toC func _  -> func plane (toC plane) acc
          LabelElement toC func _   -> func plane (toC plane) acc
          SubElements func          -> List.foldl toValues acc (func plane items)
          GridElement _             -> acc
          ListOfElements _          -> acc
          SvgElement _              -> acc
          HtmlElement _             -> acc
  in
  List.foldl toValues (TickValues [] [] [] []) elements


viewElements : Container data msg -> C.Plane -> TickValues -> List (Item.Product CE.Any (Maybe Float) data) -> List Legend.Legend -> List (Element data msg) -> ( List (H.Html msg), List (S.Svg msg), List (H.Html msg) )
viewElements config plane tickValues allItems allLegends elements =
  let viewOne el ( before, chart_, after ) =
        case el of
          Indexed _                 -> ( before,chart_, after )
          SeriesElement _ _ _ view  -> ( before, view plane :: chart_, after )
          BarsElement _ _ _ _ view  -> ( before, view plane :: chart_, after )
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
            ( if List.length chart_ > 0 then view plane allLegends :: before else before
            , chart_
            , if List.length chart_ > 0 then after else view plane allLegends :: after
            )
  in
  List.foldr viewOne ([], [], []) elements



 -- TOOLTIP


type alias Tooltip =
  { direction : Maybe IS.Direction
  , focal : Maybe (C.Position -> C.Position)
  , height : Float
  , width : Float
  , offset : Float
  , arrow : Bool
  , border : String
  , background : String
  }


{-| -}
tooltip : Item.Item a -> List (CA.Attribute Tooltip) -> List (H.Attribute Never) -> List (H.Html Never) -> Element data msg
tooltip i edits attrs_ content =
  html <| \p ->
    let pos = Item.getLimits i
        content_ = if content == [] then Item.toHtml i else content
    in
    if CS.isWithinPlane p pos.x1 pos.y2 -- TODO
    then CS.tooltip p (Item.getPosition p i) edits attrs_ content_
    else H.text ""



-- AXIS


{-| -}
type alias Axis =
  { limits : List (CA.Attribute C.Axis)
  , pinned : C.Axis -> Float
  , arrow : Bool
  , color : String
  }


{-| -}
xAxis : List (CA.Attribute Axis) -> Element item msg
xAxis edits =
  let config =
        Helpers.apply edits
          { limits = []
          , pinned = CA.zero
          , color = ""
          , arrow = True
          }

      addTickValues p ts =
        { ts | yAxis = config.pinned p.y :: ts.yAxis }
  in
  AxisElement addTickValues <| \p ->
    let xLimit = List.foldl (\f x -> f x) p.x config.limits in
    S.g
      [ SA.class "elm-charts__x-axis" ]
      [ CS.line p
          [ CA.color config.color
          , CA.y1 (config.pinned p.y)
          , CA.x1 (max p.x.min xLimit.min)
          , CA.x2 (min p.x.max xLimit.max)
          ]
      , if config.arrow then
          CS.arrow p
            [ CA.color config.color ]
            { x = xLimit.max
            , y = config.pinned p.y
            }
        else
          S.text ""
      ]


{-| -}
yAxis : List (CA.Attribute Axis) -> Element item msg
yAxis edits =
  let config =
        Helpers.apply edits
          { limits = []
          , pinned = CA.zero
          , color = ""
          , arrow = True
          }

      addTickValues p ts =
        { ts | xAxis = config.pinned p.x :: ts.xAxis }
  in
  AxisElement addTickValues <| \p ->
    let yLimit = List.foldl (\f y -> f y) p.y config.limits in
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
  { color : String
  , height : Float
  , width : Float
  , pinned : C.Axis -> Float
  , limits : List (CA.Attribute C.Axis)
  , amount : Int
  , flip : Bool
  , grid : Bool
  , generate : IS.TickType
  }


{-| -}
xTicks : List (CA.Attribute Ticks) -> Element item msg
xTicks edits =
  let config =
        Helpers.apply edits
          { color = ""
          , limits = []
          , pinned = CA.zero
          , amount = 5
          , generate = IS.Floats
          , height = 5
          , flip = False
          , grid = True
          , width = 1
          }

      toTicks p =
        List.foldl (\f x -> f x) p.x config.limits
          |> generateValues config.amount config.generate
          |> List.map .value

      addTickValues p ts =
        if not config.grid then ts else
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
yTicks : List (CA.Attribute Ticks) -> Element item msg
yTicks edits =
  let config =
        Helpers.apply edits
          { color = ""
          , limits = []
          , pinned = CA.zero
          , amount = 5
          , generate = IS.Floats
          , height = 5
          , flip = False
          , grid = True
          , width = 1
          }

      toTicks p =
        List.foldl (\f y -> f y) p.y config.limits
          |> generateValues config.amount config.generate
          |> List.map .value

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
  { color : String
  , pinned : C.Axis -> Float
  , limits : List (CA.Attribute C.Axis)
  , xOff : Float
  , yOff : Float
  , flip : Bool
  , amount : Int
  , anchor : Maybe IS.Anchor
  , generate : IS.TickType
  , fontSize : Maybe Int
  , uppercase : Bool
  , grid : Bool
  }


{-| -}
xLabels : List (CA.Attribute Labels) -> Element item msg
xLabels edits =
  let toConfig p =
        Helpers.apply edits
          { color = "#808BAB"
          , limits = []
          , pinned = CA.zero
          , amount = 5
          , generate = IS.Floats
          , flip = False
          , anchor = Nothing
          , xOff = 0
          , yOff = 18
          , grid = True
          , uppercase = False
          , fontSize = Nothing
          }

      toTicks p config =
        List.foldl (\f x -> f x) p.x config.limits
          |> generateValues config.amount config.generate

      toTickValues p config ts =
        if not config.grid then ts else
        { ts | xs = ts.xs ++ List.map .value (toTicks p config) }
  in
  LabelsElement toConfig toTickValues <| \p config ->
    let default = IS.defaultLabel
        toLabel item =
          IS.label p
            { default
            | xOff = config.xOff
            , yOff = if config.flip then -config.yOff + 10 else config.yOff
            , color = config.color
            , anchor = config.anchor
            , fontSize = config.fontSize
            , uppercase = config.uppercase
            }
            [ S.text item.label ]
            { x = item.value
            , y = config.pinned p.y
            }
    in
    S.g [ SA.class "elm-charts__x-labels" ] (List.map toLabel (toTicks p config))


{-| -}
yLabels : List (CA.Attribute Labels) -> Element item msg
yLabels edits =
  let toConfig p =
        Helpers.apply edits
          { color = "#808BAB"
          , limits = []
          , pinned = CA.zero
          , amount = 5
          , generate = IS.Floats
          , anchor = Nothing
          , flip = False
          , xOff = -10
          , yOff = 3
          , grid = True
          , uppercase = False
          , fontSize = Nothing
          }

      toTicks p config =
        List.foldl (\f y -> f y) p.y config.limits
          |> generateValues config.amount config.generate

      toTickValues p config ts =
        if not config.grid then ts else
        { ts | ys = ts.ys ++ List.map .value (toTicks p config) }
  in
  LabelsElement toConfig toTickValues <| \p config ->
    let default = IS.defaultLabel
        toLabel item =
          IS.label p
            { default
            | xOff = if config.flip then -config.xOff else config.xOff
            , yOff = config.yOff
            , color = config.color
            , fontSize = config.fontSize
            , uppercase = config.uppercase
            , anchor =
                case config.anchor of
                  Nothing -> Just (if config.flip then IS.Start else IS.End)
                  Just anchor -> Just anchor
            }
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
  , anchor : Maybe IS.Anchor
  , rotate : Float
  , uppercase : Bool
  , flip : Bool
  , grid : Bool
  }


{-| -}
xLabel : List (CA.Attribute Label) -> List (S.Svg msg) -> Element data msg
xLabel edits inner =
  let toConfig p =
        Helpers.apply edits
          { x = CA.middle p.x
          , y = CA.zero p.y
          , xOff = 0
          , yOff = 20
          , border = "white"
          , borderWidth = 0.1
          , uppercase = False
          , fontSize = Nothing
          , color = "#808BAB"
          , anchor = Nothing
          , rotate = 0
          , flip = False
          , grid = True
          }

      toTickValues p config ts =
        if not config.grid then ts else
        { ts | xs = ts.xs ++ [ config.x ] }
  in
  LabelElement toConfig toTickValues <| \p config ->
    let string =
          if inner == []
          then [ S.text (String.fromFloat config.x) ]
          else inner
    in
    IS.label p
      { xOff = config.xOff
      , yOff = if config.flip then -config.yOff + 10 else config.yOff
      , border = config.border
      , borderWidth = config.borderWidth
      , fontSize = config.fontSize
      , uppercase = config.uppercase
      , color = config.color
      , anchor = config.anchor
      , rotate = config.rotate
      , attrs = []
      }
      string
      { x = config.x, y = config.y }


{-| -}
yLabel : List (CA.Attribute Label) -> List (S.Svg msg) -> Element data msg
yLabel edits inner =
  let toConfig p =
        Helpers.apply edits
          { x = CA.zero p.x
          , y = CA.middle p.y
          , xOff = -8
          , yOff = 3
          , border = "white"
          , borderWidth = 0.1
          , uppercase = False
          , fontSize = Nothing
          , color = "#808BAB"
          , anchor = Nothing
          , rotate = 0
          , flip = False
          , grid = True
          }

      toTickValues p config ts =
        if not config.grid then ts else
        { ts | ys = ts.ys ++ [ config.y ] }
  in
  LabelElement toConfig toTickValues <| \p config ->
    let string =
          if inner == []
          then [ S.text (String.fromFloat config.y) ]
          else inner
    in
    IS.label p
      { xOff = if config.flip then -config.xOff else config.xOff
      , yOff = config.yOff
      , border = config.border
      , borderWidth = config.borderWidth
      , fontSize = config.fontSize
      , uppercase = config.uppercase
      , color = config.color
      , anchor =
          case config.anchor of
            Nothing -> Just (if config.flip then IS.Start else IS.End)
            Just anchor -> Just anchor
      , rotate = config.rotate
      , attrs = []
      }
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
  , grid : Bool
  }


{-| -}
xTick : List (CA.Attribute Tick) -> Element data msg
xTick edits =
  let toConfig p =
        Helpers.apply edits
          { x = CA.middle p.x
          , y = CA.zero p.y
          , length = 5
          , color = "rgb(210, 210, 210)"
          , width = 1
          , flip = False
          , grid = True
          }

      toTickValues p config ts =
        if not config.grid then ts else
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
yTick : List (CA.Attribute Tick) -> Float -> Element data msg
yTick edits val =
  let toConfig p =
        Helpers.apply edits
          { x = CA.middle p.x
          , y = CA.zero p.y
          , length = 5
          , color = "rgb(210, 210, 210)"
          , width = 1
          , flip = False
          , grid = True
          }

      toTickValues p config ts =
        if not config.grid then ts else
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
    { color : String
    , width : Float
    , dotGrid : Bool
    , dashed : List Float
    }


{-| -}
grid : List (CA.Attribute Grid) -> Element item msg
grid edits =
  let config =
        Helpers.apply edits
          { color = ""
          , width = 0
          , dotGrid = False
          , dashed = []
          }

      color =
        if String.isEmpty config.color then
          if config.dotGrid then Helpers.darkGray else Helpers.gray
        else
          config.color

      width =
        if config.width == 0 then
          if config.dotGrid then 0.5 else 1
        else
          config.width

      toXGrid vs p v =
        if List.member v vs.xAxis
        then Nothing else Just <|
          CS.line p [ CA.color color, CA.width width, CA.x1 v, CA.dashed config.dashed ]

      toYGrid vs p v =
        if List.member v vs.yAxis
        then Nothing else Just <|
          CS.line p [ CA.color color, CA.width width, CA.y1 v, CA.dashed config.dashed ]

      toDot vs p x y =
        if List.member x vs.xAxis || List.member y vs.yAxis
        then Nothing
        else Just <| CS.dot p .x .y [ CA.color color, CA.size width, CA.circle ] { x = x, y = y }
  in
  GridElement <| \p vs ->
    S.g [ SA.class "elm-charts__grid" ] <|
      if config.dotGrid then
        List.concatMap (\x -> List.filterMap (toDot vs p x) vs.ys) vs.xs
      else
        [ S.g [ SA.class "elm-charts__x-grid" ] (List.filterMap (toXGrid vs p) vs.xs)
        , S.g [ SA.class "elm-charts__y-grid" ] (List.filterMap (toYGrid vs p) vs.ys)
        ]



-- PROPERTIES


{-| -}
type alias Property data inter deco =
  P.Property data String inter deco


{-| -}
interpolated : (data -> Maybe Float) -> List (CA.Attribute CS.Interpolation) -> List (CA.Attribute CS.Dot) -> Property data CS.Interpolation CS.Dot
interpolated y_ inter =
  P.property y_ ([ CA.linear ] ++ inter)


{-| -}
scatter : (data -> Maybe Float) -> List (CA.Attribute CS.Dot) -> Property data inter CS.Dot
scatter y_ =
  P.property y_ []


{-| -}
bar : (data -> Maybe Float) -> List (CA.Attribute CS.Bar) -> Property data inter CS.Bar
bar y_ =
  P.property y_ []


{-| -}
named : String -> Property data inter deco -> Property data inter deco
named name =
  P.meta name


{-| -}
variation : (data -> List (CA.Attribute deco)) -> Property data inter deco -> Property data inter deco
variation func =
  P.variation <| \_ _ _ -> func


{-| -}
amongst : List (CE.Product config value data) -> (data -> List (CA.Attribute deco)) -> Property data inter deco -> Property data inter deco
amongst inQuestion func =
  P.variation <| \p s meta d ->
    let check product =
          if Item.getPropertyIndex product == p &&
             Item.getStackIndex product == s &&
             Item.getDatum product == d
          then func d else []
    in
    List.concatMap check inQuestion


{-| -}
stacked : List (Property data inter deco) -> Property data inter deco
stacked =
  P.stacked



-- BARS


{-| -}
type alias Bars data =
  { spacing : Float
  , margin : Float
  , roundTop : Float
  , roundBottom : Float
  , grouped : Bool
  , grid : Bool
  , x1 : Maybe (data -> Float)
  , x2 : Maybe (data -> Float)
  }


{-| -}
bars : List (CA.Attribute (Bars data)) -> List (Property data () CS.Bar) -> List data -> Element data msg
bars edits properties data =
  barsMap identity edits properties data


{-| -}
barsMap : (data -> a) -> List (CA.Attribute (Bars data)) -> List (Property data () CS.Bar) -> List data -> Element a msg
barsMap mapData edits properties data =
  Indexed <| \index ->
    let barsConfig =
          Helpers.apply edits IS.defaultBars

        items =
          Produce.toBarSeries index edits properties data

        generalized =
          List.concatMap Group.getProducts items
            |> List.map (Item.map mapData)

        bins =
          CE.group CE.bin generalized

        legends_ =
          Legend.toBarLegends index edits properties

        toTicks plane acc =
          { acc | xs = acc.xs ++
              if barsConfig.grid then
                List.concatMap (CE.getLimits >> \pos -> [ pos.x1, pos.x2 ]) bins
              else
                []
          }

        toLimits =
          List.map Item.getLimits bins
    in
    ( BarsElement toLimits generalized legends_ toTicks <| \plane ->
      S.g [ SA.class "elm-charts__bar-series" ] (List.map (Item.toSvg plane) items)
        |> S.map never
    , index + List.length (List.concatMap P.toConfigs properties)
    )



-- SERIES


{-| -}
series : (data -> Float) -> List (Property data CS.Interpolation CS.Dot) -> List data -> Element data msg
series toX properties data =
  seriesMap identity toX properties data


{-| -}
seriesMap : (data -> a) -> (data -> Float) -> List (Property data CS.Interpolation CS.Dot) -> List data -> Element a msg
seriesMap mapData toX properties data =
  Indexed <| \index ->
    let items =
          Produce.toDotSeries index toX properties data

        generalized =
          List.concatMap Group.getProducts items
            |> List.map (Item.map mapData)

        legends_ =
          Legend.toDotLegends index properties

        toLimits =
          List.map Item.getLimits items
    in
    ( SeriesElement toLimits generalized legends_ <| \p ->
        S.g [ SA.class "elm-charts__dot-series" ] (List.map (Item.toSvg p) items)
          |> S.map never
    , index + List.length (List.concatMap P.toConfigs properties)
    )



-- OTHER


{-| -}
withPlane : (C.Plane -> List (Element data msg)) -> Element data msg
withPlane func =
  SubElements <| \p is -> func p


{-| -}
withBins : (C.Plane -> List (CE.Group (CE.Bin data) CE.Any (Maybe Float) data) -> List (Element data msg)) -> Element data msg
withBins func =
  SubElements <| \p is -> func p (CE.group CE.bin is)


{-| -}
withStacks : (C.Plane -> List (CE.Group (CE.Stack data) CE.Any (Maybe Float) data) -> List (Element data msg)) -> Element data msg
withStacks func =
  SubElements <| \p is -> func p (CE.group CE.stack is)


{-| -}
withBars : (C.Plane -> List (CE.Product CE.Bar (Maybe Float) data) -> List (Element data msg)) -> Element data msg
withBars func =
  SubElements <| \p is -> func p (CE.group CE.bar is)


{-| -}
withDots : (C.Plane -> List (CE.Product CE.Dot (Maybe Float) data) -> List (Element data msg)) -> Element data msg
withDots func =
  SubElements <| \p is -> func p (CE.group CE.dot is)


{-| -}
withProducts : (C.Plane -> List (CE.Product CE.Any (Maybe Float) data) -> List (Element data msg)) -> Element data msg
withProducts func =
  SubElements <| \p is -> func p is


{-| -}
each : List a -> (C.Plane -> a -> List (Element data msg)) -> Element data msg
each items func =
  SubElements <| \p _ -> List.concatMap (func p) items


{-| -}
eachBin : (C.Plane -> CE.Group (CE.Bin data) CE.Any (Maybe Float) data -> List (Element data msg)) -> Element data msg
eachBin func =
  SubElements <| \p is -> List.concatMap (func p) (CE.group CE.bin is)


{-| -}
eachStack : (C.Plane -> CE.Group (CE.Stack data) CE.Any (Maybe Float) data -> List (Element data msg)) -> Element data msg
eachStack func =
  SubElements <| \p is -> List.concatMap (func p) (CE.group CE.stack is)


{-| -}
eachBar : (C.Plane -> Item.Product CE.Bar (Maybe Float) data -> List (Element data msg)) -> Element data msg
eachBar func =
  SubElements <| \p is -> List.concatMap (func p) (CE.group CE.bar is)


{-| -}
eachDot : (C.Plane -> Item.Product CE.Dot (Maybe Float) data -> List (Element data msg)) -> Element data msg
eachDot func =
  SubElements <| \p is -> List.concatMap (func p) (CE.group CE.dot is)


{-| -}
eachProduct : (C.Plane -> Item.Product CE.Any (Maybe Float) data -> List (Element data msg)) -> Element data msg
eachProduct func =
  SubElements <| \p is -> List.concatMap (func p) is


{-| -}
legendsAt : (C.Axis -> Float) -> (C.Axis -> Float) -> Float -> Float -> List (CA.Attribute (CS.Legends msg)) -> List (CA.Attribute (CS.Legend msg)) -> Element data msg
legendsAt toX toY xOff yOff attrs children =
  HtmlElement <| \p legends_ ->
    let viewLegend legend =
          case legend of
            Legend.BarLegend name barAttrs -> CS.barLegend (CA.title name :: children) barAttrs
            Legend.LineLegend name interAttrs dotAttrs -> CS.lineLegend (CA.title name :: children) interAttrs dotAttrs
    in
    CS.legendsAt p (toX p.x) (toY p.y) xOff yOff attrs (List.map viewLegend legends_)


{-| -}
generate : Int -> CS.Generator a -> (C.Plane -> C.Axis) -> List (CA.Attribute C.Axis) -> (C.Plane -> a -> List (Element data msg)) -> Element data msg
generate num gen limit attrs func =
  SubElements <| \p _ ->
    let items = CS.generate num gen (List.foldl (\f x -> f x) (limit p) attrs) in
    List.concatMap (func p) items


{-| -}
floats : CS.Generator Float
floats =
  CS.floats


{-| -}
ints : CS.Generator Int
ints =
  CS.ints


{-| -}
times : Time.Zone -> CS.Generator I.Time
times =
  CS.times


{-| -}
label : List (CA.Attribute CS.Label) -> List (S.Svg msg) -> C.Point -> Element data msg
label attrs inner point =
  SvgElement <| \p -> CS.label p attrs inner point


{-| -}
labelAt : (C.Axis -> Float) -> (C.Axis -> Float) -> List (CA.Attribute CS.Label) -> List (S.Svg msg) -> Element data msg
labelAt toX toY attrs inner =
  SvgElement <| \p -> CS.label p attrs inner { x = toX p.x, y = toY p.y }


{-| -}
line : List (CA.Attribute CS.Line) -> Element data msg
line attrs =
  SvgElement <| \p -> CS.line p attrs


{-| -}
rect : List (CA.Attribute CS.Rect) -> Element data msg
rect attrs =
  SvgElement <| \p -> CS.rect p attrs


{-| -}
svg : (C.Plane -> S.Svg msg) -> Element data msg
svg func =
  SvgElement <| \p -> func p


{-| -}
html : (C.Plane -> H.Html msg) -> Element data msg
html func =
  HtmlElement <| \p _ -> func p


{-| -}
svgAt : (C.Axis -> Float) -> (C.Axis -> Float) -> Float -> Float -> List (S.Svg msg) -> Element data msg
svgAt toX toY xOff yOff view =
  SvgElement <| \p ->
    S.g [ CS.position p 0 (toX p.x) (toY p.y) xOff yOff ] view


{-| -}
htmlAt : (C.Axis -> Float) -> (C.Axis -> Float) -> Float -> Float -> List (H.Attribute msg) -> List (H.Html msg) -> Element data msg
htmlAt toX toY xOff yOff att view =
  HtmlElement <| \p _ ->
    CS.positionHtml p (toX p.x) (toY p.y) xOff yOff att view


{-| -}
none : Element data msg
none =
  HtmlElement <| \_ _ -> H.text ""



-- DATA HELPERS


binned : Float -> (data -> Float) -> List data -> List { bin : Float, data : List data }
binned binWidth func data =
  let fold datum =
        Dict.update (toBin datum) (updateDict datum)

      updateDict datum maybePrev =
        case maybePrev of
          Just prev -> Just (datum :: prev)
          Nothing -> Just [ datum ]

      toBin datum =
        floor (func datum / binWidth)
  in
  List.foldr fold Dict.empty data
    |> Dict.toList
    |> List.map (\( bin, ds ) -> { bin = toFloat bin * binWidth, data = ds })



-- HELPERS


generateValues : Int -> IS.TickType -> C.Axis -> List IS.TickValue
generateValues amount tick axis =
  case tick of
    IS.Floats -> IS.toTickValues identity String.fromFloat (CS.generate amount CS.floats axis)
    IS.Ints -> IS.toTickValues toFloat String.fromInt (CS.generate amount CS.ints axis)
    IS.Times zone -> IS.toTickValues (toFloat << Time.posixToMillis << .timestamp) (CS.formatTime zone) (CS.generate amount (CS.times zone) axis)


