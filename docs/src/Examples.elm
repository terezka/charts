module Examples exposing (Id, Model, init, Msg, update, view, name, all, first, smallCode, largeCode)


-- THIS IS A GENERATED MODULE!

import Html
import Examples.BarCharts.Spacing
import Examples.BarCharts.Margin
import Examples.BarCharts.Basic


type Id
  = BarCharts__Spacing
  | BarCharts__Margin
  | BarCharts__Basic


type alias Model =
  { example0 : Examples.BarCharts.Spacing.Model
  , example1 : Examples.BarCharts.Margin.Model
  , example2 : Examples.BarCharts.Basic.Model
  }


init : Model
init =
  { example0 = Examples.BarCharts.Spacing.init
  , example1 = Examples.BarCharts.Margin.init
  , example2 = Examples.BarCharts.Basic.init
  }


type Msg
  = ExampleMsg0 Examples.BarCharts.Spacing.Msg
  | ExampleMsg1 Examples.BarCharts.Margin.Msg
  | ExampleMsg2 Examples.BarCharts.Basic.Msg


update : Msg -> Model -> Model
update msg model =
  case msg of
    ExampleMsg0 sub -> { model | example0 = Examples.BarCharts.Spacing.update sub model.example0 }
    ExampleMsg1 sub -> { model | example1 = Examples.BarCharts.Margin.update sub model.example1 }
    ExampleMsg2 sub -> { model | example2 = Examples.BarCharts.Basic.update sub model.example2 }


view : Model -> Id -> Html.Html Msg
view model chosen =
  case chosen of
    BarCharts__Spacing -> Html.map ExampleMsg0 (Examples.BarCharts.Spacing.view model.example0)
    BarCharts__Margin -> Html.map ExampleMsg1 (Examples.BarCharts.Margin.view model.example1)
    BarCharts__Basic -> Html.map ExampleMsg2 (Examples.BarCharts.Basic.view model.example2)


smallCode : Id -> String
smallCode chosen =
  case chosen of
    BarCharts__Spacing -> Examples.BarCharts.Spacing.smallCode
    BarCharts__Margin -> Examples.BarCharts.Margin.smallCode
    BarCharts__Basic -> Examples.BarCharts.Basic.smallCode


largeCode : Id -> String
largeCode chosen =
  case chosen of
    BarCharts__Spacing -> Examples.BarCharts.Spacing.largeCode
    BarCharts__Margin -> Examples.BarCharts.Margin.largeCode
    BarCharts__Basic -> Examples.BarCharts.Basic.largeCode


name : Id -> String
name chosen =
  case chosen of
    BarCharts__Spacing -> "Examples.BarCharts.Spacing"
    BarCharts__Margin -> "Examples.BarCharts.Margin"
    BarCharts__Basic -> "Examples.BarCharts.Basic"


all : List Id
all =
  [ BarCharts__Spacing
  , BarCharts__Margin
  , BarCharts__Basic
  ]


first : Id
first =
  BarCharts__Spacing

