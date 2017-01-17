module CounterReusableView exposing (..)

import Html exposing (..)
import Markdown

import Types exposing (ContentMetaData)

name : String
name = "creating-simple-reusable-view-modules"

metaData : ContentMetaData msg
metaData =
    { name = name
    , title = "Creating a Simple Reusable View Module in Elm"
    , date = [2016, 08, 25]
    , description = "An updated version of an old example of how to scale your Elm app using modules, this time using reusable views rather than components."
    , category = "Code"
    , subcategory = "Elm"
    , url = "#blog/" ++ name
    , content = content
    }

content : Html msg
content = Markdown.toHtml [] rawContent

rawContent: String
rawContent = """
There seems to be a lot of confusion about how to scale an Elm app, and in particular, how to break out functionality into generic, reusable elements. I first started using Elm at v0.16, and at that point there was a tutorial on how this should be done. It centred around creating a reusable counter *component* that managed its own updates, and then you used this to create list of Counters. However, leading up to v0.17 there was a shift away from reusable components towards reusable views.

Working with reusable components was quite awkward, and involved multiple update functions and relaying `msgs` to the correct place. Personally, I found it difficult to get my head around and I much prefer that the module simply contains functions to create views.

In this post, I'm going to reimplement the old counter example using a reusable views.

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
  , subscriptions = (\_ -> Sub.none)
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

To start with, we can get rid of most of the mechanical stuff that Elm needs: the main function `Html.program`, `init` and `update`. We'll rename the model to `CounterModel`, just to be explicit and avoid confusion. I'm also going to tweak the model a bit:

```Elm
type alias CounterModel =
  { currentCount : Int
  , refID : CounterID
  }

type alias CounterID = Int

newCounter : CounterID -> CounterModel
newCounter refID = CounterModel 0 refID
```

We've changed it to be a record with the count as before but also a reference ID. We'll need the reference ID later to be able to keep track of our counters. We also have a type alias for our counter ID, to help us keep track of everything, as well as a convenience function for making a new counter.

Our update function has been replaced by a helper method that deals with modifying the counters:

```Elm
type CounterModifier = Increment | Decrement | Clear

modifyCounter : CounterModifier -> CounterModel -> CounterModel
modifyCounter counterModifier counterModel =
  case counterModifier of
    Increment -> { counterModel | currentCount = counterModel.currentCount + 1 }
    Decrement -> { counterModel | currentCount = counterModel.currentCount - 1 }
    Clear -> { counterModel | currentCount = 0 }
```

It looks quite like an update function, but doesn't pass messages or commands. Our different counter operations have been defined using a union type. `modifyCounter` takes a `CounterModel` and a modifier command and returns a new model.

Next up we have the view for our counter:

```Elm
viewCounter : Config msg -> CounterModel -> Html msg
viewCounter (Config { modifyMsg, removeMsg }) counterModel =
  div []
    [ button [ onClick (modifyMsg Decrement counterModel.refID) ] [ text "-" ]
    , div [ countStyle ] [ text (toString counterModel.currentCount) ]
    , button [ onClick (modifyMsg Increment counterModel.refID) ] [ text "+" ]
    , button [ onClick (modifyMsg Clear counterModel.refID) ] [ text "Clear" ]
    , button [ onClick (removeMsg counterModel.refID) ] [ text "Remove" ]
    ]
```

This looks quite familiar, but it's slightly more complicated than before. Firstly, we've added an extra button to remove the counter and all the modifiers now take our new counter IDs, but that's pretty straight forward. Now that the counter is not handling it's own update, it needs to give the `onClick` event a `Msg` from the module that's calling it, which will be our CounterList app. We're passing in the messages from the module that's using the counter in a `Config` type, let's take a look at that:

```Elm
type Config msg =
  Config
    { modifyMsg : (CounterModifier -> CounterID -> msg)
    , removeMsg : (CounterID -> msg)
    }

config
  : { modifyMsg : (CounterModifier -> CounterID -> msg)
    , removeMsg : (CounterID -> msg)
    }
  -> Config msg
config { modifyMsg, removeMsg } =
  Config
    { modifyMsg = modifyMsg
    , removeMsg = removeMsg
    }
```

This looks a bit weird, but it makes sense if we break it down. First, we define a sort of "generic" type, it takes a type and returns a new type that uses the input type. In this case we pass in a `msg`, which will be our `Msg` union type from our CounterList app. The function annotations are suited to the type of message: the `modifyMsg` will be used to pass a `CounterModifier` and a `CounterID` to the `modifyCounter` function in our main app. The `removeMsg` only requires the `CounterID` of the counter to be removed. We then define a config function which takes our messages and returns a `Config` type.

That's all the changes to the counter itself, now we can make something with it!

#### Counter List

The app itself is pretty basic, we use the standard `Html.program`. The model looks like this:

```Elm
import ReusableCounter exposing (..)

type alias Model =
  { counterList : List CounterModel
  , currentCounterID : CounterID
  }
```

It contains a list of `CounterModel`s and the next free `CounterID`, both of these types are from the `ReusableCounter` module we defined previously.

Our update is pretty simple too:

```Elm
type Msg 
  = AddCounter
  | ModifyCounter CounterModifier CounterID
  | RemoveCounter CounterID
```

We handle 3 messages, 2 of which, `ModifyCounter` and `RemoveCounter` are required by the `ReusableCounter` module. Remember the `Config` above expected messages that had those type annotations?

```Elm
update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
  case action of
    AddCounter ->
      let
        nextID = model.currentCounterID + 1
        newModel =
          { counterList = ( newCounter nextID ) :: model.counterList
          , currentCounterID = nextID
          }
      in
        ( newModel, Cmd.none )
    
    ModifyCounter modifier counterID ->
      let
        counterList = List.map (updateCounterList modifier counterID) model.counterList
      in
        ( { model | counterList = counterList }, Cmd.none )
    
    RemoveCounter counterID ->
      let
        counterList = List.filter (\cntr -> cntr.refID /= counterID) model.counterList
      in
        ( { model | counterList = counterList }, Cmd.none )

updateCounterList : CounterModifier -> CounterID -> CounterModel -> CounterModel
updateCounterList modifier targetID counter =
  if targetID == counter.refID then
    modifyCounter modifier counter
  else
    counter
```

`AddCounter` just adds a new `CounterModel` to our list, giving it the next ID that's free.

Our `ModifyCounter` message takes a modifier type and a `CounterID`, both of which are from the `ReusableCounter` module. To modify the correct counter, we use the `updateCounterList` function, which will run the `modifyCounter` function from the `ReusableCounter` module on the counter, only if the reference and target IDs match, otherwise it will return the counter unchanged. After this, the `counterList` field is updated in the model.

`RemoveCounter` receives a `CounterID` that needs to be removed, and filters the list of counters for all the ones that *do not* have that ID. This results with a new list that does not contain the counter that was to be removed.

Lastly, we have our main view:

```Elm
view : Model -> Html Msg
view model =
  div []
    [ div [] [ button [ onClick AddCounter ] [ text "Add Counter" ] ]
    , div [] (List.map makeView model.counterList)
    ]

counterConfig : Config Msg
counterConfig =
  config
    { modifyMsg = ModifyCounter
    , removeMsg = RemoveCounter
    }

makeView : CounterModel -> Html Msg
makeView counterModel = viewCounter counterConfig counterModel
```

It has a button to add counters and uses the `viewcounter` function from `ReusableCounter` module to generate the views for each of the counters. This function needs to be passed a `Config`, which we make using the config function from `ReusableCounter`, giving it our `ModifyCounter` and `RemoveCounter` messages.

Done and dusted! Using this basic approach, you can make modular, composable units, but all your update code is in a single place. You don't need to bother passing `Msg`s around, you just have views and functions to help create views.

Here's the final `CounterList` application:

<iframe src="https://chriswellswood.github.io/elm-counters/counter-list.html"></iframe>

Feel free to ask questions or share your thoughts on this over on Twitter ([@ChrisWellsWood](https://twitter.com/ChrisWellsWood))!
```