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
import Examples.Frame.Lines
import Examples.Frame.Position
import Examples.Frame.GridFilter
import Examples.Frame.Dimensions
import Examples.Frame.NoArrow
import Examples.Frame.Background
import Examples.Frame.Padding
import Examples.Frame.OnlyInts
import Examples.Frame.GridColor
import Examples.Frame.Offset
import Examples.Frame.Color
import Examples.Frame.Amount
import Examples.Frame.Titles
import Examples.Frame.CustomLabels
import Examples.Frame.Margin
import Examples.Frame.DotGrid
import Examples.Frame.AxisLength
import Examples.Frame.Arbitrary
import Examples.Frame.Legends
import Examples.Frame.Basic
import Examples.Interactivity.BasicBin
import Examples.Interactivity.BasicStack
import Examples.Interactivity.ChangeName
import Examples.Interactivity.BasicBar
import Examples.Interactivity.BasicArea
import Examples.Interactivity.BasicLine
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
  | Frame__Lines
  | Frame__Position
  | Frame__GridFilter
  | Frame__Dimensions
  | Frame__NoArrow
  | Frame__Background
  | Frame__Padding
  | Frame__OnlyInts
  | Frame__GridColor
  | Frame__Offset
  | Frame__Color
  | Frame__Amount
  | Frame__Titles
  | Frame__CustomLabels
  | Frame__Margin
  | Frame__DotGrid
  | Frame__AxisLength
  | Frame__Arbitrary
  | Frame__Legends
  | Frame__Basic
  | Interactivity__BasicBin
  | Interactivity__BasicStack
  | Interactivity__ChangeName
  | Interactivity__BasicBar
  | Interactivity__BasicArea
  | Interactivity__BasicLine
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
  , example20 : Examples.Frame.Lines.Model
  , example21 : Examples.Frame.Position.Model
  , example22 : Examples.Frame.GridFilter.Model
  , example23 : Examples.Frame.Dimensions.Model
  , example24 : Examples.Frame.NoArrow.Model
  , example25 : Examples.Frame.Background.Model
  , example26 : Examples.Frame.Padding.Model
  , example27 : Examples.Frame.OnlyInts.Model
  , example28 : Examples.Frame.GridColor.Model
  , example29 : Examples.Frame.Offset.Model
  , example30 : Examples.Frame.Color.Model
  , example31 : Examples.Frame.Amount.Model
  , example32 : Examples.Frame.Titles.Model
  , example33 : Examples.Frame.CustomLabels.Model
  , example34 : Examples.Frame.Margin.Model
  , example35 : Examples.Frame.DotGrid.Model
  , example36 : Examples.Frame.AxisLength.Model
  , example37 : Examples.Frame.Arbitrary.Model
  , example38 : Examples.Frame.Legends.Model
  , example39 : Examples.Frame.Basic.Model
  , example40 : Examples.Interactivity.BasicBin.Model
  , example41 : Examples.Interactivity.BasicStack.Model
  , example42 : Examples.Interactivity.ChangeName.Model
  , example43 : Examples.Interactivity.BasicBar.Model
  , example44 : Examples.Interactivity.BasicArea.Model
  , example45 : Examples.Interactivity.BasicLine.Model
  , example46 : Examples.LineCharts.Area.Model
  , example47 : Examples.LineCharts.Gradient.Model
  , example48 : Examples.LineCharts.Width.Model
  , example49 : Examples.LineCharts.TooltipStack.Model
  , example50 : Examples.LineCharts.Tooltip.Model
  , example51 : Examples.LineCharts.Montone.Model
  , example52 : Examples.LineCharts.Pattern.Model
  , example53 : Examples.LineCharts.Dots.Model
  , example54 : Examples.LineCharts.Dashed.Model
  , example55 : Examples.LineCharts.Color.Model
  , example56 : Examples.LineCharts.Stepped.Model
  , example57 : Examples.LineCharts.Stacked.Model
  , example58 : Examples.LineCharts.Labels.Model
  , example59 : Examples.LineCharts.Legends.Model
  , example60 : Examples.LineCharts.Basic.Model
  , example61 : Examples.ScatterCharts.Colors.Model
  , example62 : Examples.ScatterCharts.Shapes.Model
  , example63 : Examples.ScatterCharts.Tooltip.Model
  , example64 : Examples.ScatterCharts.Highlight.Model
  , example65 : Examples.ScatterCharts.DataDependent.Model
  , example66 : Examples.ScatterCharts.Borders.Model
  , example67 : Examples.ScatterCharts.Labels.Model
  , example68 : Examples.ScatterCharts.Opacity.Model
  , example69 : Examples.ScatterCharts.Sizes.Model
  , example70 : Examples.ScatterCharts.Legends.Model
  , example71 : Examples.ScatterCharts.Basic.Model
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
  , example20 = Examples.Frame.Lines.init
  , example21 = Examples.Frame.Position.init
  , example22 = Examples.Frame.GridFilter.init
  , example23 = Examples.Frame.Dimensions.init
  , example24 = Examples.Frame.NoArrow.init
  , example25 = Examples.Frame.Background.init
  , example26 = Examples.Frame.Padding.init
  , example27 = Examples.Frame.OnlyInts.init
  , example28 = Examples.Frame.GridColor.init
  , example29 = Examples.Frame.Offset.init
  , example30 = Examples.Frame.Color.init
  , example31 = Examples.Frame.Amount.init
  , example32 = Examples.Frame.Titles.init
  , example33 = Examples.Frame.CustomLabels.init
  , example34 = Examples.Frame.Margin.init
  , example35 = Examples.Frame.DotGrid.init
  , example36 = Examples.Frame.AxisLength.init
  , example37 = Examples.Frame.Arbitrary.init
  , example38 = Examples.Frame.Legends.init
  , example39 = Examples.Frame.Basic.init
  , example40 = Examples.Interactivity.BasicBin.init
  , example41 = Examples.Interactivity.BasicStack.init
  , example42 = Examples.Interactivity.ChangeName.init
  , example43 = Examples.Interactivity.BasicBar.init
  , example44 = Examples.Interactivity.BasicArea.init
  , example45 = Examples.Interactivity.BasicLine.init
  , example46 = Examples.LineCharts.Area.init
  , example47 = Examples.LineCharts.Gradient.init
  , example48 = Examples.LineCharts.Width.init
  , example49 = Examples.LineCharts.TooltipStack.init
  , example50 = Examples.LineCharts.Tooltip.init
  , example51 = Examples.LineCharts.Montone.init
  , example52 = Examples.LineCharts.Pattern.init
  , example53 = Examples.LineCharts.Dots.init
  , example54 = Examples.LineCharts.Dashed.init
  , example55 = Examples.LineCharts.Color.init
  , example56 = Examples.LineCharts.Stepped.init
  , example57 = Examples.LineCharts.Stacked.init
  , example58 = Examples.LineCharts.Labels.init
  , example59 = Examples.LineCharts.Legends.init
  , example60 = Examples.LineCharts.Basic.init
  , example61 = Examples.ScatterCharts.Colors.init
  , example62 = Examples.ScatterCharts.Shapes.init
  , example63 = Examples.ScatterCharts.Tooltip.init
  , example64 = Examples.ScatterCharts.Highlight.init
  , example65 = Examples.ScatterCharts.DataDependent.init
  , example66 = Examples.ScatterCharts.Borders.init
  , example67 = Examples.ScatterCharts.Labels.init
  , example68 = Examples.ScatterCharts.Opacity.init
  , example69 = Examples.ScatterCharts.Sizes.init
  , example70 = Examples.ScatterCharts.Legends.init
  , example71 = Examples.ScatterCharts.Basic.init
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
  | ExampleMsg20 Examples.Frame.Lines.Msg
  | ExampleMsg21 Examples.Frame.Position.Msg
  | ExampleMsg22 Examples.Frame.GridFilter.Msg
  | ExampleMsg23 Examples.Frame.Dimensions.Msg
  | ExampleMsg24 Examples.Frame.NoArrow.Msg
  | ExampleMsg25 Examples.Frame.Background.Msg
  | ExampleMsg26 Examples.Frame.Padding.Msg
  | ExampleMsg27 Examples.Frame.OnlyInts.Msg
  | ExampleMsg28 Examples.Frame.GridColor.Msg
  | ExampleMsg29 Examples.Frame.Offset.Msg
  | ExampleMsg30 Examples.Frame.Color.Msg
  | ExampleMsg31 Examples.Frame.Amount.Msg
  | ExampleMsg32 Examples.Frame.Titles.Msg
  | ExampleMsg33 Examples.Frame.CustomLabels.Msg
  | ExampleMsg34 Examples.Frame.Margin.Msg
  | ExampleMsg35 Examples.Frame.DotGrid.Msg
  | ExampleMsg36 Examples.Frame.AxisLength.Msg
  | ExampleMsg37 Examples.Frame.Arbitrary.Msg
  | ExampleMsg38 Examples.Frame.Legends.Msg
  | ExampleMsg39 Examples.Frame.Basic.Msg
  | ExampleMsg40 Examples.Interactivity.BasicBin.Msg
  | ExampleMsg41 Examples.Interactivity.BasicStack.Msg
  | ExampleMsg42 Examples.Interactivity.ChangeName.Msg
  | ExampleMsg43 Examples.Interactivity.BasicBar.Msg
  | ExampleMsg44 Examples.Interactivity.BasicArea.Msg
  | ExampleMsg45 Examples.Interactivity.BasicLine.Msg
  | ExampleMsg46 Examples.LineCharts.Area.Msg
  | ExampleMsg47 Examples.LineCharts.Gradient.Msg
  | ExampleMsg48 Examples.LineCharts.Width.Msg
  | ExampleMsg49 Examples.LineCharts.TooltipStack.Msg
  | ExampleMsg50 Examples.LineCharts.Tooltip.Msg
  | ExampleMsg51 Examples.LineCharts.Montone.Msg
  | ExampleMsg52 Examples.LineCharts.Pattern.Msg
  | ExampleMsg53 Examples.LineCharts.Dots.Msg
  | ExampleMsg54 Examples.LineCharts.Dashed.Msg
  | ExampleMsg55 Examples.LineCharts.Color.Msg
  | ExampleMsg56 Examples.LineCharts.Stepped.Msg
  | ExampleMsg57 Examples.LineCharts.Stacked.Msg
  | ExampleMsg58 Examples.LineCharts.Labels.Msg
  | ExampleMsg59 Examples.LineCharts.Legends.Msg
  | ExampleMsg60 Examples.LineCharts.Basic.Msg
  | ExampleMsg61 Examples.ScatterCharts.Colors.Msg
  | ExampleMsg62 Examples.ScatterCharts.Shapes.Msg
  | ExampleMsg63 Examples.ScatterCharts.Tooltip.Msg
  | ExampleMsg64 Examples.ScatterCharts.Highlight.Msg
  | ExampleMsg65 Examples.ScatterCharts.DataDependent.Msg
  | ExampleMsg66 Examples.ScatterCharts.Borders.Msg
  | ExampleMsg67 Examples.ScatterCharts.Labels.Msg
  | ExampleMsg68 Examples.ScatterCharts.Opacity.Msg
  | ExampleMsg69 Examples.ScatterCharts.Sizes.Msg
  | ExampleMsg70 Examples.ScatterCharts.Legends.Msg
  | ExampleMsg71 Examples.ScatterCharts.Basic.Msg


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
    ExampleMsg20 sub -> { model | example20 = Examples.Frame.Lines.update sub model.example20 }
    ExampleMsg21 sub -> { model | example21 = Examples.Frame.Position.update sub model.example21 }
    ExampleMsg22 sub -> { model | example22 = Examples.Frame.GridFilter.update sub model.example22 }
    ExampleMsg23 sub -> { model | example23 = Examples.Frame.Dimensions.update sub model.example23 }
    ExampleMsg24 sub -> { model | example24 = Examples.Frame.NoArrow.update sub model.example24 }
    ExampleMsg25 sub -> { model | example25 = Examples.Frame.Background.update sub model.example25 }
    ExampleMsg26 sub -> { model | example26 = Examples.Frame.Padding.update sub model.example26 }
    ExampleMsg27 sub -> { model | example27 = Examples.Frame.OnlyInts.update sub model.example27 }
    ExampleMsg28 sub -> { model | example28 = Examples.Frame.GridColor.update sub model.example28 }
    ExampleMsg29 sub -> { model | example29 = Examples.Frame.Offset.update sub model.example29 }
    ExampleMsg30 sub -> { model | example30 = Examples.Frame.Color.update sub model.example30 }
    ExampleMsg31 sub -> { model | example31 = Examples.Frame.Amount.update sub model.example31 }
    ExampleMsg32 sub -> { model | example32 = Examples.Frame.Titles.update sub model.example32 }
    ExampleMsg33 sub -> { model | example33 = Examples.Frame.CustomLabels.update sub model.example33 }
    ExampleMsg34 sub -> { model | example34 = Examples.Frame.Margin.update sub model.example34 }
    ExampleMsg35 sub -> { model | example35 = Examples.Frame.DotGrid.update sub model.example35 }
    ExampleMsg36 sub -> { model | example36 = Examples.Frame.AxisLength.update sub model.example36 }
    ExampleMsg37 sub -> { model | example37 = Examples.Frame.Arbitrary.update sub model.example37 }
    ExampleMsg38 sub -> { model | example38 = Examples.Frame.Legends.update sub model.example38 }
    ExampleMsg39 sub -> { model | example39 = Examples.Frame.Basic.update sub model.example39 }
    ExampleMsg40 sub -> { model | example40 = Examples.Interactivity.BasicBin.update sub model.example40 }
    ExampleMsg41 sub -> { model | example41 = Examples.Interactivity.BasicStack.update sub model.example41 }
    ExampleMsg42 sub -> { model | example42 = Examples.Interactivity.ChangeName.update sub model.example42 }
    ExampleMsg43 sub -> { model | example43 = Examples.Interactivity.BasicBar.update sub model.example43 }
    ExampleMsg44 sub -> { model | example44 = Examples.Interactivity.BasicArea.update sub model.example44 }
    ExampleMsg45 sub -> { model | example45 = Examples.Interactivity.BasicLine.update sub model.example45 }
    ExampleMsg46 sub -> { model | example46 = Examples.LineCharts.Area.update sub model.example46 }
    ExampleMsg47 sub -> { model | example47 = Examples.LineCharts.Gradient.update sub model.example47 }
    ExampleMsg48 sub -> { model | example48 = Examples.LineCharts.Width.update sub model.example48 }
    ExampleMsg49 sub -> { model | example49 = Examples.LineCharts.TooltipStack.update sub model.example49 }
    ExampleMsg50 sub -> { model | example50 = Examples.LineCharts.Tooltip.update sub model.example50 }
    ExampleMsg51 sub -> { model | example51 = Examples.LineCharts.Montone.update sub model.example51 }
    ExampleMsg52 sub -> { model | example52 = Examples.LineCharts.Pattern.update sub model.example52 }
    ExampleMsg53 sub -> { model | example53 = Examples.LineCharts.Dots.update sub model.example53 }
    ExampleMsg54 sub -> { model | example54 = Examples.LineCharts.Dashed.update sub model.example54 }
    ExampleMsg55 sub -> { model | example55 = Examples.LineCharts.Color.update sub model.example55 }
    ExampleMsg56 sub -> { model | example56 = Examples.LineCharts.Stepped.update sub model.example56 }
    ExampleMsg57 sub -> { model | example57 = Examples.LineCharts.Stacked.update sub model.example57 }
    ExampleMsg58 sub -> { model | example58 = Examples.LineCharts.Labels.update sub model.example58 }
    ExampleMsg59 sub -> { model | example59 = Examples.LineCharts.Legends.update sub model.example59 }
    ExampleMsg60 sub -> { model | example60 = Examples.LineCharts.Basic.update sub model.example60 }
    ExampleMsg61 sub -> { model | example61 = Examples.ScatterCharts.Colors.update sub model.example61 }
    ExampleMsg62 sub -> { model | example62 = Examples.ScatterCharts.Shapes.update sub model.example62 }
    ExampleMsg63 sub -> { model | example63 = Examples.ScatterCharts.Tooltip.update sub model.example63 }
    ExampleMsg64 sub -> { model | example64 = Examples.ScatterCharts.Highlight.update sub model.example64 }
    ExampleMsg65 sub -> { model | example65 = Examples.ScatterCharts.DataDependent.update sub model.example65 }
    ExampleMsg66 sub -> { model | example66 = Examples.ScatterCharts.Borders.update sub model.example66 }
    ExampleMsg67 sub -> { model | example67 = Examples.ScatterCharts.Labels.update sub model.example67 }
    ExampleMsg68 sub -> { model | example68 = Examples.ScatterCharts.Opacity.update sub model.example68 }
    ExampleMsg69 sub -> { model | example69 = Examples.ScatterCharts.Sizes.update sub model.example69 }
    ExampleMsg70 sub -> { model | example70 = Examples.ScatterCharts.Legends.update sub model.example70 }
    ExampleMsg71 sub -> { model | example71 = Examples.ScatterCharts.Basic.update sub model.example71 }


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
    Frame__Lines -> Html.map ExampleMsg20 (Examples.Frame.Lines.view model.example20)
    Frame__Position -> Html.map ExampleMsg21 (Examples.Frame.Position.view model.example21)
    Frame__GridFilter -> Html.map ExampleMsg22 (Examples.Frame.GridFilter.view model.example22)
    Frame__Dimensions -> Html.map ExampleMsg23 (Examples.Frame.Dimensions.view model.example23)
    Frame__NoArrow -> Html.map ExampleMsg24 (Examples.Frame.NoArrow.view model.example24)
    Frame__Background -> Html.map ExampleMsg25 (Examples.Frame.Background.view model.example25)
    Frame__Padding -> Html.map ExampleMsg26 (Examples.Frame.Padding.view model.example26)
    Frame__OnlyInts -> Html.map ExampleMsg27 (Examples.Frame.OnlyInts.view model.example27)
    Frame__GridColor -> Html.map ExampleMsg28 (Examples.Frame.GridColor.view model.example28)
    Frame__Offset -> Html.map ExampleMsg29 (Examples.Frame.Offset.view model.example29)
    Frame__Color -> Html.map ExampleMsg30 (Examples.Frame.Color.view model.example30)
    Frame__Amount -> Html.map ExampleMsg31 (Examples.Frame.Amount.view model.example31)
    Frame__Titles -> Html.map ExampleMsg32 (Examples.Frame.Titles.view model.example32)
    Frame__CustomLabels -> Html.map ExampleMsg33 (Examples.Frame.CustomLabels.view model.example33)
    Frame__Margin -> Html.map ExampleMsg34 (Examples.Frame.Margin.view model.example34)
    Frame__DotGrid -> Html.map ExampleMsg35 (Examples.Frame.DotGrid.view model.example35)
    Frame__AxisLength -> Html.map ExampleMsg36 (Examples.Frame.AxisLength.view model.example36)
    Frame__Arbitrary -> Html.map ExampleMsg37 (Examples.Frame.Arbitrary.view model.example37)
    Frame__Legends -> Html.map ExampleMsg38 (Examples.Frame.Legends.view model.example38)
    Frame__Basic -> Html.map ExampleMsg39 (Examples.Frame.Basic.view model.example39)
    Interactivity__BasicBin -> Html.map ExampleMsg40 (Examples.Interactivity.BasicBin.view model.example40)
    Interactivity__BasicStack -> Html.map ExampleMsg41 (Examples.Interactivity.BasicStack.view model.example41)
    Interactivity__ChangeName -> Html.map ExampleMsg42 (Examples.Interactivity.ChangeName.view model.example42)
    Interactivity__BasicBar -> Html.map ExampleMsg43 (Examples.Interactivity.BasicBar.view model.example43)
    Interactivity__BasicArea -> Html.map ExampleMsg44 (Examples.Interactivity.BasicArea.view model.example44)
    Interactivity__BasicLine -> Html.map ExampleMsg45 (Examples.Interactivity.BasicLine.view model.example45)
    LineCharts__Area -> Html.map ExampleMsg46 (Examples.LineCharts.Area.view model.example46)
    LineCharts__Gradient -> Html.map ExampleMsg47 (Examples.LineCharts.Gradient.view model.example47)
    LineCharts__Width -> Html.map ExampleMsg48 (Examples.LineCharts.Width.view model.example48)
    LineCharts__TooltipStack -> Html.map ExampleMsg49 (Examples.LineCharts.TooltipStack.view model.example49)
    LineCharts__Tooltip -> Html.map ExampleMsg50 (Examples.LineCharts.Tooltip.view model.example50)
    LineCharts__Montone -> Html.map ExampleMsg51 (Examples.LineCharts.Montone.view model.example51)
    LineCharts__Pattern -> Html.map ExampleMsg52 (Examples.LineCharts.Pattern.view model.example52)
    LineCharts__Dots -> Html.map ExampleMsg53 (Examples.LineCharts.Dots.view model.example53)
    LineCharts__Dashed -> Html.map ExampleMsg54 (Examples.LineCharts.Dashed.view model.example54)
    LineCharts__Color -> Html.map ExampleMsg55 (Examples.LineCharts.Color.view model.example55)
    LineCharts__Stepped -> Html.map ExampleMsg56 (Examples.LineCharts.Stepped.view model.example56)
    LineCharts__Stacked -> Html.map ExampleMsg57 (Examples.LineCharts.Stacked.view model.example57)
    LineCharts__Labels -> Html.map ExampleMsg58 (Examples.LineCharts.Labels.view model.example58)
    LineCharts__Legends -> Html.map ExampleMsg59 (Examples.LineCharts.Legends.view model.example59)
    LineCharts__Basic -> Html.map ExampleMsg60 (Examples.LineCharts.Basic.view model.example60)
    ScatterCharts__Colors -> Html.map ExampleMsg61 (Examples.ScatterCharts.Colors.view model.example61)
    ScatterCharts__Shapes -> Html.map ExampleMsg62 (Examples.ScatterCharts.Shapes.view model.example62)
    ScatterCharts__Tooltip -> Html.map ExampleMsg63 (Examples.ScatterCharts.Tooltip.view model.example63)
    ScatterCharts__Highlight -> Html.map ExampleMsg64 (Examples.ScatterCharts.Highlight.view model.example64)
    ScatterCharts__DataDependent -> Html.map ExampleMsg65 (Examples.ScatterCharts.DataDependent.view model.example65)
    ScatterCharts__Borders -> Html.map ExampleMsg66 (Examples.ScatterCharts.Borders.view model.example66)
    ScatterCharts__Labels -> Html.map ExampleMsg67 (Examples.ScatterCharts.Labels.view model.example67)
    ScatterCharts__Opacity -> Html.map ExampleMsg68 (Examples.ScatterCharts.Opacity.view model.example68)
    ScatterCharts__Sizes -> Html.map ExampleMsg69 (Examples.ScatterCharts.Sizes.view model.example69)
    ScatterCharts__Legends -> Html.map ExampleMsg70 (Examples.ScatterCharts.Legends.view model.example70)
    ScatterCharts__Basic -> Html.map ExampleMsg71 (Examples.ScatterCharts.Basic.view model.example71)


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
    Frame__Lines -> Examples.Frame.Lines.smallCode
    Frame__Position -> Examples.Frame.Position.smallCode
    Frame__GridFilter -> Examples.Frame.GridFilter.smallCode
    Frame__Dimensions -> Examples.Frame.Dimensions.smallCode
    Frame__NoArrow -> Examples.Frame.NoArrow.smallCode
    Frame__Background -> Examples.Frame.Background.smallCode
    Frame__Padding -> Examples.Frame.Padding.smallCode
    Frame__OnlyInts -> Examples.Frame.OnlyInts.smallCode
    Frame__GridColor -> Examples.Frame.GridColor.smallCode
    Frame__Offset -> Examples.Frame.Offset.smallCode
    Frame__Color -> Examples.Frame.Color.smallCode
    Frame__Amount -> Examples.Frame.Amount.smallCode
    Frame__Titles -> Examples.Frame.Titles.smallCode
    Frame__CustomLabels -> Examples.Frame.CustomLabels.smallCode
    Frame__Margin -> Examples.Frame.Margin.smallCode
    Frame__DotGrid -> Examples.Frame.DotGrid.smallCode
    Frame__AxisLength -> Examples.Frame.AxisLength.smallCode
    Frame__Arbitrary -> Examples.Frame.Arbitrary.smallCode
    Frame__Legends -> Examples.Frame.Legends.smallCode
    Frame__Basic -> Examples.Frame.Basic.smallCode
    Interactivity__BasicBin -> Examples.Interactivity.BasicBin.smallCode
    Interactivity__BasicStack -> Examples.Interactivity.BasicStack.smallCode
    Interactivity__ChangeName -> Examples.Interactivity.ChangeName.smallCode
    Interactivity__BasicBar -> Examples.Interactivity.BasicBar.smallCode
    Interactivity__BasicArea -> Examples.Interactivity.BasicArea.smallCode
    Interactivity__BasicLine -> Examples.Interactivity.BasicLine.smallCode
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
    Frame__Lines -> Examples.Frame.Lines.largeCode
    Frame__Position -> Examples.Frame.Position.largeCode
    Frame__GridFilter -> Examples.Frame.GridFilter.largeCode
    Frame__Dimensions -> Examples.Frame.Dimensions.largeCode
    Frame__NoArrow -> Examples.Frame.NoArrow.largeCode
    Frame__Background -> Examples.Frame.Background.largeCode
    Frame__Padding -> Examples.Frame.Padding.largeCode
    Frame__OnlyInts -> Examples.Frame.OnlyInts.largeCode
    Frame__GridColor -> Examples.Frame.GridColor.largeCode
    Frame__Offset -> Examples.Frame.Offset.largeCode
    Frame__Color -> Examples.Frame.Color.largeCode
    Frame__Amount -> Examples.Frame.Amount.largeCode
    Frame__Titles -> Examples.Frame.Titles.largeCode
    Frame__CustomLabels -> Examples.Frame.CustomLabels.largeCode
    Frame__Margin -> Examples.Frame.Margin.largeCode
    Frame__DotGrid -> Examples.Frame.DotGrid.largeCode
    Frame__AxisLength -> Examples.Frame.AxisLength.largeCode
    Frame__Arbitrary -> Examples.Frame.Arbitrary.largeCode
    Frame__Legends -> Examples.Frame.Legends.largeCode
    Frame__Basic -> Examples.Frame.Basic.largeCode
    Interactivity__BasicBin -> Examples.Interactivity.BasicBin.largeCode
    Interactivity__BasicStack -> Examples.Interactivity.BasicStack.largeCode
    Interactivity__ChangeName -> Examples.Interactivity.ChangeName.largeCode
    Interactivity__BasicBar -> Examples.Interactivity.BasicBar.largeCode
    Interactivity__BasicArea -> Examples.Interactivity.BasicArea.largeCode
    Interactivity__BasicLine -> Examples.Interactivity.BasicLine.largeCode
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
    Frame__Lines -> "Examples.Frame.Lines"
    Frame__Position -> "Examples.Frame.Position"
    Frame__GridFilter -> "Examples.Frame.GridFilter"
    Frame__Dimensions -> "Examples.Frame.Dimensions"
    Frame__NoArrow -> "Examples.Frame.NoArrow"
    Frame__Background -> "Examples.Frame.Background"
    Frame__Padding -> "Examples.Frame.Padding"
    Frame__OnlyInts -> "Examples.Frame.OnlyInts"
    Frame__GridColor -> "Examples.Frame.GridColor"
    Frame__Offset -> "Examples.Frame.Offset"
    Frame__Color -> "Examples.Frame.Color"
    Frame__Amount -> "Examples.Frame.Amount"
    Frame__Titles -> "Examples.Frame.Titles"
    Frame__CustomLabels -> "Examples.Frame.CustomLabels"
    Frame__Margin -> "Examples.Frame.Margin"
    Frame__DotGrid -> "Examples.Frame.DotGrid"
    Frame__AxisLength -> "Examples.Frame.AxisLength"
    Frame__Arbitrary -> "Examples.Frame.Arbitrary"
    Frame__Legends -> "Examples.Frame.Legends"
    Frame__Basic -> "Examples.Frame.Basic"
    Interactivity__BasicBin -> "Examples.Interactivity.BasicBin"
    Interactivity__BasicStack -> "Examples.Interactivity.BasicStack"
    Interactivity__ChangeName -> "Examples.Interactivity.ChangeName"
    Interactivity__BasicBar -> "Examples.Interactivity.BasicBar"
    Interactivity__BasicArea -> "Examples.Interactivity.BasicArea"
    Interactivity__BasicLine -> "Examples.Interactivity.BasicLine"
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
    Frame__Lines -> Examples.Frame.Lines.meta
    Frame__Position -> Examples.Frame.Position.meta
    Frame__GridFilter -> Examples.Frame.GridFilter.meta
    Frame__Dimensions -> Examples.Frame.Dimensions.meta
    Frame__NoArrow -> Examples.Frame.NoArrow.meta
    Frame__Background -> Examples.Frame.Background.meta
    Frame__Padding -> Examples.Frame.Padding.meta
    Frame__OnlyInts -> Examples.Frame.OnlyInts.meta
    Frame__GridColor -> Examples.Frame.GridColor.meta
    Frame__Offset -> Examples.Frame.Offset.meta
    Frame__Color -> Examples.Frame.Color.meta
    Frame__Amount -> Examples.Frame.Amount.meta
    Frame__Titles -> Examples.Frame.Titles.meta
    Frame__CustomLabels -> Examples.Frame.CustomLabels.meta
    Frame__Margin -> Examples.Frame.Margin.meta
    Frame__DotGrid -> Examples.Frame.DotGrid.meta
    Frame__AxisLength -> Examples.Frame.AxisLength.meta
    Frame__Arbitrary -> Examples.Frame.Arbitrary.meta
    Frame__Legends -> Examples.Frame.Legends.meta
    Frame__Basic -> Examples.Frame.Basic.meta
    Interactivity__BasicBin -> Examples.Interactivity.BasicBin.meta
    Interactivity__BasicStack -> Examples.Interactivity.BasicStack.meta
    Interactivity__ChangeName -> Examples.Interactivity.ChangeName.meta
    Interactivity__BasicBar -> Examples.Interactivity.BasicBar.meta
    Interactivity__BasicArea -> Examples.Interactivity.BasicArea.meta
    Interactivity__BasicLine -> Examples.Interactivity.BasicLine.meta
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
  , Frame__Lines
  , Frame__Position
  , Frame__GridFilter
  , Frame__Dimensions
  , Frame__NoArrow
  , Frame__Background
  , Frame__Padding
  , Frame__OnlyInts
  , Frame__GridColor
  , Frame__Offset
  , Frame__Color
  , Frame__Amount
  , Frame__Titles
  , Frame__CustomLabels
  , Frame__Margin
  , Frame__DotGrid
  , Frame__AxisLength
  , Frame__Arbitrary
  , Frame__Legends
  , Frame__Basic
  , Interactivity__BasicBin
  , Interactivity__BasicStack
  , Interactivity__ChangeName
  , Interactivity__BasicBar
  , Interactivity__BasicArea
  , Interactivity__BasicLine
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

