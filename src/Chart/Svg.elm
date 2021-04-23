module Chart.Svg exposing
  ( Container, Event, container
  , Line, line
  , Tick, xTick, yTick
  , Label, label
  , Arrow, arrow
  , Bar, bar
  , Interpolation, interpolation, area
  , Dot, dot, toRadius
  , Tooltip, tooltip
  , decoder, getNearest, getNearestX, getWithin, getWithinX, isWithinPlane
  , position, positionHtml
  , Bounds, produce, floats, ints, times
  , TickValue, toTickValues, formatTime
  , blue, pink, orange, green, purple, red
  )

import Html as H exposing (Html)
import Html.Attributes as HA
import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Svg.Events as SE
import Svg.Coordinates as Coord exposing (Point, Position, Plane, place, toSVGX, toSVGY, toCartesianX, toCartesianY, scaleSVG, scaleCartesian, placeWithOffset)
import Svg.Commands as C exposing (..)
import Chart.Attributes as CA
import Internal.Interpolation as Interpolation
import Intervals as I
import Json.Decode as Json
import DOM
import Time
import DateFormat as F
import Dict exposing (Dict)


-- TODO clean up plane
-- TODO clean up property



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
container plane edits below chartEls above =
  -- TODO seperate plane from container size
  let config =
        apply edits
          { attrs = []
          , htmlAttrs = []
          , responsive = True
          , events = []
          }

      htmlAttrsDef =
        [ HA.class "elm-charts__container"
        , HA.style "position" "relative"
        ]

      htmlAttrsSize =
        if config.responsive then
          []
        else
          [ HA.style "width" (String.fromFloat plane.x.length ++ "px")
          , HA.style "height" (String.fromFloat plane.y.length ++ "px")
          ]

      htmlAttrs =
        config.htmlAttrs ++ htmlAttrsDef ++ htmlAttrsSize

      chart =
        S.svg
          (svgAttrsSize ++ config.attrs)
          (chartEls ++ [catcher])

      svgAttrsSize =
        if config.responsive then
          [ SA.viewBox ("0 0 " ++ String.fromFloat plane.x.length ++ " " ++ String.fromFloat plane.y.length) ]
        else
          [ SA.width (String.fromFloat plane.x.length)
          , SA.height (String.fromFloat plane.y.length)
          ]

      catcher =
        S.rect (chartPosition ++ List.map toEvent config.events) []

      toEvent event =
        SE.on event.name (decoder plane event.handler)

      chartPosition =
        [ SA.x (String.fromFloat plane.x.marginLower)
        , SA.y (String.fromFloat plane.y.marginUpper)
        , SA.width (String.fromFloat (plane.x.length - plane.x.marginLower - plane.x.marginUpper))
        , SA.height (String.fromFloat (plane.y.length - plane.y.marginLower - plane.y.marginUpper))
        , SA.fill "transparent"
        ]
  in
  H.div htmlAttrs (below ++ [ chart ] ++ above)



-- TICK


{-| -}
type alias Tick =
  { color : String
  , width : Float
  , length : Float
  }


{-| -}
xTick : Plane -> List (CA.Attribute Tick) -> Point -> Svg msg
xTick plane edits point =
  tick plane edits True point


{-| -}
yTick : Plane -> List (CA.Attribute Tick) -> Point -> Svg msg
yTick plane edits point =
  tick plane edits False point


tick : Plane -> List (CA.Attribute Tick) -> Bool -> Point -> Svg msg
tick plane edits isX point =
  let config =
        apply edits
          { length = 5
          , color = "rgb(210, 210, 210)"
          , width = 1
          }
  in
  S.line
    [ SA.class "elm-charts__tick"
    , SA.stroke config.color
    , SA.strokeWidth (String.fromFloat config.width)
    , SA.x1 <| String.fromFloat (toSVGX plane point.x)
    , SA.x2 <| String.fromFloat (toSVGX plane point.x + if isX then 0 else -config.length)
    , SA.y1 <| String.fromFloat (toSVGY plane point.y)
    , SA.y2 <| String.fromFloat (toSVGY plane point.y + if isX then config.length else 0)
    ]
    []



-- LINE


{-| -}
type alias Line =
  { x1 : Maybe Float
  , x2 : Maybe Float
  , y1 : Maybe Float
  , y2 : Maybe Float
  , color : String
  , width : Float
  , dashed : List Float
  }


