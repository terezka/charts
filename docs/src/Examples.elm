module Examples exposing (Id, Model, init, Msg, update, view, name, all, first, smallCode, largeCode)


-- THIS IS A GENERATED MODULE!

import Html
import Examples.BarCharts.Gradient
import Examples.BarCharts.Pattern
import Examples.BarCharts.SetX1X2
import Examples.BarCharts.Spacing
import Examples.BarCharts.DataDependent
import Examples.BarCharts.Color
import Examples.BarCharts.Corners
import Examples.BarCharts.Ungroup
import Examples.BarCharts.Stacked
import Examples.BarCharts.Margin
import Examples.BarCharts.Borders
import Examples.BarCharts.Opacity
import Examples.BarCharts.Basic
import Examples.LineCharts.Area
import Examples.LineCharts.Gradient
import Examples.LineCharts.Width
import Examples.LineCharts.Montone
import Examples.LineCharts.Pattern
import Examples.LineCharts.Dots
import Examples.LineCharts.Dashed
import Examples.LineCharts.Color
import Examples.LineCharts.Stacked
import Examples.LineCharts.Basic
import Examples.ScatterCharts.Colors
import Examples.ScatterCharts.Shapes
import Examples.ScatterCharts.Highlight
import Examples.ScatterCharts.DataDependent
import Examples.ScatterCharts.Borders
import Examples.ScatterCharts.Opacity
import Examples.ScatterCharts.Sizes
import Examples.ScatterCharts.Basic


type Id
  = BarCharts__Gradient
  | BarCharts__Pattern
  | BarCharts__SetX1X2
  | BarCharts__Spacing
  | BarCharts__DataDependent
  | BarCharts__Color
  | BarCharts__Corners
  | BarCharts__Ungroup
  | BarCharts__Stacked
  | BarCharts__Margin
  | BarCharts__Borders
  | BarCharts__Opacity
  | BarCharts__Basic
  | LineCharts__Area
  | LineCharts__Gradient
  | LineCharts__Width
  | LineCharts__Montone
  | LineCharts__Pattern
  | LineCharts__Dots
  | LineCharts__Dashed
  | LineCharts__Color
  | LineCharts__Stacked
  | LineCharts__Basic
  | ScatterCharts__Colors
  | ScatterCharts__Shapes
  | ScatterCharts__Highlight
  | ScatterCharts__DataDependent
  | ScatterCharts__Borders
  | ScatterCharts__Opacity
  | ScatterCharts__Sizes
  | ScatterCharts__Basic


type alias Model =
  { example0 : Examples.BarCharts.Gradient.Model
  , example1 : Examples.BarCharts.Pattern.Model
  , example2 : Examples.BarCharts.SetX1X2.Model
  , example3 : Examples.BarCharts.Spacing.Model
  , example4 : Examples.BarCharts.DataDependent.Model
  , example5 : Examples.BarCharts.Color.Model
  , example6 : Examples.BarCharts.Corners.Model
  , example7 : Examples.BarCharts.Ungroup.Model
  , example8 : Examples.BarCharts.Stacked.Model
  , example9 : Examples.BarCharts.Margin.Model
  , example10 : Examples.BarCharts.Borders.Model
  , example11 : Examples.BarCharts.Opacity.Model
  , example12 : Examples.BarCharts.Basic.Model
  , example13 : Examples.LineCharts.Area.Model
  , example14 : Examples.LineCharts.Gradient.Model
  , example15 : Examples.LineCharts.Width.Model
  , example16 : Examples.LineCharts.Montone.Model
  , example17 : Examples.LineCharts.Pattern.Model
  , example18 : Examples.LineCharts.Dots.Model
  , example19 : Examples.LineCharts.Dashed.Model
  , example20 : Examples.LineCharts.Color.Model
  , example21 : Examples.LineCharts.Stacked.Model
  , example22 : Examples.LineCharts.Basic.Model
  , example23 : Examples.ScatterCharts.Colors.Model
  , example24 : Examples.ScatterCharts.Shapes.Model
  , example25 : Examples.ScatterCharts.Highlight.Model
  , example26 : Examples.ScatterCharts.DataDependent.Model
  , example27 : Examples.ScatterCharts.Borders.Model
  , example28 : Examples.ScatterCharts.Opacity.Model
  , example29 : Examples.ScatterCharts.Sizes.Model
  , example30 : Examples.ScatterCharts.Basic.Model
  }


