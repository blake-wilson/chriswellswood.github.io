module OOBrainAndTypes exposing (..)

import Html exposing (..)
import Markdown

import Types exposing (ContentMetaData)

name : String
name = "object-oriented-brain-and-types"

metaData : ContentMetaData msg
metaData =
    { name = name
    , title = "Object-Oriented Brain and Types"
    , date = [2016, 08, 29]
    , description = "An intro to types and type aliases in Elm."
    , category = "Code"
    , subcategory = "Elm"
    , url = "#blog/" ++ name
    , content = content
    }

content : Html msg
content = Markdown.toHtml [] rawContent

rawContent: String
rawContent = """
I'm not embarrassed to admit that it took me a fair amount of time to get my head around object-oriented programming. For a long time I just couldn't figure out why it was a useful thing. That's probably got something to do with my background as a research scientist, and the type of problems I originally tackled during the first few weeks and months after I started learning to code.

After a while of staring at examples and messing about with classes in Python, it eventually clicked for me. A funny thing happened in between finally grasping the idea of objects and now… my brain has become object oriented.

There is a concept known as the law of the instrument, which was most famously expressed by Abraham Maslow as follows:

> I suppose it is tempting, if the only tool you have is a hammer, to treat everything as if it were a nail."

I now see most problems when I'm programming in terms of objects - "Oh I'll take that data and store it in this object, and it can interact with this, this and this though these methods, and it'll have these properties and some nice class methods and I'll chuck in this static method too". Now I don't think that this is inherently a bad thing, sure it can be taken to absurd extremes†, but most of the time I think what I come up with is a decent solution that can be easily followed, modified, tested etc.

What happens if you're using a language that doesn't contain objects? I'm not taking about something like Rust where there's not objects, but there sort of are really, you can glue together structs and functions using the impl keyword and traits. Okay I'm probably over simplifying that, my Rust* isn't great but that's the way it seemed to me. In Elm there are no objects, but there are types…

Elm has strong, static typing. This means that all data in Elm has a type, and that type is used to dictate what you can do with that data. The compiler will tell you if you've used an Int in a function that expects a String. The compiler can tell from your source code, exactly how data flows through your program, and can tell how everything should connect together. If you pass the wrong type of data to a function, the compiler will tell you long before you run your code as it knows  what the type of the function is (more on this later) and the type of your data. This avoids many of the unexpected behaviours that arise when you're using languages that aren't statically typed, and particularly when you're working with a language like JavaScript or Python where you have duck typing.

What does static typing have to do with objects? Well in Elm you can define your own types, and these types represent complex data in the same way that objects can in OOP. Types in Elm can be defined using some simple tools: type annotations and type aliases.

If we use the Elm repl, we can see the types of values easily:

```Elm
> "This is a string"
"This is a string" : String

> 2.71828
2.71828 : Float

> 123
123 : number

> [1, 2, 3, 4, 5]
[1,2,3,4,5] : List number

> [True, False, True]
[True,False,True] : List Bool

> []
[] : List a

> floor
<function:floor> : Float -> Int

> addX s = s ++ "X"
<function> : String -> String

> \\n -> n * 2
<function> : number -> number

> (\\n -> n * 2) 4
8 : number

> \\x y -> x ^ (y - 1)
<function> : number -> number -> number
```

When you type an expression in the repl, the type of the evaluated expression is displayed immediately after (in the format "data : type". Most of this seems obvious, you have strings and their types are strings, or a number of type number or slightly more complicated you have lists which are of the types List "something", like List String or List Bool. You can even have lists of a generic type (see the empty list on line 16). There's something odd though…

Let's look at the type of a function, for example floor on line 19, it has a type of Float -&gt; Int. This means that the type of the function is defined by the type of its input argument and the type that it returns. The type signature looks a lot like you define an anonymous function in Elm, using the syntax on line 25, and that's not a coincidence. I won't go into why this is here, but it's a pretty fundamental part of the language that I'll discuss in a later post.

As you can see in the example, Elm can infer the types of data a function will receive, but you can explicitly state them using type annotations using the same syntax as the type signature:

```Elm
doubleIt : number -> number
doubleIt n = n * 2

import String

stringify : number -> String
stringify n = toString n

addX : String -> String
addX s = s ++ "X"

addX : String -> Int
addX s = s ++ "X"
-- This raises a error on compilation

powerMinusOne : number -> number -> number
powerMinusOne x y = x ^ (y - 1)

getFileExtension : { name : String, path : String } -> String
getFileExtension rec = String.right 4 rec.name

-- With no type annotation on get file the type sig is:
-- <function> : { a | name : String } -> String
```

As you can see in line 12, you can't lie to the compiler, I checks the types even if you've annotated them. So that's all fine, but what if you want to pass more complex data to a function using records? Well you need to annotate the type of the record, and specify the types of all its component data. You can see this on lines 19 and 20. The record that's being passed into the function is relatively simple, what if you have lots of data in the record? Well no worries, let's just not annotate the type, and the compiler can infer the type. If you do that in the Elm repl you get the type signature on line 23. This shows that the function will take any generic type with that contains a ".name" field. This sucks! Everything should be more explicit, that'd make it easier to read. In the words of Raymond Hettinger "There must be a better way!", and of course there is. We can use type aliases to make this more readable, concise and maintainable. 

```Elm
import String
import Html
import List

type alias Person = { name : String
  , access : List String }

type alias Location = String

ee1 = { name = "Ian Beal"
  , access = ["Caff", "Laundrette"] }

ee2 = { name = "Pat Butcher"
  , access = ["Queen Vic", "The Market"] }

requestAccess : Person -> Location -> Bool
requestAccess person location = if List.member location person.access
  then True
  else False

requestAccess ee1 "Caff"
-- Returns True

requestAccess ee1 "Queen Vic"
-- Returns False

requestAccess ee2 "Queen Vic"
-- Returns True

requestAccess { name = "Ian Beal", access = ["Caff", "Laundrette"] } "Caff"
-- Returns True

requestAccess { access = ["Caff", "Laundrette"] } "Caff"
-- Raises error on compilation
```

You can see the type aliases on line 5/6 and line 8. 5/6 shows a type alias of a Record with a name and an access field and 8 is an alias of a String. We then add a type annotation to the requestAccess function. This function takes a "Person" and a "Location" type, then returns a bool if they're allowed access. You can annotate any type, but you must remember that it doesn't do anything special, it merely is a form of shorthand for the annotations.

Type aliases are much lighter weight than objects in most languages, but I think that maybe they're a bit more transparent too. Pretty neat!

Update: There are also type unions, which as the name suggests groups types together, but I'll go into more depth about those in another post.

Note: Most of the examples here are based on the Elm docs regarding types, check them out [here](https://guide.elm-lang.org/types/).


† - I love this article by Steve Yegge where he describes a terrifying world where there are only objects http://steve-yegge.blogspot.co.uk/2006/03/execution-in-kingdom-of-nouns.html

\\* - Rust is cool, I like it for the same main reason I like Elm; it has a clear domain except it's systems programming not web development. I might write some posts on it at some point.
"""