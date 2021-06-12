module Examples exposing (Id, Model, init, Msg, update, view, name, all, first, smallCode, largeCode, meta)


-- THIS IS A GENERATED MODULE!

import Html
import Examples.BarCharts.Gradient
import Examples.BarCharts.Title
import Examples.BarCharts.TooltipStack
import Examples.BarCharts.Tooltip
import Examples.BarCharts.BarLabels
import Examples.BarCharts.Pattern
import Examples.BarCharts.SetX1X2
import Examples.BarCharts.Spacing
import Examples.BarCharts.DataDependent
import Examples.BarCharts.Color
import Examples.BarCharts.TooltipBin
import Examples.BarCharts.Corners
import Examples.BarCharts.Ungroup
import Examples.BarCharts.BinLabels
import Examples.BarCharts.Stacked
import Examples.BarCharts.Margin
import Examples.BarCharts.Borders
import Examples.BarCharts.Opacity
import Examples.BarCharts.Legends
import Examples.BarCharts.Basic
import Examples.Navigation.Position
import Examples.Navigation.GridFilter
import Examples.Navigation.Dimensions
import Examples.Navigation.NoArrow
import Examples.Navigation.OnlyInts
import Examples.Navigation.GridColor
import Examples.Navigation.Offset
import Examples.Navigation.Color
import Examples.Navigation.Amount
import Examples.Navigation.CustomLabels
import Examples.Navigation.DotGrid
import Examples.Navigation.AxisLength
import Examples.Navigation.Basic
import Examples.LineCharts.Area
import Examples.LineCharts.Gradient
import Examples.LineCharts.Width
import Examples.LineCharts.TooltipStack
import Examples.LineCharts.Tooltip
import Examples.LineCharts.Montone
import Examples.LineCharts.Pattern
import Examples.LineCharts.Dots
import Examples.LineCharts.Dashed
import Examples.LineCharts.Color
import Examples.LineCharts.Stepped
import Examples.LineCharts.Stacked
import Examples.LineCharts.Labels
import Examples.LineCharts.Legends
import Examples.LineCharts.Basic
import Examples.ScatterCharts.Colors
import Examples.ScatterCharts.Shapes
import Examples.ScatterCharts.Tooltip
import Examples.ScatterCharts.Highlight
import Examples.ScatterCharts.DataDependent
import Examples.ScatterCharts.Borders
import Examples.ScatterCharts.Labels
import Examples.ScatterCharts.Opacity
import Examples.ScatterCharts.Sizes
import Examples.ScatterCharts.Legends
import Examples.ScatterCharts.Basic


type Id
  = BarCharts__Gradient
  | BarCharts__Title
  | BarCharts__TooltipStack
  | BarCharts__Tooltip
  | BarCharts__BarLabels
  | BarCharts__Pattern
  | BarCharts__SetX1X2
  | BarCharts__Spacing
  | BarCharts__DataDependent
  | BarCharts__Color
  | BarCharts__TooltipBin
  | BarCharts__Corners
  | BarCharts__Ungroup
  | BarCharts__BinLabels
  | BarCharts__Stacked
  | BarCharts__Margin
  | BarCharts__Borders
  | BarCharts__Opacity
  | BarCharts__Legends
  | BarCharts__Basic
  | Navigation__Position
  | Navigation__GridFilter
  | Navigation__Dimensions
  | Navigation__NoArrow
  | Navigation__OnlyInts
  | Navigation__GridColor
  | Navigation__Offset
  | Navigation__Color
  | Navigation__Amount
  | Navigation__CustomLabels
  | Navigation__DotGrid
  | Navigation__AxisLength
  | Navigation__Basic
  | LineCharts__Area
  | LineCharts__Gradient
  | LineCharts__Width
  | LineCharts__TooltipStack
  | LineCharts__Tooltip
  | LineCharts__Montone
  | LineCharts__Pattern
  | LineCharts__Dots
  | LineCharts__Dashed
  | LineCharts__Color
  | LineCharts__Stepped
  | LineCharts__Stacked
  | LineCharts__Labels
  | LineCharts__Legends
  | LineCharts__Basic
  | ScatterCharts__Colors
  | ScatterCharts__Shapes
  | ScatterCharts__Tooltip
  | ScatterCharts__Highlight
  | ScatterCharts__DataDependent
  | ScatterCharts__Borders
  | ScatterCharts__Labels
  | ScatterCharts__Opacity
  | ScatterCharts__Sizes
  | ScatterCharts__Legends
  | ScatterCharts__Basic


type alias Model =
  { example0 : Examples.BarCharts.Gradient.Model
  , example1 : Examples.BarCharts.Title.Model
  , example2 : Examples.BarCharts.TooltipStack.Model
  , example3 : Examples.BarCharts.Tooltip.Model
  , example4 : Examples.BarCharts.BarLabels.Model
  , example5 : Examples.BarCharts.Pattern.Model
  , example6 : Examples.BarCharts.SetX1X2.Model
  , example7 : Examples.BarCharts.Spacing.Model
  , example8 : Examples.BarCharts.DataDependent.Model
  , example9 : Examples.BarCharts.Color.Model
  , example10 : Examples.BarCharts.TooltipBin.Model
  , example11 : Examples.BarCharts.Corners.Model
  , example12 : Examples.BarCharts.Ungroup.Model
  , example13 : Examples.BarCharts.BinLabels.Model
  , example14 : Examples.BarCharts.Stacked.Model
  , example15 : Examples.BarCharts.Margin.Model
  , example16 : Examples.BarCharts.Borders.Model
  , example17 : Examples.BarCharts.Opacity.Model
  , example18 : Examples.BarCharts.Legends.Model
  , example19 : Examples.BarCharts.Basic.Model
  , example20 : Examples.Navigation.Position.Model
  , example21 : Examples.Navigation.GridFilter.Model
  , example22 : Examples.Navigation.Dimensions.Model
  , example23 : Examples.Navigation.NoArrow.Model
  , example24 : Examples.Navigation.OnlyInts.Model
  , example25 : Examples.Navigation.GridColor.Model
  , example26 : Examples.Navigation.Offset.Model
  , example27 : Examples.Navigation.Color.Model
  , example28 : Examples.Navigation.Amount.Model
  , example29 : Examples.Navigation.CustomLabels.Model
  , example30 : Examples.Navigation.DotGrid.Model
  , example31 : Examples.Navigation.AxisLength.Model
  , example32 : Examples.Navigation.Basic.Model
  , example33 : Examples.LineCharts.Area.Model
  , example34 : Examples.LineCharts.Gradient.Model
  , example35 : Examples.LineCharts.Width.Model
  , example36 : Examples.LineCharts.TooltipStack.Model
  , example37 : Examples.LineCharts.Tooltip.Model
  , example38 : Examples.LineCharts.Montone.Model
  , example39 : Examples.LineCharts.Pattern.Model
  , example40 : Examples.LineCharts.Dots.Model
  , example41 : Examples.LineCharts.Dashed.Model
  , example42 : Examples.LineCharts.Color.Model
  , example43 : Examples.LineCharts.Stepped.Model
  , example44 : Examples.LineCharts.Stacked.Model
  , example45 : Examples.LineCharts.Labels.Model
  , example46 : Examples.LineCharts.Legends.Model
  , example47 : Examples.LineCharts.Basic.Model
  , example48 : Examples.ScatterCharts.Colors.Model
  , example49 : Examples.ScatterCharts.Shapes.Model
  , example50 : Examples.ScatterCharts.Tooltip.Model
  , example51 : Examples.ScatterCharts.Highlight.Model
  , example52 : Examples.ScatterCharts.DataDependent.Model
  , example53 : Examples.ScatterCharts.Borders.Model
  , example54 : Examples.ScatterCharts.Labels.Model
  , example55 : Examples.ScatterCharts.Opacity.Model
  , example56 : Examples.ScatterCharts.Sizes.Model
  , example57 : Examples.ScatterCharts.Legends.Model
  , example58 : Examples.ScatterCharts.Basic.Model
  }


