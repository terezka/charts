module Page.Administration exposing (Model, Params, Msg, init, subscriptions, exit, update, view)


import Browser exposing (Document)
import Route exposing (Route)
import Session exposing (Session)
import Browser.Navigation as Navigation
import Html as H
import Html.Attributes as HA

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
              , E.el [ F.bold ] (E.text "like to support  the maintanence and furter development")
              , E.text " through a commission of work or donation, you are welcome to contact me "
              , E.text "at "
              , Layout.link "mailto:terezasokol@gmail.com" "terezasokol@gmail.com"
              , E.text "."
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
              [ F.size 22
              , E.paddingEach { top = 45, bottom = 5, left = 0, right = 0 }
              ]
              (E.text "Roadmap")

          , E.paragraph
              [ E.paddingXY 0 10
              , F.size 14
              , E.width (E.px 700)
              ]
              [ E.text "Here are some upcoming features and improvements in approximate order. "
              , E.text "If you have more suggestions or have wishes regarding the priority, then "
              , E.text "you're welcome to "
              , Layout.link "https://github.com/terezka/charts/issues" "open an issue"
              , E.text "."
              ]

          , E.el [ F.size 14 ] <| E.html <|
              let item text =
                    H.li [ HA.style "padding" "5px 0" ] [ H.text text ]
              in
              H.ul
                [ HA.style "padding-left" "25px" ]
                [ item "Logarithmic scales"
                , item "Multiple scales"
                , item "Horizontal bar charts"
                , item "Relative stacked bars"
                , item "Further improvements of automatic \"nice\" ticks"
                , item "Heat maps charts"
                , item "Pie charts"
                , item "Confidence intervals"
                , item "More interpolation options"
                ]
          ]
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

