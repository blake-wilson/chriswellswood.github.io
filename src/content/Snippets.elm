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
      , content = div [] []
      }
    ]
