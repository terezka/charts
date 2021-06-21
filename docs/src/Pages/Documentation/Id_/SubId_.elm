module Pages.Documentation.Id_.SubId_ exposing (Model, Msg, page)

import Gen.Params.Documentation.Id_.SubId_ exposing (Params)
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
  , selectedThumb : String
  }


init : Request.With Params -> Model
init req =
  { examples = Examples.init
  , selectedTab = req.params.id
  , selectedThumb = req.params.subId
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
        , viewContent model
        ]
  }



viewContent : Model -> E.Element Msg
viewContent model =
  let currentId =
        Examples.all
          |> List.map (\id ->
                ( ( Ui.Thumbnail.urlify (Examples.meta id).category
                  , Ui.Thumbnail.urlify (Examples.meta id).name
                  )
                , id
                )
            )
          |> Dict.fromList
          |> Dict.get ( model.selectedTab, model.selectedThumb )
          |> Maybe.withDefault Examples.first

      meta =
        Examples.meta currentId
  in
  E.column
    [ E.width E.fill
    , E.height E.fill
    , E.paddingEach { top = 20, bottom = 0, left = 0, right = 0 }
    ]
    [ E.row
        [ F.size 28
        , E.paddingEach { top = 0, bottom = 20, left = 0, right = 0 }
        ]
        [ E.text meta.name ]

    , E.row
        [ F.size 14
        , E.paddingEach { top = 0, bottom = 40, left = 0, right = 0 }
        ]
        [ E.text meta.description ]
    , E.row
        [ E.width E.fill
        , E.height E.fill
        , E.spacing 50
        , E.alignTop
        ]
        [ E.el
            [ E.width (E.px 300)
            , E.alignTop
            , E.paddingEach { top = 0, bottom = 40, left = 0, right = 0 }
            ]
            (E.map OnExampleMsg <| E.html <| Examples.view model.examples currentId)
        , E.column
            [ E.width (E.fillPortion 8)
            , E.height E.fill
            ]
            [ E.column
                [ E.width E.fill
                , E.height E.fill
                , BG.color (E.rgb255 250 250 250)
                ]
                [ Code.view { template = Examples.smallCode currentId, edits = [] } ]
            ]
          ]
    ]



getCategoryAndTitle : Examples.Id -> ( String, String )
getCategoryAndTitle id =
  case String.split "." (Examples.name id) of
    _ :: category :: title :: _ -> ( category, title )
    _ -> ( "NOT FOUND", Examples.name id )