init : Model
init =
  { example0 = Examples.BarCharts.Gradient.init
  , example1 = Examples.BarCharts.Pattern.init
  , example2 = Examples.BarCharts.SetX1X2.init
  , example3 = Examples.BarCharts.Spacing.init
  , example4 = Examples.BarCharts.DataDependent.init
  , example5 = Examples.BarCharts.Color.init
  , example6 = Examples.BarCharts.Corners.init
  , example7 = Examples.BarCharts.Ungroup.init
  , example8 = Examples.BarCharts.Stacked.init
  , example9 = Examples.BarCharts.Margin.init
  , example10 = Examples.BarCharts.Borders.init
  , example11 = Examples.BarCharts.Opacity.init
  , example12 = Examples.BarCharts.Basic.init
  , example13 = Examples.LineCharts.Area.init
  , example14 = Examples.LineCharts.Gradient.init
  , example15 = Examples.LineCharts.Width.init
  , example16 = Examples.LineCharts.Montone.init
  , example17 = Examples.LineCharts.Pattern.init
  , example18 = Examples.LineCharts.Dots.init
  , example19 = Examples.LineCharts.Dashed.init
  , example20 = Examples.LineCharts.Color.init
  , example21 = Examples.LineCharts.Stacked.init
  , example22 = Examples.LineCharts.Basic.init
  , example23 = Examples.ScatterCharts.Colors.init
  , example24 = Examples.ScatterCharts.Shapes.init
  , example25 = Examples.ScatterCharts.Highlight.init
  , example26 = Examples.ScatterCharts.DataDependent.init
  , example27 = Examples.ScatterCharts.Borders.init
  , example28 = Examples.ScatterCharts.Opacity.init
  , example29 = Examples.ScatterCharts.Sizes.init
  , example30 = Examples.ScatterCharts.Basic.init
  }


type Msg
  = ExampleMsg0 Examples.BarCharts.Gradient.Msg
  | ExampleMsg1 Examples.BarCharts.Pattern.Msg
  | ExampleMsg2 Examples.BarCharts.SetX1X2.Msg
  | ExampleMsg3 Examples.BarCharts.Spacing.Msg
  | ExampleMsg4 Examples.BarCharts.DataDependent.Msg
  | ExampleMsg5 Examples.BarCharts.Color.Msg
  | ExampleMsg6 Examples.BarCharts.Corners.Msg
  | ExampleMsg7 Examples.BarCharts.Ungroup.Msg
  | ExampleMsg8 Examples.BarCharts.Stacked.Msg
  | ExampleMsg9 Examples.BarCharts.Margin.Msg
  | ExampleMsg10 Examples.BarCharts.Borders.Msg
  | ExampleMsg11 Examples.BarCharts.Opacity.Msg
  | ExampleMsg12 Examples.BarCharts.Basic.Msg
  | ExampleMsg13 Examples.LineCharts.Area.Msg
  | ExampleMsg14 Examples.LineCharts.Gradient.Msg
  | ExampleMsg15 Examples.LineCharts.Width.Msg
  | ExampleMsg16 Examples.LineCharts.Montone.Msg
  | ExampleMsg17 Examples.LineCharts.Pattern.Msg
  | ExampleMsg18 Examples.LineCharts.Dots.Msg
  | ExampleMsg19 Examples.LineCharts.Dashed.Msg
  | ExampleMsg20 Examples.LineCharts.Color.Msg
  | ExampleMsg21 Examples.LineCharts.Stacked.Msg
  | ExampleMsg22 Examples.LineCharts.Basic.Msg
  | ExampleMsg23 Examples.ScatterCharts.Colors.Msg
  | ExampleMsg24 Examples.ScatterCharts.Shapes.Msg
  | ExampleMsg25 Examples.ScatterCharts.Highlight.Msg
  | ExampleMsg26 Examples.ScatterCharts.DataDependent.Msg
  | ExampleMsg27 Examples.ScatterCharts.Borders.Msg
  | ExampleMsg28 Examples.ScatterCharts.Opacity.Msg
  | ExampleMsg29 Examples.ScatterCharts.Sizes.Msg
  | ExampleMsg30 Examples.ScatterCharts.Basic.Msg


