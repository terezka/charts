module Pages.Documentation exposing (Model, Msg, page)

import Gen.Params.Documentation exposing (Params)
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


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
  Page.sandbox
    { init = init
    , update = update
    , view = view
    }



-- INIT


type alias Model =
  { examples : Examples.Model
  , selectedTab : Int
  , displayed : Maybe Examples.Id
  }


init : Model
init =
  { examples = Examples.init
  , selectedTab = 0
  , displayed = Nothing
  }



-- UPDATE


type Msg
  = OnExampleMsg Examples.Msg
  | OnSelectTab Int
  | OnDisplayExample Examples.Id
  | OnResetExample



update : Msg -> Model -> Model
update msg model =
    case msg of
      OnExampleMsg sub ->
        { model | examples = Examples.update sub model.examples }

      OnSelectTab index ->
        { model | selectedTab = index }

      OnDisplayExample id ->
        { model | displayed = Just id }

      OnResetExample ->
        { model | displayed = Nothing }



-- VIEW


view : Model -> View Msg
view model =
  { title = "elm-charts | Documentation"
  , body =
      Layout.view <|
        case model.displayed of
            Just id ->
              [ Menu.small
              , content model id
              ]

            Nothing ->
              let groupBy : Examples.Id -> Dict.Dict String (List Examples.Id) -> Dict.Dict String (List Examples.Id)
                  groupBy id =
                    Dict.update (Examples.meta id).category (updateCat id)

                  updateCat id maybeIds =
                    case maybeIds of
                      Just ids -> Just (id :: ids)
                      Nothing -> Just [id]

                  groups =
                    List.foldl groupBy Dict.empty Examples.all

                  tabs =
                    E.el [ E.width E.fill, E.paddingXY 0 30 ] <|
                      E.row
                        [ E.width E.fill
                        , E.spacing 10
                        , E.paddingXY 10 0
                        , B.color (E.rgb255 220 220 220)
                        , B.widthEach { top = 0, bottom = 1, left = 0, right = 0 }
                        ]
                        (List.indexedMap toTab (Dict.toList groups))

                  toTab index ( category, _ ) =
                    I.button
                      [ F.size 14
                      , E.paddingXY 30 10
                      , E.moveDown 1
                      , BG.color (E.rgb255 255 255 255)
                      , B.color (E.rgb255 220 220 220)
                      , if model.selectedTab == index then F.color (E.rgb255 0 0 0) else F.color (E.rgb255 120 120 120)
                      , B.widthEach { top = 1, bottom = if model.selectedTab == index then 0 else 1, left = 1, right = 1 }
                      , B.roundEach { topLeft = 5, topRight = 5, bottomLeft = 0, bottomRight = 0 }
                      ]
                      { onPress = Just (OnSelectTab index)
                      , label = E.text category
                      }

                  thumbnails =
                    List.indexedMap Tuple.pair (Dict.toList groups)
                      |> Dict.fromList
                      |> Dict.get model.selectedTab
                      |> Maybe.withDefault ("", [])
                      |> toThumbnails

                  toThumbnails ( category, ids ) =
                    E.column
                      [ E.paddingEach { top = 30, bottom = 100, left = 0, right = 0 } ]
                      [ ids
                          |> List.map (\id -> ( thumbnail model id, Examples.meta id ))
                          |> List.sortBy (Tuple.second >> \meta -> ( meta.category, meta.order ))
                          |> List.map Tuple.first
                          |> E.wrappedRow
                              [ E.width E.fill
                              , E.height E.fill
                              , E.spacing 100
                              ]
                      ]
              in
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
              , tabs
              , thumbnails
              ]
  }


thumbnail : Model -> Examples.Id -> E.Element Msg
thumbnail model id =
  I.button
    [ E.height (E.px 265)
    , E.width (E.px 265)
    ]
    { onPress = Just (OnDisplayExample id)
    , label =
        let meta = Examples.meta id in
        E.column
          [ E.width E.fill
          , E.height E.fill
          , E.spacing 5
          ]
          [ E.el [ F.size 16 ] (E.text meta.name)
          , E.el [ F.size 12 ] (E.text meta.description)
          , E.el
              [ E.width E.fill
              , E.height E.fill
              , E.paddingXY 0 5
              ] <|
              E.map OnExampleMsg <| E.html <| Examples.view model.examples id
          ]
    }


content : Model -> Examples.Id -> E.Element Msg
content model id =
  let ( cat, title ) = getCategoryAndTitle id in
  E.column
    [ E.width E.fill
    , E.height E.fill
    , E.paddingEach { top = 50, bottom = 0, left = 0, right = 0 }
    ]
    [ I.button [ F.size 16 ]
        { onPress = Just OnResetExample
        , label = E.text "← Back to overview"
        }
    , E.row
        [ E.width E.fill
        , E.height E.fill
        , E.spacing 50
        , E.alignTop
        ]
        [ E.el
            [ E.height (E.px 300)
            , E.width (E.px 300)
            , E.alignTop
            , E.paddingEach { top = 0, bottom = 40, left = 0, right = 0 }
            ]
            (E.map OnExampleMsg <| E.html <| Examples.view model.examples id)
        , E.column
            [ E.width (E.fillPortion 8)
            , E.height E.fill
            ]
            [ E.row
                [ F.size 28
                , E.paddingEach { top = 25, bottom = 25, left = 0, right = 0 }
                ]
                [ E.text cat
                , E.el [ F.color (E.rgb255 130 130 130) ] (E.text <| " · " ++ title)
                ]
            , E.column
                [ E.width E.fill
                , E.height E.fill
                , BG.color (E.rgb255 250 250 250)
                ]
                [ Code.view { template = Examples.smallCode id, edits = [] } ]
            ]
          ]
    ]



getCategoryAndTitle : Examples.Id -> ( String, String )
getCategoryAndTitle id =
  case String.split "." (Examples.name id) of
    _ :: category :: title :: _ -> ( category, title )
    _ -> ( "NOT FOUND", Examples.name id )