{-| -}
line : Plane -> List (CA.Attribute Line) -> Svg msg
line plane edits =
  let config =
        apply edits
          { x1 = Nothing
          , x2 = Nothing
          , y1 = Nothing
          , y2 = Nothing
          , color = "rgb(210, 210, 210)"
          , width = 1
          , dashed = []
          }

      ( ( x1_, x2_ ), ( y1_, y2_ ) ) =
        case ( ( config.x1, config.x2 ), ( config.y1, config.y2 ) ) of
          -- ONLY X
          ( ( Just a, Just b ), ( Nothing, Nothing ) ) ->
            ( ( a, b ), ( plane.y.min, plane.y.min ) )

          ( ( Just a, Nothing ), ( Nothing, Nothing ) ) ->
            ( ( a, a ), ( plane.y.min, plane.y.max ) )

          ( ( Nothing, Just b ), ( Nothing, Nothing ) ) ->
            ( ( b, b ), ( plane.y.min, plane.y.max ) )

          -- ONLY Y
          ( ( Nothing, Nothing ), ( Just a, Just b ) ) ->
            ( ( plane.x.min, plane.x.min ), ( a, b ) )

          ( ( Nothing, Nothing ), ( Just a, Nothing ) ) ->
            ( ( plane.x.min, plane.x.max ), ( a, a ) )

          ( ( Nothing, Nothing ), ( Nothing, Just b ) ) ->
            ( ( plane.x.min, plane.x.max ), ( b, b ) )

          -- MIXED

          ( ( Nothing, Just c ), ( Just a, Just b ) ) ->
            ( ( c, c ), ( a, b ) )

          ( ( Just c, Nothing ), ( Just a, Just b ) ) ->
            ( ( c, c ), ( a, b ) )

          ( ( Just a, Just b ), ( Nothing, Just c ) ) ->
            ( ( a, b ), ( c, c ) )

          ( ( Just a, Just b ), ( Just c, Nothing ) ) ->
            ( ( a, b ), ( c, c ) )

          -- NEITHER
          ( ( Nothing, Nothing ), ( Nothing, Nothing ) ) ->
            ( ( plane.x.min, plane.x.max ), ( plane.y.min, plane.y.max ) )

          _ ->
            ( ( Maybe.withDefault plane.x.min config.x1
              , Maybe.withDefault plane.x.max config.x2
              )
            , ( Maybe.withDefault plane.y.min config.y1
              , Maybe.withDefault plane.y.max config.y2
              )
            )

      cmds =
        [ C.Move x1_ y1_
        , C.Line x1_ y1_
        , C.Line x2_ y2_
        ]
  in
  S.path
    [ SA.class "elm-charts__line"
    , SA.stroke config.color
    , SA.strokeWidth (String.fromFloat config.width)
    , SA.strokeDasharray (String.join " " <| List.map String.fromFloat config.dashed)
    , SA.d (C.description plane cmds)
    ]
    []



-- LABEL


{-| -}
type alias Label =
  { xOff : Float
  , yOff : Float
  , border : String
  , borderWidth : Float
  , fontSize : Maybe Int
  , color : String
  , anchor : CA.Anchor
  , rotate : Float
  }


{-| -}
label : Plane -> List (CA.Attribute Label) -> String -> Point -> Svg msg
label plane edits string point =
  let config =
        apply edits
          { xOff = 0
          , yOff = 0
          , border = "white"
          , borderWidth = 0.1
          , fontSize = Nothing
          , color = "#808BAB"
          , anchor = CA.Middle
          , rotate = 0
          }

      fontStyle =
        case config.fontSize of
          Just size_ -> "font-size: " ++ String.fromInt size_ ++ ";"
          Nothing -> ""

      anchorStyle =
        case config.anchor of
          CA.End -> "text-anchor: end;"
          CA.Start -> "text-anchor: start;"
          CA.Middle -> "text-anchor: middle;"
  in
  S.text_
    [ SA.class "elm-charts__label"
    , SA.stroke config.border
    , SA.strokeWidth (String.fromFloat config.borderWidth)
    , SA.fill config.color
    , position plane -config.rotate point.x point.y config.xOff config.yOff
    , SA.style <| String.join " " [ "pointer-events: none;", fontStyle, anchorStyle ]
    ]
    [ S.tspan [] [ S.text string ] ]



-- ARROW


{-| -}
type alias Arrow =
  { xOff : Float
  , yOff : Float
  , color : String
  , width : Float
  , length : Float
  , rotate : Float
  }


{-| -}
arrow : Plane -> List (CA.Attribute Arrow) -> Point -> Svg msg
arrow plane edits point =
  let config =
        apply edits
          { xOff = 0
          , yOff = 0
          , color = "rgb(210, 210, 210)"
          , width = 4
          , length = 7
          , rotate = 0
          }

      points_ =
        "0,0 " ++ String.fromFloat config.length ++ "," ++ String.fromFloat config.width ++ " 0, " ++ String.fromFloat (config.width * 2)

      commands =
        "rotate(" ++ String.fromFloat config.rotate ++ ") translate(0 " ++ String.fromFloat -config.width ++ ") "
  in
  S.g
    [ SA.class "elm-charts__arrow"
    , position plane 0 point.x point.y config.xOff config.yOff
    ]
    [ S.polygon
        [ SA.fill config.color
        , SA.points points_
        , SA.transform commands
        ]
        []
    ]



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
  -- TODO aura
  }


