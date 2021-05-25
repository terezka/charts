module Chart.Attributes exposing
  ( Attribute, x, x1, x2, y, y1, y2, xOff, yOff, flip, border, borderWidth, fontSize, format, color, width, height, offset
  , Anchor(..), alignLeft, alignRight, content
  , rotate, length, roundTop, roundBottom, area, opacity, size, aura, auraWidth, ungroup, margin, spacing
  , Design(..), GradientConfig, Pattern, space, striped, dotted, gradient, top, bottom, dashed, break
  , Method(..), linear, monotone
  , Shape(..), circle, triangle, square, diamond, plus, cross, shape
  , Direction(..), onTop, onBottom, onRight, onLeft, onLeftOrRight, onTopOrBottom, noPointer
  , blue, pink, orange, green, purple, red, turquoise
  , background, attrs, htmlAttrs, static, events
  )


{-| -}
type alias Attribute c =
  c -> c


{-| -}
x : Float -> Attribute { a | x : Float }
x v config =
  { config | x = v }


{-| -}
x1 : x -> Attribute { a | x1 : Maybe x }
x1 v config =
  { config | x1 = Just v }


{-| -}
x2 : x -> Attribute { a | x2 : Maybe x }
x2 v config =
  { config | x2 = Just v }


{-| -}
y : Float -> Attribute { a | y : Float }
y v config =
  { config | y = v }


{-| -}
y1 : Float -> Attribute { a | y1 : Maybe Float }
y1 v config =
  { config | y1 = Just v }


{-| -}
y2 : Float -> Attribute { a | y2 : Maybe Float }
y2 v config =
  { config | y2 = Just v }


{-| -}
break : Attribute { a | break : Bool }
break config =
  { config | break = True }


{-| -}
xOff : Float -> Attribute { a | xOff : Float }
xOff v config =
  { config | xOff = config.xOff + v }


{-| -}
yOff : Float -> Attribute { a | yOff : Float }
yOff v config =
  { config | yOff = config.yOff + v }


{-| -}
flip : Attribute { a | flip : Bool }
flip config =
  { config | flip = True }


{-| -}
border : String -> Attribute { a | border : String }
border v config =
  { config | border = v }


{-| -}
borderWidth : Float -> Attribute { a | borderWidth : Float }
borderWidth v config =
  { config | borderWidth = v }


{-| -}
background : String -> Attribute { a | background : String }
background v config =
  { config | background = v }


{-| -}
fontSize : Int -> Attribute { a | fontSize : Maybe Int }
fontSize v config =
  { config | fontSize = Just v }


{-| -}
format : String -> Attribute { a | format : String }
format v config =
  { config | format = v }


{-| -}
color : String -> Attribute { a | color : String }
color v config =
  if v == "" then config else { config | color = v }


{-| -}
opacity : Float -> Attribute { a | opacity : Float }
opacity v config =
  { config | opacity = v }


{-| -}
aura : Float -> Attribute { a | aura : Float }
aura v config =
  { config | aura = v }


{-| -}
auraWidth : Float -> Attribute { a | auraWidth : Float }
auraWidth v config =
  { config | auraWidth = v }


{-| -}
size : Float -> Attribute { a | size : Float }
size v config =
  { config | size = v }


{-| -}
width : Float -> Attribute { a | width : Float }
width v config =
  { config | width = v }


{-| -}
height : Float -> Attribute { a | height : Float }
height v config =
  { config | height = v }


{-| -}
attrs : a -> Attribute { x | attrs : a }
attrs v config =
  { config | attrs = v }


{-| -}
htmlAttrs : a -> Attribute { x | htmlAttrs : a }
htmlAttrs v config =
  { config | htmlAttrs = v }


{-| -}
length : Float -> Attribute { a | length : Float }
length v config =
  { config | length = v }


{-| -}
offset : Float -> Attribute { a | offset : Float }
offset v config =
  { config | offset = v }


{-| -}
rotate : Float -> Attribute { a | rotate : Float }
rotate v config =
  { config | rotate = config.rotate + v }


{-| -}
margin : Float -> Attribute { a | margin : Float }
margin v config =
  { config | margin = v }


{-| -}
spacing : Float -> Attribute { a | spacing : Float }
spacing v config =
  { config | spacing = v }


{-| -}
roundTop : Float -> Attribute { a | roundTop : Float }
roundTop v config =
  { config | roundTop = v }


{-| -}
roundBottom : Float -> Attribute { a | roundBottom : Float }
roundBottom v config =
  { config | roundBottom = v }


{-| -}
ungroup : Attribute { a | grouped : Bool }
ungroup config =
  { config | grouped = False }


{-| -}
static : Attribute { a | responsive : Bool }
static config =
  { config | responsive = False }


{-| -}
events : x -> Attribute { a | events : x }
events v config =
  { config | events = v }


-- TODO Move to internal
{-| -}
type Anchor
  = End
  | Start
  | Middle


