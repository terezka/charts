module Pages.Documentation exposing (Model, Msg, page)

import Gen.Params.Documentation exposing (Params)
import Page
import Request
import Shared
import View exposing (View)
import Ui.Layout as Layout
import Ui.Menu as Menu
import SyntaxHighlight as SH
import Ui.Section as Section
import Section.ScatterChart
import Section.LineChart
import Section.BarChart
import Section.CustomAxes
import Section.Interactivity
import Dict
import Element as E
import Element.Font as F
import Element.Border as B
import Element.Background as BG


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
  Page.sandbox
    { init = init
    , update = update
    , view = view
    }



-- INIT


type alias Model =
  { exploration : Section.Model
  , interactivity : Section.Interactivity.Model
  }


init : Model
init =
  { exploration = Section.init Section.ScatterChart.section
  , interactivity = Section.Interactivity.init
  }



-- UPDATE


type Msg
  = OnExploration String String
  | OnInteractivity Section.Interactivity.Msg



update : Msg -> Model -> Model
update msg model =
    case msg of
      OnExploration title selected ->
        { model | exploration = { selected = title, selectedSub = selected } }

      OnInteractivity subMsg ->
        { model | interactivity = Section.Interactivity.update subMsg model.interactivity }



-- VIEW


view : Model -> View Msg
view model =
  { title = "elm-charts | Documentation"
  , body =
      Layout.view
        [ Menu.small
        , Section.view OnExploration model.exploration
            [ Section.ScatterChart.section
            , Section.LineChart.section
            , Section.BarChart.section
            , Section.CustomAxes.section
            , Section.Interactivity.section OnInteractivity model.interactivity
            ]
        ]
  }
