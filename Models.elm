module Models exposing (..)

import Date


type alias Image =
  { filename : String
  , gallery : String
  , created : Maybe Date.Date
  , width : Int
  , height : Int
  }


type alias Images =
  List Image


type alias Model =
  { images : Images
  , selectedImage : Maybe Image
  }
