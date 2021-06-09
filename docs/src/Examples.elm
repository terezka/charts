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
  ]


first : Id
first =
  BarCharts__Gradient

