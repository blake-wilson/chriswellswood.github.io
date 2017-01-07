module Snippets exposing (..)

-- Snippets are essentially metadata without the content.

allSnippets = 
    [ { name = "markdown-cheatsheet"
      , title = "Markdown Cheatsheet"
      , date = (2016, 12, 11)
      , description = "A great cheatsheet for markdown written by @adam-p. I always forget how to make tables..."
      , category = "Code"
      , subcategory = "Markdown"
      , url = "https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet"
      , rawContent = Nothing
      }
    ]