module Content exposing (..)

type alias InfoRecord =
    { title : String
    , date : (Int, Int, Int)
    , description : String
    , category : String
    , subcategory : String
    , url : String
    }

type alias PostInfo = InfoRecord

type alias ContentIndex = List PostInfo

allPosts : ContentIndex
allPosts =
    [ { title = "Empty Rust Structs"
      , date = (2016, 12, 11)
      , description = "A little article about methods for initialising empty/default structs in Rust, which can be more complicated than you might think!"
      , category = "Code"
      , subcategory = "Rust"
      , url = "posts/empty_rust_structs.html"
      }
    , { title = "Building a blog in Elm"
      , date = (2017, 1, 1)
      , description = "A guide/outline of my experiences using Elm to build a blog hosted on GitHub."
      , category = "Code"
      , subcategory = "Elm"
      , url = "content/drafts/code/elm/2016_12_30_elm_website.md"
      }
    , { title = "Test Post 2"
      , date = (2015, 1, 1)
      , description = "Another post fake post."
      , category = "Code"
      , subcategory = "Rust"
      , url = "content/posts/code/rust/2016_12_11_empty_structs.md"
      }
    ]

type alias Snippet = InfoRecord

type alias SnippetIndex = List Snippet

allSnippets : SnippetIndex
allSnippets = 
    [ { title = "Markdown Cheatsheet"
      , date = (2016, 12, 11)
      , description = "A great cheatsheet for markdown written by @adam-p. I always forget how to make tables..."
      , category = "Code"
      , subcategory = "Markdown"
      , url = "https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet"
      }
    ]

