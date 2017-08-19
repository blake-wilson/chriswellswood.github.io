module Snippets exposing (..)

import Html exposing (..)
import Types exposing (ContentMetaData)


-- Snippets are essentially metadata without the content.


allSnippets : List (ContentMetaData msg)
allSnippets =
    [ { name = "markdown-cheatsheet"
      , title = "Markdown Cheatsheet"
      , date = [ 2016, 12, 11 ]
      , description = "A great cheatsheet for markdown written by @adam-p. I always forget how to make tables..."
      , category = "Code"
      , subcategory = "Markdown"
      , url = "https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet"
      , content = Nothing
      }
    , { name = "python-packages"
      , title = "Packaging a Python Project and Distributing on PyPi"
      , date = [ 2017, 8, 17 ]
      , description = "Workflow for making and distributing a Python package."
      , category = "Code"
      , subcategory = "Python"
      , url = "https://gist.github.com/ChrisWellsWood/165e3144f4a8199482ab50a8146c8069"
      , content = Nothing
      }
    ]
