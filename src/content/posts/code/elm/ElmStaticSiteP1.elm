module ElmStaticSiteP1 exposing (..)

import Html exposing (..)
import Markdown
import Types exposing (ContentMetaData)


name : String
name =
    "elm-static-site-p1"


metaData : ContentMetaData msg
metaData =
    { name = name
    , title = "Tools for Handling Static Pages in Elm - Part 1. Dealing with Links"
    , date = [ 2017, 1, 7 ]
    , description = "How to handle links to static content in a dynamic one page Elm app, using the Navigation and UrlParser modules."
    , category = "Code"
    , subcategory = "Elm"
    , url = "#blog/" ++ name
    , content = Just content
    }


content : Html msg
content =
    Markdown.toHtml [] rawContent


rawContent : String
rawContent =
    """\x0D
*Check out the source code for the site [here](https://github.com/ChrisWellsWood/chriswellswood.github.io).*\x0D
\x0D
First of all, happy new year! I hope everyone had a great holiday. I've got a bit of time off of work, and as I'm now back from visiting family, I've been getting stuck into some little projects. The first thing I wanted to do was update this website. I was very pleased how quickly I managed to get the site up and running using just Markdown and GitHub pages, but obviously there are limitations around building a website this way. So I decided I'd rebuild it in [Elm](http://elm-lang.org/), which is a neat functional programming language designed to make webapps.\x0D
\x0D
The main purpose of this website is to host my blog, as well as sharing things that I've made and other interesting stuff I've found. Usually Elm is used to make one page webapps, where content is dynamically added to the page, so it wasn't particularly obvious to me how I should implement a site that mainly uses static content with the [Elm Architecture](https://guide.elm-lang.org/architecture/). There were two main difficulties I came across while making the site:\x0D
\x0D
1. **How you would provide a link to a particular article when there's only a single HTML page?**\x0D
2. After dynamically changing the website, how do you deal with running external Javascript libraries in response to these changes?\x0D
\x0D
This post deals with the first topic.\x0D
\x0D
### Links on a single page Elm application\x0D
\x0D
My initial solution to this was to just have Elm files that each compiled independently to create a bunch of HTML pages. I used a bat file to automate the building process, but it felt clunky. Then I came across the `navigation` module in the Elm core library. So I rewrote the site to use this, but quickly found out I also needed to use the `url-parser` module.\x0D
\x0D
To start, you need to use a special `Program` type, stored in the `Navigation` module:\x0D
\x0D
```Elm\x0D
main : Program Never Model Msg\x0D
main =\x0D
    Navigation.program UrlChange\x0D
        { init = init\x0D
        , view = view\x0D
        , update = update\x0D
        , subscriptions = (\\_ -> Sub.none)\x0D
        }\x0D
```\x0D
\x0D
This is very similar to `Html.program`, the only real difference is that you need to supply a `Msg` that will be fed to the update function everytime the URL changes. The `init` function is important too, but I'll come back to that later.\x0D
\x0D
Next, the current active page is recorded in the model using a union type:\x0D
\x0D
```Elm\x0D
type alias Model =\x0D
    { page: Page\x0D
    }\x0D
\x0D
type Page\x0D
    = Home\x0D
    | AllPosts\x0D
    | Post String\x0D
```\x0D
\x0D
This means that we can currently have 3 "types" of pages. `Home` and `AllPosts` are pretty self explanatory, correspond to a unique page. The `Post` page type corresponds to blog post pages, of which there are many, and so information on the specific post is also required.\x0D
\x0D
You can handle the unique pages using just the navigation module, by pattern matching a hash in a url, as outlined in [this article](https://medium.com/@nithstong/spa-simple-with-elm-navigation-630bdfdbef94#.om47asuv1) by Pablo Fernández. However, you need more information for the post pages, so you can get the correct post. This can be extracted from the URL using the [`url-parser` module](http://package.elm-lang.org/packages/evancz/url-parser/2.0.1/).\x0D
\x0D
To parse a URL, you need a `Msg` to handle the change in URL, which takes a `Navigation.Location` as an input:\x0D
\x0D
```Elm\x0D
type Msg\x0D
    = UrlChange Navigation.Location\x0D
```\x0D
\x0D
The `Navigation.Location` record has the following type annotation:\x0D
\x0D
```Elm\x0D
type alias Location =\x0D
    { href : String\x0D
    , host : String\x0D
    , hostname : String\x0D
    , protocol : String\x0D
    , origin : String\x0D
    , port_ : String\x0D
    , pathname : String\x0D
    , search : String\x0D
    , hash : String\x0D
    , username : String\x0D
    , password : String }\x0D
```\x0D
\x0D
I'm using location hashes for the links to different content, so we can ignore the rest of the record. Our update function handles the `UrlChange Msg`, parsing the URL and saving the correct page type in the model.\x0D
\x0D
```Elm\x0D
import UrlParser exposing ((</>))\x0D
\x0D
update : Msg -> Model -> ( Model, Cmd Msg )\x0D
update msg model =\x0D
    case msg of\x0D
        UrlChange location ->\x0D
            { model | page = getPage location } ! [ Cmd.none ]\x0D
\x0D
getPage : Navigation.Location -> Page\x0D
getPage location =\x0D
    Maybe.withDefault AllPosts (UrlParser.parseHash route location)\x0D
\x0D
route : UrlParser.Parser (Page -> a) a\x0D
route =\x0D
    UrlParser.oneOf\x0D
        [ UrlParser.map Home UrlParser.top\x0D
        , UrlParser.map Post (UrlParser.s "blog" </> UrlParser.string)\x0D
        ]\x0D
```\x0D
\x0D
The update function is pretty straight forward, it process a `UrlChange Msg` and then parses the location to get the page type, which is stored in the model. The `getPage` function uses `UrlParser.parseHash` to process the location, generating a `Maybe Page`.\x0D
\x0D
`parseHash` takes a `UrlParser.Parser` type, in this case `route`. Route looks a bit weird, mainly due to `UrlParser.oneOf`, but essentially it just take a bunch of parsers and merges them together to make a super parser that when used will try each of the parsers it contains.\x0D
\x0D
The actual parsers themselves are the `(UrlParser.s "blog" </> UrlParser.string)` and `UrlParser.top` bits. The `Parser` takes URLs and converts them to data. `UrlParser.top` is pretty simple, it doesn't consume any segments from the path, and so will successfully parse if the URL if it has no additional segments. The `s` parser will parse a segment of the URL if it *exactly* matches a provided string, so `UrlParser.s "blog"` will parse `/blog/` but nothing else. `UrlParser.string` will successfully parse any segment that is a string. Finally, `UrlParser.</>` combines the parsers together, to make a parser that has to exactly match `blog` and then contain another segment that is a string. There are other parser types too, check out the [docs](http://package.elm-lang.org/packages/evancz/url-parser/2.0.1/UrlParser) for more details.\x0D
\x0D
The parser can then be applied to the location using either `parsePath` or `parseHash`, and will return `Just` *data* or `Nothing`. `UrlParser.map` is used to transform the data contained in the URL into a `Msg`. So, using this parser:\x0D
\x0D
```Elm\x0D
-- /                      ==> Just Home\x0D
-- /blog/my-gid-blog-post ==> Just (Post "my-gid-blog-post")\x0D
-- /blog                  ==> Nothing\x0D
```\x0D
\x0D
`UrlParser` is very powerful, and it isn't as complex to use as it is to explain. The best way to get a feel for how `UrlParser` works is to actually use it.\x0D
\x0D
Finally, the post type in the `model` can be used to alter content in the view when it's rendered:\x0D
\x0D
```Elm\x0D
view : Model -> Html Msg\x0D
view model = div [ id "mainSiteDiv", mainSiteDivStyle ]\x0D
    [ CommonViews.siteHeader\x0D
    , content model\x0D
    , CommonViews.siteFooter\x0D
    ]\x0D
\x0D
content : Model -> Html Msg\x0D
content model = div [ id "contentSection" ]\x0D
    [ getContent model\x0D
    ]\x0D
\x0D
getContent : Model -> Html Msg\x0D
getContent model =\x0D
    case model.page of\x0D
      Home -> home\x0D
      AllPosts -> postList\x0D
      Post title -> getBlogPost title\x0D
```\x0D
\x0D
There's one more bit of plumbing we need to do if this is to work properly. Previously I mentioned that the `init` was important. When I originally implemented the `init`, it looks like this:\x0D
\x0D
```Elm\x0D
init : Navigation.Location -> (Model, Cmd Msg)\x0D
init _ = ( Model Home, Cmd.none )\x0D
```\x0D
\x0D
As its `Navigation.program` it takes a `Navigation.Location` as an input, but I threw it away because I didn't know what to do with it. The model is simply initialised with the `Home` page. This works, if you went to the URL of my website it goes to the homepage. However, if you use with a hash location, like this https://chriswellswood.github.io/#blog/elm-static-site-p1, it would still go to the homepage. It's pretty obvious why this is happening, no `UrlChange` message is getting passed to the `update` function.\x0D
\x0D
To fix this, I changed the `init` function to look like this:\x0D
\x0D
```Elm\x0D
init : Navigation.Location -> (Model, Cmd Msg)\x0D
init location =\x0D
    ( Model Home\x0D
    , Task.perform identity (Task.succeed (UrlChange location))\x0D
    )\x0D
```\x0D
\x0D
This time, the model is the same, but the location is not thrown away. We need to send a command to pass `UrlChange` to the `update` function. To do this we wrap a `Msg` in a task that will always succeed and will return the `UrlChange`, and then identity is used to provide `UrlChange` to be passed to update after the task has been performed. The end result is that as soon as the website starts, the URL will be parsed and the correct content will be loaded.\x0D
\x0D
That's it for this post, but in the next post I'll discuss using ports and tasks to interact with Javascript, allowing us to format code in the posts and interact with Google Analytics.\x0D
\x0D
### References\x0D
\x0D
1. [SPA simple with Elm Navigation](https://medium.com/@nithstong/spa-simple-with-elm-navigation-630bdfdbef94#.om47asuv1) Pablo Fernández\x0D
1. UrlParser [documentation](http://package.elm-lang.org/packages/evancz/url-parser/2.0.1/) and [example](https://github.com/evancz/url-parser/blob/2.0.1/examples/Example.elm) by Evan Czaplicki.\x0D
"""
