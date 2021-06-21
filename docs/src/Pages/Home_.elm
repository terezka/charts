module Pages.Home_ exposing (Model, Msg, page)

import Gen.Params.Home_ exposing (Params)
import Page
import Request
import Shared
import View exposing (View)
import Charts.SalaryDist as SalaryDist
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
    { salaryDist : SalaryDist.Model
    }


init : Model
init =
    { salaryDist = SalaryDist.init
    }



-- UPDATE


type Msg
    = SalaryDistMsg SalaryDist.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
      SalaryDistMsg subMsg ->
          { model | salaryDist = SalaryDist.update subMsg model.salaryDist }



-- VIEW


view : Model -> View Msg
view model =
    { title = "elm-charts"
    , body =
        Layout.view
          [ E.el
              [ E.paddingEach { top = 0, bottom = 10, left = 0, right = 0 }
              , E.width E.fill
              , E.height (E.px 530)
              ]
              (E.html <| H.map SalaryDistMsg (SalaryDist.view model.salaryDist))
          , Menu.expanded
          ]
    }