update : Msg -> Model -> Model
update msg model =
  case msg of
    ExampleMsg0 sub -> { model | example0 = Examples.BarCharts.Gradient.update sub model.example0 }
    ExampleMsg1 sub -> { model | example1 = Examples.BarCharts.Pattern.update sub model.example1 }
    ExampleMsg2 sub -> { model | example2 = Examples.BarCharts.SetX1X2.update sub model.example2 }
    ExampleMsg3 sub -> { model | example3 = Examples.BarCharts.Spacing.update sub model.example3 }
    ExampleMsg4 sub -> { model | example4 = Examples.BarCharts.DataDependent.update sub model.example4 }
    ExampleMsg5 sub -> { model | example5 = Examples.BarCharts.Color.update sub model.example5 }
    ExampleMsg6 sub -> { model | example6 = Examples.BarCharts.Corners.update sub model.example6 }
    ExampleMsg7 sub -> { model | example7 = Examples.BarCharts.Ungroup.update sub model.example7 }
    ExampleMsg8 sub -> { model | example8 = Examples.BarCharts.Stacked.update sub model.example8 }
    ExampleMsg9 sub -> { model | example9 = Examples.BarCharts.Margin.update sub model.example9 }
    ExampleMsg10 sub -> { model | example10 = Examples.BarCharts.Borders.update sub model.example10 }
    ExampleMsg11 sub -> { model | example11 = Examples.BarCharts.Opacity.update sub model.example11 }
    ExampleMsg12 sub -> { model | example12 = Examples.BarCharts.Basic.update sub model.example12 }
    ExampleMsg13 sub -> { model | example13 = Examples.LineCharts.Area.update sub model.example13 }
    ExampleMsg14 sub -> { model | example14 = Examples.LineCharts.Gradient.update sub model.example14 }
    ExampleMsg15 sub -> { model | example15 = Examples.LineCharts.Width.update sub model.example15 }
    ExampleMsg16 sub -> { model | example16 = Examples.LineCharts.Montone.update sub model.example16 }
    ExampleMsg17 sub -> { model | example17 = Examples.LineCharts.Pattern.update sub model.example17 }
    ExampleMsg18 sub -> { model | example18 = Examples.LineCharts.Dots.update sub model.example18 }
    ExampleMsg19 sub -> { model | example19 = Examples.LineCharts.Dashed.update sub model.example19 }
    ExampleMsg20 sub -> { model | example20 = Examples.LineCharts.Color.update sub model.example20 }
    ExampleMsg21 sub -> { model | example21 = Examples.LineCharts.Stacked.update sub model.example21 }
    ExampleMsg22 sub -> { model | example22 = Examples.LineCharts.Basic.update sub model.example22 }
    ExampleMsg23 sub -> { model | example23 = Examples.ScatterCharts.Colors.update sub model.example23 }
    ExampleMsg24 sub -> { model | example24 = Examples.ScatterCharts.Shapes.update sub model.example24 }
    ExampleMsg25 sub -> { model | example25 = Examples.ScatterCharts.Highlight.update sub model.example25 }
    ExampleMsg26 sub -> { model | example26 = Examples.ScatterCharts.DataDependent.update sub model.example26 }
    ExampleMsg27 sub -> { model | example27 = Examples.ScatterCharts.Borders.update sub model.example27 }
    ExampleMsg28 sub -> { model | example28 = Examples.ScatterCharts.Opacity.update sub model.example28 }
    ExampleMsg29 sub -> { model | example29 = Examples.ScatterCharts.Sizes.update sub model.example29 }
    ExampleMsg30 sub -> { model | example30 = Examples.ScatterCharts.Basic.update sub model.example30 }