init : Model
init =
  { example0 = Examples.BarCharts.Gradient.init
  , example1 = Examples.BarCharts.Title.init
  , example2 = Examples.BarCharts.TooltipStack.init
  , example3 = Examples.BarCharts.Tooltip.init
  , example4 = Examples.BarCharts.BarLabels.init
  , example5 = Examples.BarCharts.Pattern.init
  , example6 = Examples.BarCharts.SetX1X2.init
  , example7 = Examples.BarCharts.Spacing.init
  , example8 = Examples.BarCharts.DataDependent.init
  , example9 = Examples.BarCharts.Color.init
  , example10 = Examples.BarCharts.TooltipBin.init
  , example11 = Examples.BarCharts.Corners.init
  , example12 = Examples.BarCharts.Ungroup.init
  , example13 = Examples.BarCharts.BinLabels.init
  , example14 = Examples.BarCharts.Stacked.init
  , example15 = Examples.BarCharts.Margin.init
  , example16 = Examples.BarCharts.Borders.init
  , example17 = Examples.BarCharts.Opacity.init
  , example18 = Examples.BarCharts.Legends.init
  , example19 = Examples.BarCharts.Basic.init
  , example20 = Examples.Navigation.Position.init
  , example21 = Examples.Navigation.GridFilter.init
  , example22 = Examples.Navigation.Dimensions.init
  , example23 = Examples.Navigation.NoArrow.init
  , example24 = Examples.Navigation.OnlyInts.init
  , example25 = Examples.Navigation.GridColor.init
  , example26 = Examples.Navigation.Offset.init
  , example27 = Examples.Navigation.Color.init
  , example28 = Examples.Navigation.Amount.init
  , example29 = Examples.Navigation.CustomLabels.init
  , example30 = Examples.Navigation.DotGrid.init
  , example31 = Examples.Navigation.AxisLength.init
  , example32 = Examples.Navigation.Basic.init
  , example33 = Examples.LineCharts.Area.init
  , example34 = Examples.LineCharts.Gradient.init
  , example35 = Examples.LineCharts.Width.init
  , example36 = Examples.LineCharts.TooltipStack.init
  , example37 = Examples.LineCharts.Tooltip.init
  , example38 = Examples.LineCharts.Montone.init
  , example39 = Examples.LineCharts.Pattern.init
  , example40 = Examples.LineCharts.Dots.init
  , example41 = Examples.LineCharts.Dashed.init
  , example42 = Examples.LineCharts.Color.init
  , example43 = Examples.LineCharts.Stepped.init
  , example44 = Examples.LineCharts.Stacked.init
  , example45 = Examples.LineCharts.Labels.init
  , example46 = Examples.LineCharts.Legends.init
  , example47 = Examples.LineCharts.Basic.init
  , example48 = Examples.ScatterCharts.Colors.init
  , example49 = Examples.ScatterCharts.Shapes.init
  , example50 = Examples.ScatterCharts.Tooltip.init
  , example51 = Examples.ScatterCharts.Highlight.init
  , example52 = Examples.ScatterCharts.DataDependent.init
  , example53 = Examples.ScatterCharts.Borders.init
  , example54 = Examples.ScatterCharts.Labels.init
  , example55 = Examples.ScatterCharts.Opacity.init
  , example56 = Examples.ScatterCharts.Sizes.init
  , example57 = Examples.ScatterCharts.Legends.init
  , example58 = Examples.ScatterCharts.Basic.init
  }