{-| -}
bar : Plane -> List (CA.Attribute Bar) -> Position -> Svg msg
bar plane edits point =
  -- TODO round via clipPath
  let config =
        apply edits
          { roundTop = 0
          , roundBottom = 0
          , border = "white"
          , borderWidth = 0
          , color = blue
          , opacity = 1
          , design = Nothing
          }

      x1_ = point.x1 + scaleCartesian plane.x (config.borderWidth / 2)
      x2_ = point.x2 - scaleCartesian plane.x (config.borderWidth / 2)
      y1_ = point.y1 + scaleCartesian plane.y (config.borderWidth / 2)
      y2_ = point.y2 - scaleCartesian plane.y (config.borderWidth / 2)

      x_ = x1_
      y_ = max y1_ y2_
      bs = min y1_ y2_
      w = x2_ - x_
      bT = scaleSVG plane.x w * 0.5 * (clamp 0 1 config.roundTop)
      bB = scaleSVG plane.x w * 0.5 * (clamp 0 1 config.roundBottom)
      ys = abs (scaleSVG plane.y y_)
      rxT = scaleCartesian plane.x bT
      ryT = scaleCartesian plane.y bT
      rxB = scaleCartesian plane.x bB
      ryB = scaleCartesian plane.y bB

      commands =
        if bs == y_ then
          []
        else
          case ( config.roundTop > 0, config.roundBottom > 0 ) of
            ( False, False ) ->
              [ C.Move x_ bs
              , C.Line x_ y_
              , C.Line (x_ + w) y_
              , C.Line (x_ + w) bs
              , C.Line x_ bs
              ]

            ( True, False ) ->
              [ C.Move x_ bs
              , C.Line x_ (y_ + -ryT)
              , C.Arc bT bT -45 False True (x_ + rxT) y_
              , C.Line (x_ + w - rxT) y_
              , C.Arc bT bT -45 False True (x_ + w) (y_ + -ryT)
              , C.Line (x_ + w) bs
              , C.Line x_ bs
              ]

            ( False, True ) ->
              [ C.Move (x_ + rxB) bs
              , C.Arc bB bB -45 False True x_ (bs + ryB)
              , C.Line x_ y_
              , C.Line (x_ + w) y_
              , C.Line (x_ + w) (bs + ryB)
              , C.Arc bB bB -45 False True (x_ + w - rxB) bs
              , C.Line (x_ + rxB) bs
              ]

            ( True, True ) ->
              [ C.Move (x_ + rxB) bs
              , C.Arc bB bB -45 False True x_ (bs + ryB)
              , C.Line x_ (y_ - ryT)
              , C.Arc bT bT -45 False True (x_ + rxT) y_
              , C.Line (x_ + w - rxT) y_
              , C.Arc bT bT -45 False True (x_ + w) (y_ - ryT)
              , C.Line (x_ + w) (bs + ryB)
              , C.Arc bB bB -45 False True (x_ + w - rxB) bs
              , C.Line (x_ + rxB) bs
              ]

      actualBar fill =
        S.path
          [ SA.class "elm-charts__bar"
          , SA.fill fill
          , SA.fillOpacity (String.fromFloat config.opacity)
          , SA.stroke config.border
          , SA.strokeWidth (String.fromFloat config.borderWidth)
          , SA.d (C.description plane commands)
          , SA.style (clipperStyle plane x1_ x2_ bs y_)
          ]
          []
  in
  case config.design of
    Nothing ->
      actualBar config.color

    Just design ->
      let ( patternDefs, fill ) = toPattern config.color design in
      S.g
        [ SA.class "elm-charts__bar-with-pattern" ]
        [ patternDefs
        , actualBar fill
        ]



-- SERIES


{-| -}
type alias Interpolation =
  { method : Maybe CA.Method
  , color : String
  , width : Float
  , opacity : Float
  , design : Maybe CA.Design
  , dashed : List Float
  }


{-| -}
interpolation : Plane -> (data -> Float) -> (data -> Maybe Float) -> List (CA.Attribute Interpolation) -> List data -> Svg msg
interpolation plane toX toY edits data =
  let config =
        apply edits
          { method = Nothing
          , color = blue
          , width = 1
          , opacity = 0
          , design = Nothing
          , dashed = []
          }

      minX = Coord.minimum [toX >> Just] data
      maxX = Coord.maximum [toX >> Just] data
      minY = Coord.minimum [toY] data
      maxY = Coord.maximum [toY] data

      view ( first, cmds, _ ) =
        S.path
          [ SA.class "elm-charts__interpolation-section"
          , SA.fill "transparent"
          , SA.stroke config.color
          , SA.strokeDasharray (String.join " " <| List.map String.fromFloat config.dashed)
          , SA.strokeWidth (String.fromFloat config.width)
          , SA.d (C.description plane (Move first.x first.y :: cmds))
          , SA.style (clipperStyle plane minX maxX minY maxY)
          ]
          []
  in
  case config.method of
    Nothing -> S.text ""
    Just method ->
      S.g [ SA.class "elm-charts__interpolation-sections" ] <|
        List.map view (toCommands method toX toY data)


