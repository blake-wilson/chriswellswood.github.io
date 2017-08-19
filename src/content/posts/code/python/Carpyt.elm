module Carpyt exposing (..)

import Html exposing (..)
import Markdown
import Types exposing (ContentMetaData)


name : String
name =
    "carpyt"


metaData : ContentMetaData msg
metaData =
    { name = name
    , title = "Carpyt, a module creation tool for Python."
    , date = [ 2017, 8, 19 ]
    , description = "Making modules in Python is hard, let's make it easier!"
    , category = "Code"
    , subcategory = "Python"
    , url = "#blog/" ++ name
    , content = Just content
    }


content : Html msg
content =
    Markdown.toHtml [] rawContent


rawContent : String
rawContent =
    """

    """
