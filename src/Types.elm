module Types exposing (..)

import Html exposing (..)


type alias ContentMetaData msg =
    { name : String
    , title : String
    , date : List Int
    , description : String
    , category : String
    , subcategory : String
    , url : String
    , content : Html msg
    }
