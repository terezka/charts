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
  , displayed : Examples.Id
  }


init : Model
init =
  { examples = Examples.init
  , displayed = Examples.first
  }



-- UPDATE


type Msg
  = OnExampleMsg Examples.Msg
  | OnDisplayExample Examples.Id



update : Msg -> Model -> Model
update msg model =
    case msg of
      OnExampleMsg sub ->
        { model | examples = Examples.update sub model.examples }

      OnDisplayExample id ->
        { model | displayed = id }



-- VIEW


view : Model -> View Msg
view model =
  { title = "elm-charts | Documentation"
  , body =
      Layout.view
        [ Menu.small
        , E.row
            [ E.width E.fill
            , E.paddingEach { top = 60, bottom = 70, left = 0, right = 0 }
            ]
            [ sidebar model
            , content model
            ]
        ]
  }


sidebar : Model -> E.Element Msg
sidebar model =
  let viewTitle ( category, subs ) =
        if List.member model.displayed (List.map Tuple.second subs)
        then viewOpen ( category, subs )
        else viewClosed ( category, subs )

      viewClosed ( category, subs ) =
        I.button
          [ F.size 16
          , F.color (E.rgb255 80 80 80)
          ]
          { onPress =
              subs
                |> List.map Tuple.second
                |> List.head
                |> Maybe.withDefault Examples.first
                |> OnDisplayExample
                |> Just
          , label = E.text category
          }

      viewOpen ( category, subs ) =
        E.column
          []
          [ E.el
              [ F.size 16
              , F.color (E.rgb255 0 0 0)
              , E.paddingEach { top = 0, bottom = 10, left = 0, right = 0 }
              ]
              (E.text category)
          , E.column
              [ E.width (E.fillPortion 1)
              , E.paddingEach { top = 0, bottom = 0, left = 5, right = 0 }
              ]
              (List.map viewSub subs)
          ]

      viewSub ( name, id ) =
        let isSelected =
              id == model.displayed
        in
        I.button
          [ F.size 14
          , E.paddingEach { top = 5, bottom = 5, left = 10, right = 0 }
          , if isSelected
              then F.color (E.rgb255 0 0 0)
              else F.color (E.rgb255 80 80 80)
          , B.widthEach { top = 0, bottom = 0, left = 1, right = 0 }
          , if isSelected
              then B.color (E.rgb255 180 180 180)
              else B.color (E.rgb255 230 230 230)
          , E.moveLeft 2
          ]
          { onPress = Just (OnDisplayExample id)
          , label = E.text name
          }
  in
  E.column
    [ E.alignTop
    , E.width (E.fillPortion 4)
    , E.spacing 20
    ]
    [ E.el [ F.size 14 ] (E.text "Documentation")
    , E.column
      [ E.spacing 15
      ]
      (List.map viewTitle groups)
    ]


content : Model -> E.Element Msg
content model =
  let ( cat, title ) = getCategoryAndTitle model.displayed in
  E.column
    [ E.width (E.fillPortion 9)
    , E.height E.fill
    ]
    [ E.row
        [ F.size 28
        , E.paddingEach { top = 0, bottom = 25, left = 0, right = 0 }
        ]
        [ E.text cat
        , E.el [ F.color (E.rgb255 130 130 130) ] (E.text <| " · " ++ title)
        ]
    , E.el
      [ E.width E.fill
      , E.height E.fill
      , E.paddingEach { top = 0, bottom = 40, left = 0, right = 0 }
      ]
      (E.map OnExampleMsg <| E.html <| Examples.view model.examples model.displayed)
    , E.column
        [ E.width E.fill
        , E.height E.fill
        , BG.color (E.rgb255 250 250 250)
        ]
        [ Code.view { template = Examples.smallCode model.displayed, edits = [] } ]
      ]


groups : List ( String, List ( String, Examples.Id ) )
groups =
  let func id acc =
        case getCategoryAndTitle id of
          ( category, title ) ->
            let updateCat maybeSome =
                  case maybeSome of
                    Just some -> Just (( title, id ) :: some)
                    Nothing -> Just [ ( title, id ) ]
            in
            Dict.update category updateCat acc
  in
  List.foldl func Dict.empty Examples.all
    |> Dict.toList


getCategoryAndTitle : Examples.Id -> ( String, String )
getCategoryAndTitle id =
  case String.split "." (Examples.name id) of
    _ :: category :: title :: _ -> ( category, title )
    _ -> ( "NOT FOUND", Examples.name id )


