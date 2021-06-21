module Pages.Real exposing (Model, Msg, page)

import Gen.Params.Real exposing (Params)
import Page
import Request
import Shared
import View exposing (View)
import Charts.SalaryDist as SalaryDist
import Charts.SalaryDistBar as SalaryDistBar
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
    , salaryDistBar : SalaryDistBar.Model
    }


init : Model
init =
    { salaryDist = SalaryDist.init
    , salaryDistBar = SalaryDistBar.init
    }



-- UPDATE


type Msg
    = SalaryDistMsg SalaryDist.Msg
    | SalaryDistBarMsg SalaryDistBar.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
      SalaryDistMsg subMsg ->
          { model | salaryDist = SalaryDist.update subMsg model.salaryDist }

      SalaryDistBarMsg subMsg ->
          { model | salaryDistBar = SalaryDistBar.update subMsg model.salaryDistBar }



-- VIEW


view : Model -> View Msg
view model =
    { title = "elm-charts"
    , body =
        Layout.view
          [ Menu.small
          , E.el
              [ F.size 32
              , E.paddingXY 0 10
              ]
              (E.text "Real data examples")

          , E.paragraph
              [ E.paddingEach { top = 10, bottom = 70, left = 0, right = 0 }
              , F.size 14
              , E.width (E.px 700)
              ]
              [ E.text "Examples of charts build with elm-charts using real data."
              ]

          , E.el
              [ F.size 20
              , E.paddingXY 0 10
              ]
              (E.text "1. Salary distribution in Denmark")

          , E.paragraph
              [ E.paddingEach { top = 10, bottom = 10, left = 0, right = 0 }
              , F.size 14
              , E.width (E.px 700)
              ]
              [ E.text "Note that the data visualized here is already aggregated into averages. This means that there might "
              , E.text "be women or men earning more or less than what the numbers show. For example, there may well be a woman CEO being payed the "
              , E.text "same or more than her male counter part, but what the data shows is that "
              , E.el [ F.italic ] (E.text "on average")
              , E.text " this is not the case. This is particularily important to keep in mind when interpreting the second chart."
              ]

          , E.el
              [ E.paddingEach { top = 50, bottom = 40, left = 0, right = 0 }
              , E.width (E.px 1000)
              ]
              (E.html <| H.map SalaryDistMsg (SalaryDist.view model.salaryDist))

          , E.el
              [ E.paddingEach { top = 0, bottom = 80, left = 0, right = 0 }
              , E.width (E.px 1000)
              ]
              (E.map SalaryDistBarMsg (SalaryDistBar.view model.salaryDistBar))
          ]
    }

