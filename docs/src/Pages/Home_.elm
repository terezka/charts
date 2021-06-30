module Pages.Home_ exposing (Model, Msg, page)

import Gen.Params.Home_ exposing (Params)
import Page
import Request
import Shared
import View exposing (View)
import Charts.SalaryDist as SalaryDist
import Charts.Dashboard1 as Dashboard1
import Charts.Dashboard2 as Dashboard2
import Charts.Dashboard3 as Dashboard3
import Charts.Dashboard4 as Dashboard4
import Charts.Dashboard5 as Dashboard5
import Charts.Dashboard6 as Dashboard6
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
  , dashboard1 : Dashboard1.Model
  , dashboard2 : Dashboard2.Model
  , dashboard3 : Dashboard3.Model
  , dashboard4 : Dashboard4.Model
  , dashboard5 : Dashboard5.Model
  , dashboard6 : Dashboard6.Model
  }


init : Model
init =
  { salaryDist = SalaryDist.init
  , dashboard1 = Dashboard1.init
  , dashboard2 = Dashboard2.init
  , dashboard3 = Dashboard3.init
  , dashboard4 = Dashboard4.init
  , dashboard5 = Dashboard5.init
  , dashboard6 = Dashboard6.init
  }



-- UPDATE


type Msg
  = SalaryDistMsg SalaryDist.Msg
  | Dashboard1Msg Dashboard1.Msg
  | Dashboard2Msg Dashboard2.Msg
  | Dashboard3Msg Dashboard3.Msg
  | Dashboard4Msg Dashboard4.Msg
  | Dashboard5Msg Dashboard5.Msg
  | Dashboard6Msg Dashboard6.Msg


update : Msg -> Model -> Model
update msg model =
  case msg of
    SalaryDistMsg subMsg ->
      { model | salaryDist = SalaryDist.update subMsg model.salaryDist }

    Dashboard1Msg subMsg ->
      { model | dashboard1 = Dashboard1.update subMsg model.dashboard1 }

    Dashboard2Msg subMsg ->
      { model | dashboard2 = Dashboard2.update subMsg model.dashboard2 }

    Dashboard3Msg subMsg ->
      { model | dashboard3 = Dashboard3.update subMsg model.dashboard3 }

    Dashboard4Msg subMsg ->
      { model | dashboard4 = Dashboard4.update subMsg model.dashboard4 }

    Dashboard5Msg subMsg ->
      { model | dashboard5 = Dashboard5.update subMsg model.dashboard5 }

    Dashboard6Msg subMsg ->
      { model | dashboard6 = Dashboard6.update subMsg model.dashboard6 }



-- VIEW


view : Model -> View Msg
view model =
    { title = "elm-charts"
    , body =
        Layout.view
          [ Menu.small
          , E.column
              [ E.width E.fill
              , E.spacing 20
              ]
              [ E.row
                  [ E.width E.fill
                  , E.spacing 15
                  ]
                  [ section 5 (H.map Dashboard1Msg (Dashboard1.view model.dashboard1))
                  , E.column
                      [ E.alignTop
                      , E.width E.fill
                      , E.spacing 15
                      ]
                      [ E.row
                          [ E.alignTop
                          , E.width E.fill
                          , E.spacing 15
                          ]
                          [ section 5 (H.map Dashboard2Msg (Dashboard2.view model.dashboard2))
                          , section 5 (H.map Dashboard3Msg (Dashboard3.view model.dashboard3))
                          ]
                      , section 5 (H.map Dashboard4Msg (Dashboard4.view model.dashboard4))
                      ]
                  ]
              , E.row
                  [ E.width E.fill
                  , E.spacing 40
                  ]
                  [ E.row
                      [ E.width E.fill
                      , E.spacing 15
                      ]
                      [ section 5 (H.map Dashboard5Msg (Dashboard5.view model.dashboard5))
                      ]
                  , E.column
                      [ E.width (E.fillPortion 2)
                      ]
                      [ E.el [ F.size 125 ] (E.text "elm-charts")
                      , E.paragraph
                          [ F.size 24
                          , F.color (E.rgb255 120 120 120)
                          , E.paddingXY 10 5
                          ]
                          [ E.text "An empowering charting library made in all Elm." ]
                      ]
                  ]
              , E.row
                  [ E.width E.fill
                  , E.spacing 20
                  ]
                  [ E.el [ E.width E.fill ] E.none
                  , E.el [ E.width E.fill ] E.none
                  , section 5 (H.map Dashboard6Msg (Dashboard6.view model.dashboard6))
                  ]
              ]
          ]
    }



section : Int -> H.Html msg -> E.Element msg
section padding chart =
  E.column
    [ E.alignTop
    , E.width E.fill
    , E.padding padding
    ]
    [ E.html chart
    ]