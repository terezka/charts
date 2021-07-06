module Main exposing (..)

import Browser
import Browser.Navigation as Navigation
import Url exposing (Url)
import Url.Parser as P
import Page.Home
import Page.QuickStart
import Page.Documentation
import Page.Example
import Route


type alias Model =
  { key : Navigation.Key
  , page : Page
  }


type Page
  = Home Page.Home.Model
  | QuickStart Page.QuickStart.Model
  | Documentation Page.Documentation.Model
  | Section Page.Section.Model
  | Example Page.Example.Model
  | NotFound


main : Program () Model Msg
main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlRequest = onUrlRequest
    , onUrlChange = onUrlChange
    }


init : () -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init _ url key =
  { key = key, page = initPage url }


initPage : Url -> Page
initPage url =
  case toRoute url of
    Just Route.Home                       -> Home Page.Home.init
    Just Route.QuickStart                 -> QuickStart Page.QuickStart.init
    Just Route.Documentation              -> Documentation Page.Documentation.init
    Just (Route.Section section)          -> Section (Page.Section.init section)
    Just (Route.Example section example)  -> Example (Page.Example.init section example)
    Nothing                               -> NotFound


type Msg
  = HomeMsg Page.Home.HomeMsg
  | QuickStartMsg Page.QuickStart.Msg
  | DocumentationMsg Page.Documentation.Msg
  | SectionMsg Page.Section.Msg
  | ExampleMsg Page.Example.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    HomeMsg subMsg ->
      case model.page of
        let ( newSubModel, newCmd ) =
              Page.Home.update subMsg subModel
        in
        Home subModel ->
          ( { model | page = Home newSubModel }
          , Cmd.map HomeMsg newCmd
          )

        _ ->
          model

    QuickStartMsg subMsg ->
      case model.page of
        let ( newSubModel, newCmd ) =
              Page.QuickStart.update subMsg subModel
        in
        QuickStart subModel ->
          ( { model | page = QuickStart newSubModel }
          , Cmd.map QuickStartMsg newCmd
          )

        _ ->
          model

    DocumentationMsg subMsg ->
      case model.page of
        let ( newSubModel, newCmd ) =
              Page.Documentation.update subMsg subModel
        in
        Documentation subModel ->
          ( { model | page = Documentation newSubModel }
          , Cmd.map DocumentationMsg newCmd
          )

        _ ->
          model

    SectionMsg subMsg ->
      case model.page of
        let ( newSubModel, newCmd ) =
              Page.Section.update subMsg subModel
        in
        Section subModel ->
          ( { model | page = Section newSubModel }
          , Cmd.map SectionMsg newCmd
          )

        _ ->
          model

    ExampleMsg subMsg ->
      case model.page of
        let ( newSubModel, newCmd ) =
              Page.Example.update subMsg subModel
        in
        Example subModel ->
          ( { model | page = Example newSubModel }
          , Cmd.map ExampleMsg newCmd
          )

        _ ->
          model






