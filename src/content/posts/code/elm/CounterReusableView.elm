module CounterReusableView exposing (..)

import Html exposing (..)
import Markdown
import Skeleton exposing (ContentMetaData, skeleton, blogPostView, contentUrl)


main =
    blogPostView metaData content
        |> skeleton


name : String
name =
    "creating-simple-reusable-view-modules"


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
    , title = "Creating a Simple Reusable View Module in Elm"
    , date = [ 2017, 1, 17 ]
    , description = "An updated version of an old example of how to scale your Elm app using modules, this time using reusable views rather than components."
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
*Check out the source code [here](https://github.com/ChrisWellsWood/elm-counters)*

There seems to be a lot of confusion about how to scale an Elm app, and in particular, how to break out functionality into generic, reusable elements. I first started using Elm at v0.16, and at that point there was a tutorial on how this should be achieved. It centred around creating a reusable counter *component* that managed its own updates, and then you used this to create list of Counters. However, leading up to v0.17 there was a shift away from reusable components towards reusable views.

Working with reusable components was quite awkward, and involved multiple update functions and relaying `msgs` to the correct place. Personally, I found it difficult to get my head around and I much prefer that the module simply contains functions to create views.

In this post, I'm going to reimplement the old counter example using a the reusable view pattern.

### The Counter App

We'll start with a little Counter app that's entirely self contained:

```Elm
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)


main = Html.program
  { init = init
  , view = view
  , update = update
  , subscriptions = (\\_ -> Sub.none)
  }

init : ( Model, Cmd Msg )
init = ( 0, Cmd.none )

-- MODEL

type alias Model = Int


-- UPDATE


type Msg = Increment | Decrement | Clear

update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
  case action of
    Increment ->
      ( model + 1, Cmd.none )

    Decrement ->
      ( model - 1, Cmd.none )

    Clear ->
      ( 0, Cmd.none )


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [ countStyle ] [ text (toString model) ]
    , button [ onClick Increment ] [ text "+" ]
    , button [ onClick Clear ] [ text "Clear" ]
    ]

countStyle : Attribute msg
countStyle =
  style
    [ ("font-size", "20px")
    , ("font-family", "monospace")
    , ("display", "inline-block")
    , ("width", "50px")
    , ("text-align", "center")
    ]
```

Here's what it looks like:

<iframe src="https://chriswellswood.github.io/elm-counters/counter.html"></iframe>

It's pretty straight forward, your model is simply an `Int` and the messages that update handles are `Increment`, `Decrement` and `Clear`. The model is used to create a view which displays the current count, as well as buttons for sending messages to the update function.

I think this is a pretty realistic starting point, as when I make an app in Elm, I make the core functional bit first and then expanded that into the full application.

### Counter List

Let's start making our counter list app. What we're aiming for is an app where we can dynamically add and remove counters. We need to change the structure of the counter module to accommodate this.

#### Reusable Counter View

To start with, we can get rid of most of the mechanical stuff that Elm needs: the main function `Html.program`, `init` and `update`. We'll rename the model to `CounterModel`, just to be explicit and avoid confusion.

Our update function has been replaced by a helper method that deals with modifying the counters:

```Elm
type CounterModifier = Increment | Decrement | Clear

modifyCounter : CounterModifier -> CounterModel -> CounterModel
modifyCounter counterModifier counterModel =
  case counterModifier of
    Increment -> counterModel + 1
    Decrement -> counterModel - 1
    Clear -> 0
```

It looks quite like an update function, but doesn't pass messages or commands. Our different counter operations have been defined using a union type. `modifyCounter` takes a `CounterModel` and a modifier command and returns a new model.

Next up we have the view for our counter:

```Elm
viewCounter : Config msg -> CounterModel -> Html msg
viewCounter (Config { modifyMsg, removeMsg }) counterModel =
  div []
    [ button [ onClick (modifyMsg Decrement) ] [ text "-" ]
    , div [ countStyle ] [ text (toString counterModel) ]
    , button [ onClick (modifyMsg Increment) ] [ text "+" ]
    , button [ onClick (modifyMsg Clear) ] [ text "Clear" ]
    , button [ onClick (removeMsg) ] [ text "Remove" ]
    ]
```

This looks quite familiar, but it's slightly more complicated than before. Firstly, we've added an extra button to remove the counter, but that's pretty straight forward. Now that the counter is not handling it's own update, it needs to give the `onClick` event a `Msg` from the module that's calling it, which will be our `CounterList` app. We're passing in the messages from the module that's using the counter in a `Config` type, let's take a look at that:

```Elm
type Config msg =
  Config
    { modifyMsg : (CounterModifier -> msg)
    , removeMsg : msg
    }

config
  : { modifyMsg : (CounterModifier -> msg)
    , removeMsg : msg
    }
  -> Config msg
config { modifyMsg, removeMsg } =
  Config
    { modifyMsg = modifyMsg
    , removeMsg = removeMsg
    }
```

This looks a bit weird, but it makes sense if we break it down. First, we define a sort of "generic" type, it takes a type and returns a new type that uses the input type. In this case we pass in a `msg`, which will be our `Msg` union type from our CounterList app. The function annotations are suited to the type of message: the `modifyMsg` will be used to pass a `CounterModifier` to the `modifyCounter` function in our main app. We then define a config function which takes our messages and returns a `Config` type.

That's all the changes to the counter itself, now we can make something with it!

#### Counter List

The app itself is pretty basic, we use the standard `Html.program`. The model looks like this:

```Elm
import ReusableCounter exposing (..)

type alias Model =
  { counterDict : CounterDict
  , currentCounterID : CounterID
  }

type alias CounterDict = Dict.Dict CounterID CounterModel

type alias CounterID = Int
```

It contains `counterDict`, a dictionary with a `CounterID` as the key and a `CounterModel` as the value, and `currentCounterID` where the last used `CounterID` is stored.

Our update is pretty simple too:

```Elm
type Msg
  = AddCounter
  | ModifyCounter CounterID CounterModifier
  | RemoveCounter CounterID
```

We handle 3 messages, 2 of which - `ModifyCounter` and `RemoveCounter` - are required by the `ReusableCounter` module. Remember the `Config` above expected messages that had those type annotations? The messages are modified to contain a CounterID before being passed to the counter module, so the CounterID isn't in the `Config` annotation.

```Elm
update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
  case action of
    AddCounter ->
      let
        nextID = model.currentCounterID + 1
        newModel =
          { counterDict = Dict.insert nextID 0 model.counterDict
          , currentCounterID = nextID
          }
      in
        ( newModel, Cmd.none )

    ModifyCounter counterID modifier ->
      let
        clickedCounter = Dict.get counterID model.counterDict
      in
        case clickedCounter of
          Just counter ->
            ( { model | counterDict =
              Dict.insert counterID (modifyCounter modifier counter) model.counterDict }
            , Cmd.none )
          Nothing ->
            ( model, Cmd.none )

    RemoveCounter counterID ->
        ( { model | counterDict = Dict.remove counterID model.counterDict }, Cmd.none )
```

`AddCounter` just adds a new `CounterModel` to our dictionary, using the next ID that's free as the key.

Our `ModifyCounter` message takes a modifier type, from the `ReusableCounter` module, and a `CounterID`. The `CounterID` is used to get the relevant counter and is passed to the `modifyCounter` function from the `ReusableCounter` module. After this, the `counterDict` field is updated in the model.

`RemoveCounter` receives a `CounterID` that needs to be removed, and uses `Dict.remove` to create a new Dict without that counter.

Lastly, we have our main view:

```Elm
view : Model -> Html Msg
view model =
  div []
    [ div [] [ button [ onClick AddCounter ] [ text "Add Counter" ] ]
    , div [] (List.map makeView (Dict.toList model.counterDict))
    ]

makeView : (CounterID, CounterModel) -> Html Msg
makeView (refID, counterModel) =
  let
    counterConfig =
      config
        { modifyMsg = ModifyCounter refID
        , removeMsg = RemoveCounter refID
        }
  in
    viewCounter counterConfig counterModel
```

It has a button to add counters and uses the `viewCounter` function from `ReusableCounter` module to generate the views for each of the counters. This function needs to be passed a `Config`, which we make using the `config` function from `ReusableCounter`, giving it our `ModifyCounter` and `RemoveCounter` messages, modified with the relevant `CounterID`s.

Done and dusted! Using this basic approach, you can make modular, composable units, while all your update logic remains in one place. You don't need to bother passing `Msg`s around, you just have views and functions to help create views.

Here's the final `CounterList` application:

<iframe src="https://chriswellswood.github.io/elm-counters/counter-list.html"></iframe>

Feel free to ask questions or share your thoughts on this over on Twitter ([@ChrisWellsWood](https://twitter.com/ChrisWellsWood))!

*Many thanks to [/u/wintvelt](https://www.reddit.com/user/wintvelt) for some great suggestions on improvements to the code.*
"""