{-| -}
area : Plane -> (data -> Float) -> Maybe (data -> Maybe Float) -> (data -> Maybe Float) -> List (CA.Attribute Interpolation) -> List data -> Svg msg
area plane toX toY2M toY edits data =
  let config =
        apply edits
          { method = Nothing
          , color = blue
          , width = 1
          , opacity = 0.2
          , design = Nothing
          , dashed = []
          }

      minX = Coord.minimum [toX >> Just] data
      maxX = Coord.maximum [toX >> Just] data
      minY = Coord.minimum [toY, Maybe.withDefault (always (Just 0)) toY2M] data
      maxY = Coord.maximum [toY, Maybe.withDefault (always (Just 0)) toY2M] data


      ( patternDefs, fill ) =
        case config.design of
          Nothing -> ( S.text "", config.color )
          Just design -> toPattern config.color design

      view cmds =
        S.path
          [ SA.class "elm-charts__area-section"
          , SA.fill fill
          , SA.fillOpacity (String.fromFloat config.opacity)
          , SA.strokeWidth "0"
          , SA.fillRule "evenodd"
          , SA.d (C.description plane cmds)
          , SA.style (clipperStyle plane minX maxX minY maxY)
          ]
          []

      withoutUnder ( first, cmds, end ) =
        view <|
          [ C.Move first.x 0, C.Line first.x first.y ] ++ cmds ++ [ C.Line end.x 0 ]

      withUnder ( firstBottom, cmdsBottom, endBottom ) ( firstTop, cmdsTop, endTop ) =
        view <|
          [ C.Move firstBottom.x firstBottom.y, C.Line firstTop.x firstTop.y ] ++ cmdsTop ++
          [ C.Move firstBottom.x firstBottom.y ] ++ cmdsBottom ++ [ C.Line endTop.x endTop.y ]
  in
  if config.opacity <= 0 then S.text "" else
  case config.method of
    Nothing -> S.text ""
    Just method ->
      S.g [ SA.class "elm-charts__area-sections" ] <|
        case toY2M of
          Nothing -> patternDefs :: List.map withoutUnder (toCommands method toX toY data)
          Just toY2 -> patternDefs :: List.map2 withUnder (toCommands method toX toY2 data) (toCommands method toX toY data)


toCommands : CA.Method -> (data -> Float) -> (data -> Maybe Float) -> List data -> List ( Point, List C.Command, Point )
toCommands method toX toY data =
  let fold datum_ acc =
        case toY datum_ of
          Just y_ ->
            case acc of
              latest :: rest -> (latest ++ [ { x = toX datum_, y = y_ } ]) :: rest
              [] -> [ { x = toX datum_, y = y_ } ] :: acc

          Nothing ->
            [] :: acc

      points =
        List.reverse (List.foldl fold [] data)

      commands =
        case method of
          CA.Linear -> Interpolation.linear points
          CA.Monotone -> Interpolation.monotone points

      toSets ps cmds =
        withBorder ps <| \first last_ -> ( first, cmds, last_ )
  in
  List.map2 toSets points commands
    |> List.filterMap identity



-- PATTERN


toPattern : String -> CA.Design -> ( S.Svg msg, String )
toPattern defaultColor design =
  let toPatternId props =
        String.replace "(" "-" <|
        String.replace ")" "-" <|
        String.replace "." "-" <|
        String.replace "," "-" <|
        String.replace " " "-" <|
        String.join "-" <|
          [ "elm-charts__pattern"
          , case design of
              CA.Striped _ -> "striped"
              CA.Dotted _ -> "dotted"
              CA.Gradient _ -> "gradient"
          ] ++ props

      toPatternDefs id space rotate inside =
        S.defs []
          [ S.pattern
              [ SA.id id
              , SA.patternUnits "userSpaceOnUse"
              , SA.width (String.fromFloat space)
              , SA.height (String.fromFloat space)
              , SA.patternTransform ("rotate(" ++ String.fromFloat rotate ++ ")")
              ]
              [ inside ]
          ]

      ( patternDefs, patternId ) =
        case design of
          CA.Striped edits ->
            let config =
                  apply edits
                    { color = defaultColor
                    , width = 5
                    , space = 5
                    , rotate = 0
                    }

                theId =
                  toPatternId
                    [ config.color
                    , String.fromFloat config.width
                    , String.fromFloat config.space
                    , String.fromFloat config.rotate
                    ]
            in
            ( toPatternDefs theId config.space config.rotate <|
                S.line
                  [ SA.x1 "0"
                  , SA.y "0"
                  , SA.x2 "0"
                  , SA.y2 (String.fromFloat config.space)
                  , SA.stroke config.color
                  , SA.strokeWidth (String.fromFloat config.width)
                  ]
                  []
            , theId
            )


          CA.Dotted edits ->
            let config =
                  apply edits
                    { color = defaultColor
                    , width = 5
                    , space = 5
                    , rotate = 0
                    }

                theId =
                  toPatternId
                    [ config.color
                    , String.fromFloat config.width
                    , String.fromFloat config.space
                    , String.fromFloat config.rotate
                    ]
            in
            ( toPatternDefs theId config.space config.rotate <|
                S.circle
                  [ SA.fill config.color
                  , SA.cx (String.fromFloat <| config.width / 3)
                  , SA.cy (String.fromFloat <| config.width / 3)
                  , SA.r (String.fromFloat <| config.width / 3)
                  ]
                  []
            , theId
            )

          CA.Gradient edits ->
            let config =
                  apply edits
                    { top = defaultColor
                    , bottom = "transparent"
                    }

                theId =
                  toPatternId
                    [ config.top
                    , config.bottom
                    ]

            in
            ( S.defs []
                [ S.linearGradient
                    [ SA.id theId, SA.x1 "0", SA.x2 "0", SA.y1 "0", SA.y2 "1" ]
                    [ S.stop [ SA.offset "0%", SA.stopColor config.top ] []
                    , S.stop [ SA.offset "100%", SA.stopColor config.bottom ] []
                    ]
                ]
            , theId
            )
  in
  ( patternDefs, "url(#" ++ patternId ++ ")" )




