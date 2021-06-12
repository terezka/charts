module Chart.Attributes exposing
  ( Attribute, x, x1, x2, y, y1, y2, xOff, yOff, flip
  , moveLeft, moveRight, moveUp, moveDown
  , border, borderWidth, fontSize, format, color, width, height, offset
  , Anchor(..), alignLeft, alignRight, alignMiddle, content
  , rotate, length, roundTop, roundBottom, area, opacity, size, aura, auraWidth, ungroup, margin, spacing
  , Design(..), GradientConfig, Pattern, space, striped, dotted, gradient, top, bottom, dashed, break
  , Method(..), linear, monotone, stepped
  , Shape(..), circle, triangle, square, diamond, plus, cross, shape
  , Direction(..), onTop, onBottom, onRight, onLeft, onLeftOrRight, onTopOrBottom, noPointer
  , Alignment(..), row, column
  , blue, pink, orange, green, purple, red, turquoise
  , background, attrs, htmlAttrs, static, events

  , marginTop, marginBottom, marginLeft, marginRight
  , paddingTop, paddingBottom, paddingLeft, paddingRight
  , pinned, dotGrid, noArrow
  , range, domain, limits, amount

  , lowest, highest, orLower, orHigher, exactly, more, less, window, likeData, zero, middle, percent

  , Tick(..), ints, times
  , noGrid, title
  )


import Time
import Svg.Coordinates as C
import Internal.Helpers as Helpers


{-| -}
type alias Attribute c =
  c -> c


{-| -}
lowest : Float -> (Float -> Float -> Float -> Float) -> Attribute C.Axis
lowest v edit b =
  { b | min = edit v b.min b.dataMin }


{-| -}
highest : Float -> (Float -> Float -> Float -> Float) -> Attribute C.Axis
highest v edit b =
  { b | max = edit v b.max b.dataMax }


{-| -}
likeData : Attribute C.Axis
likeData b =
  { b | min = b.dataMin, max = b.dataMax }


{-| -}
window : Float -> Float -> Attribute C.Axis
window min_ max_ b =
  { b | min = min_, max = max_ }


{-| -}
exactly : Float -> Float -> Float -> Float
exactly exact _ _ =
  exact


{-| -}
orLower : Float -> Float -> Float -> Float
orLower least real _ =
  if real > least then least else real


{-| -}
orHigher : Float -> Float -> Float -> Float
orHigher most real _ =
  if real < most then most else real


{-| -}
more : Float -> Float -> Float -> Float
more v o _ =
  o + v


{-| -}
less : Float -> Float -> Float -> Float
less v o _ =
  o - v


{-| -}
zero : C.Axis -> Float
zero b =
  clamp b.min b.max 0


{-| -}
middle : C.Axis -> Float
middle b =
  b.min + (b.max - b.min) / 2


{-| -}
percent : Float -> C.Axis -> Float
percent per b =
  b.min + (b.max - b.min) * per


{-| -}
amount : Int -> Attribute { a | amount : Int }
amount value config =
  { config | amount = value }


{-| -}
title : x -> Attribute { a | title : x }
title value config =
  { config | title = value }


{-| -}
type Tick
  = Floats
  | Ints
  | Times Time.Zone


{-| -}
ints : Attribute { a | generate : Tick }
ints config =
  { config | generate = Ints }


{-| -}
times : Time.Zone -> Attribute { a | generate : Tick }
times zone config =
  { config | generate = Times zone }


{-| -}
limits : x -> Attribute { a | limits : x }
limits value config =
  { config | limits = value }


{-| -}
range : x -> Attribute { a | range : x }
range v config =
  { config | range = v }


{-| -}
domain : x -> Attribute { a | domain : x }
domain v config =
  { config | domain = v }


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
pinned : x -> Attribute { a | pinned : x }
pinned value config =
  { config | pinned = value }


{-| -}
dotGrid : Attribute { a | dotGrid : Bool }
dotGrid config =
  { config | dotGrid = True }


{-| -}
noArrow : Attribute { a | arrow : Bool }
noArrow config =
  { config | arrow = False }


{-| -}
noGrid : Attribute { a | grid : Bool }
noGrid config =
  { config | grid = False }


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
moveLeft : Float -> Attribute { a | xOff : Float }
moveLeft v config =
  { config | xOff = config.xOff - v }


{-| -}
moveRight : Float -> Attribute { a | xOff : Float }
moveRight v config =
  { config | xOff = config.xOff + v }


{-| -}
moveUp : Float -> Attribute { a | yOff : Float }
moveUp v config =
  { config | yOff = config.yOff - v }


{-| -}
moveDown : Float -> Attribute { a | yOff : Float }
moveDown v config =
  { config | yOff = config.yOff + v }


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
alignLeft : Attribute { a | anchor : Maybe Anchor }
alignLeft config =
  { config | anchor = Just Start }


{-| -}
alignRight : Attribute { a | anchor : Maybe Anchor }
alignRight config =
  { config | anchor = Just End }


{-| -}
alignMiddle : Attribute { a | anchor : Maybe Anchor }
alignMiddle config =
  { config | anchor = Just Middle }



-- TODO Move to internal
{-| -}
type Method
  = Linear
  | Monotone
  | Stepped


{-| -}
linear : Attribute { a | method : Maybe Method }
linear config =
  { config | method = Just Linear }


{-| -}
monotone : Attribute { a | method : Maybe Method }
monotone config =
  { config | method = Just Monotone }


{-| -}
stepped : Attribute { a | method : Maybe Method }
stepped config =
  { config | method = Just Stepped }


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


type Alignment
  = Row
  | Column


row : Attribute { a | alignment : Alignment }
row config =
  { config | alignment = Row }


column : Attribute { a | alignment : Alignment }
column config =
  { config | alignment = Column }



-- COLORS


{-| -}
blue : String
blue =
  Helpers.blue


{-| -}
orange : String
orange =
  Helpers.orange


{-| -}
pink : String
pink =
  Helpers.pink


purple : String
purple =
  Helpers.purple


{-| -}
green : String
green =
  Helpers.green


{-| -}
red : String
red =
  Helpers.red


{-| -}
turquoise : String
turquoise =
  Helpers.turquoise
