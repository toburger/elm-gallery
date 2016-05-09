module Decoder exposing (..)

import Json.Decode as Json exposing ((:=))
import Date
import Models exposing (Image, Images)


date : Json.Decoder (Maybe Date.Date)
date =
  Json.string
    |> Json.map
      (Date.fromString >> Result.toMaybe)


image : Json.Decoder Image
image =
  Json.object5
    Image
    ("filename" := Json.string)
    ("gallery" := Json.string)
    ("created" := date)
    ("width" := Json.int)
    ("height" := Json.int)


images : Json.Decoder Images
images =
  Json.list image