-- DOTS


{-| -}
type alias Dot =
  { color : String
  , opacity : Float
  , size : Float
  , border : String
  , borderWidth : Float
  , aura : Float
  , auraWidth : Float
  , shape : Maybe CA.Shape
  }


{-| -}
dot : Plane -> (data -> Float) -> (data -> Float) -> List (CA.Attribute Dot) -> data -> Svg msg
dot plane toX toY edits datum_ =
  let config =
        apply edits
          { color = blue
          , opacity = 1
          , size = 6
          , border = "white"
          , borderWidth = 1
          , aura = 0
          , auraWidth = 10
          , shape = Nothing
          }

      x_ = toSVGX plane (toX datum_)
      y_ = toSVGY plane (toY datum_)
      area_ = 2 * pi * config.size

      styleAttrs =
        [ SA.stroke config.border
        , SA.strokeWidth (String.fromFloat config.borderWidth)
        , SA.fillOpacity (String.fromFloat config.opacity)
        , SA.fill config.color
        , SA.class "elm-charts__dot"
        ]

      auraAttrs =
        [ SA.stroke config.color
        , SA.strokeWidth (String.fromFloat config.auraWidth)
        , SA.strokeOpacity (String.fromFloat config.aura)
        , SA.fill "transparent"
        , SA.class "elm-charts__dot-aura"
        ]

      view toEl auraOff toAttrs =
        if config.aura > 0 then
          S.g
            [ SA.class "elm-charts__dot-container" ]
            [ toEl (toAttrs auraOff ++ auraAttrs) []
            , toEl (toAttrs 0 ++ styleAttrs) []
            ]
        else
          toEl (toAttrs 0 ++ styleAttrs) []
  in
  if not (isWithinPlane plane (toX datum_) (toY datum_)) then S.text "" else
  case config.shape of
    Nothing ->
      S.text ""

    Just CA.Circle ->
      let radius = sqrt (area_ / pi)
          radiusAura = config.auraWidth / 2
          toAttrs off =
            [ SA.cx (String.fromFloat x_)
            , SA.cy (String.fromFloat y_)
            , SA.r (String.fromFloat (radius + off))
            ]
      in
      view S.circle radiusAura toAttrs

    Just CA.Triangle ->
      let toAttrs off =
            [ SA.d (trianglePath area_ off x_ y_) ]
      in
      view S.path config.auraWidth toAttrs

    Just CA.Square ->
      let side = sqrt area_
          toAttrs off =
            let sideOff = side + off in
            [ SA.x <| String.fromFloat (x_ - sideOff / 2)
            , SA.y <| String.fromFloat (y_ - sideOff / 2)
            , SA.width (String.fromFloat sideOff)
            , SA.height (String.fromFloat sideOff)
            ]
      in
      view S.rect (config.auraWidth) toAttrs

    Just CA.Diamond ->
      let side = sqrt area_
          rotation = "rotate(45 " ++ String.fromFloat x_ ++ " " ++ String.fromFloat y_ ++ ")"
          toAttrs off =
            let sideOff = side + off in
            [ SA.x <| String.fromFloat (x_ - sideOff / 2)
            , SA.y <| String.fromFloat (y_ - sideOff / 2)
            , SA.width (String.fromFloat sideOff)
            , SA.height (String.fromFloat sideOff)
            , SA.transform rotation
            ]
      in
      view S.rect config.auraWidth toAttrs

    Just CA.Cross ->
      let rotation = "rotate(45 " ++ String.fromFloat x_ ++ " " ++ String.fromFloat y_ ++ ")"
          toAttrs off =
            [ SA.d (plusPath area_ off x_ y_)
            , SA.transform rotation
            ]
      in
      view S.path config.auraWidth toAttrs

    Just CA.Plus ->
      let toAttrs off =
            [ SA.d (plusPath area_ off x_ y_) ]
      in
      view S.path config.auraWidth toAttrs


toRadius : Float -> CA.Shape -> Float
toRadius size_ shape =
  let area_ = 2 * pi * size_ in
  case shape of
    CA.Circle   -> sqrt (area_ / pi)
    CA.Triangle -> let side = sqrt <| area_ * 4 / (sqrt 3) in (sqrt 3) * side
    CA.Square   -> sqrt area_ / 2
    CA.Diamond  -> sqrt area_ / 2
    CA.Cross    -> sqrt (area_ / 4)
    CA.Plus     -> sqrt (area_ / 4)


