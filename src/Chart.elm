module Chart exposing (..)
    --  chart, linear, monotone
    --, xAxis, yAxis, xTicks, yTicks, xLabels, yLabels, grid
    --)


import Svg.Chart as C
import Svg.Coordinates as C
import Svg as S
import Svg.Attributes as SA
import Svg.Events as SE
import Html as H
import Html.Attributes as HA
import Intervals as I
import Time



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


events : List (Event msg) -> { a | events : List (Event msg) } -> { a | events : List (Event msg) }
events value config =
  { config | events = value }


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


dot : (data -> C.Dot msg) -> { a | dot : Tracked (data -> C.Dot msg) } -> { a | dot : Tracked (data -> C.Dot msg) }
dot value config =
  { config | dot = Changed value }


dotted : { a | dotted : Bool } -> { a | dotted : Bool }
dotted config =
  { config | dotted = True }


area : String -> { a | area : Maybe String } -> { a | area : Maybe String }
area value config =
  { config | area = Just value }




-- ELEMENTS


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
    , events : List (Event msg)
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
          , events = []
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
        S.svg (sizingAttrs ++ List.map toEvent config.events ++ config.attrs) <|
          C.frame config.id plane :: els ++ [ C.eventCatcher plane [] ]

      sizingAttrs =
        if config.responsive
        then [ C.responsive plane ]
        else C.static plane

      toEvent e =
        SE.on e.name (C.decodePoint plane e.msg)
  in
  C.container plane config.htmlAttrs <|
    htmlElsBefore ++ [ svgContainer svgEls ] ++ htmlElsAfter



{-| -}
type Element msg
    = SvgElement (C.Plane -> S.Svg msg)
    | HtmlElement (C.Plane -> H.Html msg)


{-| -}
type alias Event msg =
  { name : String
  , msg : C.Plane -> C.Point -> msg
  }


{-| -}
event : String -> (C.Plane -> C.Point -> msg) -> Event msg
event =
  Event


{-| -}
getNearest : (Maybe data -> msg) -> (data -> Float) -> (data -> Float) -> List data -> C.Plane -> C.Point -> msg
getNearest toMsg toX toY data plane point =
  let points = C.toDataPoints toX toY data in
  toMsg (C.getNearest points plane point)


{-| -}
getWithin : (Maybe data -> msg) -> Float -> (data -> Float) -> (data -> Float) -> List data -> C.Plane -> C.Point -> msg
getWithin toMsg radius toX toY data plane point =
  let points = C.toDataPoints toX toY data in
  toMsg (C.getWithin radius points plane point)


{-| -}
getNearestX : (List data -> msg) -> (data -> Float) -> (data -> Float) -> List data -> C.Plane -> C.Point -> msg
getNearestX toMsg toX toY data plane point =
  let points = C.toDataPoints toX toY data in
  toMsg (C.getNearestX points plane point)


{-| -}
getWithinX : (List data -> msg) -> Float -> (data -> Float) -> (data -> Float) -> List data -> C.Plane -> C.Point -> msg
getWithinX toMsg radius toX toY data plane point =
  let points = C.toDataPoints toX toY data in
  toMsg (C.getWithinX radius points plane point)


{-| -}
tooltip : Float -> Float -> List (H.Attribute msg) -> List (H.Html msg) -> Element msg
tooltip x y att content =
  html <| \p -> C.tooltip p x y att content




-- AXIS


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
          , color = "rgb(210, 210, 210)"
          , attrs = []
          }
  in
  SvgElement <| \p ->
    C.horizontal p ([ SA.stroke config.color ] ++ config.attrs) (config.pinned <| toBounds .y p) (config.start <| toBounds .x p) (config.end <| toBounds .x p)


yAxis : List (Axis msg -> Axis msg) -> Element msg
yAxis edits =
  let config =
        applyAttrs edits
          { start = .min
          , end = .max
          , pinned = .min
          , color = "rgb(210, 210, 210)"
          , attrs = []
          }
  in
  SvgElement <| \p ->
    C.vertical p ([ SA.stroke config.color ] ++ config.attrs) (config.pinned <| toBounds .x p) (config.start <| toBounds .y p) (config.end <| toBounds .y p)


ints : Int -> (Int -> String) -> Bounds -> List { value : Float, label : String }
ints amount format =
  I.ints (I.around amount) >> List.map (\i -> { value = toFloat i, label = format i })