view : Model -> Id -> Html.Html Msg
view model chosen =
  case chosen of
    BarCharts__Gradient -> Html.map ExampleMsg0 (Examples.BarCharts.Gradient.view model.example0)
    BarCharts__Pattern -> Html.map ExampleMsg1 (Examples.BarCharts.Pattern.view model.example1)
    BarCharts__SetX1X2 -> Html.map ExampleMsg2 (Examples.BarCharts.SetX1X2.view model.example2)
    BarCharts__Spacing -> Html.map ExampleMsg3 (Examples.BarCharts.Spacing.view model.example3)
    BarCharts__DataDependent -> Html.map ExampleMsg4 (Examples.BarCharts.DataDependent.view model.example4)
    BarCharts__Color -> Html.map ExampleMsg5 (Examples.BarCharts.Color.view model.example5)
    BarCharts__Corners -> Html.map ExampleMsg6 (Examples.BarCharts.Corners.view model.example6)
    BarCharts__Ungroup -> Html.map ExampleMsg7 (Examples.BarCharts.Ungroup.view model.example7)
    BarCharts__Stacked -> Html.map ExampleMsg8 (Examples.BarCharts.Stacked.view model.example8)
    BarCharts__Margin -> Html.map ExampleMsg9 (Examples.BarCharts.Margin.view model.example9)
    BarCharts__Borders -> Html.map ExampleMsg10 (Examples.BarCharts.Borders.view model.example10)
    BarCharts__Opacity -> Html.map ExampleMsg11 (Examples.BarCharts.Opacity.view model.example11)
    BarCharts__Basic -> Html.map ExampleMsg12 (Examples.BarCharts.Basic.view model.example12)
    LineCharts__Area -> Html.map ExampleMsg13 (Examples.LineCharts.Area.view model.example13)
    LineCharts__Gradient -> Html.map ExampleMsg14 (Examples.LineCharts.Gradient.view model.example14)
    LineCharts__Width -> Html.map ExampleMsg15 (Examples.LineCharts.Width.view model.example15)
    LineCharts__Montone -> Html.map ExampleMsg16 (Examples.LineCharts.Montone.view model.example16)
    LineCharts__Pattern -> Html.map ExampleMsg17 (Examples.LineCharts.Pattern.view model.example17)
    LineCharts__Dots -> Html.map ExampleMsg18 (Examples.LineCharts.Dots.view model.example18)
    LineCharts__Dashed -> Html.map ExampleMsg19 (Examples.LineCharts.Dashed.view model.example19)
    LineCharts__Color -> Html.map ExampleMsg20 (Examples.LineCharts.Color.view model.example20)
    LineCharts__Stacked -> Html.map ExampleMsg21 (Examples.LineCharts.Stacked.view model.example21)
    LineCharts__Basic -> Html.map ExampleMsg22 (Examples.LineCharts.Basic.view model.example22)
    ScatterCharts__Colors -> Html.map ExampleMsg23 (Examples.ScatterCharts.Colors.view model.example23)
    ScatterCharts__Shapes -> Html.map ExampleMsg24 (Examples.ScatterCharts.Shapes.view model.example24)
    ScatterCharts__Highlight -> Html.map ExampleMsg25 (Examples.ScatterCharts.Highlight.view model.example25)
    ScatterCharts__DataDependent -> Html.map ExampleMsg26 (Examples.ScatterCharts.DataDependent.view model.example26)
    ScatterCharts__Borders -> Html.map ExampleMsg27 (Examples.ScatterCharts.Borders.view model.example27)
    ScatterCharts__Opacity -> Html.map ExampleMsg28 (Examples.ScatterCharts.Opacity.view model.example28)
    ScatterCharts__Sizes -> Html.map ExampleMsg29 (Examples.ScatterCharts.Sizes.view model.example29)
    ScatterCharts__Basic -> Html.map ExampleMsg30 (Examples.ScatterCharts.Basic.view model.example30)


