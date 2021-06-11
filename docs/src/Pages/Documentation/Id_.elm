module Pages.Documentation.Id_ exposing (Model, Msg, page)

import Gen.Params.Documentation.Id_ exposing (Params)
import Page
import Request
import Shared
import View exposing (View)
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


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
  Page.sandbox
    { init = init req
    , update = update
    , view = view
    }



-- INIT


type alias Model =
  { examples : Examples.Model
  , selectedTab : String
  }


init : Request.With Params -> Model
init req =
  { examples = Examples.init
  , selectedTab = req.params.id
  }



-- UPDATE


type Msg
  = OnExampleMsg Examples.Msg



update : Msg -> Model -> Model
update msg model =
    case msg of
      OnExampleMsg sub ->
        { model | examples = Examples.update sub model.examples }


-- VIEW


view : Model -> View Msg
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
            [ E.text "This is an attempt at documentation through example. For documentation of exact API, see official Elm documentation."
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