trianglePath : Float -> Float -> Float -> Float -> String
trianglePath area_ off x_ y_ =
  let side = sqrt (area_ * 4 / sqrt 3) + off * sqrt 3
      height = (sqrt 3) * side / 2
      fromMiddle = height - tan (degrees 30) * side / 2
  in
  String.join " "
    [ "M" ++ String.fromFloat x_ ++ " " ++ String.fromFloat (y_ - fromMiddle)
    , "l" ++ String.fromFloat (-side / 2) ++ " " ++ String.fromFloat height
    , "h" ++ String.fromFloat side
    , "z"
    ]


plusPath : Float -> Float -> Float -> Float ->  String
plusPath area_ off x_ y_ =
  let side = sqrt (area_ / 4) + off
      r3 = side
      r6 = side / 2
  in
  String.join " "
    [ "M" ++ String.fromFloat (x_ - r6) ++ " " ++ String.fromFloat (y_ - r3 - r6 + off)
    , "v" ++ String.fromFloat (r3 - off)
    , "h" ++ String.fromFloat (-r3 + off)
    , "v" ++ String.fromFloat r3
    , "h" ++ String.fromFloat (r3 - off)
    , "v" ++ String.fromFloat (r3 - off)
    , "h" ++ String.fromFloat r3
    , "v" ++ String.fromFloat (-r3 + off)
    , "h" ++ String.fromFloat (r3 - off)
    , "v" ++ String.fromFloat -r3
    , "h" ++ String.fromFloat (-r3 + off)
    , "v" ++ String.fromFloat (-r3 + off)
    , "h" ++ String.fromFloat -r3
    , "v" ++ String.fromFloat (r3 - off)
    ]



-- TOOLTIP


{-| -}
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
tooltip : Plane -> Position -> List (CA.Attribute Tooltip) -> List (H.Attribute Never) -> List (H.Html Never) -> H.Html msg
tooltip plane pos edits htmlAttrs content =
  let config =
        apply edits
          { direction = Nothing
          , height = 0
          , width = 0
          , offset = 12
          , pointer = True
          , border = "#D8D8D8"
          , background = "white"
          }

      distanceTop = toSVGY plane pos.y2
      distanceBottom = plane.y.length - toSVGY plane pos.y1
      distanceLeft = toSVGX plane pos.x2
      distanceRight = plane.x.length - toSVGX plane pos.x1

      direction =
        case config.direction of
          Just CA.LeftOrRight ->
            if config.width > 0
            then if distanceLeft > (config.width + config.offset) then CA.Left else CA.Right
            else if distanceLeft > distanceRight then CA.Left else CA.Right

          Just CA.TopOrBottom ->
            if config.height > 0
            then if distanceTop > (config.height + config.offset) then CA.Top else CA.Bottom
            else if distanceTop > distanceBottom then CA.Top else CA.Bottom

          Just dir -> dir
          Nothing ->
            let isLargest a = List.all (\b -> a >= b) in
            if isLargest distanceTop [ distanceBottom, distanceLeft, distanceRight ] then CA.Top
            else if isLargest distanceBottom [ distanceTop, distanceLeft, distanceRight ] then CA.Bottom
            else if isLargest distanceLeft [ distanceTop, distanceBottom, distanceRight ] then CA.Left
            else CA.Right

      { xOff, yOff, transformation, className } =
        case direction of
          CA.Top         -> { xOff = 0, yOff = -config.offset, transformation = "translate(-50%, -100%)", className = "elm-charts__tooltip-top" }
          CA.Bottom      -> { xOff = 0, yOff = config.offset, transformation = "translate(-50%, 0%)", className = "elm-charts__tooltip-bottom" }
          CA.Left        -> { xOff = -config.offset, yOff = 0, transformation = "translate(-100%, -50%)", className = "elm-charts__tooltip-left" }
          CA.Right       -> { xOff = config.offset, yOff = 0, transformation = "translate(0, -50%)", className = "elm-charts__tooltip-right" }
          CA.LeftOrRight -> { xOff = -config.offset, yOff = 0, transformation = "translate(0, -50%)", className = "elm-charts__tooltip-leftOrRight" }
          CA.TopOrBottom -> { xOff = 0, yOff = config.offset, transformation =  "translate(-50%, -100%)", className = "elm-charts__tooltip-topOrBottom" }

      children =
        if config.pointer then
          H.node "style" [] [ H.text (tooltipPointerStyle direction className config.background config.border) ] :: content
        else
          content

      attributes =
        [ HA.class className
        , HA.style "transform" transformation
        , HA.style "padding" "5px 10px"
        , HA.style "background" config.background
        , HA.style "border" ("1px solid " ++ config.border)
        , HA.style "border-radius" "3px"
        , HA.style "pointer-events" "none"
        ] ++ htmlAttrs

      ( x, y ) =
        case direction of
          CA.Top         -> ( pos.x1 + (pos.x2 - pos.x1) / 2, pos.y2 )
          CA.Bottom      -> ( pos.x1 + (pos.x2 - pos.x1) / 2, pos.y1 )
          CA.Left        -> ( pos.x1, pos.y1 + (pos.y2 - pos.y1) / 2 )
          CA.Right       -> ( pos.x2, pos.y1 + (pos.y2 - pos.y1) / 2 )
          CA.LeftOrRight -> ( pos.x2, pos.y1 + (pos.y2 - pos.y1) / 2 )
          CA.TopOrBottom -> ( pos.x1 + (pos.x2 - pos.x1) / 2, pos.y2 )
  in
  positionHtml plane x y xOff yOff attributes children
    |> H.map never