smallCode : Id -> String
smallCode chosen =
  case chosen of
    BarCharts__Gradient -> Examples.BarCharts.Gradient.smallCode
    BarCharts__Pattern -> Examples.BarCharts.Pattern.smallCode
    BarCharts__SetX1X2 -> Examples.BarCharts.SetX1X2.smallCode
    BarCharts__Spacing -> Examples.BarCharts.Spacing.smallCode
    BarCharts__DataDependent -> Examples.BarCharts.DataDependent.smallCode
    BarCharts__Color -> Examples.BarCharts.Color.smallCode
    BarCharts__Corners -> Examples.BarCharts.Corners.smallCode
    BarCharts__Ungroup -> Examples.BarCharts.Ungroup.smallCode
    BarCharts__Stacked -> Examples.BarCharts.Stacked.smallCode
    BarCharts__Margin -> Examples.BarCharts.Margin.smallCode
    BarCharts__Borders -> Examples.BarCharts.Borders.smallCode
    BarCharts__Opacity -> Examples.BarCharts.Opacity.smallCode
    BarCharts__Basic -> Examples.BarCharts.Basic.smallCode
    LineCharts__Area -> Examples.LineCharts.Area.smallCode
    LineCharts__Gradient -> Examples.LineCharts.Gradient.smallCode
    LineCharts__Width -> Examples.LineCharts.Width.smallCode
    LineCharts__Montone -> Examples.LineCharts.Montone.smallCode
    LineCharts__Pattern -> Examples.LineCharts.Pattern.smallCode
    LineCharts__Dots -> Examples.LineCharts.Dots.smallCode
    LineCharts__Dashed -> Examples.LineCharts.Dashed.smallCode
    LineCharts__Color -> Examples.LineCharts.Color.smallCode
    LineCharts__Stacked -> Examples.LineCharts.Stacked.smallCode
    LineCharts__Basic -> Examples.LineCharts.Basic.smallCode
    ScatterCharts__Colors -> Examples.ScatterCharts.Colors.smallCode
    ScatterCharts__Shapes -> Examples.ScatterCharts.Shapes.smallCode
    ScatterCharts__Highlight -> Examples.ScatterCharts.Highlight.smallCode
    ScatterCharts__DataDependent -> Examples.ScatterCharts.DataDependent.smallCode
    ScatterCharts__Borders -> Examples.ScatterCharts.Borders.smallCode
    ScatterCharts__Opacity -> Examples.ScatterCharts.Opacity.smallCode
    ScatterCharts__Sizes -> Examples.ScatterCharts.Sizes.smallCode
    ScatterCharts__Basic -> Examples.ScatterCharts.Basic.smallCode


largeCode : Id -> String
largeCode chosen =
  case chosen of
    BarCharts__Gradient -> Examples.BarCharts.Gradient.largeCode
    BarCharts__Pattern -> Examples.BarCharts.Pattern.largeCode
    BarCharts__SetX1X2 -> Examples.BarCharts.SetX1X2.largeCode
    BarCharts__Spacing -> Examples.BarCharts.Spacing.largeCode
    BarCharts__DataDependent -> Examples.BarCharts.DataDependent.largeCode
    BarCharts__Color -> Examples.BarCharts.Color.largeCode
    BarCharts__Corners -> Examples.BarCharts.Corners.largeCode
    BarCharts__Ungroup -> Examples.BarCharts.Ungroup.largeCode
    BarCharts__Stacked -> Examples.BarCharts.Stacked.largeCode
    BarCharts__Margin -> Examples.BarCharts.Margin.largeCode
    BarCharts__Borders -> Examples.BarCharts.Borders.largeCode
    BarCharts__Opacity -> Examples.BarCharts.Opacity.largeCode
    BarCharts__Basic -> Examples.BarCharts.Basic.largeCode
    LineCharts__Area -> Examples.LineCharts.Area.largeCode
    LineCharts__Gradient -> Examples.LineCharts.Gradient.largeCode
    LineCharts__Width -> Examples.LineCharts.Width.largeCode
    LineCharts__Montone -> Examples.LineCharts.Montone.largeCode
    LineCharts__Pattern -> Examples.LineCharts.Pattern.largeCode
    LineCharts__Dots -> Examples.LineCharts.Dots.largeCode
    LineCharts__Dashed -> Examples.LineCharts.Dashed.largeCode
    LineCharts__Color -> Examples.LineCharts.Color.largeCode
    LineCharts__Stacked -> Examples.LineCharts.Stacked.largeCode
    LineCharts__Basic -> Examples.LineCharts.Basic.largeCode
    ScatterCharts__Colors -> Examples.ScatterCharts.Colors.largeCode
    ScatterCharts__Shapes -> Examples.ScatterCharts.Shapes.largeCode
    ScatterCharts__Highlight -> Examples.ScatterCharts.Highlight.largeCode
    ScatterCharts__DataDependent -> Examples.ScatterCharts.DataDependent.largeCode
    ScatterCharts__Borders -> Examples.ScatterCharts.Borders.largeCode
    ScatterCharts__Opacity -> Examples.ScatterCharts.Opacity.largeCode
    ScatterCharts__Sizes -> Examples.ScatterCharts.Sizes.largeCode
    ScatterCharts__Basic -> Examples.ScatterCharts.Basic.largeCode


