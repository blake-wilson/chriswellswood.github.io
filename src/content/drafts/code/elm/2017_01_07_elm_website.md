## Tools for Handling Static Pages in Elm - Part 1. Dealing with Links

*Check out the source code for the site [here](https://github.com/ChrisWellsWood/chriswellswood.github.io).*

First of all, happy new year! I hope everyone had a great holiday. I've got a bit of time off of work, and as I'm now back from visiting family, I've been getting stuck into some little projects. The first thing I wanted to do was update this website. I was very pleased how quickly I managed to get the site up and running using just Markdown and GitHub pages, but obviously there are limitations around building a website this way. So I decided I'd rebuild it in [Elm](http://elm-lang.org/), which is a neat functional programming language designed to make webapps.

I've been playing around with Elm for a while, and I'm starting to get relatively comfortable with it, but it has taken me much longer than expected to superficially recreate the site I made in 15 mins with GitHub Pages and Markdown! However, it is now a really flexible little platform and I've learned a lot about Elm, Javascript and HTML along the way.

The main purpose of this website is to host my blog, sharing things that I've made and other interesting stuff I've found. As the content will be static site, traditionally this type of site would be constructed from a bunch of separate HTML documents i.e one for home, one for each post etc.

Usually Elm is used to make one page webapps, where content is dynamically added to the page. It wasn't particularly obvious to me how I should implement this type of site using the [Elm Architecture](https://guide.elm-lang.org/architecture/). There were two main difficulties I came across while making the site:

1. **How you would provide a link to a particular article when there's only a single HTML page?**
2. After dynamically changing the website, how do you deal with running external Javascript libraries in response to these changes?

This post deals with the first topic.

### Links on a single page Elm application

My initial solution to this was to just have a bunch of Elm files that each compiled independently to create a bunch of HTML pages. I used a bat file to automate the building process, but it felt clunky. Then I came across the `navigation` module in the Elm core library. So I rewrote the site to use this, but quickly found out I also needed to use the `url-parser` module.

Firstly, the current active page is recorded in the model using a union type:

```Elm
type alias Model =
    { page: Page
    }

type Page
    = Home
    | AllPosts
    | Post String
```

This means that we can currently have 3 "types" of pages. `Home` and `AllPosts` are pretty self explanatory, correspond to a unique page. The `Post` page type corresponds to blog post pages, of which there are many, and so information on the specific post is also required.

You can handle the unique pages using just the navigation module, by pattern matching a hash in a url, as outlined in [this article](https://medium.com/@nithstong/spa-simple-with-elm-navigation-630bdfdbef94#.om47asuv1), by Pablo Fernández. However, you need more information for the post pages, so you can get the correct post. This can be extracted from the URL using the [`url-parser` module](http://package.elm-lang.org/packages/evancz/url-parser/2.0.1/).

To parse a URL, you need a `Msg` to handle the change, which takes a `Navigation.Location` as an input:

```Elm
type Msg
    = UrlChange Navigation.Location
```

The `Navigation.Location` record which has the following type annotation:

```Elm
type alias Location =
    { href : String
    , host : String
    , hostname : String
    , protocol : String
    , origin : String
    , port_ : String
    , pathname : String
    , search : String
    , hash : String
    , username : String
    , password : String }
```

I'm using location hashes for the links to different content, so we can ignore the rest of the record. Our update function handles the `UrlChange Msg`, parsing the URL and saving the correct page type in the model.

```Elm
import UrlParser exposing ((</>))

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            { model | page = getPage location } ! [ Cmd.none ]

getPage : Navigation.Location -> Page
getPage location =
    Maybe.withDefault AllPosts (UrlParser.parseHash route location)

route : UrlParser.Parser (Page -> a) a
route =
    UrlParser.oneOf
        [ UrlParser.map Home UrlParser.top
        , UrlParser.map Post (UrlParser.s "blog" </> UrlParser.string)
        ]
```

The update function is pretty straight forward, it process a `UrlChange Msg` and then parses the location to get the page type, which is stored in the model. The `getPage` function uses `UrlParser.parseHash` to process the location, generating a `Maybe Page`.

`parseHash` takes a `UrlParser.Parser` type, in this case `route`. Route looks a bit weird, mainly due to `UrlParser.oneOf`, but essentially it just take a bunch of parsers and merges them together to make a super parser that when used will try each of the parsers it contains.

The actual parsers themselves are the `(UrlParser.s "blog" </> UrlParser.string)` and `UrlParser.top` bits. The `Parser` takes URLs and converts them to data. `UrlParser.top` is pretty simple, it doesn't consume any segments from the path, and so will successfully parse if the URL if it has no additional segments. The `s` parser will parse a segment of the URL if it *exactly* matches a provided string, so `UrlParser.s "blog"` will parse `/blog/` but nothing else. `UrlParser.string` will successfully parse any segment that is a string. Finally, `UrlParser.</>` combines the parsers together, to make a parser that has to exactly match `blog` and then contain another segment that is a string. There are other parser types too, check out the [docs](http://package.elm-lang.org/packages/evancz/url-parser/2.0.1/UrlParser) for more details.

The parser can then be applied to the location using either `parsePath` or `parseHash`, and will return `Just *data*` or `Nothing`. `UrlParser.map` is used to transform the data contained in the URL into a `Msg`. So, using this parser:

```Elm
-- /                      ==> Just Home
-- /blog/my-gid-blog-post ==> Just (Post "my-gid-blog-post")
-- /blog                  ==> Nothing
```

`UrlParser` is very powerful, and isn't as complex to use as it is to explain. The best way to get a feel for how `UrlParser` works is to actually use it.

Finally, the post type in the `model` can be used to alter content in the view when it's rendered:

```Elm
view : Model -> Html Msg
view model = div [ id "mainSiteDiv", mainSiteDivStyle ]
    [ CommonViews.siteHeader
    , content model
    , CommonViews.siteFooter
    ]

content : Model -> Html Msg
content model = div [ id "contentSection" ]
    [ getContent model
    ]

getContent : Model -> Html Msg
getContent model =
    case model.page of
      Home -> home
      AllPosts -> postList
      Post title -> getBlogPost title
```

Now you can easily link to content using URLs with location tags.

That's it for this post, but in the next post I'll discuss using ports and tasks to interact with Javascript, allowing us to format code in the posts.