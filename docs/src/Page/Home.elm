module Page.Home exposing (Model, Params, Msg, init, subscriptions, exit, update, view)


import Browser exposing (Document)
import Route exposing (Route)
import Session exposing (Session)
import Browser.Navigation as Navigation
import Charts.Landing as Landing
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
import Element.Events as EE
import Element.Font as F
import Element.Border as B
import Element.Background as BG
import Ui.Layout as Layout
import Ui.CompactExample as CompactExample
import Ui.Code as Code
import Ui.Menu as Menu

import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Svg as S
import Svg.Attributes as SA

import Chart as C
import Chart.Attributes as CA
import Chart.Events as CE
import Chart.Svg as CS


-- TODO
-- fix static / responsive
-- fix bar highlight


-- MODEL


type alias Model =
  { landing : Landing.Model
  , concise : Concise.Model
  , conciseToggle : Bool
  , familiarToggle : Bool
  , hovering : List (CE.Product CE.Any (Maybe Float) { year : Float, income : Float})
  }


type alias Params =
  ()



-- INIT


init : Navigation.Key -> Session -> Params -> ( Model, Cmd Msg )
init key session params =
  ( { landing = Landing.init
    , concise = Concise.init
    , conciseToggle = False
    , familiarToggle = True
    , hovering = []
    }
  , Cmd.none
  )


exit : Model -> Session -> Session
exit model session =
  session



-- UPDATE


type Msg
  = LandingMsg Landing.Msg
  | ConciseMsg Concise.Msg
  | FamiliarToggle
  | ConsiceToggle
  | OnHover (List (CE.Product CE.Any (Maybe Float) { year : Float, income : Float}))
  | None



update : Navigation.Key -> Msg -> Model -> ( Model, Cmd Msg )
update key msg model =
  case msg of
    ConciseMsg subMsg ->
      ( { model | concise = Concise.update subMsg model.concise }, Cmd.none )

    FamiliarToggle ->
      ( { model | familiarToggle = not model.familiarToggle }, Cmd.none )

    ConsiceToggle ->
      ( { model | conciseToggle = not model.conciseToggle }, Cmd.none )

    LandingMsg subMsg ->
      ( { model | landing = Landing.update subMsg model.landing }, Cmd.none )

    OnHover hovering ->
      ( { model | hovering = hovering }, Cmd.none )

    None ->
      ( model, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Document Msg
view model =
    { title = "elm-charts"
    , body =
        Layout.view
          [ Menu.small

          , E.el [] (E.html <| H.map LandingMsg (Landing.view model.landing))

          , E.column
              [ E.width E.fill
              , E.spacing 120
              , E.paddingXY 0 120
              ]
              [ feature
                  { title = "Intuitive"
                  , body =
                      """Simple charts should be simple to make. The interface mirrors the element
and attribute pattern which you already know and love. Get started composing your chart in
minutes!"""
                  , onToggle = FamiliarToggle
                  , toggled = model.familiarToggle
                  , chart = H.map (\_ -> None) (Familiar.view ())
                  , code = Familiar.smallCode
                  , flipped = False
                  }

              , feature
                  { title = "Flexible, yet concise"
                  , body = "No clutter even with tricky details!"
                  , onToggle = ConsiceToggle
                  , toggled = model.conciseToggle
                  , chart = H.map ConciseMsg (Concise.view model.concise)
                  , code = Concise.smallCode
                  , flipped = True
                  }

              --, feature
              --    { title = "Visual documentation"
              --    , body = "You never need to know how SVG clip paths work or any SVG for that matter!"
              --    , chart = H.map (\_ -> None) (Familiar.view ())
              --    , code = Familiar.smallCode
              --    }
              ]
          ]
    }


feature :
  { title : String
  , body : String
  , onToggle : msg
  , toggled : Bool
  , chart : H.Html msg
  , code : String
  , flipped : Bool
  }
  -> E.Element msg
feature config =
  E.row
    [ E.width E.fill
    , E.height (E.minimum 350 E.fill)
    , E.spacing 70
    ] <| (if config.flipped then List.reverse else identity)
    [ E.column
        [ E.width E.fill
        , E.alignTop
        , E.alignLeft
        , E.spacing 10
        , E.width (E.fillPortion 3)
        ]
        [ E.el
            [ E.width E.fill
            , F.size 40
            ]
            (E.text config.title)
        , E.paragraph
            [ F.size 16
            , F.color (E.rgb255 120 120 120)
            , E.paddingXY 0 10
            ]
            [ E.text config.body ]
        ]
    , E.el
        [ E.width (E.fillPortion 5)
        , E.alignTop
        , EE.onClick config.onToggle
        ] <|
        if config.toggled then
          E.el
            [ E.width E.fill
            , E.height E.fill
            , BG.color (E.rgb255 250 250 250)
            ]
            (Code.view { template = config.code, edits = [] })
        else
          E.el [ E.centerX ] (E.html config.chart)

    ]


section : Int -> H.Html msg -> E.Element msg
section portion chart =
  E.column
    [ E.alignTop
    , E.width (E.fillPortion portion)
    ]
    [ E.html chart
    ]