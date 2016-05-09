module Image exposing (viewThumbnailImage, viewImage, Msg, update)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onMouseOver, onMouseOut)
import Models exposing (Image)
import Utils exposing ((=>), host)


type Msg
  = Select
  | Unselect


update msg model =
  model


imagePath : String -> Image -> String
imagePath size image =
  host ++ "/" ++ size ++ "/" ++ image.gallery ++ "/" ++ image.filename


viewThumbnailImage : (Image -> msg) -> Image -> Html msg
viewThumbnailImage msg image =
  img
    [ onClick (msg image)
    -- , onMouseOver Select
    -- , onMouseOut Unselect
    , class "img-thumbnail"
    , thumbnailImageStyle
    , title (toString image)
    , src (imagePath "thumbs" image) ]
    []


viewImage : Image -> Html msg
viewImage image =
  img
    [ src (imagePath "gallery" image)
    , class "img-rounded"
    , bigImageStyle
    ]
    []


thumbnailImageStyle =
  style
    [ "width" => "120px"
    , "cursor" => "pointer"
    ]


bigImageStyle =
  style
    [ "width" => "600px" ]
