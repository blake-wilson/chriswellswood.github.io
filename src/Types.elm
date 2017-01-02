module Types exposing (..)

type alias ContentMetaData =
    { title : String
    , date : (Int, Int, Int)
    , description : String
    , category : String
    , subcategory : String
    , url : String
    }