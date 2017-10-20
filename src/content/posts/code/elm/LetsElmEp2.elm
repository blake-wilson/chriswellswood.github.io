module LetsElmEp2 exposing (..)

import Html exposing (..)
import Markdown
import Skeleton exposing (ContentMetaData, skeleton, blogPostView, contentUrl)


main =
    blogPostView metaData content
        |> skeleton


name : String
name =
    "lets-elm-ep2"


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
    , title = "Let's Elm Episode 2"
    , date = [ 2017, 3, 11 ]
    , description = "Input boxes and drop-down menus."
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
In this episode we're creating the player information section of the
application, which requires adding some text boxes and making some drop-down
menus.

<iframe width="560" height="315" src="https://www.youtube.com/embed/F1kBo8B-5ZM"
frameborder="0" allowfullscreen style="display: block; margin: auto;"></iframe>
"""