{-| -}
alignLeft : Attribute { a | anchor : Anchor }
alignLeft config =
  { config | anchor = Start }


{-| -}
alignRight : Attribute { a | anchor : Anchor }
alignRight config =
  { config | anchor = End }


-- TODO Move to internal
{-| -}
type Method
  = Linear
  | Monotone


{-| -}
linear : Attribute { a | method : Maybe Method }
linear config =
  { config | method = Just Linear }


{-| -}
monotone : Attribute { a | method : Maybe Method }
monotone config =
  { config | method = Just Monotone }


{-| -}
area : Float -> Attribute { a | area : Float, method : Maybe Method }
area v config =
  { config | area = v
  , method =
      case config.method of
        Just _ -> config.method
        Nothing -> Just Linear
  }


{-| -}
type Design
  = Striped (List (Attribute Pattern))
  | Dotted (List (Attribute Pattern))
  | Gradient (List (Attribute GradientConfig))


{-| -}
type alias Pattern =
  { color : String
  , width : Float
  , space : Float
  , rotate : Float
  }


{-| -}
type alias GradientConfig =
  { top : String
  , bottom : String
  }


{-| -}
space : x -> Attribute { a | space : x }
space value config =
  { config | space = value }


{-| -}
striped : List (Attribute Pattern) -> Attribute { a | design : Maybe Design, opacity : Float }
striped attrs_ config =
  { config | design = Just (Striped attrs_), opacity = if config.opacity == 0 then 1 else config.opacity }


{-| -}
dotted : List (Attribute Pattern) -> Attribute { a | design : Maybe Design, opacity : Float }
dotted attrs_ config =
  { config | design = Just (Dotted attrs_), opacity = if config.opacity == 0 then 1 else config.opacity }


{-| -}
gradient : List (Attribute GradientConfig) -> Attribute { a | design : Maybe Design, opacity : Float }
gradient attrs_ config =
  { config | design = Just (Gradient attrs_), opacity = if config.opacity == 0 then 1 else config.opacity }


{-| -}
top : x -> Attribute { a | top : x }
top value config =
  { config | top = value }


{-| -}
bottom : x -> Attribute { a | bottom : x }
bottom value config =
  { config | bottom = value }


{-| -}
dashed : x -> Attribute { a | dashed : x }
dashed value config =
  { config | dashed = value }


-- TODO Move to internal
{-| -}
type Shape
  = Circle
  | Triangle
  | Square
  | Diamond
  | Cross
  | Plus


{-| -}
circle : Attribute { a | shape : Maybe Shape }
circle config =
  { config | shape = Just Circle }


{-| -}
triangle : Attribute { a | shape : Maybe Shape }
triangle config =
  { config | shape = Just Triangle }


{-| -}
square : Attribute { a | shape : Maybe Shape }
square config =
  { config | shape = Just Square }


{-| -}
diamond : Attribute { a | shape : Maybe Shape }
diamond config =
  { config | shape = Just Diamond }


{-| -}
plus : Attribute { a | shape : Maybe Shape }
plus config =
  { config | shape = Just Plus }


{-| -}
cross : Attribute { a | shape : Maybe Shape }
cross config =
  { config | shape = Just Cross }


{-| -}
shape : Maybe Shape -> Attribute { a | shape : Maybe Shape }
shape v config =
  { config | shape = v }


{-| -}
content : v -> Attribute { a | content : v }
content v config =
  { config | content = v }


{-| -}
type Direction
  = Top
  | Left
  | Right
  | Bottom
  | LeftOrRight
  | TopOrBottom


{-| -}
onTop : Attribute { a | direction : Maybe Direction }
onTop config =
  { config | direction = Just Top }


{-| -}
onBottom : Attribute { a | direction : Maybe Direction }
onBottom config =
  { config | direction = Just Bottom }


{-| -}
onRight : Attribute { a | direction : Maybe Direction }
onRight config =
  { config | direction = Just Right }


{-| -}
onLeft : Attribute { a | direction : Maybe Direction }
onLeft config =
  { config | direction = Just Left }


onLeftOrRight : Attribute { a | direction : Maybe Direction }
onLeftOrRight config =
  { config | direction = Just LeftOrRight }


onTopOrBottom : Attribute { a | direction : Maybe Direction }
onTopOrBottom config =
  { config | direction = Just TopOrBottom }


-- TODO arrow intead?
noPointer : Attribute { a | pointer : Bool }
noPointer config =
  { config | pointer = False }


-- COLORS


{-| -}
blue : String
blue =
  "#1976d2"


{-| -}
orange : String
orange =
  "#e47d32"


{-| -}
pink : String
pink =
  "#f56dbc"


purple : String
purple =
  "#7c29ed"


{-| -}
green : String
green =
  "#388e3c"


{-| -}
red : String
red =
  "#d32f2f"


{-| -}
turquoise : String
turquoise =
  "#4eaea7"
