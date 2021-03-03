module Chart exposing (..)
    --  chart, linear, monotone
    --, xAxis, yAxis, xTicks, yTicks, xLabels, yLabels, grid
    --)


import Svg.Chart as C
import Svg.Coordinates as C
import Svg as S
import Svg.Attributes as SA
import Html as H
import Html.Attributes as HA



fromData : (data -> Float) -> List data -> Bounds
fromData value data =
  { min = C.minimum [value] data
  , max = C.maximum [value] data
  }



-- ATTRS


width : Float -> { a | width : Float } -> { a | width : Float }
width value config =
  { config | width = value }


height : Float -> { a | height : Float } -> { a | height : Float }
height value config =
  { config | height = value }


marginTop : Float -> { a | marginTop : Float } -> { a | marginTop : Float }
marginTop value config =
  { config | marginTop = value }


marginBottom : Float -> { a | marginBottom : Float } -> { a | marginBottom : Float }
marginBottom value config =
  { config | marginBottom = value }


marginLeft : Float -> { a | marginLeft : Float } -> { a | marginLeft : Float }
marginLeft value config =
  { config | marginLeft = value }


marginRight : Float -> { a | marginRight : Float } -> { a | marginRight : Float }
marginRight value config =
  { config | marginRight = value }


responsive : { a | responsive : Bool } -> { a | responsive : Bool }
responsive config =
  { config | responsive = True }


id : String -> { a | id : String } -> { a | id : String }
id value config =
  { config | id = value }


range : Bounds -> { a | range : Bounds } -> { a | range : Bounds }
range value config =
  { config | range = value }


domain : Bounds -> { a | domain : Bounds } -> { a | domain : Bounds }
domain value config =
  { config | domain = value }


attrs : List (S.Attribute msg) -> { a | attrs : List (S.Attribute msg) } -> { a | attrs : List (S.Attribute msg) }
attrs value config =
  { config | attrs = value }


htmlAttrs : List (H.Attribute msg) -> { a | htmlAttrs : List (H.Attribute msg) } -> { a | htmlAttrs : List (H.Attribute msg) }
htmlAttrs value config =
  { config | htmlAttrs = value }


start : (Bounds -> Float) -> { a | start : Bounds -> Float } -> { a | start : Bounds -> Float }
start value config =
  { config | start = value }


end : (Bounds -> Float) -> { a | end : Bounds -> Float } -> { a | end : Bounds -> Float }
end value config =
  { config | end = value }


pinned : (Bounds -> Float) -> { a | pinned : Bounds -> Float } -> { a | pinned : Bounds -> Float }
pinned value config =
  { config | pinned = value }


color : String -> { a | color : String } -> { a | color : String }
color value config =
  { config | color = value }



----

type alias Container msg =
    { width : Float
    , height : Float
    , marginTop : Float
    , marginBottom : Float
    , marginLeft : Float
    , marginRight : Float
    , responsive : Bool
    , id : String
    , range : Bounds
    , domain : Bounds
    , htmlAttrs : List (H.Attribute msg)
    , attrs : List (S.Attribute msg)
    }


type alias Bounds =
    { min : Float, max : Float }


