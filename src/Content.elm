module Content exposing (..)

type alias PostInfo =
    { title : String
    , date : (Int, Int, Int)
    , description : String
    , category : String
    , subcategory : String
    , url : String
    }

type alias ContentIndex = List PostInfo

allPosts : ContentIndex
allPosts =
    [ { title = "Empty Rust Structs"
      , date = (2016, 12, 11)
      , description = "A little article about methods for initialising empty/default structs in Rust, which can be more complicated than you might think!"
      , category = "Code"
      , subcategory = "Rust"
      , url = "content/posts/code/rust/2016_12_11_empty_structs.md"
      }
    , { title = "Test Post 1"
      , date = (2015, 12, 31)
      , description = "A post fake post."
      , category = "Code"
      , subcategory = "Rust"
      , url = "content/posts/code/rust/2016_12_11_empty_structs.md"
      }
    , { title = "Test Post 2"
      , date = (2017, 1, 1)
      , description = "Another post fake post."
      , category = "Code"
      , subcategory = "Rust"
      , url = "content/posts/code/rust/2016_12_11_empty_structs.md"
      }
    ]