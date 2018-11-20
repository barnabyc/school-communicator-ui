module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Page.Home as Home
import Route exposing (Route)


type Model
    = Home Home.Model



-- MODEL


init : Maybe Viewer -> Url -> Nav.Key -> ( Model, Cmd Msg )
init maybeViewer url navKey =
    changeRouteTo (Route.fromUrl url)
        (Redirect (Session.fromViewer navKey maybeViewer))



-- VIEW


view : Model -> Document Msg
view model =
    let
        viewPage page toMsg config =
            let
                { title, body } =
                    Page.view
            in
            { title = title, body = List.map (Html.map toMsg) body }
    in
    case model of
        Home home ->
            viewPage Page.Home GotHomeMsg (Home.view home)



-- UPDATE


type Msg
    = Ignored
    | GotHomeMsg Home.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( Ignored, _ ) ->
            ( model, Cmd.none )

        ( GotHomeMsg subMsg, Home home ) ->
            Home.update subMsg home
                |> updateWith Home GotHomeMsg model



-- SUBSCRIPTIONS
-- todo: subscriptions
-- MAIN


main : Program Value Model Msg
main =
    Browser.application
        { init = init

        -- , onUrlChange = ChangedUrl
        -- , onUrlRequest = ClickedLink
        -- , subscriptions = subscriptions
        , update = update
        , view = view
        }
