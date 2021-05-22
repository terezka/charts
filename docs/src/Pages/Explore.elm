module Pages.Explore exposing (Model, Msg, page)

import Gen.Params.Explore exposing (Params)
import Page
import Request
import Shared
import View exposing (View)
import Ui.Layout as Layout
import SyntaxHighlight as SH
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
    { exploration : Dict.Dict String Int
    , interactivity : Section.Interactivity.Model
    }


init : Model
init =
    { exploration = Dict.empty
    , interactivity = Section.Interactivity.init
    }



-- UPDATE


type Msg
  = OnExploration String Int
  | OnInteractivity Section.Interactivity.Msg



update : Msg -> Model -> Model
update msg model =
    case msg of
      OnExploration title selected ->
        { model | exploration = Dict.insert title selected model.exploration }

      OnInteractivity subMsg ->
        { model | interactivity = Section.Interactivity.update subMsg model.interactivity }



-- VIEW


view : Model -> View Msg
view model =
  { title = "Explore"
  , body =
      Layout.view
        [ Section.ScatterChart.view OnExploration model.exploration
        , Section.LineChart.view OnExploration model.exploration
        , Section.BarChart.view OnExploration model.exploration
        , Section.CustomAxes.view OnExploration model.exploration
        , Section.Interactivity.view OnExploration model.exploration OnInteractivity model.interactivity
        ]
  }