{-| -}
positionHtml : Plane -> Float -> Float -> Float -> Float -> List (H.Attribute msg) -> List (H.Html msg) -> H.Html msg
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
    H.div (posititonStyles ++ attrs) content



-- EVENTS


{-| -}
getNearest : (a -> Point) -> List a -> Plane -> Point -> List a
getNearest toPoint items plane searchedSvg =
  let searched =
        { x = toCartesianX plane searchedSvg.x
        , y = toCartesianY plane searchedSvg.y
        }
  in
  getNearestHelp toPoint items plane searched


{-| -}
getWithin : Float -> (a -> Point) -> List a -> Plane -> Point -> List a
getWithin radius toPoint items plane searchedSvg =
    let
      searched =
        { x = toCartesianX plane searchedSvg.x
        , y = toCartesianY plane searchedSvg.y
        }

      keepIfEligible closest =
        withinRadius plane radius searched (toPoint closest)
    in
    getNearestHelp toPoint items plane searched
      |> List.filter keepIfEligible


{-| -}
getNearestX : (a -> Point) -> List a -> Plane -> Point -> List a
getNearestX toPoint items plane searchedSvg =
    let
      searched =
        { x = toCartesianX plane searchedSvg.x
        , y = toCartesianY plane searchedSvg.y
        }
    in
    getNearestXHelp toPoint items plane searched


{-| -}
getWithinX : Float -> (a -> Point) -> List a -> Plane -> Point -> List a
getWithinX radius toPoint items plane searchedSvg =
    let
      searched =
        { x = toCartesianX plane searchedSvg.x
        , y = toCartesianY plane searchedSvg.y
        }

      keepIfEligible =
          withinRadiusX plane radius searched << toPoint
    in
    getNearestXHelp toPoint items plane searched
      |> List.filter keepIfEligible


getNearestHelp : (a -> Point) -> List a -> Plane -> Point -> List a
getNearestHelp toPoint items plane searched =
  let
      distance_ =
          distance plane searched

      getClosest item allClosest =
        case List.head allClosest of
          Just closest ->
            if toPoint closest == toPoint item then item :: allClosest
            else if distance_ (toPoint closest) > distance_ (toPoint item) then [ item ]
            else allClosest

          Nothing ->
            [ item ]
  in
  List.foldl getClosest [] items


getNearestXHelp : (a -> Point) -> List a ->Plane -> Point -> List a
getNearestXHelp toPoint items plane searched =
  let
      distanceX_ =
          distanceX plane searched

      getClosest item allClosest =
        case List.head allClosest of
          Just closest ->
              if (toPoint closest).x == (toPoint item).x then item :: allClosest
              else if distanceX_ (toPoint closest) > distanceX_ (toPoint item) then [ item ]
              else allClosest

          Nothing ->
            [ item ]
  in
  List.foldl getClosest [] items


distanceX : Plane -> Point -> Point -> Float
distanceX plane searched point =
    abs <| toSVGX plane point.x - toSVGX plane searched.x


distanceY : Plane -> Point -> Point -> Float
distanceY plane searched point =
    abs <| toSVGY plane point.y - toSVGY plane searched.y


distance : Plane -> Point -> Point -> Float
distance plane searched point =
    sqrt <| distanceX plane searched point ^ 2 + distanceY plane searched point ^ 2


withinRadius : Plane -> Float -> Point -> Point -> Bool
withinRadius plane radius searched point =
    distance plane searched point <= radius


withinRadiusX : Plane -> Float -> Point -> Point -> Bool
withinRadiusX plane radius searched point =
    distanceX plane searched point <= radius


{-| -}
decoder : Plane -> (Plane -> Point -> msg) -> Json.Decoder msg
decoder plane toMsg =
  let
    handle mouseX mouseY rect =
      let
        widthPercent = rect.width / plane.x.length
        heightPercent = rect.height / plane.y.length

        xPrev = plane.x
        yPrev = plane.y

        newPlane =
          { x =
              { xPrev | length = rect.width
              , marginLower = plane.x.marginLower * widthPercent
              , marginUpper = plane.x.marginUpper * widthPercent
              }
          , y =
              { yPrev | length = rect.height
              , marginLower = plane.y.marginLower * heightPercent
              , marginUpper = plane.y.marginUpper * heightPercent
              }
          }
      in
      toMsg newPlane { x = mouseX - rect.left, y = mouseY - rect.top }
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



-- POSITIONING


