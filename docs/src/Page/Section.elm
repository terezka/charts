module Page.Section exposing (Model, Params, Msg, init, subscriptions, exit, update, view)


import Browser exposing (Document)
import Route exposing (Route)
import Session exposing (Session)
import Browser.Navigation as Navigation
import Html
import Ui.Layout as Layout
import Ui.Menu as Menu
import Ui.Code as Code
import SyntaxHighlight as SH
import Dict
import Element as E
import Element.Font as F
import Element.Input as I
import Element.Border as B
import Element.Background as BG
import Examples
import Ui.Thumbnail
import Ui.Tabs



-- MODEL


type alias Model =
  { examples : Examples.Model
  , selectedTab : String
  }


type alias Params =
  { section : String
  }



-- INIT


init : Navigation.Key -> Session -> Params -> ( Model, Cmd Msg )
init key session params =
  ( { examples = Examples.init
    , selectedTab = params.section
    }
  , Cmd.none
  )


exit : Model -> Session -> Session
exit model session =
  session



-- UPDATE


type Msg
  = OnExampleMsg Examples.Msg


update : Navigation.Key -> Msg -> Model -> ( Model, Cmd Msg )
update key msg model =
  case msg of
    OnExampleMsg sub ->
      ( { model | examples = Examples.update sub model.examples }
      , Cmd.none
      )




-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Document Msg
view model =
  { title = "elm-charts | Documentation"
  , body =
      Layout.view <|
        [ Menu.small
        , E.el
            [ F.size 32
            , E.paddingXY 0 10
            ]
            (E.text "Documentation")
        , E.paragraph
            [ E.paddingXY 0 10
            , F.size 14
            , E.width (E.px 700)
            ]
            [ E.text "This is an attempt at documentation through example. For documentation of exact API, see "
            , E.link
                [ F.underline ]
                { url = "https://package.elm-lang.org/packages/terezka/charts/latest"
                , label = E.text "official Elm documentation"
                }
            , E.text "."
            ]
        , Ui.Tabs.view
            { toUrl = Ui.Thumbnail.toUrlGroup << .title
            , toTitle = .title
            , selected = "/documentation/" ++ model.selectedTab
            , all = Ui.Thumbnail.groups
            }
        , E.map OnExampleMsg
            (Ui.Thumbnail.viewSelected model.examples <| "/documentation/" ++ model.selectedTab)
        ]
  }