chart : List (Container msg -> Container msg) -> List (Element msg) -> H.Html msg
chart edits elements =
  let config =
        applyAttrs edits
          { width = 500
          , height = 200
          , marginTop = 5
          , marginBottom = 30
          , marginLeft = 30
          , marginRight = 5
          , responsive = True
          , id = "you-should-really-set-the-id-of-your-chart"
          , range = { min = 1, max = 100 }
          , domain = { min = 1, max = 100 }
          , attrs = []
          , htmlAttrs = []
          }

      plane = -- TODO use config / system directly instead
        { x =
            { marginLower = config.marginLeft
            , marginUpper = config.marginRight
            , length = config.width
            , min = config.range.min
            , max = config.range.max
            }
        , y =
            { marginUpper = config.marginTop
            , marginLower = config.marginBottom
            , length = config.height
            , min = config.range.min
            , max = config.range.max
            }
        }

      ( _, ( htmlElsBefore, svgEls, htmlElsAfter ) ) =
        List.foldl buildElement ( True, ([], [], []) ) elements

      buildElement el ( isBeforeChart, ( htmlB, svgE, htmlA ) ) =
        case el of
          SvgElement func ->
            ( False, ( htmlB, svgE ++ [ func plane ], htmlA ) )

          HtmlElement func ->
            ( isBeforeChart
            , if isBeforeChart
              then ( htmlB ++ [ func plane ], svgE, htmlA )
              else ( htmlB, svgE, htmlA ++ [ func plane ] )
            )

      svgContainer els =
        S.svg (sizingAttrs ++ config.attrs) <|
          C.frame config.id plane :: els ++ [ C.eventCatcher plane [] ]

      sizingAttrs =
        if config.responsive
        then [ C.responsive plane ]
        else C.static plane

  in
  C.container plane config.htmlAttrs <|
    htmlElsBefore ++ [ svgContainer svgEls ] ++ htmlElsAfter



{-| -}
type Element msg
    = SvgElement (C.Plane -> S.Svg msg)
    | HtmlElement (C.Plane -> H.Html msg)


{-| -}
type alias Axis msg =
    { start : Bounds -> Float
    , end : Bounds -> Float
    , pinned : Bounds -> Float
    -- TODO , withArrow : Bool
    , color : String -- TODO use Color
    , attrs : List (S.Attribute msg)
    }


{-| -}
xAxis : List (Axis msg -> Axis msg) -> Element msg
xAxis edits =
  let config =
        applyAttrs edits
          { start = .min
          , end = .max
          , pinned = .min
          , color = "lightgray"
          , attrs = []
          }
  in
  SvgElement <| \p ->
    C.horizontal p ([ SA.fill config.color ] ++ config.attrs) (config.pinned <| toBounds .y p) (config.start <| toBounds .x p) (config.end <| toBounds .x p)


yAxis : List (Axis msg -> Axis msg) -> Element msg
yAxis edits =
  let config =
        applyAttrs edits
          { start = .min
          , end = .max
          , pinned = .min
          , color = "lightgray"
          , attrs = []
          }
  in
  SvgElement <| \p ->
    C.vertical p ([ SA.fill config.color ] ++ config.attrs) (config.pinned <| toBounds .x p) (config.start <| toBounds .y p) (config.end <| toBounds .y p)



type alias Tick msg =
    { color : String -- TODO use Color -- TODO allow custom color by tick value
    , height : Float
    , width : Float
    , pinned : Bounds -> Float
    , attrs : List (S.Attribute msg)
    -- TODO , offset : Float
    }


xTicks : (a -> Float) -> List (Tick msg -> Tick msg) -> List a -> Element msg
xTicks value edits xs =
  let config =
        applyAttrs edits
          { color = "lightgray"
          , pinned = .min
          , height = 5
          , width = 1
          , attrs = []
          -- , offset = 0
          }

      labelAttrs =
        [ SA.stroke config.color
        , SA.strokeWidth (String.fromFloat config.width)
        ] ++ config.attrs
  in
  SvgElement <| \p ->
    C.xTicks p (round config.height) labelAttrs (config.pinned <| toBounds .y p) (List.map value xs)



yTicks : (a -> Float) -> List (Tick msg -> Tick msg) -> List a -> Element msg
yTicks value edits xs =
  let config =
        applyAttrs edits
          { color = "lightgray"
          , pinned = .min
          , height = 5
          , width = 1
          , attrs = []
          --, offset = 0
          }

      labelAttrs =
        [ SA.stroke config.color
        , SA.strokeWidth (String.fromFloat config.width)
        ] ++ config.attrs
  in
  SvgElement <| \p ->
    C.xTicks p (round config.height) labelAttrs (config.pinned <| toBounds .x p) (List.map value xs)