type Msg
  = ExampleMsg0 Examples.BarCharts.Gradient.Msg
  | ExampleMsg1 Examples.BarCharts.Title.Msg
  | ExampleMsg2 Examples.BarCharts.TooltipStack.Msg
  | ExampleMsg3 Examples.BarCharts.Tooltip.Msg
  | ExampleMsg4 Examples.BarCharts.BarLabels.Msg
  | ExampleMsg5 Examples.BarCharts.Pattern.Msg
  | ExampleMsg6 Examples.BarCharts.SetX1X2.Msg
  | ExampleMsg7 Examples.BarCharts.Spacing.Msg
  | ExampleMsg8 Examples.BarCharts.DataDependent.Msg
  | ExampleMsg9 Examples.BarCharts.Color.Msg
  | ExampleMsg10 Examples.BarCharts.TooltipBin.Msg
  | ExampleMsg11 Examples.BarCharts.Corners.Msg
  | ExampleMsg12 Examples.BarCharts.Ungroup.Msg
  | ExampleMsg13 Examples.BarCharts.BinLabels.Msg
  | ExampleMsg14 Examples.BarCharts.Stacked.Msg
  | ExampleMsg15 Examples.BarCharts.Margin.Msg
  | ExampleMsg16 Examples.BarCharts.Borders.Msg
  | ExampleMsg17 Examples.BarCharts.Opacity.Msg
  | ExampleMsg18 Examples.BarCharts.Legends.Msg
  | ExampleMsg19 Examples.BarCharts.Basic.Msg
  | ExampleMsg20 Examples.Navigation.Position.Msg
  | ExampleMsg21 Examples.Navigation.GridFilter.Msg
  | ExampleMsg22 Examples.Navigation.Dimensions.Msg
  | ExampleMsg23 Examples.Navigation.NoArrow.Msg
  | ExampleMsg24 Examples.Navigation.OnlyInts.Msg
  | ExampleMsg25 Examples.Navigation.GridColor.Msg
  | ExampleMsg26 Examples.Navigation.Offset.Msg
  | ExampleMsg27 Examples.Navigation.Color.Msg
  | ExampleMsg28 Examples.Navigation.Amount.Msg
  | ExampleMsg29 Examples.Navigation.CustomLabels.Msg
  | ExampleMsg30 Examples.Navigation.DotGrid.Msg
  | ExampleMsg31 Examples.Navigation.AxisLength.Msg
  | ExampleMsg32 Examples.Navigation.Basic.Msg
  | ExampleMsg33 Examples.LineCharts.Area.Msg
  | ExampleMsg34 Examples.LineCharts.Gradient.Msg
  | ExampleMsg35 Examples.LineCharts.Width.Msg
  | ExampleMsg36 Examples.LineCharts.TooltipStack.Msg
  | ExampleMsg37 Examples.LineCharts.Tooltip.Msg
  | ExampleMsg38 Examples.LineCharts.Montone.Msg
  | ExampleMsg39 Examples.LineCharts.Pattern.Msg
  | ExampleMsg40 Examples.LineCharts.Dots.Msg
  | ExampleMsg41 Examples.LineCharts.Dashed.Msg
  | ExampleMsg42 Examples.LineCharts.Color.Msg
  | ExampleMsg43 Examples.LineCharts.Stepped.Msg
  | ExampleMsg44 Examples.LineCharts.Stacked.Msg
  | ExampleMsg45 Examples.LineCharts.Labels.Msg
  | ExampleMsg46 Examples.LineCharts.Legends.Msg
  | ExampleMsg47 Examples.LineCharts.Basic.Msg
  | ExampleMsg48 Examples.ScatterCharts.Colors.Msg
  | ExampleMsg49 Examples.ScatterCharts.Shapes.Msg
  | ExampleMsg50 Examples.ScatterCharts.Tooltip.Msg
  | ExampleMsg51 Examples.ScatterCharts.Highlight.Msg
  | ExampleMsg52 Examples.ScatterCharts.DataDependent.Msg
  | ExampleMsg53 Examples.ScatterCharts.Borders.Msg
  | ExampleMsg54 Examples.ScatterCharts.Labels.Msg
  | ExampleMsg55 Examples.ScatterCharts.Opacity.Msg
  | ExampleMsg56 Examples.ScatterCharts.Sizes.Msg
  | ExampleMsg57 Examples.ScatterCharts.Legends.Msg
  | ExampleMsg58 Examples.ScatterCharts.Basic.Msg


