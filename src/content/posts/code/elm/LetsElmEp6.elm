module LetsElmEp6 exposing (..)

import Html exposing (..)
import Markdown
import Skeleton exposing (ContentMetaData, skeleton, blogPostView, contentUrl)


main =
    blogPostView metaData content
        |> skeleton


name : String
name =
    "lets-elm-ep6"


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
    , title = "Let's Elm Episode 6"
    , date = [ 2017, 4, 20 ]
    , description = "Feature blitz (abilities)."
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
In this episode of Let's Elm, we're using some of the tools we've recently
learnt about to build the abilities section of the Elm application.

You can learn more about Exalted here:
http://theonyxpath.com/category/worlds/exalted/

<iframe width="560" height="315" src="https://www.youtube.com/embed/kaLeBE5hsJY"
frameborder="0" allowfullscreen style="display: block; margin: auto;"></iframe>
"""
