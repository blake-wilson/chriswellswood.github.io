module PythonPackages exposing (..)

import Html exposing (..)
import Markdown
import Skeleton exposing (ContentMetaData, skeleton, blogPostView, contentUrl)


main =
    blogPostView metaData content
        |> skeleton


name : String
name =
    "python-packages"


group : String
group =
    "Blog"


category : String
category =
    "Code"


subcategory : String
subcategory =
    "Python"


metaData : ContentMetaData
metaData =
    { name = name
    , title = "Packaging a Python Project and Distributing on PyPi"
    , date = [ 2017, 8, 16 ]
    , description =
        "A descitption of all the files and steps required to "
            ++ "package and distribute a Python module."
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
I always forget the files and steps required to create a Python module and how
I actually go about uploading it to PyPi, so I wrote a Gist collecting together
a bunch of notes about the process. Please comment on GitHub and tell me any
other useful information you have about Python modules!

https://gist.github.com/ChrisWellsWood/165e3144f4a8199482ab50a8146c8069
"""
