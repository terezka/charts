module Pages.Home_ exposing (Model, Msg, page)

import Gen.Params.Home_ exposing (Params)
import Page
import Request
import Shared
import View exposing (View)
import Charts.SaleryDist as SaleryDist
import Charts.Basics exposing (Example)
import Html as H
import Element as E
import Element.Font as F
import Element.Border as B
import Element.Background as BG
import Ui.Layout as Layout
import Ui.CompactExample as CompactExample
import Ui.Code as Code
import Ui.Menu as Menu


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.sandbox
        { init = init
        , update = update
        , view = view
        }



-- INIT


type alias Model =
    { saleryDist : SaleryDist.Model }


init : Model
init =
    { saleryDist = SaleryDist.init }



-- UPDATE


type Msg
    = SaleryDistMsg SaleryDist.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        SaleryDistMsg subMsg ->
            { model | saleryDist = SaleryDist.update subMsg model.saleryDist }



-- VIEW


view : Model -> View Msg
view model =
    { title = "elm-charts"
    , body =
        Layout.view
          [ E.el
              [ E.paddingEach { top = 0, bottom = 40, left = 0, right = 0 } ]
              (E.html <| H.map SaleryDistMsg (SaleryDist.view model.saleryDist))
          , Menu.expanded
          ]
    }