floats : Int -> (Float -> String) -> Bounds -> List { value : Float, label : String }
floats amount format =
  I.floats (I.around amount) >> List.map (\i -> { value = i, label = format i })


times : Time.Zone -> Int -> (I.Time -> String) -> Bounds -> List { value : Float, label : String }
times zone amount format bounds =
  I.times zone amount bounds
    |> List.map (\i -> { value = toFloat (Time.posixToMillis i.timestamp), label = format i })



type alias Tick msg =
    { color : String -- TODO use Color -- TODO allow custom color by tick value
    , height : Float
    , width : Float
    , pinned : Bounds -> Float
    , attrs : List (S.Attribute msg)
    -- TODO , offset : Float
    }


xTicks : List (Tick msg -> Tick msg) -> (Bounds -> List { a | value : Float }) -> Element msg
xTicks edits xs =
  let config =
        applyAttrs edits
          { color = "rgb(210, 210, 210)"
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
    C.xTicks p (round config.height) labelAttrs (config.pinned <| toBounds .y p) (List.map .value <| xs <| toBounds .x p)



yTicks : List (Tick msg -> Tick msg) -> (Bounds -> List { a | value : Float }) -> Element msg
yTicks edits xs =
  let config =
        applyAttrs edits
          { color = "rgb(210, 210, 210)"
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
    C.xTicks p (round config.height) labelAttrs (config.pinned <| toBounds .x p) (List.map .value <| xs <| toBounds .y p)



type alias Label msg =
    { color : String -- TODO use Color
    , pinned : Bounds -> Float
    , attrs : List (S.Attribute msg)
    -- TODO , xOffset : Float
    -- TODO , yOffset : Float
    }


xLabels : List (Label msg -> Label msg) -> (Bounds -> List { a | value : Float, label : String }) -> Element msg
xLabels edits xs =
  let config =
        applyAttrs edits
          { color = "#808BAB"
          , pinned = .min
          , attrs = []
          }

      labelAttrs =
        [ SA.fill config.color
        ] ++ config.attrs
  in
  SvgElement <| \p ->
    C.xLabels p (C.xLabel labelAttrs .value .label) (config.pinned <| toBounds .y p) (xs <| toBounds .x p)


yLabels : List (Label msg -> Label msg) -> (Bounds -> List { a | value : Float, label : String }) -> Element msg
yLabels edits xs =
  let config =
        applyAttrs edits
          { color = "#808BAB"
          , pinned = .min
          , attrs = []
          }

      labelAttrs =
        [ SA.fill config.color
        ] ++ config.attrs
  in
  SvgElement <| \p ->
    C.yLabels p (C.yLabel labelAttrs .value .label) (config.pinned <| toBounds .x p) (xs <| toBounds .y p)


type alias Grid msg =
    { color : String -- TODO use Color
    , width : Float
    , attrs : List (S.Attribute msg)
    , dotted : Bool
    }


grid : List (Grid msg -> Grid msg) -> (Bounds -> List { a | value : Float }) -> (Bounds -> List { a | value : Float }) -> Element msg
grid edits xs ys =
  let config =
        applyAttrs edits
          { color = "#EFF2FA"
          , width = 1
          , attrs = []
          , dotted = False
          }

      gridAttrs =
        [ SA.stroke config.color
        , SA.strokeWidth (String.fromFloat config.width)
        ] ++ config.attrs

      toXGrid p v =
        C.xGrid p gridAttrs v.value

      toYGrid p v =
        C.yGrid p gridAttrs v.value

      toDot p x y =
        C.full config.width C.circle config.color p x.value y.value
  in
  SvgElement <| \p ->
    S.g [ SA.class "elm-charts__grid" ] <|
      if config.dotted then
        List.concatMap (\x -> List.map (toDot p x) (ys <| toBounds .y p)) (xs <| toBounds .x p)
      else
        [ S.g [ SA.class "elm-charts__x-grid" ] (List.map (toXGrid p) <| ys <| toBounds .y p)
        , S.g [ SA.class "elm-charts__y-grid" ] (List.map (toYGrid p) <| xs <| toBounds .x p)
        ]



-- SERIES


type alias Scatter data msg =
    { color : String -- TODO use Color
    , dot : Tracked (data -> C.Dot msg)
    }


scatter : (data -> Float) -> (data -> Float) -> List (Scatter data msg -> Scatter data msg) -> List data -> Element msg
scatter toX toY edits data =
  -- TODO add clip path
  let config =
        applyAttrs edits
          { color = "rgb(5,142,218)" -- TODO
          , dot = Unchanged (\_ -> C.disconnected 6 1 C.cross "rgb(5,142,218)")
          }

      finalDot =
        case config.dot of -- TODO use inheritance instead?
          Unchanged _ -> \_ -> C.disconnected 6 1 C.cross config.color
          Changed d -> d
  in
  SvgElement <| \p ->
    C.scatter p toX toY finalDot data



type alias Interpolation data msg =
    { color : String -- TODO use Color
    , area : Maybe String -- TODO use Color
    , width : Float
    , dot : Tracked (data -> C.Dot msg)
    , attrs : List (S.Attribute msg)
    }


type Tracked a
  = Changed a
  | Unchanged a


monotone : (data -> Float) -> (data -> Float) -> List (Interpolation data msg -> Interpolation data msg) -> List data -> Element msg
monotone toX toY edits data =
  -- TODO add clip path
  let config =
        applyAttrs edits
          { color = "rgb(5,142,218)" -- TODO
          , area = Nothing
          , width = 1
          , dot = Unchanged (\_ -> C.disconnected 6 1 C.cross "rgb(5,142,218)")
          , attrs = []
          }

      interAttrs =
        [ SA.stroke config.color
        , SA.strokeWidth (String.fromFloat config.width)
        ] ++ config.attrs

      finalDot =
        case config.dot of -- TODO use inheritance instead?
          Unchanged _ -> \_ -> C.disconnected 6 1 C.cross config.color
          Changed d -> d
  in
  SvgElement <| \p ->
    case config.area of
      Just fill ->
        S.g [ SA.class "elm-charts__linear-area" ]
          [ C.monotoneArea p toX toY (interAttrs ++ [ SA.stroke "transparent", SA.fill fill ]) finalDot data
          , C.monotone p toX toY interAttrs finalDot data
          ]

      Nothing ->
        C.monotone p toX toY interAttrs finalDot data


linear : (data -> Float) -> (data -> Float) -> List (Interpolation data msg -> Interpolation data msg) -> List data -> Element msg
linear toX toY edits data =
  let config =
        applyAttrs edits
          { color = "rgb(5,142,218)" -- TODO
          , area = Nothing
          , width = 1
          , dot = Unchanged (\_ -> C.disconnected 6 1 C.cross "rgb(5,142,218)")
          , attrs = []
          }

      interAttrs =
        [ SA.stroke config.color
        , SA.strokeWidth (String.fromFloat config.width)
        ] ++ config.attrs

      finalDot =
        case config.dot of
          Unchanged _ -> \_ -> C.disconnected 6 1 C.cross config.color
          Changed d -> d
  in
  SvgElement <| \p ->
    case config.area of
      Just fill ->
        S.g [ SA.class "elm-charts__linear-area" ]
          [ C.linearArea p toX toY (interAttrs ++ [ SA.stroke "transparent", SA.fill fill ]) finalDot data
          , C.linear p toX toY interAttrs finalDot data
          ]

      Nothing ->
        C.linear p toX toY interAttrs finalDot data



svg : (C.Plane -> S.Svg msg) -> Element msg
svg =
  SvgElement


html : (C.Plane -> H.Html msg) -> Element msg
html =
  HtmlElement


svgAt : Float -> Float -> Float -> Float -> List (S.Svg msg) -> Element msg
svgAt x y xOff yOff view =
  SvgElement <| \p ->
    S.g [ C.position p x y xOff yOff ] view


htmlAt : Float -> Float -> Float -> Float -> List (H.Attribute msg) -> List (H.Html msg) -> Element msg
htmlAt x y xOff yOff att view =
  HtmlElement <| \p ->
    C.positionHtml p x y xOff yOff att view


none : Element msg
none =
  HtmlElement (\_ -> H.text "")



-- HELPERS


toBounds : (C.Plane -> C.Axis) -> C.Plane -> Bounds
toBounds toA plane =
  let { min, max } = toA plane
  in { min = min, max = max }


applyAttrs : List (a -> a) -> a -> a
applyAttrs funcs default =
  let apply f a = f a in
  List.foldl apply default funcs