position : Plane -> Float -> Float -> Float -> Float -> Float -> S.Attribute msg
position plane rotation x_ y_ xOff_ yOff_ =
  SA.transform <| "translate(" ++ String.fromFloat (toSVGX plane x_ + xOff_) ++ "," ++ String.fromFloat (toSVGY plane y_ + yOff_) ++ ") rotate(" ++ String.fromFloat rotation ++ ")"



-- HELPERS


withBorder : List a -> (a -> a -> b) -> Maybe b
withBorder stuff func =
  case stuff of
    first :: rest ->
      Just (func first (Maybe.withDefault first (last rest)))

    _ ->
      Nothing


last : List a -> Maybe a
last list =
  List.head (List.drop (List.length list - 1) list)


closestToZero : Plane -> Float
closestToZero plane =
  clamp plane.y.min plane.y.max 0


apply : List (a -> a) -> a -> a
apply funcs default =
  let apply_ f a = f a in
  List.foldl apply_ default funcs


isWithinPlane : Plane -> Float -> Float -> Bool
isWithinPlane plane x y =
  clamp plane.x.min plane.x.max x == x && clamp plane.y.min plane.y.max y == y



-- COLOR


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



-- STYLES


tooltipPointerStyle : CA.Direction -> String -> String -> String -> String
tooltipPointerStyle direction className background borderColor =
  let config =
        case direction of
          CA.Top          -> { a = "right", b = "top", c = "left" }
          CA.Bottom       -> { a = "right", b = "bottom", c = "left" }
          CA.Left         -> { a = "bottom", b = "left", c = "top" }
          CA.Right        -> { a = "bottom", b = "right", c = "top" }
          CA.LeftOrRight  -> { a = "bottom", b = "left", c = "top" }
          CA.TopOrBottom  -> { a = "right", b = "top", c = "left" }
  in
  """
  .""" ++ className ++ """:before, .""" ++ className ++ """:after {
    content: "";
    position: absolute;
    border-""" ++ config.c ++ """: 5px solid transparent;
    border-""" ++ config.a ++ """: 5px solid transparent;
    """ ++ config.b ++ """: 100%;
    """ ++ config.c ++ """: 50%;
    margin-""" ++ config.c ++ """: -5px;
  }

  .""" ++ className ++ """:after {
    border-""" ++ config.b ++ """: 5px solid """ ++ background ++ """;
    margin-""" ++ config.b ++ """: -1px;
    z-index: 1;
  }

  .""" ++ className ++ """:before {
    border-""" ++ config.b ++ """: 5px solid """ ++ borderColor ++ """;
  }
  """


clipperStyle : Plane -> Float -> Float -> Float -> Float -> String
clipperStyle plane minX maxX minY maxY =
  let x1 = plane.x.min - minX
      y1 = maxY - plane.y.max
      x2 = x1 + abs (plane.x.max - plane.x.min)
      y2 = y1 + abs (plane.y.max - plane.y.min)

      path =
        String.join " "
          [ "M" ++ String.fromFloat (scaleSVG plane.x x1) ++ " " ++ String.fromFloat (scaleSVG plane.y y1)
          , "V" ++ String.fromFloat (scaleSVG plane.y y2)
          , "H" ++ String.fromFloat (scaleSVG plane.x x2)
          , "V" ++ String.fromFloat (scaleSVG plane.y y1)
          , "H" ++ String.fromFloat (scaleSVG plane.y x1)
          ]
  in
  "clip-path: path('" ++ path ++ "');"




-- INTERVALS


type alias Bounds =
  { min : Float
  , max : Float
  , dataMin : Float
  , dataMax : Float
  }


type Generator a
  = Generator (Int -> Bounds -> List a)


floats : Generator Float
floats =
  Generator (\i b -> I.floats (I.around i) { min = b.min, max = b.max })


ints : Generator Int
ints =
  Generator (\i b -> I.ints (I.around i) { min = b.min, max = b.max })


times : Time.Zone -> Generator I.Time
times zone =
  Generator (\i b -> I.times zone i { min = b.min, max = b.max })


produce : Int -> Generator a -> Bounds -> List a
produce amount (Generator func) bounds =
  func amount bounds


type alias TickValue =
  { value : Float
  , label : String
  }


toTickValues : (a -> Float) -> (a -> String) -> List a -> List TickValue
toTickValues toValue toString =
  List.map <| \i -> { value = toValue i, label = toString i }



-- FORMATTING


formatTime : Time.Zone -> I.Time -> String
formatTime zone time =
    case Maybe.withDefault time.unit time.change of
        I.Millisecond ->
            formatClockMillis zone time.timestamp

        I.Second ->
            formatClockSecond zone time.timestamp

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


formatClockSecond : Time.Zone -> Time.Posix -> String
formatClockSecond =
    F.format
        [ F.hourMilitaryFixed
        , F.text ":"
        , F.minuteFixed
        , F.text ":"
        , F.secondFixed
        ]


formatClockMillis : Time.Zone -> Time.Posix -> String
formatClockMillis =
    F.format
        [ F.hourMilitaryFixed
        , F.text ":"
        , F.minuteFixed
        , F.text ":"
        , F.secondFixed
        , F.text ":"
        , F.millisecondFixed
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

