module Main exposing (main)

import Browser
import Browser.Navigation as Navigation
import Html
import Page.Home
import Page.Administration
import Page.Documentation
import Page.Section
import Page.Example
import Page.Gallery
import Page.QuickStart
import Route exposing (Route)
import Session exposing (Session)
import Url exposing (Url)
import Json.Decode as D


main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = ClickedLink
        , onUrlChange = ChangedUrl
        }


type alias Model =
    { navigation : Navigation.Key
    , session : Session
    , page : Page
    }

type Page
    = Redirect
    | NotFound
    | Page_Home Page.Home.Model
    | Page_Administration Page.Administration.Model
    | Page_Documentation Page.Documentation.Model
    | Page_Section Page.Section.Model
    | Page_Example Page.Example.Model
    | Page_Gallery Page.Gallery.Model
    | Page_QuickStart Page.QuickStart.Model


init : D.Value -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    changeRouteTo (Route.fromUrl url) (Model key (Session.init flags) Redirect)


view : Model -> Browser.Document Msg
view model =
    let
        viewPage toMsg { title, body } =
            { title = title
            , body = List.map (Html.map toMsg) body
            }
    in
    case model.page of
        NotFound ->
            { title = "Not found"
            , body = [ Html.text "Not found!" ]
            }

        Redirect ->
            { title = "Redirecting..."
            , body = [ Html.text "" ]
            }

        Page_Home subModel ->
            viewPage Page_Home_Msg (Page.Home.view subModel)

        Page_Administration subModel ->
            viewPage Page_Administration_Msg (Page.Administration.view subModel)

        Page_Documentation subModel ->
            viewPage Page_Documentation_Msg (Page.Documentation.view subModel)

        Page_Section subModel ->
            viewPage Page_Section_Msg (Page.Section.view subModel)

        Page_Example subModel ->
            viewPage Page_Example_Msg (Page.Example.view subModel)

        Page_Gallery subModel ->
            viewPage Page_Gallery_Msg (Page.Gallery.view subModel)

        Page_QuickStart subModel ->
            viewPage Page_QuickStart_Msg (Page.QuickStart.view subModel)


type Msg
    = ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | Page_Home_Msg Page.Home.Msg
    | Page_Administration_Msg Page.Administration.Msg
    | Page_Documentation_Msg Page.Documentation.Msg
    | Page_Section_Msg Page.Section.Msg
    | Page_Example_Msg Page.Example.Msg
    | Page_Gallery_Msg Page.Gallery.Msg
    | Page_QuickStart_Msg Page.QuickStart.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( ClickedLink urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Navigation.pushUrl model.navigation (Url.toString url)
                    )

                Browser.External href ->
                    ( model
                    , Navigation.load href
                    )

        ( ChangedUrl url, _ ) ->
            changeRouteTo (Route.fromUrl url) model

        ( Page_Home_Msg subMsg, Page_Home subModel ) ->
            Page.Home.update model.navigation subMsg subModel
                |> updateWith Page_Home Page_Home_Msg model

        ( Page_Administration_Msg subMsg, Page_Administration subModel ) ->
            Page.Administration.update model.navigation subMsg subModel
                |> updateWith Page_Administration Page_Administration_Msg model

        ( Page_Documentation_Msg subMsg, Page_Documentation subModel ) ->
            Page.Documentation.update model.navigation subMsg subModel
                |> updateWith Page_Documentation Page_Documentation_Msg model

        ( Page_Section_Msg subMsg, Page_Section subModel ) ->
            Page.Section.update model.navigation subMsg subModel
                |> updateWith Page_Section Page_Section_Msg model

        ( Page_Example_Msg subMsg, Page_Example subModel ) ->
            Page.Example.update model.navigation subMsg subModel
                |> updateWith Page_Example Page_Example_Msg model

        ( Page_Gallery_Msg subMsg, Page_Gallery subModel ) ->
            Page.Gallery.update model.navigation subMsg subModel
                |> updateWith Page_Gallery Page_Gallery_Msg model

        ( Page_QuickStart_Msg subMsg, Page_QuickStart subModel ) ->
            Page.QuickStart.update model.navigation subMsg subModel
                |> updateWith Page_QuickStart Page_QuickStart_Msg model

        ( _, _ ) ->
            -- Disregard messages that arrived for the wrong page.
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.page of
        NotFound ->
            Sub.none

        Redirect ->
            Sub.none

        Page_Home subModel ->
            Sub.map Page_Home_Msg (Page.Home.subscriptions subModel)

        Page_Administration subModel ->
            Sub.map Page_Administration_Msg (Page.Administration.subscriptions subModel)

        Page_Documentation subModel ->
            Sub.map Page_Documentation_Msg (Page.Documentation.subscriptions subModel)

        Page_Section subModel ->
            Sub.map Page_Section_Msg (Page.Section.subscriptions subModel)

        Page_Example subModel ->
            Sub.map Page_Example_Msg (Page.Example.subscriptions subModel)

        Page_Gallery subModel ->
            Sub.map Page_Gallery_Msg (Page.Gallery.subscriptions subModel)

        Page_QuickStart subModel ->
            Sub.map Page_QuickStart_Msg (Page.QuickStart.subscriptions subModel)


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute old =
    let
        session =
            exit old

        model =
             { old | session = session }
    in
    case maybeRoute of
        Nothing ->
            ( { model | page = Redirect }, Navigation.pushUrl model.navigation "/" )

        Just (Route.Top ) ->
            Page.Home.init model.navigation session ()
                |> updateWith Page_Home Page_Home_Msg model

        Just (Route.Administration ) ->
            Page.Administration.init model.navigation session ()
                |> updateWith Page_Administration Page_Administration_Msg model

        Just (Route.Documentation ) ->
            Page.Documentation.init model.navigation session ()
                |> updateWith Page_Documentation Page_Documentation_Msg model

        Just (Route.Documentation_String_ p1) ->
            Page.Section.init model.navigation session { section = p1 }
                |> updateWith Page_Section Page_Section_Msg model

        Just (Route.Documentation_String__String_ p1 p2) ->
            Page.Example.init model.navigation session { section = p1, example = p2 }
                |> updateWith Page_Example Page_Example_Msg model

        Just (Route.Gallery ) ->
            Page.Gallery.init model.navigation session ()
                |> updateWith Page_Gallery Page_Gallery_Msg model

        Just (Route.Quick_start ) ->
            Page.QuickStart.init model.navigation session ()
                |> updateWith Page_QuickStart Page_QuickStart_Msg model


updateWith : (model -> Page) -> (msg -> Msg) -> Model -> ( model, Cmd msg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( { model | page = toModel subModel }
    , Cmd.map toMsg subCmd
    )


exit : Model -> Session
exit model =
    case model.page of
        Redirect ->
            model.session

        NotFound ->
            model.session

        Page_Home subModel ->
            Page.Home.exit subModel model.session

        Page_Administration subModel ->
            Page.Administration.exit subModel model.session

        Page_Documentation subModel ->
            Page.Documentation.exit subModel model.session

        Page_Section subModel ->
            Page.Section.exit subModel model.session

        Page_Example subModel ->
            Page.Example.exit subModel model.session

        Page_Gallery subModel ->
            Page.Gallery.exit subModel model.session

        Page_QuickStart subModel ->
            Page.QuickStart.exit subModel model.session