update : Msg -> Model -> Model
update msg model =
  case msg of
    ExampleMsg0 sub -> { model | example0 = Examples.BarCharts.Gradient.update sub model.example0 }
    ExampleMsg1 sub -> { model | example1 = Examples.BarCharts.Title.update sub model.example1 }
    ExampleMsg2 sub -> { model | example2 = Examples.BarCharts.TooltipStack.update sub model.example2 }
    ExampleMsg3 sub -> { model | example3 = Examples.BarCharts.Tooltip.update sub model.example3 }
    ExampleMsg4 sub -> { model | example4 = Examples.BarCharts.BarLabels.update sub model.example4 }
    ExampleMsg5 sub -> { model | example5 = Examples.BarCharts.Pattern.update sub model.example5 }
    ExampleMsg6 sub -> { model | example6 = Examples.BarCharts.SetX1X2.update sub model.example6 }
    ExampleMsg7 sub -> { model | example7 = Examples.BarCharts.Spacing.update sub model.example7 }
    ExampleMsg8 sub -> { model | example8 = Examples.BarCharts.DataDependent.update sub model.example8 }
    ExampleMsg9 sub -> { model | example9 = Examples.BarCharts.Color.update sub model.example9 }
    ExampleMsg10 sub -> { model | example10 = Examples.BarCharts.TooltipBin.update sub model.example10 }
    ExampleMsg11 sub -> { model | example11 = Examples.BarCharts.Corners.update sub model.example11 }
    ExampleMsg12 sub -> { model | example12 = Examples.BarCharts.Ungroup.update sub model.example12 }
    ExampleMsg13 sub -> { model | example13 = Examples.BarCharts.BinLabels.update sub model.example13 }
    ExampleMsg14 sub -> { model | example14 = Examples.BarCharts.Stacked.update sub model.example14 }
    ExampleMsg15 sub -> { model | example15 = Examples.BarCharts.Margin.update sub model.example15 }
    ExampleMsg16 sub -> { model | example16 = Examples.BarCharts.Borders.update sub model.example16 }
    ExampleMsg17 sub -> { model | example17 = Examples.BarCharts.Opacity.update sub model.example17 }
    ExampleMsg18 sub -> { model | example18 = Examples.BarCharts.Legends.update sub model.example18 }
    ExampleMsg19 sub -> { model | example19 = Examples.BarCharts.Basic.update sub model.example19 }
    ExampleMsg20 sub -> { model | example20 = Examples.Navigation.Position.update sub model.example20 }
    ExampleMsg21 sub -> { model | example21 = Examples.Navigation.GridFilter.update sub model.example21 }
    ExampleMsg22 sub -> { model | example22 = Examples.Navigation.Dimensions.update sub model.example22 }
    ExampleMsg23 sub -> { model | example23 = Examples.Navigation.NoArrow.update sub model.example23 }
    ExampleMsg24 sub -> { model | example24 = Examples.Navigation.OnlyInts.update sub model.example24 }
    ExampleMsg25 sub -> { model | example25 = Examples.Navigation.GridColor.update sub model.example25 }
    ExampleMsg26 sub -> { model | example26 = Examples.Navigation.Offset.update sub model.example26 }
    ExampleMsg27 sub -> { model | example27 = Examples.Navigation.Color.update sub model.example27 }
    ExampleMsg28 sub -> { model | example28 = Examples.Navigation.Amount.update sub model.example28 }
    ExampleMsg29 sub -> { model | example29 = Examples.Navigation.CustomLabels.update sub model.example29 }
    ExampleMsg30 sub -> { model | example30 = Examples.Navigation.DotGrid.update sub model.example30 }
    ExampleMsg31 sub -> { model | example31 = Examples.Navigation.AxisLength.update sub model.example31 }
    ExampleMsg32 sub -> { model | example32 = Examples.Navigation.Basic.update sub model.example32 }
    ExampleMsg33 sub -> { model | example33 = Examples.LineCharts.Area.update sub model.example33 }
    ExampleMsg34 sub -> { model | example34 = Examples.LineCharts.Gradient.update sub model.example34 }
    ExampleMsg35 sub -> { model | example35 = Examples.LineCharts.Width.update sub model.example35 }
    ExampleMsg36 sub -> { model | example36 = Examples.LineCharts.TooltipStack.update sub model.example36 }
    ExampleMsg37 sub -> { model | example37 = Examples.LineCharts.Tooltip.update sub model.example37 }
    ExampleMsg38 sub -> { model | example38 = Examples.LineCharts.Montone.update sub model.example38 }
    ExampleMsg39 sub -> { model | example39 = Examples.LineCharts.Pattern.update sub model.example39 }
    ExampleMsg40 sub -> { model | example40 = Examples.LineCharts.Dots.update sub model.example40 }
    ExampleMsg41 sub -> { model | example41 = Examples.LineCharts.Dashed.update sub model.example41 }
    ExampleMsg42 sub -> { model | example42 = Examples.LineCharts.Color.update sub model.example42 }
    ExampleMsg43 sub -> { model | example43 = Examples.LineCharts.Stepped.update sub model.example43 }
    ExampleMsg44 sub -> { model | example44 = Examples.LineCharts.Stacked.update sub model.example44 }
    ExampleMsg45 sub -> { model | example45 = Examples.LineCharts.Labels.update sub model.example45 }
    ExampleMsg46 sub -> { model | example46 = Examples.LineCharts.Legends.update sub model.example46 }
    ExampleMsg47 sub -> { model | example47 = Examples.LineCharts.Basic.update sub model.example47 }
    ExampleMsg48 sub -> { model | example48 = Examples.ScatterCharts.Colors.update sub model.example48 }
    ExampleMsg49 sub -> { model | example49 = Examples.ScatterCharts.Shapes.update sub model.example49 }
    ExampleMsg50 sub -> { model | example50 = Examples.ScatterCharts.Tooltip.update sub model.example50 }
    ExampleMsg51 sub -> { model | example51 = Examples.ScatterCharts.Highlight.update sub model.example51 }
    ExampleMsg52 sub -> { model | example52 = Examples.ScatterCharts.DataDependent.update sub model.example52 }
    ExampleMsg53 sub -> { model | example53 = Examples.ScatterCharts.Borders.update sub model.example53 }
    ExampleMsg54 sub -> { model | example54 = Examples.ScatterCharts.Labels.update sub model.example54 }
    ExampleMsg55 sub -> { model | example55 = Examples.ScatterCharts.Opacity.update sub model.example55 }
    ExampleMsg56 sub -> { model | example56 = Examples.ScatterCharts.Sizes.update sub model.example56 }
    ExampleMsg57 sub -> { model | example57 = Examples.ScatterCharts.Legends.update sub model.example57 }
    ExampleMsg58 sub -> { model | example58 = Examples.ScatterCharts.Basic.update sub model.example58 }


