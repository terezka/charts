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
import Examples.BarCharts.Highlight
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
import Examples.Frame.Coordinates
import Examples.Frame.GridFilter
import Examples.Frame.Dimensions
import Examples.Frame.NoArrow
import Examples.Frame.Background
import Examples.Frame.Rect
import Examples.Frame.Padding
import Examples.Frame.Times
import Examples.Frame.OnlyInts
import Examples.Frame.GridColor
import Examples.Frame.Offset
import Examples.Frame.Color
import Examples.Frame.Amount
import Examples.Frame.Titles
import Examples.Frame.CustomLabels
import Examples.Frame.Margin
import Examples.Frame.LabelWithLine
import Examples.Frame.DotGrid
import Examples.Frame.AxisLength
import Examples.Frame.Arbitrary
import Examples.Frame.Legends
import Examples.Frame.Basic
import Examples.Interactivity.ChangeContent
import Examples.Interactivity.Direction
import Examples.Interactivity.Border
import Examples.Interactivity.Zoom
import Examples.Interactivity.BasicBin
import Examples.Interactivity.BasicStack
import Examples.Interactivity.ChangeName
import Examples.Interactivity.NoArrow
import Examples.Interactivity.FilterSearch
import Examples.Interactivity.Background
import Examples.Interactivity.BasicBar
import Examples.Interactivity.BasicArea
import Examples.Interactivity.TrickyTooltip
import Examples.Interactivity.Multiple
import Examples.Interactivity.BasicLine
import Examples.Interactivity.Offset
import Examples.Interactivity.DoubleSearch
import Examples.Interactivity.Focal
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
  | BarCharts__Highlight
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
  | Frame__Coordinates
  | Frame__GridFilter
  | Frame__Dimensions
  | Frame__NoArrow
  | Frame__Background
  | Frame__Rect
  | Frame__Padding
  | Frame__Times
  | Frame__OnlyInts
  | Frame__GridColor
  | Frame__Offset
  | Frame__Color
  | Frame__Amount
  | Frame__Titles
  | Frame__CustomLabels
  | Frame__Margin
  | Frame__LabelWithLine
  | Frame__DotGrid
  | Frame__AxisLength
  | Frame__Arbitrary
  | Frame__Legends
  | Frame__Basic
  | Interactivity__ChangeContent
  | Interactivity__Direction
  | Interactivity__Border
  | Interactivity__Zoom
  | Interactivity__BasicBin
  | Interactivity__BasicStack
  | Interactivity__ChangeName
  | Interactivity__NoArrow
  | Interactivity__FilterSearch
  | Interactivity__Background
  | Interactivity__BasicBar
  | Interactivity__BasicArea
  | Interactivity__TrickyTooltip
  | Interactivity__Multiple
  | Interactivity__BasicLine
  | Interactivity__Offset
  | Interactivity__DoubleSearch
  | Interactivity__Focal
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
  , example8 : Examples.BarCharts.Highlight.Model
  , example9 : Examples.BarCharts.DataDependent.Model
  , example10 : Examples.BarCharts.Color.Model
  , example11 : Examples.BarCharts.TooltipBin.Model
  , example12 : Examples.BarCharts.Corners.Model
  , example13 : Examples.BarCharts.Ungroup.Model
  , example14 : Examples.BarCharts.BinLabels.Model
  , example15 : Examples.BarCharts.Stacked.Model
  , example16 : Examples.BarCharts.Margin.Model
  , example17 : Examples.BarCharts.Borders.Model
  , example18 : Examples.BarCharts.Opacity.Model
  , example19 : Examples.BarCharts.Legends.Model
  , example20 : Examples.BarCharts.Basic.Model
  , example21 : Examples.Frame.Lines.Model
  , example22 : Examples.Frame.Position.Model
  , example23 : Examples.Frame.Coordinates.Model
  , example24 : Examples.Frame.GridFilter.Model
  , example25 : Examples.Frame.Dimensions.Model
  , example26 : Examples.Frame.NoArrow.Model
  , example27 : Examples.Frame.Background.Model
  , example28 : Examples.Frame.Rect.Model
  , example29 : Examples.Frame.Padding.Model
  , example30 : Examples.Frame.Times.Model
  , example31 : Examples.Frame.OnlyInts.Model
  , example32 : Examples.Frame.GridColor.Model
  , example33 : Examples.Frame.Offset.Model
  , example34 : Examples.Frame.Color.Model
  , example35 : Examples.Frame.Amount.Model
  , example36 : Examples.Frame.Titles.Model
  , example37 : Examples.Frame.CustomLabels.Model
  , example38 : Examples.Frame.Margin.Model
  , example39 : Examples.Frame.LabelWithLine.Model
  , example40 : Examples.Frame.DotGrid.Model
  , example41 : Examples.Frame.AxisLength.Model
  , example42 : Examples.Frame.Arbitrary.Model
  , example43 : Examples.Frame.Legends.Model
  , example44 : Examples.Frame.Basic.Model
  , example45 : Examples.Interactivity.ChangeContent.Model
  , example46 : Examples.Interactivity.Direction.Model
  , example47 : Examples.Interactivity.Border.Model
  , example48 : Examples.Interactivity.Zoom.Model
  , example49 : Examples.Interactivity.BasicBin.Model
  , example50 : Examples.Interactivity.BasicStack.Model
  , example51 : Examples.Interactivity.ChangeName.Model
  , example52 : Examples.Interactivity.NoArrow.Model
  , example53 : Examples.Interactivity.FilterSearch.Model
  , example54 : Examples.Interactivity.Background.Model
  , example55 : Examples.Interactivity.BasicBar.Model
  , example56 : Examples.Interactivity.BasicArea.Model
  , example57 : Examples.Interactivity.TrickyTooltip.Model
  , example58 : Examples.Interactivity.Multiple.Model
  , example59 : Examples.Interactivity.BasicLine.Model
  , example60 : Examples.Interactivity.Offset.Model
  , example61 : Examples.Interactivity.DoubleSearch.Model
  , example62 : Examples.Interactivity.Focal.Model
  , example63 : Examples.LineCharts.Area.Model
  , example64 : Examples.LineCharts.Gradient.Model
  , example65 : Examples.LineCharts.Width.Model
  , example66 : Examples.LineCharts.TooltipStack.Model
  , example67 : Examples.LineCharts.Tooltip.Model
  , example68 : Examples.LineCharts.Montone.Model
  , example69 : Examples.LineCharts.Pattern.Model
  , example70 : Examples.LineCharts.Dots.Model
  , example71 : Examples.LineCharts.Dashed.Model
  , example72 : Examples.LineCharts.Color.Model
  , example73 : Examples.LineCharts.Stepped.Model
  , example74 : Examples.LineCharts.Stacked.Model
  , example75 : Examples.LineCharts.Labels.Model
  , example76 : Examples.LineCharts.Legends.Model
  , example77 : Examples.LineCharts.Basic.Model
  , example78 : Examples.ScatterCharts.Colors.Model
  , example79 : Examples.ScatterCharts.Shapes.Model
  , example80 : Examples.ScatterCharts.Tooltip.Model
  , example81 : Examples.ScatterCharts.Highlight.Model
  , example82 : Examples.ScatterCharts.DataDependent.Model
  , example83 : Examples.ScatterCharts.Borders.Model
  , example84 : Examples.ScatterCharts.Labels.Model
  , example85 : Examples.ScatterCharts.Opacity.Model
  , example86 : Examples.ScatterCharts.Sizes.Model
  , example87 : Examples.ScatterCharts.Legends.Model
  , example88 : Examples.ScatterCharts.Basic.Model
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
  , example8 = Examples.BarCharts.Highlight.init
  , example9 = Examples.BarCharts.DataDependent.init
  , example10 = Examples.BarCharts.Color.init
  , example11 = Examples.BarCharts.TooltipBin.init
  , example12 = Examples.BarCharts.Corners.init
  , example13 = Examples.BarCharts.Ungroup.init
  , example14 = Examples.BarCharts.BinLabels.init
  , example15 = Examples.BarCharts.Stacked.init
  , example16 = Examples.BarCharts.Margin.init
  , example17 = Examples.BarCharts.Borders.init
  , example18 = Examples.BarCharts.Opacity.init
  , example19 = Examples.BarCharts.Legends.init
  , example20 = Examples.BarCharts.Basic.init
  , example21 = Examples.Frame.Lines.init
  , example22 = Examples.Frame.Position.init
  , example23 = Examples.Frame.Coordinates.init
  , example24 = Examples.Frame.GridFilter.init
  , example25 = Examples.Frame.Dimensions.init
  , example26 = Examples.Frame.NoArrow.init
  , example27 = Examples.Frame.Background.init
  , example28 = Examples.Frame.Rect.init
  , example29 = Examples.Frame.Padding.init
  , example30 = Examples.Frame.Times.init
  , example31 = Examples.Frame.OnlyInts.init
  , example32 = Examples.Frame.GridColor.init
  , example33 = Examples.Frame.Offset.init
  , example34 = Examples.Frame.Color.init
  , example35 = Examples.Frame.Amount.init
  , example36 = Examples.Frame.Titles.init
  , example37 = Examples.Frame.CustomLabels.init
  , example38 = Examples.Frame.Margin.init
  , example39 = Examples.Frame.LabelWithLine.init
  , example40 = Examples.Frame.DotGrid.init
  , example41 = Examples.Frame.AxisLength.init
  , example42 = Examples.Frame.Arbitrary.init
  , example43 = Examples.Frame.Legends.init
  , example44 = Examples.Frame.Basic.init
  , example45 = Examples.Interactivity.ChangeContent.init
  , example46 = Examples.Interactivity.Direction.init
  , example47 = Examples.Interactivity.Border.init
  , example48 = Examples.Interactivity.Zoom.init
  , example49 = Examples.Interactivity.BasicBin.init
  , example50 = Examples.Interactivity.BasicStack.init
  , example51 = Examples.Interactivity.ChangeName.init
  , example52 = Examples.Interactivity.NoArrow.init
  , example53 = Examples.Interactivity.FilterSearch.init
  , example54 = Examples.Interactivity.Background.init
  , example55 = Examples.Interactivity.BasicBar.init
  , example56 = Examples.Interactivity.BasicArea.init
  , example57 = Examples.Interactivity.TrickyTooltip.init
  , example58 = Examples.Interactivity.Multiple.init
  , example59 = Examples.Interactivity.BasicLine.init
  , example60 = Examples.Interactivity.Offset.init
  , example61 = Examples.Interactivity.DoubleSearch.init
  , example62 = Examples.Interactivity.Focal.init
  , example63 = Examples.LineCharts.Area.init
  , example64 = Examples.LineCharts.Gradient.init
  , example65 = Examples.LineCharts.Width.init
  , example66 = Examples.LineCharts.TooltipStack.init
  , example67 = Examples.LineCharts.Tooltip.init
  , example68 = Examples.LineCharts.Montone.init
  , example69 = Examples.LineCharts.Pattern.init
  , example70 = Examples.LineCharts.Dots.init
  , example71 = Examples.LineCharts.Dashed.init
  , example72 = Examples.LineCharts.Color.init
  , example73 = Examples.LineCharts.Stepped.init
  , example74 = Examples.LineCharts.Stacked.init
  , example75 = Examples.LineCharts.Labels.init
  , example76 = Examples.LineCharts.Legends.init
  , example77 = Examples.LineCharts.Basic.init
  , example78 = Examples.ScatterCharts.Colors.init
  , example79 = Examples.ScatterCharts.Shapes.init
  , example80 = Examples.ScatterCharts.Tooltip.init
  , example81 = Examples.ScatterCharts.Highlight.init
  , example82 = Examples.ScatterCharts.DataDependent.init
  , example83 = Examples.ScatterCharts.Borders.init
  , example84 = Examples.ScatterCharts.Labels.init
  , example85 = Examples.ScatterCharts.Opacity.init
  , example86 = Examples.ScatterCharts.Sizes.init
  , example87 = Examples.ScatterCharts.Legends.init
  , example88 = Examples.ScatterCharts.Basic.init
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
  | ExampleMsg8 Examples.BarCharts.Highlight.Msg
  | ExampleMsg9 Examples.BarCharts.DataDependent.Msg
  | ExampleMsg10 Examples.BarCharts.Color.Msg
  | ExampleMsg11 Examples.BarCharts.TooltipBin.Msg
  | ExampleMsg12 Examples.BarCharts.Corners.Msg
  | ExampleMsg13 Examples.BarCharts.Ungroup.Msg
  | ExampleMsg14 Examples.BarCharts.BinLabels.Msg
  | ExampleMsg15 Examples.BarCharts.Stacked.Msg
  | ExampleMsg16 Examples.BarCharts.Margin.Msg
  | ExampleMsg17 Examples.BarCharts.Borders.Msg
  | ExampleMsg18 Examples.BarCharts.Opacity.Msg
  | ExampleMsg19 Examples.BarCharts.Legends.Msg
  | ExampleMsg20 Examples.BarCharts.Basic.Msg
  | ExampleMsg21 Examples.Frame.Lines.Msg
  | ExampleMsg22 Examples.Frame.Position.Msg
  | ExampleMsg23 Examples.Frame.Coordinates.Msg
  | ExampleMsg24 Examples.Frame.GridFilter.Msg
  | ExampleMsg25 Examples.Frame.Dimensions.Msg
  | ExampleMsg26 Examples.Frame.NoArrow.Msg
  | ExampleMsg27 Examples.Frame.Background.Msg
  | ExampleMsg28 Examples.Frame.Rect.Msg
  | ExampleMsg29 Examples.Frame.Padding.Msg
  | ExampleMsg30 Examples.Frame.Times.Msg
  | ExampleMsg31 Examples.Frame.OnlyInts.Msg
  | ExampleMsg32 Examples.Frame.GridColor.Msg
  | ExampleMsg33 Examples.Frame.Offset.Msg
  | ExampleMsg34 Examples.Frame.Color.Msg
  | ExampleMsg35 Examples.Frame.Amount.Msg
  | ExampleMsg36 Examples.Frame.Titles.Msg
  | ExampleMsg37 Examples.Frame.CustomLabels.Msg
  | ExampleMsg38 Examples.Frame.Margin.Msg
  | ExampleMsg39 Examples.Frame.LabelWithLine.Msg
  | ExampleMsg40 Examples.Frame.DotGrid.Msg
  | ExampleMsg41 Examples.Frame.AxisLength.Msg
  | ExampleMsg42 Examples.Frame.Arbitrary.Msg
  | ExampleMsg43 Examples.Frame.Legends.Msg
  | ExampleMsg44 Examples.Frame.Basic.Msg
  | ExampleMsg45 Examples.Interactivity.ChangeContent.Msg
  | ExampleMsg46 Examples.Interactivity.Direction.Msg
  | ExampleMsg47 Examples.Interactivity.Border.Msg
  | ExampleMsg48 Examples.Interactivity.Zoom.Msg
  | ExampleMsg49 Examples.Interactivity.BasicBin.Msg
  | ExampleMsg50 Examples.Interactivity.BasicStack.Msg
  | ExampleMsg51 Examples.Interactivity.ChangeName.Msg
  | ExampleMsg52 Examples.Interactivity.NoArrow.Msg
  | ExampleMsg53 Examples.Interactivity.FilterSearch.Msg
  | ExampleMsg54 Examples.Interactivity.Background.Msg
  | ExampleMsg55 Examples.Interactivity.BasicBar.Msg
  | ExampleMsg56 Examples.Interactivity.BasicArea.Msg
  | ExampleMsg57 Examples.Interactivity.TrickyTooltip.Msg
  | ExampleMsg58 Examples.Interactivity.Multiple.Msg
  | ExampleMsg59 Examples.Interactivity.BasicLine.Msg
  | ExampleMsg60 Examples.Interactivity.Offset.Msg
  | ExampleMsg61 Examples.Interactivity.DoubleSearch.Msg
  | ExampleMsg62 Examples.Interactivity.Focal.Msg
  | ExampleMsg63 Examples.LineCharts.Area.Msg
  | ExampleMsg64 Examples.LineCharts.Gradient.Msg
  | ExampleMsg65 Examples.LineCharts.Width.Msg
  | ExampleMsg66 Examples.LineCharts.TooltipStack.Msg
  | ExampleMsg67 Examples.LineCharts.Tooltip.Msg
  | ExampleMsg68 Examples.LineCharts.Montone.Msg
  | ExampleMsg69 Examples.LineCharts.Pattern.Msg
  | ExampleMsg70 Examples.LineCharts.Dots.Msg
  | ExampleMsg71 Examples.LineCharts.Dashed.Msg
  | ExampleMsg72 Examples.LineCharts.Color.Msg
  | ExampleMsg73 Examples.LineCharts.Stepped.Msg
  | ExampleMsg74 Examples.LineCharts.Stacked.Msg
  | ExampleMsg75 Examples.LineCharts.Labels.Msg
  | ExampleMsg76 Examples.LineCharts.Legends.Msg
  | ExampleMsg77 Examples.LineCharts.Basic.Msg
  | ExampleMsg78 Examples.ScatterCharts.Colors.Msg
  | ExampleMsg79 Examples.ScatterCharts.Shapes.Msg
  | ExampleMsg80 Examples.ScatterCharts.Tooltip.Msg
  | ExampleMsg81 Examples.ScatterCharts.Highlight.Msg
  | ExampleMsg82 Examples.ScatterCharts.DataDependent.Msg
  | ExampleMsg83 Examples.ScatterCharts.Borders.Msg
  | ExampleMsg84 Examples.ScatterCharts.Labels.Msg
  | ExampleMsg85 Examples.ScatterCharts.Opacity.Msg
  | ExampleMsg86 Examples.ScatterCharts.Sizes.Msg
  | ExampleMsg87 Examples.ScatterCharts.Legends.Msg
  | ExampleMsg88 Examples.ScatterCharts.Basic.Msg


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
    ExampleMsg8 sub -> { model | example8 = Examples.BarCharts.Highlight.update sub model.example8 }
    ExampleMsg9 sub -> { model | example9 = Examples.BarCharts.DataDependent.update sub model.example9 }
    ExampleMsg10 sub -> { model | example10 = Examples.BarCharts.Color.update sub model.example10 }
    ExampleMsg11 sub -> { model | example11 = Examples.BarCharts.TooltipBin.update sub model.example11 }
    ExampleMsg12 sub -> { model | example12 = Examples.BarCharts.Corners.update sub model.example12 }
    ExampleMsg13 sub -> { model | example13 = Examples.BarCharts.Ungroup.update sub model.example13 }
    ExampleMsg14 sub -> { model | example14 = Examples.BarCharts.BinLabels.update sub model.example14 }
    ExampleMsg15 sub -> { model | example15 = Examples.BarCharts.Stacked.update sub model.example15 }
    ExampleMsg16 sub -> { model | example16 = Examples.BarCharts.Margin.update sub model.example16 }
    ExampleMsg17 sub -> { model | example17 = Examples.BarCharts.Borders.update sub model.example17 }
    ExampleMsg18 sub -> { model | example18 = Examples.BarCharts.Opacity.update sub model.example18 }
    ExampleMsg19 sub -> { model | example19 = Examples.BarCharts.Legends.update sub model.example19 }
    ExampleMsg20 sub -> { model | example20 = Examples.BarCharts.Basic.update sub model.example20 }
    ExampleMsg21 sub -> { model | example21 = Examples.Frame.Lines.update sub model.example21 }
    ExampleMsg22 sub -> { model | example22 = Examples.Frame.Position.update sub model.example22 }
    ExampleMsg23 sub -> { model | example23 = Examples.Frame.Coordinates.update sub model.example23 }
    ExampleMsg24 sub -> { model | example24 = Examples.Frame.GridFilter.update sub model.example24 }
    ExampleMsg25 sub -> { model | example25 = Examples.Frame.Dimensions.update sub model.example25 }
    ExampleMsg26 sub -> { model | example26 = Examples.Frame.NoArrow.update sub model.example26 }
    ExampleMsg27 sub -> { model | example27 = Examples.Frame.Background.update sub model.example27 }
    ExampleMsg28 sub -> { model | example28 = Examples.Frame.Rect.update sub model.example28 }
    ExampleMsg29 sub -> { model | example29 = Examples.Frame.Padding.update sub model.example29 }
    ExampleMsg30 sub -> { model | example30 = Examples.Frame.Times.update sub model.example30 }
    ExampleMsg31 sub -> { model | example31 = Examples.Frame.OnlyInts.update sub model.example31 }
    ExampleMsg32 sub -> { model | example32 = Examples.Frame.GridColor.update sub model.example32 }
    ExampleMsg33 sub -> { model | example33 = Examples.Frame.Offset.update sub model.example33 }
    ExampleMsg34 sub -> { model | example34 = Examples.Frame.Color.update sub model.example34 }
    ExampleMsg35 sub -> { model | example35 = Examples.Frame.Amount.update sub model.example35 }
    ExampleMsg36 sub -> { model | example36 = Examples.Frame.Titles.update sub model.example36 }
    ExampleMsg37 sub -> { model | example37 = Examples.Frame.CustomLabels.update sub model.example37 }
    ExampleMsg38 sub -> { model | example38 = Examples.Frame.Margin.update sub model.example38 }
    ExampleMsg39 sub -> { model | example39 = Examples.Frame.LabelWithLine.update sub model.example39 }
    ExampleMsg40 sub -> { model | example40 = Examples.Frame.DotGrid.update sub model.example40 }
    ExampleMsg41 sub -> { model | example41 = Examples.Frame.AxisLength.update sub model.example41 }
    ExampleMsg42 sub -> { model | example42 = Examples.Frame.Arbitrary.update sub model.example42 }
    ExampleMsg43 sub -> { model | example43 = Examples.Frame.Legends.update sub model.example43 }
    ExampleMsg44 sub -> { model | example44 = Examples.Frame.Basic.update sub model.example44 }
    ExampleMsg45 sub -> { model | example45 = Examples.Interactivity.ChangeContent.update sub model.example45 }
    ExampleMsg46 sub -> { model | example46 = Examples.Interactivity.Direction.update sub model.example46 }
    ExampleMsg47 sub -> { model | example47 = Examples.Interactivity.Border.update sub model.example47 }
    ExampleMsg48 sub -> { model | example48 = Examples.Interactivity.Zoom.update sub model.example48 }
    ExampleMsg49 sub -> { model | example49 = Examples.Interactivity.BasicBin.update sub model.example49 }
    ExampleMsg50 sub -> { model | example50 = Examples.Interactivity.BasicStack.update sub model.example50 }
    ExampleMsg51 sub -> { model | example51 = Examples.Interactivity.ChangeName.update sub model.example51 }
    ExampleMsg52 sub -> { model | example52 = Examples.Interactivity.NoArrow.update sub model.example52 }
    ExampleMsg53 sub -> { model | example53 = Examples.Interactivity.FilterSearch.update sub model.example53 }
    ExampleMsg54 sub -> { model | example54 = Examples.Interactivity.Background.update sub model.example54 }
    ExampleMsg55 sub -> { model | example55 = Examples.Interactivity.BasicBar.update sub model.example55 }
    ExampleMsg56 sub -> { model | example56 = Examples.Interactivity.BasicArea.update sub model.example56 }
    ExampleMsg57 sub -> { model | example57 = Examples.Interactivity.TrickyTooltip.update sub model.example57 }
    ExampleMsg58 sub -> { model | example58 = Examples.Interactivity.Multiple.update sub model.example58 }
    ExampleMsg59 sub -> { model | example59 = Examples.Interactivity.BasicLine.update sub model.example59 }
    ExampleMsg60 sub -> { model | example60 = Examples.Interactivity.Offset.update sub model.example60 }
    ExampleMsg61 sub -> { model | example61 = Examples.Interactivity.DoubleSearch.update sub model.example61 }
    ExampleMsg62 sub -> { model | example62 = Examples.Interactivity.Focal.update sub model.example62 }
    ExampleMsg63 sub -> { model | example63 = Examples.LineCharts.Area.update sub model.example63 }
    ExampleMsg64 sub -> { model | example64 = Examples.LineCharts.Gradient.update sub model.example64 }
    ExampleMsg65 sub -> { model | example65 = Examples.LineCharts.Width.update sub model.example65 }
    ExampleMsg66 sub -> { model | example66 = Examples.LineCharts.TooltipStack.update sub model.example66 }
    ExampleMsg67 sub -> { model | example67 = Examples.LineCharts.Tooltip.update sub model.example67 }
    ExampleMsg68 sub -> { model | example68 = Examples.LineCharts.Montone.update sub model.example68 }
    ExampleMsg69 sub -> { model | example69 = Examples.LineCharts.Pattern.update sub model.example69 }
    ExampleMsg70 sub -> { model | example70 = Examples.LineCharts.Dots.update sub model.example70 }
    ExampleMsg71 sub -> { model | example71 = Examples.LineCharts.Dashed.update sub model.example71 }
    ExampleMsg72 sub -> { model | example72 = Examples.LineCharts.Color.update sub model.example72 }
    ExampleMsg73 sub -> { model | example73 = Examples.LineCharts.Stepped.update sub model.example73 }
    ExampleMsg74 sub -> { model | example74 = Examples.LineCharts.Stacked.update sub model.example74 }
    ExampleMsg75 sub -> { model | example75 = Examples.LineCharts.Labels.update sub model.example75 }
    ExampleMsg76 sub -> { model | example76 = Examples.LineCharts.Legends.update sub model.example76 }
    ExampleMsg77 sub -> { model | example77 = Examples.LineCharts.Basic.update sub model.example77 }
    ExampleMsg78 sub -> { model | example78 = Examples.ScatterCharts.Colors.update sub model.example78 }
    ExampleMsg79 sub -> { model | example79 = Examples.ScatterCharts.Shapes.update sub model.example79 }
    ExampleMsg80 sub -> { model | example80 = Examples.ScatterCharts.Tooltip.update sub model.example80 }
    ExampleMsg81 sub -> { model | example81 = Examples.ScatterCharts.Highlight.update sub model.example81 }
    ExampleMsg82 sub -> { model | example82 = Examples.ScatterCharts.DataDependent.update sub model.example82 }
    ExampleMsg83 sub -> { model | example83 = Examples.ScatterCharts.Borders.update sub model.example83 }
    ExampleMsg84 sub -> { model | example84 = Examples.ScatterCharts.Labels.update sub model.example84 }
    ExampleMsg85 sub -> { model | example85 = Examples.ScatterCharts.Opacity.update sub model.example85 }
    ExampleMsg86 sub -> { model | example86 = Examples.ScatterCharts.Sizes.update sub model.example86 }
    ExampleMsg87 sub -> { model | example87 = Examples.ScatterCharts.Legends.update sub model.example87 }
    ExampleMsg88 sub -> { model | example88 = Examples.ScatterCharts.Basic.update sub model.example88 }


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
    BarCharts__Highlight -> Html.map ExampleMsg8 (Examples.BarCharts.Highlight.view model.example8)
    BarCharts__DataDependent -> Html.map ExampleMsg9 (Examples.BarCharts.DataDependent.view model.example9)
    BarCharts__Color -> Html.map ExampleMsg10 (Examples.BarCharts.Color.view model.example10)
    BarCharts__TooltipBin -> Html.map ExampleMsg11 (Examples.BarCharts.TooltipBin.view model.example11)
    BarCharts__Corners -> Html.map ExampleMsg12 (Examples.BarCharts.Corners.view model.example12)
    BarCharts__Ungroup -> Html.map ExampleMsg13 (Examples.BarCharts.Ungroup.view model.example13)
    BarCharts__BinLabels -> Html.map ExampleMsg14 (Examples.BarCharts.BinLabels.view model.example14)
    BarCharts__Stacked -> Html.map ExampleMsg15 (Examples.BarCharts.Stacked.view model.example15)
    BarCharts__Margin -> Html.map ExampleMsg16 (Examples.BarCharts.Margin.view model.example16)
    BarCharts__Borders -> Html.map ExampleMsg17 (Examples.BarCharts.Borders.view model.example17)
    BarCharts__Opacity -> Html.map ExampleMsg18 (Examples.BarCharts.Opacity.view model.example18)
    BarCharts__Legends -> Html.map ExampleMsg19 (Examples.BarCharts.Legends.view model.example19)
    BarCharts__Basic -> Html.map ExampleMsg20 (Examples.BarCharts.Basic.view model.example20)
    Frame__Lines -> Html.map ExampleMsg21 (Examples.Frame.Lines.view model.example21)
    Frame__Position -> Html.map ExampleMsg22 (Examples.Frame.Position.view model.example22)
    Frame__Coordinates -> Html.map ExampleMsg23 (Examples.Frame.Coordinates.view model.example23)
    Frame__GridFilter -> Html.map ExampleMsg24 (Examples.Frame.GridFilter.view model.example24)
    Frame__Dimensions -> Html.map ExampleMsg25 (Examples.Frame.Dimensions.view model.example25)
    Frame__NoArrow -> Html.map ExampleMsg26 (Examples.Frame.NoArrow.view model.example26)
    Frame__Background -> Html.map ExampleMsg27 (Examples.Frame.Background.view model.example27)
    Frame__Rect -> Html.map ExampleMsg28 (Examples.Frame.Rect.view model.example28)
    Frame__Padding -> Html.map ExampleMsg29 (Examples.Frame.Padding.view model.example29)
    Frame__Times -> Html.map ExampleMsg30 (Examples.Frame.Times.view model.example30)
    Frame__OnlyInts -> Html.map ExampleMsg31 (Examples.Frame.OnlyInts.view model.example31)
    Frame__GridColor -> Html.map ExampleMsg32 (Examples.Frame.GridColor.view model.example32)
    Frame__Offset -> Html.map ExampleMsg33 (Examples.Frame.Offset.view model.example33)
    Frame__Color -> Html.map ExampleMsg34 (Examples.Frame.Color.view model.example34)
    Frame__Amount -> Html.map ExampleMsg35 (Examples.Frame.Amount.view model.example35)
    Frame__Titles -> Html.map ExampleMsg36 (Examples.Frame.Titles.view model.example36)
    Frame__CustomLabels -> Html.map ExampleMsg37 (Examples.Frame.CustomLabels.view model.example37)
    Frame__Margin -> Html.map ExampleMsg38 (Examples.Frame.Margin.view model.example38)
    Frame__LabelWithLine -> Html.map ExampleMsg39 (Examples.Frame.LabelWithLine.view model.example39)
    Frame__DotGrid -> Html.map ExampleMsg40 (Examples.Frame.DotGrid.view model.example40)
    Frame__AxisLength -> Html.map ExampleMsg41 (Examples.Frame.AxisLength.view model.example41)
    Frame__Arbitrary -> Html.map ExampleMsg42 (Examples.Frame.Arbitrary.view model.example42)
    Frame__Legends -> Html.map ExampleMsg43 (Examples.Frame.Legends.view model.example43)
    Frame__Basic -> Html.map ExampleMsg44 (Examples.Frame.Basic.view model.example44)
    Interactivity__ChangeContent -> Html.map ExampleMsg45 (Examples.Interactivity.ChangeContent.view model.example45)
    Interactivity__Direction -> Html.map ExampleMsg46 (Examples.Interactivity.Direction.view model.example46)
    Interactivity__Border -> Html.map ExampleMsg47 (Examples.Interactivity.Border.view model.example47)
    Interactivity__Zoom -> Html.map ExampleMsg48 (Examples.Interactivity.Zoom.view model.example48)
    Interactivity__BasicBin -> Html.map ExampleMsg49 (Examples.Interactivity.BasicBin.view model.example49)
    Interactivity__BasicStack -> Html.map ExampleMsg50 (Examples.Interactivity.BasicStack.view model.example50)
    Interactivity__ChangeName -> Html.map ExampleMsg51 (Examples.Interactivity.ChangeName.view model.example51)
    Interactivity__NoArrow -> Html.map ExampleMsg52 (Examples.Interactivity.NoArrow.view model.example52)
    Interactivity__FilterSearch -> Html.map ExampleMsg53 (Examples.Interactivity.FilterSearch.view model.example53)
    Interactivity__Background -> Html.map ExampleMsg54 (Examples.Interactivity.Background.view model.example54)
    Interactivity__BasicBar -> Html.map ExampleMsg55 (Examples.Interactivity.BasicBar.view model.example55)
    Interactivity__BasicArea -> Html.map ExampleMsg56 (Examples.Interactivity.BasicArea.view model.example56)
    Interactivity__TrickyTooltip -> Html.map ExampleMsg57 (Examples.Interactivity.TrickyTooltip.view model.example57)
    Interactivity__Multiple -> Html.map ExampleMsg58 (Examples.Interactivity.Multiple.view model.example58)
    Interactivity__BasicLine -> Html.map ExampleMsg59 (Examples.Interactivity.BasicLine.view model.example59)
    Interactivity__Offset -> Html.map ExampleMsg60 (Examples.Interactivity.Offset.view model.example60)
    Interactivity__DoubleSearch -> Html.map ExampleMsg61 (Examples.Interactivity.DoubleSearch.view model.example61)
    Interactivity__Focal -> Html.map ExampleMsg62 (Examples.Interactivity.Focal.view model.example62)
    LineCharts__Area -> Html.map ExampleMsg63 (Examples.LineCharts.Area.view model.example63)
    LineCharts__Gradient -> Html.map ExampleMsg64 (Examples.LineCharts.Gradient.view model.example64)
    LineCharts__Width -> Html.map ExampleMsg65 (Examples.LineCharts.Width.view model.example65)
    LineCharts__TooltipStack -> Html.map ExampleMsg66 (Examples.LineCharts.TooltipStack.view model.example66)
    LineCharts__Tooltip -> Html.map ExampleMsg67 (Examples.LineCharts.Tooltip.view model.example67)
    LineCharts__Montone -> Html.map ExampleMsg68 (Examples.LineCharts.Montone.view model.example68)
    LineCharts__Pattern -> Html.map ExampleMsg69 (Examples.LineCharts.Pattern.view model.example69)
    LineCharts__Dots -> Html.map ExampleMsg70 (Examples.LineCharts.Dots.view model.example70)
    LineCharts__Dashed -> Html.map ExampleMsg71 (Examples.LineCharts.Dashed.view model.example71)
    LineCharts__Color -> Html.map ExampleMsg72 (Examples.LineCharts.Color.view model.example72)
    LineCharts__Stepped -> Html.map ExampleMsg73 (Examples.LineCharts.Stepped.view model.example73)
    LineCharts__Stacked -> Html.map ExampleMsg74 (Examples.LineCharts.Stacked.view model.example74)
    LineCharts__Labels -> Html.map ExampleMsg75 (Examples.LineCharts.Labels.view model.example75)
    LineCharts__Legends -> Html.map ExampleMsg76 (Examples.LineCharts.Legends.view model.example76)
    LineCharts__Basic -> Html.map ExampleMsg77 (Examples.LineCharts.Basic.view model.example77)
    ScatterCharts__Colors -> Html.map ExampleMsg78 (Examples.ScatterCharts.Colors.view model.example78)
    ScatterCharts__Shapes -> Html.map ExampleMsg79 (Examples.ScatterCharts.Shapes.view model.example79)
    ScatterCharts__Tooltip -> Html.map ExampleMsg80 (Examples.ScatterCharts.Tooltip.view model.example80)
    ScatterCharts__Highlight -> Html.map ExampleMsg81 (Examples.ScatterCharts.Highlight.view model.example81)
    ScatterCharts__DataDependent -> Html.map ExampleMsg82 (Examples.ScatterCharts.DataDependent.view model.example82)
    ScatterCharts__Borders -> Html.map ExampleMsg83 (Examples.ScatterCharts.Borders.view model.example83)
    ScatterCharts__Labels -> Html.map ExampleMsg84 (Examples.ScatterCharts.Labels.view model.example84)
    ScatterCharts__Opacity -> Html.map ExampleMsg85 (Examples.ScatterCharts.Opacity.view model.example85)
    ScatterCharts__Sizes -> Html.map ExampleMsg86 (Examples.ScatterCharts.Sizes.view model.example86)
    ScatterCharts__Legends -> Html.map ExampleMsg87 (Examples.ScatterCharts.Legends.view model.example87)
    ScatterCharts__Basic -> Html.map ExampleMsg88 (Examples.ScatterCharts.Basic.view model.example88)


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
    BarCharts__Highlight -> Examples.BarCharts.Highlight.smallCode
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
    Frame__Coordinates -> Examples.Frame.Coordinates.smallCode
    Frame__GridFilter -> Examples.Frame.GridFilter.smallCode
    Frame__Dimensions -> Examples.Frame.Dimensions.smallCode
    Frame__NoArrow -> Examples.Frame.NoArrow.smallCode
    Frame__Background -> Examples.Frame.Background.smallCode
    Frame__Rect -> Examples.Frame.Rect.smallCode
    Frame__Padding -> Examples.Frame.Padding.smallCode
    Frame__Times -> Examples.Frame.Times.smallCode
    Frame__OnlyInts -> Examples.Frame.OnlyInts.smallCode
    Frame__GridColor -> Examples.Frame.GridColor.smallCode
    Frame__Offset -> Examples.Frame.Offset.smallCode
    Frame__Color -> Examples.Frame.Color.smallCode
    Frame__Amount -> Examples.Frame.Amount.smallCode
    Frame__Titles -> Examples.Frame.Titles.smallCode
    Frame__CustomLabels -> Examples.Frame.CustomLabels.smallCode
    Frame__Margin -> Examples.Frame.Margin.smallCode
    Frame__LabelWithLine -> Examples.Frame.LabelWithLine.smallCode
    Frame__DotGrid -> Examples.Frame.DotGrid.smallCode
    Frame__AxisLength -> Examples.Frame.AxisLength.smallCode
    Frame__Arbitrary -> Examples.Frame.Arbitrary.smallCode
    Frame__Legends -> Examples.Frame.Legends.smallCode
    Frame__Basic -> Examples.Frame.Basic.smallCode
    Interactivity__ChangeContent -> Examples.Interactivity.ChangeContent.smallCode
    Interactivity__Direction -> Examples.Interactivity.Direction.smallCode
    Interactivity__Border -> Examples.Interactivity.Border.smallCode
    Interactivity__Zoom -> Examples.Interactivity.Zoom.smallCode
    Interactivity__BasicBin -> Examples.Interactivity.BasicBin.smallCode
    Interactivity__BasicStack -> Examples.Interactivity.BasicStack.smallCode
    Interactivity__ChangeName -> Examples.Interactivity.ChangeName.smallCode
    Interactivity__NoArrow -> Examples.Interactivity.NoArrow.smallCode
    Interactivity__FilterSearch -> Examples.Interactivity.FilterSearch.smallCode
    Interactivity__Background -> Examples.Interactivity.Background.smallCode
    Interactivity__BasicBar -> Examples.Interactivity.BasicBar.smallCode
    Interactivity__BasicArea -> Examples.Interactivity.BasicArea.smallCode
    Interactivity__TrickyTooltip -> Examples.Interactivity.TrickyTooltip.smallCode
    Interactivity__Multiple -> Examples.Interactivity.Multiple.smallCode
    Interactivity__BasicLine -> Examples.Interactivity.BasicLine.smallCode
    Interactivity__Offset -> Examples.Interactivity.Offset.smallCode
    Interactivity__DoubleSearch -> Examples.Interactivity.DoubleSearch.smallCode
    Interactivity__Focal -> Examples.Interactivity.Focal.smallCode
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
    BarCharts__Highlight -> Examples.BarCharts.Highlight.largeCode
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
    Frame__Coordinates -> Examples.Frame.Coordinates.largeCode
    Frame__GridFilter -> Examples.Frame.GridFilter.largeCode
    Frame__Dimensions -> Examples.Frame.Dimensions.largeCode
    Frame__NoArrow -> Examples.Frame.NoArrow.largeCode
    Frame__Background -> Examples.Frame.Background.largeCode
    Frame__Rect -> Examples.Frame.Rect.largeCode
    Frame__Padding -> Examples.Frame.Padding.largeCode
    Frame__Times -> Examples.Frame.Times.largeCode
    Frame__OnlyInts -> Examples.Frame.OnlyInts.largeCode
    Frame__GridColor -> Examples.Frame.GridColor.largeCode
    Frame__Offset -> Examples.Frame.Offset.largeCode
    Frame__Color -> Examples.Frame.Color.largeCode
    Frame__Amount -> Examples.Frame.Amount.largeCode
    Frame__Titles -> Examples.Frame.Titles.largeCode
    Frame__CustomLabels -> Examples.Frame.CustomLabels.largeCode
    Frame__Margin -> Examples.Frame.Margin.largeCode
    Frame__LabelWithLine -> Examples.Frame.LabelWithLine.largeCode
    Frame__DotGrid -> Examples.Frame.DotGrid.largeCode
    Frame__AxisLength -> Examples.Frame.AxisLength.largeCode
    Frame__Arbitrary -> Examples.Frame.Arbitrary.largeCode
    Frame__Legends -> Examples.Frame.Legends.largeCode
    Frame__Basic -> Examples.Frame.Basic.largeCode
    Interactivity__ChangeContent -> Examples.Interactivity.ChangeContent.largeCode
    Interactivity__Direction -> Examples.Interactivity.Direction.largeCode
    Interactivity__Border -> Examples.Interactivity.Border.largeCode
    Interactivity__Zoom -> Examples.Interactivity.Zoom.largeCode
    Interactivity__BasicBin -> Examples.Interactivity.BasicBin.largeCode
    Interactivity__BasicStack -> Examples.Interactivity.BasicStack.largeCode
    Interactivity__ChangeName -> Examples.Interactivity.ChangeName.largeCode
    Interactivity__NoArrow -> Examples.Interactivity.NoArrow.largeCode
    Interactivity__FilterSearch -> Examples.Interactivity.FilterSearch.largeCode
    Interactivity__Background -> Examples.Interactivity.Background.largeCode
    Interactivity__BasicBar -> Examples.Interactivity.BasicBar.largeCode
    Interactivity__BasicArea -> Examples.Interactivity.BasicArea.largeCode
    Interactivity__TrickyTooltip -> Examples.Interactivity.TrickyTooltip.largeCode
    Interactivity__Multiple -> Examples.Interactivity.Multiple.largeCode
    Interactivity__BasicLine -> Examples.Interactivity.BasicLine.largeCode
    Interactivity__Offset -> Examples.Interactivity.Offset.largeCode
    Interactivity__DoubleSearch -> Examples.Interactivity.DoubleSearch.largeCode
    Interactivity__Focal -> Examples.Interactivity.Focal.largeCode
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
    BarCharts__Highlight -> "Examples.BarCharts.Highlight"
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
    Frame__Coordinates -> "Examples.Frame.Coordinates"
    Frame__GridFilter -> "Examples.Frame.GridFilter"
    Frame__Dimensions -> "Examples.Frame.Dimensions"
    Frame__NoArrow -> "Examples.Frame.NoArrow"
    Frame__Background -> "Examples.Frame.Background"
    Frame__Rect -> "Examples.Frame.Rect"
    Frame__Padding -> "Examples.Frame.Padding"
    Frame__Times -> "Examples.Frame.Times"
    Frame__OnlyInts -> "Examples.Frame.OnlyInts"
    Frame__GridColor -> "Examples.Frame.GridColor"
    Frame__Offset -> "Examples.Frame.Offset"
    Frame__Color -> "Examples.Frame.Color"
    Frame__Amount -> "Examples.Frame.Amount"
    Frame__Titles -> "Examples.Frame.Titles"
    Frame__CustomLabels -> "Examples.Frame.CustomLabels"
    Frame__Margin -> "Examples.Frame.Margin"
    Frame__LabelWithLine -> "Examples.Frame.LabelWithLine"
    Frame__DotGrid -> "Examples.Frame.DotGrid"
    Frame__AxisLength -> "Examples.Frame.AxisLength"
    Frame__Arbitrary -> "Examples.Frame.Arbitrary"
    Frame__Legends -> "Examples.Frame.Legends"
    Frame__Basic -> "Examples.Frame.Basic"
    Interactivity__ChangeContent -> "Examples.Interactivity.ChangeContent"
    Interactivity__Direction -> "Examples.Interactivity.Direction"
    Interactivity__Border -> "Examples.Interactivity.Border"
    Interactivity__Zoom -> "Examples.Interactivity.Zoom"
    Interactivity__BasicBin -> "Examples.Interactivity.BasicBin"
    Interactivity__BasicStack -> "Examples.Interactivity.BasicStack"
    Interactivity__ChangeName -> "Examples.Interactivity.ChangeName"
    Interactivity__NoArrow -> "Examples.Interactivity.NoArrow"
    Interactivity__FilterSearch -> "Examples.Interactivity.FilterSearch"
    Interactivity__Background -> "Examples.Interactivity.Background"
    Interactivity__BasicBar -> "Examples.Interactivity.BasicBar"
    Interactivity__BasicArea -> "Examples.Interactivity.BasicArea"
    Interactivity__TrickyTooltip -> "Examples.Interactivity.TrickyTooltip"
    Interactivity__Multiple -> "Examples.Interactivity.Multiple"
    Interactivity__BasicLine -> "Examples.Interactivity.BasicLine"
    Interactivity__Offset -> "Examples.Interactivity.Offset"
    Interactivity__DoubleSearch -> "Examples.Interactivity.DoubleSearch"
    Interactivity__Focal -> "Examples.Interactivity.Focal"
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
    BarCharts__Highlight -> Examples.BarCharts.Highlight.meta
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
    Frame__Coordinates -> Examples.Frame.Coordinates.meta
    Frame__GridFilter -> Examples.Frame.GridFilter.meta
    Frame__Dimensions -> Examples.Frame.Dimensions.meta
    Frame__NoArrow -> Examples.Frame.NoArrow.meta
    Frame__Background -> Examples.Frame.Background.meta
    Frame__Rect -> Examples.Frame.Rect.meta
    Frame__Padding -> Examples.Frame.Padding.meta
    Frame__Times -> Examples.Frame.Times.meta
    Frame__OnlyInts -> Examples.Frame.OnlyInts.meta
    Frame__GridColor -> Examples.Frame.GridColor.meta
    Frame__Offset -> Examples.Frame.Offset.meta
    Frame__Color -> Examples.Frame.Color.meta
    Frame__Amount -> Examples.Frame.Amount.meta
    Frame__Titles -> Examples.Frame.Titles.meta
    Frame__CustomLabels -> Examples.Frame.CustomLabels.meta
    Frame__Margin -> Examples.Frame.Margin.meta
    Frame__LabelWithLine -> Examples.Frame.LabelWithLine.meta
    Frame__DotGrid -> Examples.Frame.DotGrid.meta
    Frame__AxisLength -> Examples.Frame.AxisLength.meta
    Frame__Arbitrary -> Examples.Frame.Arbitrary.meta
    Frame__Legends -> Examples.Frame.Legends.meta
    Frame__Basic -> Examples.Frame.Basic.meta
    Interactivity__ChangeContent -> Examples.Interactivity.ChangeContent.meta
    Interactivity__Direction -> Examples.Interactivity.Direction.meta
    Interactivity__Border -> Examples.Interactivity.Border.meta
    Interactivity__Zoom -> Examples.Interactivity.Zoom.meta
    Interactivity__BasicBin -> Examples.Interactivity.BasicBin.meta
    Interactivity__BasicStack -> Examples.Interactivity.BasicStack.meta
    Interactivity__ChangeName -> Examples.Interactivity.ChangeName.meta
    Interactivity__NoArrow -> Examples.Interactivity.NoArrow.meta
    Interactivity__FilterSearch -> Examples.Interactivity.FilterSearch.meta
    Interactivity__Background -> Examples.Interactivity.Background.meta
    Interactivity__BasicBar -> Examples.Interactivity.BasicBar.meta
    Interactivity__BasicArea -> Examples.Interactivity.BasicArea.meta
    Interactivity__TrickyTooltip -> Examples.Interactivity.TrickyTooltip.meta
    Interactivity__Multiple -> Examples.Interactivity.Multiple.meta
    Interactivity__BasicLine -> Examples.Interactivity.BasicLine.meta
    Interactivity__Offset -> Examples.Interactivity.Offset.meta
    Interactivity__DoubleSearch -> Examples.Interactivity.DoubleSearch.meta
    Interactivity__Focal -> Examples.Interactivity.Focal.meta
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
  , BarCharts__Highlight
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
  , Frame__Coordinates
  , Frame__GridFilter
  , Frame__Dimensions
  , Frame__NoArrow
  , Frame__Background
  , Frame__Rect
  , Frame__Padding
  , Frame__Times
  , Frame__OnlyInts
  , Frame__GridColor
  , Frame__Offset
  , Frame__Color
  , Frame__Amount
  , Frame__Titles
  , Frame__CustomLabels
  , Frame__Margin
  , Frame__LabelWithLine
  , Frame__DotGrid
  , Frame__AxisLength
  , Frame__Arbitrary
  , Frame__Legends
  , Frame__Basic
  , Interactivity__ChangeContent
  , Interactivity__Direction
  , Interactivity__Border
  , Interactivity__Zoom
  , Interactivity__BasicBin
  , Interactivity__BasicStack
  , Interactivity__ChangeName
  , Interactivity__NoArrow
  , Interactivity__FilterSearch
  , Interactivity__Background
  , Interactivity__BasicBar
  , Interactivity__BasicArea
  , Interactivity__TrickyTooltip
  , Interactivity__Multiple
  , Interactivity__BasicLine
  , Interactivity__Offset
  , Interactivity__DoubleSearch
  , Interactivity__Focal
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

