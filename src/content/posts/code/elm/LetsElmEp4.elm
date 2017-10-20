module LetsElmEp4 exposing (..)

import Html exposing (..)
import Markdown
import Skeleton exposing (ContentMetaData, skeleton, blogPostView, contentUrl)


main =
    blogPostView metaData content
        |> skeleton


name : String
name =
    "lets-elm-ep4"


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
    , title = "Let's Elm Episode 4"
    , date = [ 2017, 3, 25 ]
    , description = "Building the attributes section."
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
In this episode of Let's Elm, we're building the attributes section of the
character sheet using dictionaries and other tools.

<iframe width="560" height="315" src="https://www.youtube.com/embed/DKeesj7kImg"
frameborder="0" allowfullscreen style="display: block; margin: auto;"></iframe>
"""
