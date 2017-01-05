module ElmStaticSiteP1 exposing (..)

import Html exposing (..)

import Types

name : String
name = "elm-static-site-p1"

metaData : Types.ContentMetaData
metaData =
    { name = name
    , title = "Making a Static Website with Elm and GitHub Pages - Part 1"
    , date = (2017, 01, 04)
    , description = "Creating a simple static site in Elm."
    , category = "Code"
    , subcategory = "Elm"
    , url = "#blog/" ++ name
    , rawContent = Just rawContent
    }

rawContent: String
rawContent = """
## Making a Static Website with Elm and GitHub Pages - Part 1

*Check out the source code for the site [here](https://github.com/ChrisWellsWood/chriswellswood.github.io).*

First of all, happy new year! I hope everyone had a great holiday. I've got a bit of time off of work, and as I'm now back from visiting family, I've been getting stuck into some little projects. The first thing I wanted to do was update this website. I was very pleased how quickly I managed to get the site up and running using just Markdown and GitHub pages, but obviously there are limitations around building a website this way. So I decided I'd rebuild it in [Elm](http://elm-lang.org/), which is a neat functional programming language designed to make webapps, which I've talked about in a [previous post](posts/code/elm/object-oriented-brain-and-types.html) (warning: it's bit waffly).

I've been playing around with Elm for a while, and I'm starting to get relatively comfortable with it, but it has taken me the best part of 3 evenings to create a site that replicates the site that I made using GitHub pages in 15 mins! However, it is in a much better state for it and I've learned a lot along the way. The whole process would have been much quicker had I not spent a whole bunch of time working on a design that was just fundamentally flawed, I won't go into it in detail, but it was stupid on many levels. So here's the solution I've settled on.

I had a few requirements when making the site:

1. It should be easy to maintain.
1. It be able to use Markdown for content.
1. I wanted to do as much as possible by myself.

There's nice [Jekyll](https://jekyllrb.com/) integration with GitHub pages, which would address many of these requirements, but I've had issues trying to get Jekyll to work on Windows before, and more than that, I can't quite grasp how it all fits together.

### Basic Structure

Elm applications, especially those that follow the [Elm Architecture](https://guide.elm-lang.org/architecture/), have a Model/Update/View (or [MVC](https://en.wikipedia.org/wiki/Model-view-controller)) structure. A static site is essentially just a "view", and so it's a lot simpler to construct than most Elm apps. Every discreet page on the site is currently an separate Elm app i.e. a source file compiles down to a single HTML file.

As an example, here's the first section of my Index.elm file, which compiles down to the index.html. *It actually it's compiles to `index.js`, which is embedded in a pretty spartan `index.hmtl` file, but I'll come back to that later.*

```Elm
-- in Index.elm

module Index exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Templates
import Types exposing (ContentMetaData)

-- Posts and snippets
import EmptyRustStructs
import ElmAndNewLanguages
import OOBrainAndTypes
import Snippets exposing (allSnippets)

main : Html msg
main = Templates.basicPage view

view : Html msg
view = div []
    [ aboutMe -- Defined later in the file
    , hr [] []
    , recentPosts -- Defined later in the file
    , hr [] []
    , recentSnippets -- Defined later in the file
    ]
...
```

Let's go through this and explain what's going on here. The first chunk of the file is just imports of bits of the Elm standard library, as well as various modules I've defined. The content itself, currently the posts and snippets, are Elm modules, which allows metadata such as the title and date of the post, to be easily extracted.

The `main` function is used as an entry point to an Elm application, and usually it is a `Html.Program` type, which is a record with the following structure:

```Elm
main = Html.Program
    { init = ...
    , view = ...
    , update = ...
    , subscriptions = ...
    }
```

This tells the Elm how to start and update the model, and defines the view, which will use the model to render the website. The `main` function doesn't have to be a `Html.Program` type though, it can also just be a `Html msg`, essentially just the view part. Here, I've defined a module called `Templates.elm` that contains basic templates for different types of pages. The view for the index is wrapped in the template, which adds the header and footer, here's what it looks like in `Templates.elm`:

```Elm
...
-- in Templates.elm

basicPage : Html msg -> Html msg
basicPage content =
    div [ id "main" ]
        [ siteHeader -- Defined later in the file
        , content
        , siteFooter -- Defined later in the file
        ]
...
```

The view itself contains the main sections of the homepage, which are defined later. Information regarding posts is stored in Elm records in the post "modules" (see below). These are gathered up in a list of all the posts in `Index.elm`, although I'm planning to move this to a `Content` module:

```Elm
allPosts : List ContentMetaData
allPosts =
    [ EmptyRustStructs.metaData
    , ElmAndNewLanguages.metaData
    , OOBrainAndTypes.metaData
    ]
```

Once the posts are in a list, it's easy to sort or filter them in anyway you like:

```Elm
-- in Index.elm

recentPosts : Html msg
recentPosts = div []
    [ h2 [] [ text "Recent Posts" ]
    , recentContentList (List.reverse (List.sortBy .date allPosts))
    ]
```

I currently just sort by date and reverse it, but in the future this page will be a full Elm app, with search, sort and filter functionality for posts.

The post page source files are very simple, all they contain is the metadata, a very simple view based off of another template, and the content itself, which is written in Markdown.

```Elm
-- in EmptyRustStructs.elm

module EmptyRustStructs exposing (..)

import Html exposing (..)

import Templates
import Types

metaData : Types.ContentMetaData
metaData =
    { title = "Empty Rust Structs"
    , date = (2016, 12, 11)
    , description = "A little article about methods for initialising empty/default structs in Rust, which can be more complicated than you might think!"
    , category = "Code"
    , subcategory = "Rust"
    , url = "posts/code/rust/empty-rust-structs.html"
    }

main : Html msg
main = view

view : Html msg
view = Templates.post rawContent

rawContent: String
rawContent = \"\"\"
## Initialising Empty Structs in Rust

In C/C++, you can initialise...
\"\"\"
```

The post template is currently the same as the basicPage template, except is take the content and converts it from Markdown to HTML:

```Elm
-- in Templates.elm

post : String -> Html msg
post rawContent =
    let
      content = Markdown.toHtml [] rawContent
    in
      basicPage content
```

And that's it, pretty much the simplest sort of website you can write in Elm. Now each of the source files for the pages needs to be compiled with `elm-make` and embedded in a HTML file, which I'll discuss in the next post.
"""