view : Model -> Id -> Html.Html Msg
view model chosen =
  case chosen of
    BarCharts__Gradient -> Html.map ExampleMsg0 (Examples.BarCharts.Gradient.view model.example0)
    BarCharts__Title -> Html.map ExampleMsg1 (Examples.BarCharts.Title.view model.example1)
    BarCharts__TooltipStack -> Html.map ExampleMsg2 (Examples.BarCharts.TooltipStack.view model.example2)
    BarCharts__Tooltip -> Html.map ExampleMsg3 (Examples.BarCharts.Tooltip.view model.example3)
    BarCharts__BarLabels -> Html.map ExampleMsg4 (Examples.BarCharts.BarLabels.view model.example4)
    BarCharts__Pattern -> Html.map ExampleMsg5 (Examples.BarCharts.Pattern.view model.example5)
    BarCharts__SetX1X2 -> Html.map ExampleMsg6 (Examples.BarCharts.SetX1X2.view model.example6)
    BarCharts__Spacing -> Html.map ExampleMsg7 (Examples.BarCharts.Spacing.view model.example7)
    BarCharts__DataDependent -> Html.map ExampleMsg8 (Examples.BarCharts.DataDependent.view model.example8)
    BarCharts__Color -> Html.map ExampleMsg9 (Examples.BarCharts.Color.view model.example9)
    BarCharts__TooltipBin -> Html.map ExampleMsg10 (Examples.BarCharts.TooltipBin.view model.example10)
    BarCharts__Corners -> Html.map ExampleMsg11 (Examples.BarCharts.Corners.view model.example11)
    BarCharts__Ungroup -> Html.map ExampleMsg12 (Examples.BarCharts.Ungroup.view model.example12)
    BarCharts__BinLabels -> Html.map ExampleMsg13 (Examples.BarCharts.BinLabels.view model.example13)
    BarCharts__Stacked -> Html.map ExampleMsg14 (Examples.BarCharts.Stacked.view model.example14)
    BarCharts__Margin -> Html.map ExampleMsg15 (Examples.BarCharts.Margin.view model.example15)
    BarCharts__Borders -> Html.map ExampleMsg16 (Examples.BarCharts.Borders.view model.example16)
    BarCharts__Opacity -> Html.map ExampleMsg17 (Examples.BarCharts.Opacity.view model.example17)
    BarCharts__Legends -> Html.map ExampleMsg18 (Examples.BarCharts.Legends.view model.example18)
    BarCharts__Basic -> Html.map ExampleMsg19 (Examples.BarCharts.Basic.view model.example19)
    Navigation__Position -> Html.map ExampleMsg20 (Examples.Navigation.Position.view model.example20)
    Navigation__GridFilter -> Html.map ExampleMsg21 (Examples.Navigation.GridFilter.view model.example21)
    Navigation__Dimensions -> Html.map ExampleMsg22 (Examples.Navigation.Dimensions.view model.example22)
    Navigation__NoArrow -> Html.map ExampleMsg23 (Examples.Navigation.NoArrow.view model.example23)
    Navigation__OnlyInts -> Html.map ExampleMsg24 (Examples.Navigation.OnlyInts.view model.example24)
    Navigation__GridColor -> Html.map ExampleMsg25 (Examples.Navigation.GridColor.view model.example25)
    Navigation__Offset -> Html.map ExampleMsg26 (Examples.Navigation.Offset.view model.example26)
    Navigation__Color -> Html.map ExampleMsg27 (Examples.Navigation.Color.view model.example27)
    Navigation__Amount -> Html.map ExampleMsg28 (Examples.Navigation.Amount.view model.example28)
    Navigation__CustomLabels -> Html.map ExampleMsg29 (Examples.Navigation.CustomLabels.view model.example29)
    Navigation__DotGrid -> Html.map ExampleMsg30 (Examples.Navigation.DotGrid.view model.example30)
    Navigation__AxisLength -> Html.map ExampleMsg31 (Examples.Navigation.AxisLength.view model.example31)
    Navigation__Basic -> Html.map ExampleMsg32 (Examples.Navigation.Basic.view model.example32)
    LineCharts__Area -> Html.map ExampleMsg33 (Examples.LineCharts.Area.view model.example33)
    LineCharts__Gradient -> Html.map ExampleMsg34 (Examples.LineCharts.Gradient.view model.example34)
    LineCharts__Width -> Html.map ExampleMsg35 (Examples.LineCharts.Width.view model.example35)
    LineCharts__TooltipStack -> Html.map ExampleMsg36 (Examples.LineCharts.TooltipStack.view model.example36)
    LineCharts__Tooltip -> Html.map ExampleMsg37 (Examples.LineCharts.Tooltip.view model.example37)
    LineCharts__Montone -> Html.map ExampleMsg38 (Examples.LineCharts.Montone.view model.example38)
    LineCharts__Pattern -> Html.map ExampleMsg39 (Examples.LineCharts.Pattern.view model.example39)
    LineCharts__Dots -> Html.map ExampleMsg40 (Examples.LineCharts.Dots.view model.example40)
    LineCharts__Dashed -> Html.map ExampleMsg41 (Examples.LineCharts.Dashed.view model.example41)
    LineCharts__Color -> Html.map ExampleMsg42 (Examples.LineCharts.Color.view model.example42)
    LineCharts__Stepped -> Html.map ExampleMsg43 (Examples.LineCharts.Stepped.view model.example43)
    LineCharts__Stacked -> Html.map ExampleMsg44 (Examples.LineCharts.Stacked.view model.example44)
    LineCharts__Labels -> Html.map ExampleMsg45 (Examples.LineCharts.Labels.view model.example45)
    LineCharts__Legends -> Html.map ExampleMsg46 (Examples.LineCharts.Legends.view model.example46)
    LineCharts__Basic -> Html.map ExampleMsg47 (Examples.LineCharts.Basic.view model.example47)
    ScatterCharts__Colors -> Html.map ExampleMsg48 (Examples.ScatterCharts.Colors.view model.example48)
    ScatterCharts__Shapes -> Html.map ExampleMsg49 (Examples.ScatterCharts.Shapes.view model.example49)
    ScatterCharts__Tooltip -> Html.map ExampleMsg50 (Examples.ScatterCharts.Tooltip.view model.example50)
    ScatterCharts__Highlight -> Html.map ExampleMsg51 (Examples.ScatterCharts.Highlight.view model.example51)
    ScatterCharts__DataDependent -> Html.map ExampleMsg52 (Examples.ScatterCharts.DataDependent.view model.example52)
    ScatterCharts__Borders -> Html.map ExampleMsg53 (Examples.ScatterCharts.Borders.view model.example53)
    ScatterCharts__Labels -> Html.map ExampleMsg54 (Examples.ScatterCharts.Labels.view model.example54)
    ScatterCharts__Opacity -> Html.map ExampleMsg55 (Examples.ScatterCharts.Opacity.view model.example55)
    ScatterCharts__Sizes -> Html.map ExampleMsg56 (Examples.ScatterCharts.Sizes.view model.example56)
    ScatterCharts__Legends -> Html.map ExampleMsg57 (Examples.ScatterCharts.Legends.view model.example57)
    ScatterCharts__Basic -> Html.map ExampleMsg58 (Examples.ScatterCharts.Basic.view model.example58)


