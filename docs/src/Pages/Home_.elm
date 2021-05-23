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
import Ui.Code as Code


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
        viewLayout
          { chart = H.map SaleryDistMsg (SaleryDist.view model.saleryDist)
          , navigation =
              [ { title = "Documentation"
                , links =
                    [ Link "/documentation#quick-start" "Quick start"
                    , Link "/documentation#scatter-charts" "Scatter charts"
                    , Link "/documentation#line-charts" "Line charts"
                    , Link "/documentation#bar-charts" "Bar charts"
                    , Link "/documentation#interactivity" "Interactivity"
                    , Link "/documentation#custom-axes" "Custom axes"
                    , Link "/documentation#custom-labels" "Custom labels"
                    ]
                }
              , { title = "Real data examples"
                , links =
                    [ Link "/real#salery-distribution" "Salary distribution in Denmark"
                    , Link "/real#perceptions-of-probability" "Perceptions of Probability"
                    , Link "/real#community-examples" "Community examples"
                    ]
                }
              , { title = "Administration"
                , links =
                    [ Link "/roadmap" "Roadmap"
                    , Link "/donating" "Donating"
                    , Link "/consulting" "Consulting"
                    , Link "https://github.com/terezka/charts" "Github"
                    , Link "https://twitter.com/tereza_sokol" "Twitter"
                    ]
                }
              ]
          , examples =
              [ Charts.Basics.scatter
              , Charts.Basics.lines
              , Charts.Basics.areas
              , Charts.Basics.bars
              ]
          }
    }


viewLayout : { chart : H.Html Msg, navigation : List Group, examples : List (Example Msg) } -> List (H.Html Msg)
viewLayout config =
  let viewTitle =
        E.column
          [ E.alignTop
          , E.spacing 5
          , E.width (E.px 300)
          ]
          [ E.row
              [ F.size 20
              ]
              [ E.text "terezka/elm-charts"
              , E.el [ F.color (E.rgb255 130 130 130) ] (E.text "-alpha")
              ]
          , E.paragraph
              [ E.paddingEach { top = 10, bottom = 25, left = 0, right = 0 }
              , F.color (E.rgb255 130 130 130)
              , F.size 12
              ]
              [ E.text "Alpha version. Feel free to use, but please do not share publicly yet. Documentation is unfinished/wrong and API liable to breaking changes." ]
          ]
  in
  Layout.view
    [ E.el [ E.paddingEach { top = 0, bottom = 70, left = 0, right = 0 } ] (E.html config.chart)

    , E.row
        [ E.width E.fill
        , E.spacing 80
        , E.paddingEach { top = 0, bottom = 50, left = 0, right = 0 }
        ]
        [ viewTitle
        , E.row
            [ E.spaceEvenly
            , E.width E.fill
            , E.alignRight
            ]
            (List.map viewGroup config.navigation)
        ]

    , E.column
        [ E.width E.fill
        , E.height E.fill
        , E.spacing 40
        ]
        (List.map viewExample config.examples)

    , E.el
        [ F.size 12
        , F.color (E.rgb255 180 180 180)
        , E.paddingEach { top = 50, bottom = 0, left = 0, right = 0 }
        , E.alignRight
        ]
        (E.text "Designed and developed by Tereza Sokol © 2021")
    ]


viewExample : Example msg -> E.Element msg
viewExample example =
  E.row
    [ E.width E.fill
    , E.spacing 25
    ]
    [ E.el
        [ B.widthEach { top = 0, bottom = 0, left = 1, right = 0 }
        , E.width (E.maximum 1 E.fill)
        , B.color (E.rgb255 200 200 200)
        , E.height E.fill
        , E.moveRight 6
        , E.alignTop
        ]
        E.none

    , E.row
        [ E.rotate (degrees 90)
        , E.width (E.maximum 15 E.fill)
        , E.alignTop
        , E.moveDown 20
        , E.moveLeft 27
        ]
        [ E.el
            [ F.size 14
            , E.paddingXY 10 0
            , F.color (E.rgb255 130 130 130)
            , BG.color (E.rgb255 256 256 256)
            , E.alignLeft
            ]
            (E.text example.title)
        ]

    , E.row
        [ E.width E.fill
        , E.spacing 50
        ]
        [ E.el
            [ E.width (E.fillPortion 2)
            , E.alignTop
            , F.size 10
            ] <| E.html <| example.chart ()
        , E.el
            [ E.width (E.fillPortion 6)
            , E.alignTop
            , F.size 12
            , BG.color (E.rgb255 250 250 250)
            ]
            (Code.view { template = example.code, edits = [] })
        ]
    ]


type alias Group =
  { title : String
  , links : List Link
  }


type alias Link =
  { url : String
  , title : String
  }


viewGroup : Group -> E.Element Msg
viewGroup group =
   E.column
    [ E.alignTop
    , E.spacing 5
    ]
    [ E.el
        [ F.size 16
        , E.paddingEach { top = 0, bottom = 10, left = 0, right = 0 }
        ]
        (E.text group.title)
    , group.links
        |> List.map viewLink
        |> E.column [ E.spacing 5 ]
    ]



viewLink : Link -> E.Element Msg
viewLink link =
  E.link [ F.size 13 ]
    { url = link.url
    , label = E.text link.title
    }

