module Pages.Home_ exposing (Model, Msg, page)

import Gen.Params.Home_ exposing (Params)
import Page
import Request
import Shared
import View exposing (View)
import Charts.Dashboard1 as Dashboard1
import Charts.Dashboard2 as Dashboard2
import Charts.Dashboard3 as Dashboard3
import Charts.Dashboard4 as Dashboard4
import Charts.Dashboard5 as Dashboard5
import Charts.Dashboard6 as Dashboard6
import Charts.Dashboard7 as Dashboard7
import Examples.Frontpage.Familiar as Familiar
import Examples.Frontpage.Concise as Concise
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
  { dashboard1 : Dashboard1.Model
  , dashboard2 : Dashboard2.Model
  , dashboard3 : Dashboard3.Model
  , dashboard4 : Dashboard4.Model
  , dashboard5 : Dashboard5.Model
  , dashboard6 : Dashboard6.Model
  , dashboard7 : Dashboard7.Model
  }


init : Model
init =
  { dashboard1 = Dashboard1.init
  , dashboard2 = Dashboard2.init
  , dashboard3 = Dashboard3.init
  , dashboard4 = Dashboard4.init
  , dashboard5 = Dashboard5.init
  , dashboard6 = Dashboard6.init
  , dashboard7 = Dashboard7.init
  }



-- UPDATE


type Msg
  = Dashboard1Msg Dashboard1.Msg
  | Dashboard2Msg Dashboard2.Msg
  | Dashboard3Msg Dashboard3.Msg
  | Dashboard4Msg Dashboard4.Msg
  | Dashboard5Msg Dashboard5.Msg
  | Dashboard6Msg Dashboard6.Msg
  | Dashboard7Msg Dashboard7.Msg
  | None


update : Msg -> Model -> Model
update msg model =
  case msg of
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

    Dashboard7Msg subMsg ->
      { model | dashboard7 = Dashboard7.update subMsg model.dashboard7 }

    None ->
      model



-- VIEW


view : Model -> View Msg
view model =
    { title = "elm-charts"
    , body =
        Layout.view
          [ Menu.small
          , E.row
              [ E.width E.fill
              , E.spacing 20
              ]
              [ section 1 (H.map Dashboard1Msg (Dashboard1.view model.dashboard1))
              , E.column
                  [ E.alignTop
                  , E.width E.fill
                  , E.spacing 20
                  ]
                  [ E.row
                      [ E.alignTop
                      , E.width E.fill
                      , E.spacing 20
                      ]
                      [ section 1 (H.map Dashboard2Msg (Dashboard2.view model.dashboard2))
                      , section 1 (H.map Dashboard3Msg (Dashboard3.view model.dashboard3))
                      ]
                  , section 1 (H.map Dashboard4Msg (Dashboard4.view model.dashboard4))
                  ]
              ]

          , E.column
              [ E.width E.fill
              , E.paddingEach { top = 40, bottom = 100, left = 0, right = 0 }
              , F.center
              ]
              [ E.el [ E.width E.fill, F.size 125 ] (E.text "elm-charts")
              , E.paragraph
                  [ F.size 24
                  , F.color (E.rgb255 120 120 120)
                  , E.paddingXY 10 5
                  ]
                  [ E.text "Compose "
                  , E.el [ F.italic ] (E.text "your")
                  , E.text " chart with confidence."
                  ]
              ]

          , E.column
              [ E.width E.fill
              , E.spacing 100
              ]
              [ feature
                  { title = "Familiar interface and vocabulary"
                  , body = "The API mirrors the element and attribute pattern which you already know and love."
                  , chart = H.map (\_ -> None) (Familiar.view ())
                  , code = Familiar.smallCode
                  }

              , feature
                  { title = "Concise at any level"
                  , body = "No clutter even with tricky details!"
                  , chart = H.map (\_ -> None) (Concise.view ())
                  , code = Concise.smallCode
                  }

              , feature
                  { title = "Compose any chart"
                  , body = "Mix together chart types, edit the styling, and attach labels to anything."
                  , chart = H.map (\_ -> None) (Familiar.view ())
                  , code = Familiar.smallCode
                  }

              , feature
                  { title = "Minimal context needed"
                  , body = "You never need to know how SVG clip paths work or any SVG for that matter!"
                  , chart = H.map (\_ -> None) (Familiar.view ())
                  , code = Familiar.smallCode
                  }
              ]
          ]
    }


feature config =
  E.column
    [ E.width E.fill
    , E.spacing 10
    ]
    [ E.el
        [ E.width E.fill
        , F.size 24
        ]
        (E.text config.title)
    , E.paragraph
        [ F.size 14
        , F.color (E.rgb255 120 120 120)
        , E.paddingXY 0 10
        ]
        [ E.text config.body ]
    , E.row
        [ E.width E.fill
        , E.spacing 40
        , E.paddingXY 0 15
        ]
        [ E.el [ E.alignTop ] (E.html config.chart)
        , E.el
            [ E.width E.fill
            , E.height E.fill
            , BG.color (E.rgb255 250 250 250)
            ]
            (Code.view { template = config.code, edits = [] })
        ]
    ]


section : Int -> H.Html msg -> E.Element msg
section portion chart =
  E.column
    [ E.alignTop
    , E.width (E.fillPortion portion)
    ]
    [ E.html chart
    ]