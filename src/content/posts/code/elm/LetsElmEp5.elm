module LetsElmEp5 exposing (..)

import Html exposing (..)
import Markdown
import Skeleton exposing (ContentMetaData, skeleton, blogPostView, contentUrl)


main =
    blogPostView metaData content
        |> skeleton


name : String
name =
    "lets-elm-ep5"


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
    , title = "Let's Elm Episode 5"
    , date = [ 2017, 4, 1 ]
    , description = "SVG, refactoring and map2."
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
In this episode of Let's Elm, we're using Elm SVG to make some interactive
graphics for our application.

You can learn more about SVG here:
https://www.w3schools.com/graphics/svg_intro.asp

<iframe width="560" height="315" src="https://www.youtube.com/embed/QSoIYo5qVNg"
frameborder="0" allowfullscreen style="display: block; margin: auto;"></iframe>
"""
