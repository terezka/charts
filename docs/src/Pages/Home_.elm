module Pages.Home_ exposing (Model, Msg, page)

import Gen.Params.Home_ exposing (Params)
import Page
import Request
import Shared
import View exposing (View)
import Charts.SaleryDist as SaleryDist
import Html as H
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
        List.singleton <| viewLayout
          { chart = H.map SaleryDistMsg (SaleryDist.view model.saleryDist)
          , navigation =
              [ { title = "Explore"
                , links =
                    [ "Scatter charts"
                    , "Line charts"
                    , "Bar charts"
                    , "Interactivity"
                    , "Custom axes"
                    , "Custom labels"
                    ]
                }
              , { title = "Real data examples"
                , links =
                    [ "Salary distribution in Denmark"
                    , "Perceptions of Probability"
                    , "Community examples"
                    ]
                }
              , { title = "Administration"
                , links =
                    [ "Roadmap"
                    , "Donating"
                    , "Consulting"
                    , "Github"
                    , "Twitter"
                    ]
                }
              ]
          }
    }


viewLayout : { chart : H.Html Msg, navigation : List Group } -> H.Html Msg
viewLayout config =
  E.layout
    [ E.width E.fill
    , F.family [ F.typeface "IBM Plex Sans", F.sansSerif ]
    ] <|
    E.column
      [ E.width (E.maximum 1000 E.fill)
      , E.paddingEach { top = 30, bottom = 20, left = 0, right = 0 }
      , E.centerX
      , F.size 12
      , F.color (E.rgb255 80 80 80)
      ]
      [ E.html config.chart
      , E.row
          [ F.size 50
          , E.paddingEach { top = 50, bottom = 10, left = 0, right = 0 }
          ]
          [ E.text "elm-charts"
          , E.el [ F.color (E.rgb255 130 130 130) ] (E.text "-alpha")
          ]
      , E.el
          [ E.paddingEach { top = 0, bottom = 25, left = 0, right = 0 }
          , F.color (E.rgb255 130 130 130)
          , F.size 14
          ]
          (E.text "Alpha version. Feel free to use, but please do not share publicly yet. Documentation is unfinished/wrong and API liable to breaking changes.")
      , E.row
          [ E.spaceEvenly
          , E.width (E.maximum 600 E.fill)
          ]
          (List.map viewGroup config.navigation)
      , E.el
          [ F.size 12
          , F.color (E.rgb255 180 180 180)
          , E.paddingEach { top = 20, bottom = 0, left = 0, right = 0 }
          , E.alignRight
          ]
          (E.text "Designed and developed by Tereza Sokol © 2021")
      ]


type alias Group =
  { title : String
  , links : List String
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
        |> List.map (\l -> E.el [ F.size 13 ] (E.text l))
        |> E.column [ E.spacing 5 ]
    ]



