module ElmStaticSiteP2 exposing (..)

import Html exposing (..)
import Markdown
import Skeleton exposing (ContentMetaData, skeleton, blogPostView, contentUrl)


main =
    blogPostView metaData content
        |> skeleton


name : String
name =
    "elm-static-site-p2"


group : String
group =
    "Blog"


category : String
category =
    "Code"


subcategory : String
subcategory =
    "Elm"


metaData : ContentMetaData
metaData =
    { name = name
    , title = "Tools for Handling Static Pages in Elm - Part 2. Ports, Google Analytics and Highlight.js"
    , date = [ 2017, 1, 28 ]
    , description = "How to communicate with external JavaScript libraries using ports."
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
In a [previous article](#blog/elm-static-site-p1), I discussed making a single-page web app in Elm that mainly uses static content, based on my experience making this site. The next thing I wanted to do to the site was add Google Analytics. I wanted to track page views, partly because I'm nosey, but mainly as I thought this might allow me to refine my content a bit. It's free to set up an account, and works by adding a little bit of JavaScript to your pages. To hook this up to our Elm app, we need to use ports.

Elm can communicate with JavaScript by sending data through constructs called ports. This means that the JavaScript is isolated from the Elm application, and so you still get all of the normal guarantees you'd expect with Elm. I like this mode of interopt, as it means that you're protected in a lovely bubble of predictable Elm, from all that chaotic JavaScript.

Before we start, if you're planning to do this, make sure you are compiling your Elm app to JavaScript and embedding it in HTML, rather than compiling straight to HTML. This is pretty easy to do and is covered in the [Elm guide](https://guide.elm-lang.org/interop/javascript.html).

### Setting up the Port

Google give you a bit of JavaScript to paste into your page that looks like this:

```Javascript
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-XXXXXXXX-X', 'auto');
  ga('send', 'pageview'); // we don't want this!
```

But this will only send a page view on load. As we are using fragment identifiers, i.e. "www.boblaw.com/**#lawblog**", to select our pages, we need to explicitly set the page like this:

```Javascript
ga('set', 'page', 'www.boblaw.com/#lawblog');
ga('send', 'pageview');
```

We need to run this code when we change a page, and we'll need to pass a String containing the relevant url.

To make a JavaScript port, you need to define it in your Elm app using the port keyword, both when exposing your module and to explicitly create the port:

```Elm
port module Index exposing (..)

...

port analytics : String -> Cmd msg
```

Ports use regular Elm commands and subscriptions. If we're only sending data out, it's a command, and if we're getting data back, it's a subscription. We aren't needing any data back, so we have the simpler case here.

To trigger this command when we change the location on the site, we need to change our update function, which I described in a [previous article](#blog/elm-static-site-p1). It looked like this:

```Elm
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            { model | page = getPage location } ! [ Cmd.none ]
```

Previously we had no commands, but now we want to send data through our port:

```Elm
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            { model | page = getPage location } ! [ analytics location.href ]
```

We take the full URL from the `Navigation.Location` record, which includes the current hash location. That's all that's required on the Elm side, now we need to connect it up to the JavaScript.

### Setting up the HTML file

Before, our HTML file looked roughly like this:

```Html
<!DOCTYPE HTML>
<html>

<head>
  <meta charset="UTF-8">
  <title>Bits and Pieces and Odds and Ends</title>
  <script type="text/javascript" src="index.js"></script>

  <link rel="stylesheet" href="css/style.css">
</head>

<body>
</body>

<div id="main"></div>
<script type="text/javascript">
    var node = document.getElementById('main');
    var app = Elm.Index.embed(node);
</script>

</html>
```

Our Elm app compiles down to a file called `index.js`, which is embedded into the page. We need to add the Google Analytics code so we can start tracking page views:

```Html
<head>
  ...
  <script>
    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

    ga('create', 'UA-XXXXXXXX-X', 'auto');
  </script>
</head>
...
```

`UA-XXXXXXXX-X` is the tracking ID that you get when you set up your Google Analytics account, so it varies from person to person. Here we create the session, but we don't trigger any page views yet.

Now we need to add the JavaScript that will run when we trigger our Elm port command:

```Html
...
<div id="main"></div>
<script type="text/javascript">
    var node = document.getElementById('main');
    var app = Elm.Index.embed(node);

    app.ports.analytics.subscribe(
      function (pageUrl) {
        ga('set', 'page', pageUrl);
        ga('send', 'pageview');
      }
    );
</script>

</html>
```

Let's break that down a bit. `app.ports.analytics` refers to the port that we created in our app. We subscribe to the event, which is triggered by the `analytics` command, providing a  function that will be run when the event is triggered. This function takes a string, `pageUrl`, which we pass into this function through the port in our Elm app. This is used to set the currently active page through the Google Analytics API, then we send off the page view to be recorded. Pretty easy!

### Explicitly Highlighting Code with `highlight.js`

This works with any external JavaScript API, for example, all the highlighting for the code in this article is performed using [`highlight.js`](https://highlightjs.org/), and the highlighting function is triggered in a similar way. Let's look at how that's connected up.

First we make our port:

```Elm
port highlightMarkdown : () -> Cmd msg
```

Then we trigger the command in our update:

```Elm
type Msg
    = UrlChange Navigation.Location
    | Highlight ()


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            { model | page = getPage location } !
                [ Task.perform Highlight (Process.sleep (100 * Time.millisecond))
                , analytics location.href ]

        Highlight _ ->
            ( model, highlightMarkdown () )
```

We've added a couple of things here because we need to add a delay before we trigger the highlight command, allowing the DOM to be rendered first. We have a new `Highlight Msg` to handle this, which is triggered after a sleep process is performed. `Process.sleep` doesn't return anything, so the `Highlight Msg` takes an empty tuple as an argument. All the `Highlight Msg` does is trigger the `highlightMarkdown` port command, which doesn't require any input variables, and so it also takes an empty tuple.

On the HTML side we need a few things:

```Html
<!DOCTYPE HTML>
<html>

<head>
  ...
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>

  <!-- Markdown Highlighting -->
  <link rel="stylesheet" href="css/github.css">
  <script src="js/highlight.pack.js"></script>
  ...
</head>

<body>
</body>

<div id="main"></div>
<script type="text/javascript">
    var node = document.getElementById('main');
    var app = Elm.Index.embed(node);

    app.ports.highlightMarkdown.subscribe(
      function () {
        highlightCodeBlocks();
      }
    );

    function highlightCodeBlocks() {
      $('pre code').each(function(i, block) {
        hljs.highlightBlock(block);
      });
    };

    app.ports.analytics.subscribe(
      function (pageUrl) {
        ga('set', 'page', pageUrl);
        ga('send', 'pageview');
      }
    );

</script>

</html>
```

Again we trigger a function by subscribing to the `app.ports.highlightMarkdown` port. I then use jQuery to grab the relevant divs and highlight them using `highlight.js`. Using this method, we can dynamically add content to the page and then highlight the code.

That's it for this post, take a look at the source code for this site [here](https://github.com/ChrisWellsWood/chriswellswood.github.io), and feel free to ask questions on Twitter if you have any.
"""
