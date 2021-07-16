module Ui.Menu exposing (Link, small, links, Model, Msg, update, init)


import Html as H
import Element as E
import Element.Input as I
import Element.Font as F
import Element.Border as B
import Element.Background as BG
import Session
import FeatherIcons


type alias Model =
  { isOpen : Bool }


init : Model
init =
  { isOpen = False }


type Msg
  = OnToggle


update : Msg -> Model -> Model
update msg model =
  case msg of
    OnToggle ->
      { model | isOpen = not model.isOpen }



-- VIEW


small : Session.Window -> Model -> E.Element Msg
small window model =
  E.column
    [ E.width E.fill
    , E.paddingEach { top = 0, bottom = 40, left = 0, right = 0 }
    ]
    [ E.row
        [ E.width E.fill
        ]
        [ E.column
            [ E.alignTop
            , E.spacing 5
            , E.alignLeft
            , E.width (E.maximum 300 E.fill)
            ]
            [ E.link []
                { url = "/"
                , label =
                    E.row [ F.size 20 ] [ E.text "elm-charts" ]
                }
            ]
        , E.row
            [ E.spacing 40
            , E.alignRight
            , F.size 13
            ] <|
            if window.width > 950
              then links
              else
                [ I.button []
                    { onPress = Just OnToggle
                    , label = E.html (FeatherIcons.toHtml [] (if model.isOpen then FeatherIcons.x else FeatherIcons.menu))
                    }
                ]
        ]
    , if model.isOpen then
        E.column
          [ E.centerX
          , E.spacing 10
          , E.paddingEach { top = 30, bottom = 0, left = 0, right = 0 }
          ] links
      else
        E.none
    ]


type alias Link =
  { url : String
  , title : String
  }


links : List (E.Element msg)
links =
  List.map viewLink
    [ Link "/quick-start" "Getting started"
    , Link "/documentation" "Documentation"
    --, Link "/gallery" "Gallery"
    , Link "/administration" "Administration"
    ]


viewLink : Link -> E.Element msg
viewLink link =
  E.link []
    { url = link.url
    , label = E.text link.title
    }

