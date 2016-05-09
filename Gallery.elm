module Gallery exposing (..)

import Html exposing (..)
import Html.Attributes exposing (src, style, disabled, title, href, rel, class)
import Html.Events exposing (onClick)
import Html.App as Html
import Html.Lazy exposing (lazy, lazy2)
import Http
import Task
import Utils exposing (..)
import Models exposing (Images, Image, Model)
import Decoder
import Navigation
import Image
import Keyboard


type Msg
  = LoadImages
  | ListImages Images
  | SelectedImage Image
  | Navigation Navigation.Msg
  | Image Image.Msg


loadLatest : Cmd Msg
loadLatest =
  Http.get Decoder.images (host ++ "/latest")
    |> Task.perform
      (\e -> let _ = Debug.log "Err" e in ListImages [])
      ListImages


init : ( Model, Cmd Msg )
init =
  ( Model [] Nothing, loadLatest )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    LoadImages ->
      init

    ListImages images ->
      ( { model | images = images }, Cmd.none )

    SelectedImage image ->
      ( { model | selectedImage = Just image }, Cmd.none )
      
    Navigation msg ->
      ( Navigation.update msg model, Cmd.none )
      
    Image msg ->
      ( Image.update msg model, Cmd.none )


viewReloaderBtn : Html Msg
viewReloaderBtn =
  div
    [ class "btn-group btn-group-justified" ]
    [ div
        [ class "btn-group" ]
        [ button
            [ onClick LoadImages, class "btn btn-success btn-sm" ]
            [ span [ class "glyphicon glyphicon-refresh" ] [] ]
        ]
    ]

viewImages : Model -> List (Html Msg)
viewImages model =
  viewReloaderBtn ::
  [ Html.map Navigation (lazy Navigation.view model) ] ++
  List.map (lazy2 Image.viewThumbnailImage SelectedImage) model.images ++
  [ Html.map Navigation (lazy Navigation.view model) ]


viewLoader : Html Msg
viewLoader =
  div [] [ text "loading..." ]


view : Model -> Html Msg
view model =
  div
    [ galleryStyle ]
    ( [ bootstrap
      , div
        [ thumbsStyle ]
        (if hasImages model then
           viewImages model
         else
           [ viewLoader ])
      ] ++
      viewMaybe (singleton << lazy Image.viewImage) model.selectedImage
    )


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.map Navigation Navigation.keyboard


main =
  Html.program
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }


galleryStyle =
  style
    [ "vertical-align" => "top" ]


thumbsStyle =
  style
    [ "width" => "600px"
    , "display" => "inline-block"
    , "vertical-align" => "top"
    ]


bootstrap =
  node
    "link"
    [ href "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
    , rel "stylesheet"
    ]
    []
