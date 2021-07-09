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
import Examples
import Html as H
import Element as E
import Element.Events as EE
import Element.Font as F
import Element.Input as I
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


-- MODEL


type alias Model =
  { landing : Landing.Model
  , concise : Concise.Model
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
  | OnHover (List (CE.Product CE.Any (Maybe Float) { year : Float, income : Float}))
  | None



update : Navigation.Key -> Msg -> Model -> ( Model, Cmd Msg )
update key msg model =
  case msg of
    ConciseMsg subMsg ->
      ( { model | concise = Concise.update subMsg model.concise }, Cmd.none )

    FamiliarToggle ->
      ( { model | familiarToggle = not model.familiarToggle }, Cmd.none )

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
              , E.spacing 140
              , E.paddingXY 0 120
              ]
              [ feature
                  { title = "Intuitive"
                  , body =
                      [ E.text "Simple charts should be simple to make. The interface "
                      , E.text "mirrors the element and attribute pattern which you already"
                      , E.text "know and love. Get started composing your chart in minutes!"
                      ]
                  , togglable = Just ( FamiliarToggle, model.familiarToggle )
                  , chart = E.html <| H.map (\_ -> None) (Familiar.view ())
                  , code = Familiar.smallCode
                  , flipped = False
                  , height = 350
                  }

              , feature
                  { title = "Flexible, yet concise"
                  , body =
                      [ E.text "No clutter, even with tricky requirements. Great support for"
                      , E.text "interactivity, advanced labeling, guidence lines, and "
                      , E.text "irregular details."
                      ]
                  , togglable = Nothing
                  , chart = E.html <| H.map ConciseMsg (Concise.view model.concise)
                  , code = Concise.smallCode
                  , flipped = True
                  , height = 350
                  }

              , feature
                  { title = "Visual catalog"
                  , body =
                      [ E.text "Charts are visual and so should the documentation! "
                      , E.text "There is nearly 100 examples on this site to help you "
                      , E.text "compose your exact chart. "
                      , E.link [ F.underline ] { url = "/documentation", label = E.text "Explore catalog" }
                      , E.text "."
                      ]
                  , togglable = Nothing
                  , flipped = False
                  , height = 350
                  , chart =
                      [ Examples.BarCharts__Histogram
                      , Examples.BarCharts__TooltipStack
                      , Examples.Interactivity__Zoom
                      , Examples.Frame__Titles
                      , Examples.LineCharts__Stepped
                      , Examples.ScatterCharts__Labels
                      , Examples.ScatterCharts__DataDependent
                      , Examples.LineCharts__TooltipStack
                      , Examples.LineCharts__Labels
                      , Examples.BarCharts__BarLabels
                      , Examples.BarCharts__Margin
                      , Examples.ScatterCharts__Shapes
                      ]
                        |> List.map (Examples.view Examples.init)
                        |> List.map (E.html >> E.el [ E.width (E.minimum 90 E.fill) ])
                        |> E.wrappedRow
                            [ E.width (E.px 550)
                            , E.spacing 30
                            , E.alignTop
                            ]
                        |> E.map (\_ -> None)
                  , code = ""
                  }
              ]
          ]
    }


feature :
  { title : String
  , body : List (E.Element msg)
  , height : Int
  , togglable : Maybe ( msg, Bool )
  , chart : E.Element msg
  , code : String
  , flipped : Bool
  }
  -> E.Element msg
feature config =
  E.row
    [ E.width E.fill
    , E.height (E.minimum config.height E.fill)
    , E.spacing 50
    ] <| (if config.flipped then List.reverse else identity)
    [ E.column
        [ E.width E.fill
        , E.alignTop
        , E.alignLeft
        , E.spacing 10
        , E.width (E.fillPortion 5)
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
            config.body
        ]
    , case config.togglable of
        Nothing ->
          E.el [ E.centerX, E.alignTop ] config.chart

        Just ( onToggle, isToggled ) ->
          E.el
            [ E.width (E.fillPortion 7)
            , E.alignTop
            ] <|
            if isToggled then
              E.column
                []
                [ E.el
                    [ E.width E.fill
                    , E.height E.fill
                    , BG.color (E.rgb255 250 250 250)
                    ]
                    (Code.view { template = config.code, edits = [] })
                , I.button
                    [ E.paddingXY 15 15
                    , F.size 14
                    , E.htmlAttribute (HA.style "position" "absolute")
                    , E.htmlAttribute (HA.style "right" "0")
                    ]
                    { onPress = Just onToggle
                    , label = E.text "Show chart"
                    }
                ]
            else
              E.column [ E.centerX ]
                [ E.el [ E.alignTop ] config.chart
                , I.button
                    [ E.paddingXY 15 15
                    , F.size 14
                    , E.htmlAttribute (HA.style "position" "absolute")
                    , E.htmlAttribute (HA.style "right" "0")
                    ]
                    { onPress = Just onToggle
                    , label = E.text "Show code"
                    }
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