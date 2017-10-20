module LetsElmEp1 exposing (..)

import Html exposing (..)
import Markdown
import Skeleton exposing (ContentMetaData, skeleton, blogPostView, contentUrl)


main =
    blogPostView metaData content
        |> skeleton


name : String
name =
    "lets-elm-ep1"


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
    , title = "Let's Elm Episode 1"
    , date = [ 2017, 2, 12 ]
    , description = "How to create the basic structure for an Elm application."
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
In this episode we create the basic structure for the Elm app, and I discuss the
various sections and explain their purpose. The aim for this tutorial is to get
something up in the browser!

<iframe width="560" height="315" src="https://www.youtube.com/embed/cEjYUJE9mfw"
frameborder="0" allowfullscreen style="display: block; margin: auto;"></iframe>
"""