smallCode : Id -> String
smallCode chosen =
  case chosen of
    BarCharts__Gradient -> Examples.BarCharts.Gradient.smallCode
    BarCharts__Title -> Examples.BarCharts.Title.smallCode
    BarCharts__TooltipStack -> Examples.BarCharts.TooltipStack.smallCode
    BarCharts__Tooltip -> Examples.BarCharts.Tooltip.smallCode
    BarCharts__BarLabels -> Examples.BarCharts.BarLabels.smallCode
    BarCharts__Pattern -> Examples.BarCharts.Pattern.smallCode
    BarCharts__SetX1X2 -> Examples.BarCharts.SetX1X2.smallCode
    BarCharts__Spacing -> Examples.BarCharts.Spacing.smallCode
    BarCharts__DataDependent -> Examples.BarCharts.DataDependent.smallCode
    BarCharts__Color -> Examples.BarCharts.Color.smallCode
    BarCharts__TooltipBin -> Examples.BarCharts.TooltipBin.smallCode
    BarCharts__Corners -> Examples.BarCharts.Corners.smallCode
    BarCharts__Ungroup -> Examples.BarCharts.Ungroup.smallCode
    BarCharts__BinLabels -> Examples.BarCharts.BinLabels.smallCode
    BarCharts__Stacked -> Examples.BarCharts.Stacked.smallCode
    BarCharts__Margin -> Examples.BarCharts.Margin.smallCode
    BarCharts__Borders -> Examples.BarCharts.Borders.smallCode
    BarCharts__Opacity -> Examples.BarCharts.Opacity.smallCode
    BarCharts__Legends -> Examples.BarCharts.Legends.smallCode
    BarCharts__Basic -> Examples.BarCharts.Basic.smallCode
    Navigation__Position -> Examples.Navigation.Position.smallCode
    Navigation__GridFilter -> Examples.Navigation.GridFilter.smallCode
    Navigation__Dimensions -> Examples.Navigation.Dimensions.smallCode
    Navigation__NoArrow -> Examples.Navigation.NoArrow.smallCode
    Navigation__OnlyInts -> Examples.Navigation.OnlyInts.smallCode
    Navigation__GridColor -> Examples.Navigation.GridColor.smallCode
    Navigation__Offset -> Examples.Navigation.Offset.smallCode
    Navigation__Color -> Examples.Navigation.Color.smallCode
    Navigation__Amount -> Examples.Navigation.Amount.smallCode
    Navigation__CustomLabels -> Examples.Navigation.CustomLabels.smallCode
    Navigation__DotGrid -> Examples.Navigation.DotGrid.smallCode
    Navigation__AxisLength -> Examples.Navigation.AxisLength.smallCode
    Navigation__Basic -> Examples.Navigation.Basic.smallCode
    LineCharts__Area -> Examples.LineCharts.Area.smallCode
    LineCharts__Gradient -> Examples.LineCharts.Gradient.smallCode
    LineCharts__Width -> Examples.LineCharts.Width.smallCode
    LineCharts__TooltipStack -> Examples.LineCharts.TooltipStack.smallCode
    LineCharts__Tooltip -> Examples.LineCharts.Tooltip.smallCode
    LineCharts__Montone -> Examples.LineCharts.Montone.smallCode
    LineCharts__Pattern -> Examples.LineCharts.Pattern.smallCode
    LineCharts__Dots -> Examples.LineCharts.Dots.smallCode
    LineCharts__Dashed -> Examples.LineCharts.Dashed.smallCode
    LineCharts__Color -> Examples.LineCharts.Color.smallCode
    LineCharts__Stepped -> Examples.LineCharts.Stepped.smallCode
    LineCharts__Stacked -> Examples.LineCharts.Stacked.smallCode
    LineCharts__Labels -> Examples.LineCharts.Labels.smallCode
    LineCharts__Legends -> Examples.LineCharts.Legends.smallCode
    LineCharts__Basic -> Examples.LineCharts.Basic.smallCode
    ScatterCharts__Colors -> Examples.ScatterCharts.Colors.smallCode
    ScatterCharts__Shapes -> Examples.ScatterCharts.Shapes.smallCode
    ScatterCharts__Tooltip -> Examples.ScatterCharts.Tooltip.smallCode
    ScatterCharts__Highlight -> Examples.ScatterCharts.Highlight.smallCode
    ScatterCharts__DataDependent -> Examples.ScatterCharts.DataDependent.smallCode
    ScatterCharts__Borders -> Examples.ScatterCharts.Borders.smallCode
    ScatterCharts__Labels -> Examples.ScatterCharts.Labels.smallCode
    ScatterCharts__Opacity -> Examples.ScatterCharts.Opacity.smallCode
    ScatterCharts__Sizes -> Examples.ScatterCharts.Sizes.smallCode
    ScatterCharts__Legends -> Examples.ScatterCharts.Legends.smallCode
    ScatterCharts__Basic -> Examples.ScatterCharts.Basic.smallCode


largeCode : Id -> String
largeCode chosen =
  case chosen of
    BarCharts__Gradient -> Examples.BarCharts.Gradient.largeCode
    BarCharts__Title -> Examples.BarCharts.Title.largeCode
    BarCharts__TooltipStack -> Examples.BarCharts.TooltipStack.largeCode
    BarCharts__Tooltip -> Examples.BarCharts.Tooltip.largeCode
    BarCharts__BarLabels -> Examples.BarCharts.BarLabels.largeCode
    BarCharts__Pattern -> Examples.BarCharts.Pattern.largeCode
    BarCharts__SetX1X2 -> Examples.BarCharts.SetX1X2.largeCode
    BarCharts__Spacing -> Examples.BarCharts.Spacing.largeCode
    BarCharts__DataDependent -> Examples.BarCharts.DataDependent.largeCode
    BarCharts__Color -> Examples.BarCharts.Color.largeCode
    BarCharts__TooltipBin -> Examples.BarCharts.TooltipBin.largeCode
    BarCharts__Corners -> Examples.BarCharts.Corners.largeCode
    BarCharts__Ungroup -> Examples.BarCharts.Ungroup.largeCode
    BarCharts__BinLabels -> Examples.BarCharts.BinLabels.largeCode
    BarCharts__Stacked -> Examples.BarCharts.Stacked.largeCode
    BarCharts__Margin -> Examples.BarCharts.Margin.largeCode
    BarCharts__Borders -> Examples.BarCharts.Borders.largeCode
    BarCharts__Opacity -> Examples.BarCharts.Opacity.largeCode
    BarCharts__Legends -> Examples.BarCharts.Legends.largeCode
    BarCharts__Basic -> Examples.BarCharts.Basic.largeCode
    Navigation__Position -> Examples.Navigation.Position.largeCode
    Navigation__GridFilter -> Examples.Navigation.GridFilter.largeCode
    Navigation__Dimensions -> Examples.Navigation.Dimensions.largeCode
    Navigation__NoArrow -> Examples.Navigation.NoArrow.largeCode
    Navigation__OnlyInts -> Examples.Navigation.OnlyInts.largeCode
    Navigation__GridColor -> Examples.Navigation.GridColor.largeCode
    Navigation__Offset -> Examples.Navigation.Offset.largeCode
    Navigation__Color -> Examples.Navigation.Color.largeCode
    Navigation__Amount -> Examples.Navigation.Amount.largeCode
    Navigation__CustomLabels -> Examples.Navigation.CustomLabels.largeCode
    Navigation__DotGrid -> Examples.Navigation.DotGrid.largeCode
    Navigation__AxisLength -> Examples.Navigation.AxisLength.largeCode
    Navigation__Basic -> Examples.Navigation.Basic.largeCode
    LineCharts__Area -> Examples.LineCharts.Area.largeCode
    LineCharts__Gradient -> Examples.LineCharts.Gradient.largeCode
    LineCharts__Width -> Examples.LineCharts.Width.largeCode
    LineCharts__TooltipStack -> Examples.LineCharts.TooltipStack.largeCode
    LineCharts__Tooltip -> Examples.LineCharts.Tooltip.largeCode
    LineCharts__Montone -> Examples.LineCharts.Montone.largeCode
    LineCharts__Pattern -> Examples.LineCharts.Pattern.largeCode
    LineCharts__Dots -> Examples.LineCharts.Dots.largeCode
    LineCharts__Dashed -> Examples.LineCharts.Dashed.largeCode
    LineCharts__Color -> Examples.LineCharts.Color.largeCode
    LineCharts__Stepped -> Examples.LineCharts.Stepped.largeCode
    LineCharts__Stacked -> Examples.LineCharts.Stacked.largeCode
    LineCharts__Labels -> Examples.LineCharts.Labels.largeCode
    LineCharts__Legends -> Examples.LineCharts.Legends.largeCode
    LineCharts__Basic -> Examples.LineCharts.Basic.largeCode
    ScatterCharts__Colors -> Examples.ScatterCharts.Colors.largeCode
    ScatterCharts__Shapes -> Examples.ScatterCharts.Shapes.largeCode
    ScatterCharts__Tooltip -> Examples.ScatterCharts.Tooltip.largeCode
    ScatterCharts__Highlight -> Examples.ScatterCharts.Highlight.largeCode
    ScatterCharts__DataDependent -> Examples.ScatterCharts.DataDependent.largeCode
    ScatterCharts__Borders -> Examples.ScatterCharts.Borders.largeCode
    ScatterCharts__Labels -> Examples.ScatterCharts.Labels.largeCode
    ScatterCharts__Opacity -> Examples.ScatterCharts.Opacity.largeCode
    ScatterCharts__Sizes -> Examples.ScatterCharts.Sizes.largeCode
    ScatterCharts__Legends -> Examples.ScatterCharts.Legends.largeCode
    ScatterCharts__Basic -> Examples.ScatterCharts.Basic.largeCode