name : Id -> String
name chosen =
  case chosen of
    BarCharts__Gradient -> "Examples.BarCharts.Gradient"
    BarCharts__Pattern -> "Examples.BarCharts.Pattern"
    BarCharts__SetX1X2 -> "Examples.BarCharts.SetX1X2"
    BarCharts__Spacing -> "Examples.BarCharts.Spacing"
    BarCharts__DataDependent -> "Examples.BarCharts.DataDependent"
    BarCharts__Color -> "Examples.BarCharts.Color"
    BarCharts__Corners -> "Examples.BarCharts.Corners"
    BarCharts__Ungroup -> "Examples.BarCharts.Ungroup"
    BarCharts__Stacked -> "Examples.BarCharts.Stacked"
    BarCharts__Margin -> "Examples.BarCharts.Margin"
    BarCharts__Borders -> "Examples.BarCharts.Borders"
    BarCharts__Opacity -> "Examples.BarCharts.Opacity"
    BarCharts__Basic -> "Examples.BarCharts.Basic"
    LineCharts__Area -> "Examples.LineCharts.Area"
    LineCharts__Gradient -> "Examples.LineCharts.Gradient"
    LineCharts__Width -> "Examples.LineCharts.Width"
    LineCharts__Montone -> "Examples.LineCharts.Montone"
    LineCharts__Pattern -> "Examples.LineCharts.Pattern"
    LineCharts__Dots -> "Examples.LineCharts.Dots"
    LineCharts__Dashed -> "Examples.LineCharts.Dashed"
    LineCharts__Color -> "Examples.LineCharts.Color"
    LineCharts__Stacked -> "Examples.LineCharts.Stacked"
    LineCharts__Basic -> "Examples.LineCharts.Basic"
    ScatterCharts__Colors -> "Examples.ScatterCharts.Colors"
    ScatterCharts__Shapes -> "Examples.ScatterCharts.Shapes"
    ScatterCharts__Highlight -> "Examples.ScatterCharts.Highlight"
    ScatterCharts__DataDependent -> "Examples.ScatterCharts.DataDependent"
    ScatterCharts__Borders -> "Examples.ScatterCharts.Borders"
    ScatterCharts__Opacity -> "Examples.ScatterCharts.Opacity"
    ScatterCharts__Sizes -> "Examples.ScatterCharts.Sizes"
    ScatterCharts__Basic -> "Examples.ScatterCharts.Basic"


all : List Id
all =
  [ BarCharts__Gradient
  , BarCharts__Pattern
  , BarCharts__SetX1X2
  , BarCharts__Spacing
  , BarCharts__DataDependent
  , BarCharts__Color
  , BarCharts__Corners
  , BarCharts__Ungroup
  , BarCharts__Stacked
  , BarCharts__Margin
  , BarCharts__Borders
  , BarCharts__Opacity
  , BarCharts__Basic
  , LineCharts__Area
  , LineCharts__Gradient
  , LineCharts__Width
  , LineCharts__Montone
  , LineCharts__Pattern
  , LineCharts__Dots
  , LineCharts__Dashed
  , LineCharts__Color
  , LineCharts__Stacked
  , LineCharts__Basic
  , ScatterCharts__Colors
  , ScatterCharts__Shapes
  , ScatterCharts__Highlight
  , ScatterCharts__DataDependent
  , ScatterCharts__Borders
  , ScatterCharts__Opacity
  , ScatterCharts__Sizes
  , ScatterCharts__Basic
  ]


first : Id
first =
  BarCharts__Gradient

