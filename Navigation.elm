module Navigation exposing (Msg (..), update, view, keyboard)

import Html exposing (..)
import Html.Attributes exposing (style, disabled, class, hidden)
import Html.Events exposing (onClick)
import Models exposing (Model)
import Utils exposing (..)
import Keyboard


type Msg
  = FirstImage
  | PreviousImage
  | NextImage
  | LastImage
  | Unselect
  | Noop


update : Msg -> Model -> Model
update msg model =
  case msg of
    FirstImage ->
      { model | selectedImage = findFirstImage model.images }

    PreviousImage ->
      { model | selectedImage = findPreviousImage model.images model.selectedImage }

    NextImage ->
      { model | selectedImage = findNextImage model.images model.selectedImage }

    LastImage ->
      { model | selectedImage = findLastImage model.images }

    Unselect ->
      { model | selectedImage = Nothing }

    Noop ->
      model


isImageUnselected : Model -> Bool
isImageUnselected { selectedImage } =
  case selectedImage of
    Just _ -> False
    Nothing -> True


isFirstImage : Model -> Bool
isFirstImage { images, selectedImage } =
  findIndex images selectedImage == Just 0


isLastImage : Model -> Bool
isLastImage { images, selectedImage } =
  findIndex images selectedImage == Just (List.length images - 1)


view : Model -> Html Msg
view model =
  div
    [ class "btn-group btn-group-justified" ]
    [ button
        [ onClick FirstImage
        , disabled (not (hasImages model) || isFirstImage model) ]
        [ glyph "step-backward" ]
    , button
        [ onClick PreviousImage
        , disabled (isImageUnselected model || isFirstImage model) ]
        [ glyph "chevron-left" ]
    , button
        [ onClick Unselect
        , disabled (isImageUnselected model) ]
        [ glyph "remove" ]
    , button
        [ onClick NextImage
        , disabled (isImageUnselected model || isLastImage model) ]
        [ glyph "chevron-right" ]
    , button
        [ onClick LastImage
        , disabled (not (hasImages model) || isLastImage model) ]
        [ glyph "step-forward" ]
    ]


keyboard : Sub Msg
keyboard =
  Keyboard.presses (\keycode ->
    case keycode of
      102 ->
        FirstImage

      110 ->
        NextImage
      
      112 ->
        PreviousImage

      108 ->
        LastImage

      _ ->
        Noop)


button a n =
  div
    [ class "btn-group" ]
    [ Html.button (class "btn btn-default btn-sm" :: a) n ]


glyph name =
  span
    [ class ("glyphicon glyphicon-" ++ name)
    -- , aria-hidden True
    ]
    []