name : Id -> String
name chosen =
  case chosen of
    BarCharts__Gradient -> "Examples.BarCharts.Gradient"
    BarCharts__Title -> "Examples.BarCharts.Title"
    BarCharts__TooltipStack -> "Examples.BarCharts.TooltipStack"
    BarCharts__Tooltip -> "Examples.BarCharts.Tooltip"
    BarCharts__BarLabels -> "Examples.BarCharts.BarLabels"
    BarCharts__Pattern -> "Examples.BarCharts.Pattern"
    BarCharts__SetX1X2 -> "Examples.BarCharts.SetX1X2"
    BarCharts__Spacing -> "Examples.BarCharts.Spacing"
    BarCharts__DataDependent -> "Examples.BarCharts.DataDependent"
    BarCharts__Color -> "Examples.BarCharts.Color"
    BarCharts__TooltipBin -> "Examples.BarCharts.TooltipBin"
    BarCharts__Corners -> "Examples.BarCharts.Corners"
    BarCharts__Ungroup -> "Examples.BarCharts.Ungroup"
    BarCharts__BinLabels -> "Examples.BarCharts.BinLabels"
    BarCharts__Stacked -> "Examples.BarCharts.Stacked"
    BarCharts__Margin -> "Examples.BarCharts.Margin"
    BarCharts__Borders -> "Examples.BarCharts.Borders"
    BarCharts__Opacity -> "Examples.BarCharts.Opacity"
    BarCharts__Legends -> "Examples.BarCharts.Legends"
    BarCharts__Basic -> "Examples.BarCharts.Basic"
    Navigation__Position -> "Examples.Navigation.Position"
    Navigation__GridFilter -> "Examples.Navigation.GridFilter"
    Navigation__Dimensions -> "Examples.Navigation.Dimensions"
    Navigation__NoArrow -> "Examples.Navigation.NoArrow"
    Navigation__OnlyInts -> "Examples.Navigation.OnlyInts"
    Navigation__GridColor -> "Examples.Navigation.GridColor"
    Navigation__Offset -> "Examples.Navigation.Offset"
    Navigation__Color -> "Examples.Navigation.Color"
    Navigation__Amount -> "Examples.Navigation.Amount"
    Navigation__CustomLabels -> "Examples.Navigation.CustomLabels"
    Navigation__DotGrid -> "Examples.Navigation.DotGrid"
    Navigation__AxisLength -> "Examples.Navigation.AxisLength"
    Navigation__Basic -> "Examples.Navigation.Basic"
    LineCharts__Area -> "Examples.LineCharts.Area"
    LineCharts__Gradient -> "Examples.LineCharts.Gradient"
    LineCharts__Width -> "Examples.LineCharts.Width"
    LineCharts__TooltipStack -> "Examples.LineCharts.TooltipStack"
    LineCharts__Tooltip -> "Examples.LineCharts.Tooltip"
    LineCharts__Montone -> "Examples.LineCharts.Montone"
    LineCharts__Pattern -> "Examples.LineCharts.Pattern"
    LineCharts__Dots -> "Examples.LineCharts.Dots"
    LineCharts__Dashed -> "Examples.LineCharts.Dashed"
    LineCharts__Color -> "Examples.LineCharts.Color"
    LineCharts__Stepped -> "Examples.LineCharts.Stepped"
    LineCharts__Stacked -> "Examples.LineCharts.Stacked"
    LineCharts__Labels -> "Examples.LineCharts.Labels"
    LineCharts__Legends -> "Examples.LineCharts.Legends"
    LineCharts__Basic -> "Examples.LineCharts.Basic"
    ScatterCharts__Colors -> "Examples.ScatterCharts.Colors"
    ScatterCharts__Shapes -> "Examples.ScatterCharts.Shapes"
    ScatterCharts__Tooltip -> "Examples.ScatterCharts.Tooltip"
    ScatterCharts__Highlight -> "Examples.ScatterCharts.Highlight"
    ScatterCharts__DataDependent -> "Examples.ScatterCharts.DataDependent"
    ScatterCharts__Borders -> "Examples.ScatterCharts.Borders"
    ScatterCharts__Labels -> "Examples.ScatterCharts.Labels"
    ScatterCharts__Opacity -> "Examples.ScatterCharts.Opacity"
    ScatterCharts__Sizes -> "Examples.ScatterCharts.Sizes"
    ScatterCharts__Legends -> "Examples.ScatterCharts.Legends"
    ScatterCharts__Basic -> "Examples.ScatterCharts.Basic"


