module Utils exposing (..)

import Array
import Models exposing (..)
import Html exposing (Html)


host : String
host =
  "http://localhost:8083"
  -- "http://raspberrypi:8083"


findIndex : List Image -> Maybe Image -> Maybe Int
findIndex images image =
  case image of
    Just image ->
      images
        |> List.indexedMap ((,))
        |> List.filter (snd >> ((==) image))
        |> List.map fst
        |> List.head
    Nothing -> Nothing


findPreviousImage : Images -> Maybe Image -> Maybe Image
findPreviousImage images image =
  let
    array =
      images
        |> Array.fromList
    
    index =
      findIndex images image
        |> Maybe.withDefault (-1)

    previousImage =
      array
        |> Array.get (max 0 (index - 1))

  in previousImage


findFirstImage : Images -> Maybe Image
findFirstImage images =
  images
    |> List.head


findLastImage : Images -> Maybe Image
findLastImage images =
  images
    |> List.reverse
    |> List.head


findNextImage : Images -> Maybe Image -> Maybe Image
findNextImage images image =
  let
    array =
      images
        |> Array.fromList
    
    index =
      findIndex images image
        |> Maybe.withDefault (-1)

    nextImage =
      array
        |> Array.get (min (Array.length array - 1) (index + 1))
        
  in nextImage


(=>) : a -> b -> ( a, b )
(=>) = (,)


singleton : a -> List a
singleton x =
  [ x ]


viewMaybe :  (a -> List b) -> Maybe a -> List b
viewMaybe view =
  Maybe.map view
    >> Maybe.withDefault []


hasImages : Model -> Bool
hasImages { images } =
  List.length images > 0
