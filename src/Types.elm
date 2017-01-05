module Types exposing (..)

type alias ContentMetaData =
    { name : String
    , title : String
    , date : (Int, Int, Int)
    , description : String
    , category : String
    , subcategory : String
    , url : String
    , rawContent : Maybe String
    }