type alias Label msg =
    { color : String -- TODO use Color
    , pinned : Bounds -> Float
    , attrs : List (S.Attribute msg)
    -- TODO , xOffset : Float
    -- TODO , yOffset : Float
    }


xLabels : (a -> Float) -> (a -> String) -> List (Label msg -> Label msg) -> List a -> Element msg
xLabels value format edits xs =
  let config =
        applyAttrs edits
          { color = "lightgray"
          , pinned = .min
          , attrs = []
          }

      labelAttrs =
        [ SA.fill config.color
        ] ++ config.attrs
  in
  SvgElement <| \p ->
    C.xLabels p (C.xLabel labelAttrs value format) (config.pinned <| toBounds .y p) xs


yLabels : (a -> Float) -> (a -> String) -> List (Label msg -> Label msg) -> List a -> Element msg
yLabels value format edits xs =
  let config =
        applyAttrs edits
          { color = "lightgray"
          , pinned = .min
          , attrs = []
          }

      labelAttrs =
        [ SA.fill config.color
        ] ++ config.attrs
  in
  SvgElement <| \p ->
    C.yLabels p (C.yLabel labelAttrs value format) (config.pinned <| toBounds .x p) xs


type alias Grid msg =
    { color : String -- TODO use Color
    , width : Float
    , attrs : List (S.Attribute msg)
    -- TODO , dotted : Bool
    }


grid : (x -> Float) -> (y -> Float) -> List (Grid msg -> Grid msg) -> List x -> List y -> Element msg
grid toX toY edits xs ys =
  let config =
        applyAttrs edits
          { color = "lightgray"
          , width = 1
          , attrs = []
          -- , dotted = False
          }

      gridAttrs =
        [ SA.stroke config.color
        , SA.strokeWidth (String.fromFloat config.width)
        ] ++ config.attrs

      toXGrid p v =
        C.xGrid p gridAttrs (toY v)

      toYGrid p v =
        C.yGrid p gridAttrs (toX v)
  in
  SvgElement <| \p ->
    S.g [ SA.class "elm-charts__grid" ]
      [ S.g [ SA.class "elm-charts__x-grid" ] (List.map (toXGrid p) ys)
      , S.g [ SA.class "elm-charts__y-grid" ] (List.map (toYGrid p) xs)
      ]


type alias Interpolation msg =
    { color : String -- TODO use Color
    , width : Float
    , attrs : List (S.Attribute msg)
    }


monotone : (data -> Float) -> (data -> Float) -> (data -> C.Dot msg) -> List (Interpolation msg -> Interpolation msg) -> List data -> Element msg
monotone toX toY dot edits data =
  -- TODO add clip path
  let config =
        applyAttrs edits
          { color = "blue" -- TODO
          , width = 1
          , attrs = []
          }

      interAttrs =
        [ SA.stroke config.color
        , SA.strokeWidth (String.fromFloat config.width)
        ] ++ config.attrs
  in
  SvgElement <| \p ->
    C.monotone p toX toY interAttrs dot data


linear : (data -> Float) -> (data -> Float) -> (data -> C.Dot msg) -> List (Interpolation msg -> Interpolation msg) -> List data -> Element msg
linear toX toY dot edits data =
  let config =
        applyAttrs edits
          { color = "blue" -- TODO
          , width = 1
          , attrs = []
          }

      interAttrs =
        [ SA.stroke config.color
        , SA.strokeWidth (String.fromFloat config.width)
        ] ++ config.attrs
  in
  SvgElement <| \p ->
    C.linear p toX toY interAttrs dot data



-- HELPERS


toBounds : (C.Plane -> C.Axis) -> C.Plane -> Bounds
toBounds toA plane =
  let { min, max } = toA plane
  in { min = min, max = max }


applyAttrs : List (a -> a) -> a -> a
applyAttrs funcs default =
  let apply f a = f a in
  List.foldl apply default funcs

