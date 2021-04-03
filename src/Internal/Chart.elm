module Internal.Svg exposing
  ( Point
  , Container, container
  , Line, line, Label, label, Arrow, arrow
  , position
  , Bar, bar
  , Series, Method, linear, monotone, interpolation, area
  , Dot, circle, triangle, square, diamond, plus, cross
  --, tooltip
  )

import Html as H exposing (Html)
import Html.Attributes as HA
import Svg as S exposing (Svg)
import S.Attributes as SA
import S.Events as SE


{-| -}
type alias Point =
  { x : Float
  , y : Float
  }


{-| -}
type alias Attribute c =
  c -> c


-- CONTAINER


{-| -}
type alias Container msg =
  { id : String
  , attrs : List (S.Attribute msg)
  , htmlAttrs : List (H.Attribute msg)
  , responsive : Bool
  , events : List (Event msg)
  }


{-| -}
type alias Event msg =
  { name : String
  , handler : Plane -> Point -> msg
  }


container : Plane -> List (Attribute Container) -> List (Html msg) -> List (Svg msg) -> List (Html msg) -> Html msg
container plane edits below chartEls above =
  -- TODO seperate plane from container size
  let config =
        apply edits
          { id = "you-should-add-a-unique-id-here"
          , attrs = []
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
          (svgAttrsSize ++ List.map toEvent config.events ++ config.attrs)
          ([frame] ++ chartEls ++ [catcher])

      svgAttrsSize =
        if config.responsive then
          [ SA.viewBox ("0 0 " ++ String.fromFloat plane.x.length ++ " " ++ String.fromFloat plane.y.length) ]
        else
          [ SA.width (String.fromFloat plane.x.length)
          , SA.height (String.fromFloat plane.y.length)
          ]

      frame =
        S.defs [] [ S.clipPath [ SA.id config.id ] [ S.rect chartPosition [] ] ]

      catcher =
        S.rect (chartPosition ++ List.map svgAttrsEvent config.events) []

      svgAttrsEvent event =
        SE.on event.name (decodePoint plane event.func)

      chartPosition =
        [ SA.x (String.fromFloat plane.x.marginLower)
        , SA.y (String.fromFloat plane.y.marginUpper)
        , SA.width (String.fromFloat (plane.x.length - plane.x.marginLower - plane.x.marginUpper))
        , SA.height (String.fromFloat (plane.y.length - plane.y.marginLower - plane.y.marginUpper))
        , SA.fill "transparent"
        ]
  in
  H.div htmlAttrs (below ++ [ chart ] ++ above)



-- LINE


{-| -}
type alias Line =
  { x1 : Float
  , x2 : Float
  , y1 : Float
  , y2 : Float
  , color : String
  , width : Float
  }


{-| -}
line : Plane -> List (Attribute Line) -> Svg msg
line plane edits =
  let config =
        apply edits
          { x1 = plane.x.min
          , x2 = plane.x.max
          , y1 = plane.y.min
          , y2 = plane.y.min
          , color = "#EFF2FA"
          , width = 1
          }

      cmds =
        [ C.Move config.x1 config.y1
        , C.Line config.x1 config.y1
        , C.Line config.x2 config.y2
        ]
  in
  S.path
    [ SA.class "elm-charts__line"
    , SA.stroke config.color
    , SA.strokeWidth (String.fromFloat config.width)
    , SA.d (C.description plane cmds)
    ]
    []



-- LABEL


{-| -}
type alias Label =
  { x : Float
  , y : Float
  , xOff : Float
  , yOff : Float
  , borderColor : String
  , borderWidth : Float
  , fontSize : Maybe Int
  , color : String
  , achor : Anchor
  -- TODO rotate
  }


{-| -}
type Anchor
  = End
  | Start
  | Middle


{-| -}
label : Plane -> List (Attribute Label) -> String -> Svg msg
label plane config string =
  let config =
        apply edits
          { x = plane.x.min
          , y = plane.y.max
          , xOff = 0
          , yOff = 0
          , borderColor = "white"
          , borderWidth = 0.1
          , fontSize = Nothing
          , color = "#808BAB"
          , achor = Middle
          }

      fontStyle =
        case config.fontSize of
          Just size_ -> "font-size: " ++ String.fromInt size_ ++ ";"
          Nothing -> ""

      achorStyle =
        case config.anchor of
        End -> "text-anchor: end;"
        Start -> "text-anchor: start;"
        Middle -> "text-anchor: middle;"
  in
  S.text_
    [ SA.class "elm-charts__label"
    , SA.stroke config.borderColor
    , SA.strokeWidth config.borderWidth
    , SA.fill config.color
    , position plane config.x config.y config.xOff config.yOff
    , SA.style <| String.join " " [ "pointer-events: none;", fontStyle, achorStyle ]
    ,
    ]
    [ S.tspan [] [ S.text string ] ]



-- ARROW


{-| -}
type alias Arrow =
  { x : Float
  , y : Float
  , xOff : Float
  , yOff : Float
  , color : String
  -- TODO , width : Float
  -- TODO , length : Float
  , upwards : Bool
  }


{-| -}
arrow : Plane -> List (Attribute Arrow) -> Svg msg
arrow plane edits =
  let config =
        apply edits
          { x = plane.x.min
          , y = plane.y.max
          , xOff = 0
          , yOff = 0
          , color = "#EFF2FA"
          -- TODO , width : Float
          -- TODO , length : Float
          , upwards = False -- TODO rotate instead
          }
  in
  S.g [ position plane config.x config.y config.xOff config.yOff ]
    [ S.polygon
        [ SA.fill config.color
        , SA.points "0,0 50,0 25.0,43.3"
        , if config.upwards
          then SA.transform "translate(0 -6) scale(0.15) rotate(60)"
          else SA.transform "translate(6 0) scale(0.15) rotate(150)"
        ]
        []
    ]



-- BAR


{-| -}
type alias Bar =
  { roundTop : Float
  , roundBottom : Float
  , color : String
  -- TODO , pattern : Pattern
  , x1 : Float
  , x2 : Float
  , y1 : Float
  , y2 : Float
  -- TODO, border :
  -- TODO    { color : String
  -- TODO    , opacity : String
  -- TODO    , width : Float
  -- TODO    }
  }


{-| -}
bar : Plane -> List (Attribute Bar) -> Svg msg
bar plane edits =
  -- TODO round via clipPath
  let config =
        apply edits
          { roundTop = 0
          , roundBottom = 0
          , color = "rgb(5, 142, 218)"
          , x1 = plane.x.min
          , x2 = plane.x.max
          , y1 = plane.y.min
          , y2 = plane.y.max
          }

      x = config.x1
      y = config.y2
      w = config.x2 - config.x1
      bs = config.y1
      bT = scaleSVG plane.x w * 0.5 * (clamp 0 1 config.roundTop)
      bB = scaleSVG plane.x w * 0.5 * (clamp 0 1 config.roundBottom)
      ys = abs (scaleSVG plane.y y)
      rx = scaleCartesian plane.x b
      ry = scaleCartesian plane.y b

      commands =
        if bs == y then
          []
        else
          case ( config.roundTop > 0, config.roundBottom > 0 ) of
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
        [ C.Move x bs
        , C.Line x y
        , C.Line (x + w) y
        , C.Line (x + w) bs
        ]

      commandsRoundBoth outwards ry_ =
        [ C.Move (x + rx) bs
        , C.Arc bB bB -45 False outwards x (bs + ry_)
        , C.Line x (y - ry_)
        , C.Arc bT bT -45 False outwards (x + rx) y
        , C.Line (x + w - rx) y
        , C.Arc bT bT -45 False outwards (x + w) (y - ry_)
        , C.Line (x + w) (bs + ry_)
        , C.Arc bB bB -45 False outwards (x + w - rx) bs
        ]

      commandsRoundTop outwards ry_ =
        [ C.Move x bs
        , C.Line x (y + ry_)
        , C.Arc bT bT -45 False outwards (x + rx) y
        , C.Line (x + w - rx) y
        , C.Arc bT bT -45 False outwards (x + w) (y + ry_)
        , C.Line (x + w) bs
        ]

      commandsRoundBottom outwards ry_ =
        [ C.Move (x + rx) bs
        , C.Arc bB bB -45 False outwards x (bs + ry_)
        , C.Line x y
        , C.Line (x + w) y
        , C.Line (x + w) (bs + ry_)
        , C.Arc bB bB -45 False outwards (x + w - rx) bs
        ]
  in
  S.path
    [ SA.class "elm-charts__bar"
    , SA.fill config.color
    , SA.d (C.description plane commands)
    ]
    []



-- SERIES


{-| -}
type alias Series =
  { interpolation : Maybe Method
  , color : String
  , width : Float
  , points : List (List Point)
  , area : Float
  }


{-| -}
type Method
  = Linear
  | Monotone


{-| -}
linear : Method
linear =
  Linear


{-| -}
monotone : Method
monotone =
  Monotone


{-| -}
interpolation : Plane -> List (Attribute Series) -> Svg msg
interpolation plane config =
  let view ps cmds =
        widthBorder ps <| \first rest ->
          S.path
            [ SA.class "elm-charts__interpolation"
            , SA.fill "transparent"
            , SA.stroke config.color
            , SA.strokeWidth (String.fromFloat config.width)
            , SA.d (C.description plane (Move first.x first.y :: cmds))
            ]
            []

      pieces =
        List.map2 view series.points (seriesCommands series)
  in
  S.g [ SA.class "elm-charts__interpolations" ] (List.filterMap identity pieces)


{-| -}
area : Plane -> Maybe Series -> String -> Series -> List (Svg msg)
area plane nextMaybe id series =
  let clipperId =
        "area-clipper-" ++ id

      defsMaybe =
        case nextMaybe of
          -- TODO make sure missing data doesn't cut wrong
          -- TODO make sure monotone w missing data works correct
          Just next ->
            let nextPs = List.concat next.points
                nextCmds = List.concat (seriesCommands next [ nextPs ])
                startCmds start = [ Move plane.x.min plane.y.max, Line plane.x.min start.y ]
                endCmds end = [ Line plane.x.max end.y, Line plane.x.max plane.y.max ]
                toPath start end = C.description plane (startCmds start ++ nextCmds ++ endCmds end)
            in
            withBorder nextPs <| \start end ->
              S.defs []
                [ S.clipPath
                    [ SA.id clipperId ]
                    [ S.path [ SA.d (toPath start end) ] [] ]
                ]

          Nothing ->
            Nothing

      toArea points cmds =
        withBorder points <| \start end ->
          let startCmds = [ Move start.x 0, Line start.x start.y ]
              endCmds = [ Line end.x 0 ]
              path = C.description plane (startCmds ++ cmds ++ endCmds)
          in
          S.path
            [ SA.class "elm-charts__area"
            , SA.clipPath ("url(#" ++ clipperId ++ ")")
            , SA.fill series.color
            , SA.fillOpacity (String.fromFloat series.area)
            , SA.d path
            ]
            []

      areas =
        List.map2 toArea series.points (seriesCommands series)
          |> List.filterMap identity
  in
  S.g [ SA.class "elm-charts__areas" ] <|
    case defsMaybe of
      Just defs -> [ defs, S.g [] areas ]
      Nothing -> areas


seriesCommands : Series -> List (List C.Command)
seriesCommands series =
  case series.interpolation of
    Nothing -> []
    Just Linear -> Interpolation.linear series.points
    Just Monotone -> Interpolation.monotone series.points



-- DOTS


{-| -}
type alias Dot =
  { x : Float
  , y : Float
  , color : String
  , opacity : Float
  , size : Float
  , borderColor : String
  , borderWidth : Float
  -- TODO, auraColor : String
  -- TODO, auraOpacity : Float
  -- TODO, auraWidth : Float
  }


{-| -}
circle : Plane -> Dot -> Svg msg
circle plane dot =
  let x_ = toSVGX plane dot.x
      y_ = toSVGY plane dot.y
      area = 2 * pi * dot.size
      radius = sqrt (area / pi)
      attrs =
        [ SA.cx (String.fromFloat x_)
        , SA.cy (String.fromFloat y_)
        , SA.r (String.fromFloat radius)
        ]
  in
  S.circle (attrs ++ styleAttrs dot) []


{-| -}
triangle : Plane -> Dot -> Svg msg
triangle plane dot =
  let x_ = toSVGX plane dot.x
      y_ = toSVGY plane dot.y
      area = 2 * pi * dot.size
      attrs = [ SA.d (pathTriangle area x_ y_) ]
  in
  Svg.path (attrs ++ styleAttrs dot) []


{-| -}
square : Plane -> Dot -> Svg msg
square plane dot =
  let x_ = toSVGX plane dot.x
      y_ = toSVGY plane dot.y
      area = 2 * pi * dot.size
      side = sqrt area
      attrs =
        [ SA.x <| String.fromFloat (x_ - side / 2)
        , SA.y <| String.fromFloat (y_ - side / 2)
        , SA.width (String.fromFloat side)
        , SA.height (String.fromFloat side)
        ]
  in
  Svg.rect (attrs ++ styleAttrs dot) []


{-| -}
diamond : Plane -> Dot -> Svg msg
diamond plane dot =
  let x_ = toSVGX plane dot.x
      y_ = toSVGY plane dot.y
      area = 2 * pi * dot.size
      side = sqrt area
      rotation = "rotate(45 " ++ String.fromFloat x_ ++ " " ++ String.fromFloat y_ ++ ")"
      attrs =
        [ SA.x <| String.fromFloat (x_ - side / 2)
        , SA.y <| String.fromFloat (y_ - side / 2)
        , SA.width (String.fromFloat side)
        , SA.height (String.fromFloat side)
        , SA.transform rotation
        ]
  in
  Svg.rect (attrs ++ styleAttrs dot) []

{-| -}
plus : Plane -> Dot -> Svg msg
plus plane dot =
  let x_ = toSVGX plane dot.x
      y_ = toSVGY plane dot.y
      area = 2 * pi * dot.size
      attrs = [ SA.d (plusPath area x_ y_) ]
  in
  Svg.path (attrs ++ styleAttrs dot) []


{-| -}
cross : Plane -> Dot -> Svg msg
cross plane dot =
  let x_ = toSVGX plane dot.x
      y_ = toSVGY plane dot.y
      area = 2 * pi * dot.size
      rotation = "rotate(45 " ++ String.fromFloat x_ ++ " " ++ String.fromFloat y_ ++ ")"
      attrs = [ SA.d (plusPath area x_ y_), SA.transform rotation ]
  in
  Svg.path (attrs ++ styleAttrs dot) []


trianglePath : Float -> Float -> Float -> String
trianglePath area x y =
  let side = sqrt <| area * 4 / (sqrt 3)
      height = (sqrt 3) * side / 2
      fromMiddle = height - tan (degrees 30) * side / 2
  in
  String.join " "
    [ "M" ++ String.fromFloat x ++ " " ++ String.fromFloat (y - fromMiddle)
    , "l" ++ String.fromFloat (-side / 2) ++ " " ++ String.fromFloat height
    , "h" ++ String.fromFloat side
    , "z"
    ]


plusPath : Float -> Float -> Float ->  String
plusPath area x y =
  let side = sqrt (area / 5)
      r3 = side
      r6 = side / 2
  in
  String.join " "
    [ "M" ++ String.fromFloat (x - r6) ++ " " ++ String.fromFloat (y - r3 - r6)
    , "v" ++ String.fromFloat r3
    , "h" ++ String.fromFloat -r3
    , "v" ++ String.fromFloat r3
    , "h" ++ String.fromFloat r3
    , "v" ++ String.fromFloat r3
    , "h" ++ String.fromFloat r3
    , "v" ++ String.fromFloat -r3
    , "h" ++ String.fromFloat r3
    , "v" ++ String.fromFloat -r3
    , "h" ++ String.fromFloat -r3
    , "v" ++ String.fromFloat -r3
    , "h" ++ String.fromFloat -r3
    , "v" ++ String.fromFloat r3
    ]


styleAttrs : Dot -> List (S.Attribute msg)
styleAttrs dot =
  [ SA.stroke dot.borderColor
  , SA.strokeWidth (String.fromFloat dot.borderWidth)
  , SA.fillOpacity (String.fromFloat dot.opacity)
  , SA.fill dot.color
  ]



-- TOOLTIP

--type alias Tooltip

--tooltip : Tooltip -> Html msg


-- POSITIONING


position : Plane -> Float -> Float -> Float -> Float -> S.Attribute msg
position plane x y xOff yOff =
  SA.transform <| "translate(" ++ String.fromFloat (toSVGX plane x + xOff) ++ "," ++ String.fromFloat (toSVGY plane y + yOff) ++ ")"



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


apply : List (a -> a) -> a -> a
apply funcs default =
  let apply_ f a = f a in
  List.foldl apply_ default funcs



