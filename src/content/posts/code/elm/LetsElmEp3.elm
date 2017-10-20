module LetsElmEp3 exposing (..)

import Html exposing (..)
import Markdown
import Skeleton exposing (ContentMetaData, skeleton, blogPostView, contentUrl)


main =
    blogPostView metaData content
        |> skeleton


name : String
name =
    "lets-elm-ep3"


group : String
group =
    "Videos"


category : String
category =
    "Code"


subcategory : String
subcategory =
    "Elm"


metaData : ContentMetaData
metaData =
    { name = name
    , title = "Let's Elm Episode 3"
    , date = [ 2017, 3, 19 ]
    , description = "Decluttering with Dicts."
    , group = group
    , category = category
    , subcategory = subcategory
    , url = contentUrl group category subcategory name
    }


content : Html msg
content =
    Markdown.toHtml [] rawContent


rawContent : String
rawContent =
    """
In this episode of Let's Elm, we're decluttering our update function using Elm
dictionaries.

<iframe width="560" height="315" src="https://www.youtube.com/embed/QTdL76CFXDw"
frameborder="0" allowfullscreen style="display: block; margin: auto;"></iframe>
"""
