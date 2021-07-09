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
              [ E.text "This library is developed and managed by "
              , Layout.link "https://twitter.com/tereza_sokol" "Tereza Sokol"
              , E.text ". If you'd "
              , E.el [ F.bold ] (E.text "like to support  the maintanence and furter development")
              , E.text " through a commission of work, you are welcome to contact me "
              , E.text "at "
              , Layout.link "mailto:terezasokol@gmail.com" "terezasokol@gmail.com"
              , E.text "."
              ]

          , E.el
              [ F.size 22
              , E.paddingEach { top = 30, bottom = 5, left = 0, right = 0 }
              ]
              (E.text "Contracting")

          , E.paragraph
              [ E.paddingXY 0 10
              , F.size 14
              , E.width (E.px 700)
              ]
              [ E.text "If you or your company would like me to build you a chart with elm-charts, I'm happy to do so! "
              , E.text "Feel free to contact me at "
              , Layout.link "mailto:terezasokol@gmail.com" "terezasokol@gmail.com"
              , E.text " and we can figure out the details."
              ]

          , E.el
              [ F.size 22
              , E.paddingEach { top = 30, bottom = 5, left = 0, right = 0 }
              ]
              (E.text "Roadmap")

          , E.paragraph
              [ E.paddingXY 0 10
              , F.size 14
              , E.width (E.px 700)
              ]
              [ E.text "Here are some upcoming features and improvements in approximate order of priority. "
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
                [ item "Heat maps charts"
                , item "Horizontal bar charts"
                , item "Logarithmic scales"
                , item "Multiple scales"
                , item "Relative stacked bars"
                , item "Further improvements of automatic \"nice\" ticks"
                , item "Pie charts"
                , item "Confidence intervals"
                , item "More interpolation options"
                ]

          , E.row
              [ F.size 14
              , E.paddingXY 0 30
              , E.spacing 20
              ]
              [ E.text "Quick links:"
              , Layout.link "https://github.com/terezka" "GitHub"
              , Layout.link "https://twitter.com/tereza_sokol" "Twitter"
              , Layout.link "https://github.com/terezka/charts/issues" "Report an issue"
              ]
          ]
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