meta chosen =
  case chosen of
    BarCharts__Gradient -> Examples.BarCharts.Gradient.meta
    BarCharts__Title -> Examples.BarCharts.Title.meta
    BarCharts__TooltipStack -> Examples.BarCharts.TooltipStack.meta
    BarCharts__Tooltip -> Examples.BarCharts.Tooltip.meta
    BarCharts__BarLabels -> Examples.BarCharts.BarLabels.meta
    BarCharts__Pattern -> Examples.BarCharts.Pattern.meta
    BarCharts__SetX1X2 -> Examples.BarCharts.SetX1X2.meta
    BarCharts__Spacing -> Examples.BarCharts.Spacing.meta
    BarCharts__DataDependent -> Examples.BarCharts.DataDependent.meta
    BarCharts__Color -> Examples.BarCharts.Color.meta
    BarCharts__TooltipBin -> Examples.BarCharts.TooltipBin.meta
    BarCharts__Corners -> Examples.BarCharts.Corners.meta
    BarCharts__Ungroup -> Examples.BarCharts.Ungroup.meta
    BarCharts__BinLabels -> Examples.BarCharts.BinLabels.meta
    BarCharts__Stacked -> Examples.BarCharts.Stacked.meta
    BarCharts__Margin -> Examples.BarCharts.Margin.meta
    BarCharts__Borders -> Examples.BarCharts.Borders.meta
    BarCharts__Opacity -> Examples.BarCharts.Opacity.meta
    BarCharts__Legends -> Examples.BarCharts.Legends.meta
    BarCharts__Basic -> Examples.BarCharts.Basic.meta
    Navigation__Position -> Examples.Navigation.Position.meta
    Navigation__GridFilter -> Examples.Navigation.GridFilter.meta
    Navigation__Dimensions -> Examples.Navigation.Dimensions.meta
    Navigation__NoArrow -> Examples.Navigation.NoArrow.meta
    Navigation__OnlyInts -> Examples.Navigation.OnlyInts.meta
    Navigation__GridColor -> Examples.Navigation.GridColor.meta
    Navigation__Offset -> Examples.Navigation.Offset.meta
    Navigation__Color -> Examples.Navigation.Color.meta
    Navigation__Amount -> Examples.Navigation.Amount.meta
    Navigation__CustomLabels -> Examples.Navigation.CustomLabels.meta
    Navigation__DotGrid -> Examples.Navigation.DotGrid.meta
    Navigation__AxisLength -> Examples.Navigation.AxisLength.meta
    Navigation__Basic -> Examples.Navigation.Basic.meta
    LineCharts__Area -> Examples.LineCharts.Area.meta
    LineCharts__Gradient -> Examples.LineCharts.Gradient.meta
    LineCharts__Width -> Examples.LineCharts.Width.meta
    LineCharts__TooltipStack -> Examples.LineCharts.TooltipStack.meta
    LineCharts__Tooltip -> Examples.LineCharts.Tooltip.meta
    LineCharts__Montone -> Examples.LineCharts.Montone.meta
    LineCharts__Pattern -> Examples.LineCharts.Pattern.meta
    LineCharts__Dots -> Examples.LineCharts.Dots.meta
    LineCharts__Dashed -> Examples.LineCharts.Dashed.meta
    LineCharts__Color -> Examples.LineCharts.Color.meta
    LineCharts__Stepped -> Examples.LineCharts.Stepped.meta
    LineCharts__Stacked -> Examples.LineCharts.Stacked.meta
    LineCharts__Labels -> Examples.LineCharts.Labels.meta
    LineCharts__Legends -> Examples.LineCharts.Legends.meta
    LineCharts__Basic -> Examples.LineCharts.Basic.meta
    ScatterCharts__Colors -> Examples.ScatterCharts.Colors.meta
    ScatterCharts__Shapes -> Examples.ScatterCharts.Shapes.meta
    ScatterCharts__Tooltip -> Examples.ScatterCharts.Tooltip.meta
    ScatterCharts__Highlight -> Examples.ScatterCharts.Highlight.meta
    ScatterCharts__DataDependent -> Examples.ScatterCharts.DataDependent.meta
    ScatterCharts__Borders -> Examples.ScatterCharts.Borders.meta
    ScatterCharts__Labels -> Examples.ScatterCharts.Labels.meta
    ScatterCharts__Opacity -> Examples.ScatterCharts.Opacity.meta
    ScatterCharts__Sizes -> Examples.ScatterCharts.Sizes.meta
    ScatterCharts__Legends -> Examples.ScatterCharts.Legends.meta
    ScatterCharts__Basic -> Examples.ScatterCharts.Basic.meta


all : List Id
all =
  [ BarCharts__Gradient
  , BarCharts__Title
  , BarCharts__TooltipStack
  , BarCharts__Tooltip
  , BarCharts__BarLabels
  , BarCharts__Pattern
  , BarCharts__SetX1X2
  , BarCharts__Spacing
  , BarCharts__DataDependent
  , BarCharts__Color
  , BarCharts__TooltipBin
  , BarCharts__Corners
  , BarCharts__Ungroup
  , BarCharts__BinLabels
  , BarCharts__Stacked
  , BarCharts__Margin
  , BarCharts__Borders
  , BarCharts__Opacity
  , BarCharts__Legends
  , BarCharts__Basic
  , Navigation__Position
  , Navigation__GridFilter
  , Navigation__Dimensions
  , Navigation__NoArrow
  , Navigation__OnlyInts
  , Navigation__GridColor
  , Navigation__Offset
  , Navigation__Color
  , Navigation__Amount
  , Navigation__CustomLabels
  , Navigation__DotGrid
  , Navigation__AxisLength
  , Navigation__Basic
  , LineCharts__Area
  , LineCharts__Gradient
  , LineCharts__Width
  , LineCharts__TooltipStack
  , LineCharts__Tooltip
  , LineCharts__Montone
  , LineCharts__Pattern
  , LineCharts__Dots
  , LineCharts__Dashed
  , LineCharts__Color
  , LineCharts__Stepped
  , LineCharts__Stacked
  , LineCharts__Labels
  , LineCharts__Legends
  , LineCharts__Basic
  , ScatterCharts__Colors
  , ScatterCharts__Shapes
  , ScatterCharts__Tooltip
  , ScatterCharts__Highlight
  , ScatterCharts__DataDependent
  , ScatterCharts__Borders
  , ScatterCharts__Labels
  , ScatterCharts__Opacity
  , ScatterCharts__Sizes
  , ScatterCharts__Legends
  , ScatterCharts__Basic
  ]


first : Id
first =
  BarCharts__Gradient

