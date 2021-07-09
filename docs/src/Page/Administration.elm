module Page.Administration exposing (Model, Params, Msg, init, subscriptions, exit, update, view)


import Browser exposing (Document)
import Route exposing (Route)
import Session exposing (Session)
import Browser.Navigation as Navigation
import Html as H

import Element as E
import Element.Font as F
import Element.Input as I
import Element.Border as B
import Element.Background as BG

import Ui.Layout as Layout
import Ui.Menu as Menu



-- MODEL


type alias Model =
  ()


type alias Params =
  ()



-- INIT


init : Navigation.Key -> Session -> Params -> ( Model, Cmd Msg )
init key session params =
  ( ()
  , Cmd.none
  )


exit : Model -> Session -> Session
exit model session =
  session



-- UPDATE


type Msg
  = NoOp


update : Navigation.Key -> Msg -> Model -> ( Model, Cmd Msg )
update key msg model =
  case msg of
    NoOp ->
      ( model, Cmd.none )



-- VIEW


view : Model -> Document Msg
view model =
    { title = "elm-charts"
    , body =
        Layout.view
          [ Menu.small
          , E.el
              [ F.size 32
              , E.paddingXY 0 10
              ]
              (E.text "Administration")

          , E.paragraph
              [ E.paddingXY 0 10
              , F.size 14
              , E.width (E.px 700)
              ]
              [ E.text "This library is developed and managed by Tereza Sokol by the "
              , E.text "support of freelance contracts with various companies. If you'd "
              , E.text "to support the maintanence and furter development, you can "
              , E.text "contact me at terezasokol@gmail.com."
              ]

          , E.row
              [ F.size 14
              , E.paddingXY 0 10
              , E.spacing 20
              ]
              [ Layout.link "https://github.com/terezka" "GitHub"
              , Layout.link "https://twitter.com/tereza_sokol" "Twitter"
              , Layout.link "https://github.com/terezka/charts/issues" "Report an issue"
              ]

          , E.el
              [ F.size 24
              , E.paddingXY 0 10
              ]
              (E.text "Roadmap")

          , E.el [ F.size 14 ] <| E.html <|
              H.ul []
                [ H.li [] [ H.text "Logarithmic scales" ]
                , H.li [] [ H.text "Multiple scales" ]
                , H.li [] [ H.text "Horizontal bar charts" ]
                , H.li [] [ H.text "Further improvements of automatic \"nice\" ticks"]
                , H.li [] [ H.text "Heat maps charts" ]
                , H.li [] [ H.text "Pie charts" ]
                , H.li [] [ H.text "Confidence intervals" ]
                , H.li [] [ H.text "More interpolation options" ]
                ]
          ]
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

