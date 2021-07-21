module Page.Articles exposing (Model, Params, Msg, init, subscriptions, exit, update, view)


import Browser exposing (Document)
import Route exposing (Route)
import Session exposing (Session)
import Browser.Navigation as Navigation
import Html
import Html as H
import Element as E
import Element.Font as F
import Element.Border as B
import Element.Background as BG
import Ui.Layout as Layout
import Ui.Code as Code
import Ui.Menu as Menu
import Articles




-- MODEL


type alias Model =
  { window : Session.Window
  , menu : Menu.Model
  }


type alias Params =
  ()



-- INIT


init : Navigation.Key -> Session -> Params -> ( Model, Cmd Msg )
init key session params =
  ( { window = session.window
    , menu = Menu.init
    }
  , Cmd.none
  )


exit : Model -> Session -> Session
exit model session =
  session



-- UPDATE


type Msg
  = MenuMsg Menu.Msg
  | None



update : Navigation.Key -> Msg -> Model -> ( Model, Cmd Msg )
update key msg model =
  case msg of
    MenuMsg subMsg ->
      ( { model | menu = Menu.update subMsg model.menu }, Cmd.none )

    None ->
      ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Document Msg
view model =
  { title = "elm-charts"
    , body =
        Layout.view model.window
          [ Menu.small model.window model.menu
              |> E.map MenuMsg

          , Layout.heading model.window "Gallery"

          , E.paragraph
              [ E.paddingEach { top = 10, bottom = 40, left = 0, right = 0 }
              , F.size 14
              , E.width (E.px 600)
              ]
              [ E.text "Examples of charts build with elm-charts using real data."
              ]

          , E.wrappedRow [] <|
              let link id =
                    let url = (Articles.meta id).id in
                    E.link
                      [ E.width (E.px 300)
                      , E.height E.fill
                      ]
                      { url = Route.articles ++ "/" ++ url
                      , label =
                          (Articles.view Articles.init id).landing ()
                            |> E.el [ E.width E.fill, E.height E.fill ]
                            |> E.map (\_ -> None)
                      }
              in
              List.map link Articles.all
          ]
    }

