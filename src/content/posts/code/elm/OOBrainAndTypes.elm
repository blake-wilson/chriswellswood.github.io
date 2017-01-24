module OOBrainAndTypes exposing (..)

import Html exposing (..)
import Markdown
import Types exposing (ContentMetaData)


name : String
name =
    "object-oriented-brain-and-types"


metaData : ContentMetaData msg
metaData =
    { name = name
    , title = "Object-Oriented Brain and Types"
    , date = [ 2016, 8, 29 ]
    , description = "An intro to types and type aliases in Elm."
    , category = "Code"
    , subcategory = "Elm"
    , url = "#blog/" ++ name
    , content = content
    }


content : Html msg
content =
    Markdown.toHtml [] rawContent


rawContent : String
rawContent =
    """\x0D
I'm not embarrassed to admit that it took me a fair amount of time to get my head around object-oriented programming. For a long time I just couldn't figure out why it was a useful thing. That's probably got something to do with my background as a research scientist, and the type of problems I originally tackled during the first few weeks and months after I started learning to code.\x0D
\x0D
After a while of staring at examples and messing about with classes in Python, it eventually clicked for me. A funny thing happened in between finally grasping the idea of objects and now… my brain has become object oriented.\x0D
\x0D
There is a concept known as the law of the instrument, which was most famously expressed by Abraham Maslow as follows:\x0D
\x0D
> I suppose it is tempting, if the only tool you have is a hammer, to treat everything as if it were a nail."\x0D
\x0D
I now see most problems when I'm programming in terms of objects - "Oh I'll take that data and store it in this object, and it can interact with this, this and this though these methods, and it'll have these properties and some nice class methods and I'll chuck in this static method too". Now I don't think that this is inherently a bad thing, sure it can be taken to absurd extremes†, but most of the time I think what I come up with is a decent solution that can be easily followed, modified, tested etc.\x0D
\x0D
What happens if you're using a language that doesn't contain objects? I'm not taking about something like Rust where there's not objects, but there sort of are really, you can glue together structs and functions using the impl keyword and traits. Okay I'm probably over simplifying that, my Rust* isn't great but that's the way it seemed to me. In Elm there are no objects, but there are types…\x0D
\x0D
Elm has strong, static typing. This means that all data in Elm has a type, and that type is used to dictate what you can do with that data. The compiler will tell you if you've used an Int in a function that expects a String. The compiler can tell from your source code, exactly how data flows through your program, and can tell how everything should connect together. If you pass the wrong type of data to a function, the compiler will tell you long before you run your code as it knows  what the type of the function is (more on this later) and the type of your data. This avoids many of the unexpected behaviours that arise when you're using languages that aren't statically typed, and particularly when you're working with a language like JavaScript or Python where you have duck typing.\x0D
\x0D
What does static typing have to do with objects? Well in Elm you can define your own types, and these types represent complex data in the same way that objects can in OOP. Types in Elm can be defined using some simple tools: type annotations and type aliases.\x0D
\x0D
If we use the Elm repl, we can see the types of values easily:\x0D
\x0D
```Elm\x0D
> "This is a string"\x0D
"This is a string" : String\x0D
\x0D
> 2.71828\x0D
2.71828 : Float\x0D
\x0D
> 123\x0D
123 : number\x0D
\x0D
> [1, 2, 3, 4, 5]\x0D
[1,2,3,4,5] : List number\x0D
\x0D
> [True, False, True]\x0D
[True,False,True] : List Bool\x0D
\x0D
> []\x0D
[] : List a\x0D
\x0D
> floor\x0D
<function:floor> : Float -> Int\x0D
\x0D
> addX s = s ++ "X"\x0D
<function> : String -> String\x0D
\x0D
> \\n -> n * 2\x0D
<function> : number -> number\x0D
\x0D
> (\\n -> n * 2) 4\x0D
8 : number\x0D
\x0D
> \\x y -> x ^ (y - 1)\x0D
<function> : number -> number -> number\x0D
```\x0D
\x0D
When you type an expression in the repl, the type of the evaluated expression is displayed immediately after (in the format "data : type". Most of this seems obvious, you have strings and their types are strings, or a number of type number or slightly more complicated you have lists which are of the types List "something", like List String or List Bool. You can even have lists of a generic type (see the empty list on line 16). There's something odd though…\x0D
\x0D
Let's look at the type of a function, for example floor on line 19, it has a type of Float -&gt; Int. This means that the type of the function is defined by the type of its input argument and the type that it returns. The type signature looks a lot like you define an anonymous function in Elm, using the syntax on line 25, and that's not a coincidence. I won't go into why this is here, but it's a pretty fundamental part of the language that I'll discuss in a later post.\x0D
\x0D
As you can see in the example, Elm can infer the types of data a function will receive, but you can explicitly state them using type annotations using the same syntax as the type signature:\x0D
\x0D
```Elm\x0D
doubleIt : number -> number\x0D
doubleIt n = n * 2\x0D
\x0D
import String\x0D
\x0D
stringify : number -> String\x0D
stringify n = toString n\x0D
\x0D
addX : String -> String\x0D
addX s = s ++ "X"\x0D
\x0D
addX : String -> Int\x0D
addX s = s ++ "X"\x0D
-- This raises a error on compilation\x0D
\x0D
powerMinusOne : number -> number -> number\x0D
powerMinusOne x y = x ^ (y - 1)\x0D
\x0D
getFileExtension : { name : String, path : String } -> String\x0D
getFileExtension rec = String.right 4 rec.name\x0D
\x0D
-- With no type annotation on get file the type sig is:\x0D
-- <function> : { a | name : String } -> String\x0D
```\x0D
\x0D
As you can see in line 12, you can't lie to the compiler, I checks the types even if you've annotated them. So that's all fine, but what if you want to pass more complex data to a function using records? Well you need to annotate the type of the record, and specify the types of all its component data. You can see this on lines 19 and 20. The record that's being passed into the function is relatively simple, what if you have lots of data in the record? Well no worries, let's just not annotate the type, and the compiler can infer the type. If you do that in the Elm repl you get the type signature on line 23. This shows that the function will take any generic type with that contains a ".name" field. This sucks! Everything should be more explicit, that'd make it easier to read. In the words of Raymond Hettinger "There must be a better way!", and of course there is. We can use type aliases to make this more readable, concise and maintainable. \x0D
\x0D
```Elm\x0D
import String\x0D
import Html\x0D
import List\x0D
\x0D
type alias Person = { name : String\x0D
  , access : List String }\x0D
\x0D
type alias Location = String\x0D
\x0D
ee1 = { name = "Ian Beal"\x0D
  , access = ["Caff", "Laundrette"] }\x0D
\x0D
ee2 = { name = "Pat Butcher"\x0D
  , access = ["Queen Vic", "The Market"] }\x0D
\x0D
requestAccess : Person -> Location -> Bool\x0D
requestAccess person location = if List.member location person.access\x0D
  then True\x0D
  else False\x0D
\x0D
requestAccess ee1 "Caff"\x0D
-- Returns True\x0D
\x0D
requestAccess ee1 "Queen Vic"\x0D
-- Returns False\x0D
\x0D
requestAccess ee2 "Queen Vic"\x0D
-- Returns True\x0D
\x0D
requestAccess { name = "Ian Beal", access = ["Caff", "Laundrette"] } "Caff"\x0D
-- Returns True\x0D
\x0D
requestAccess { access = ["Caff", "Laundrette"] } "Caff"\x0D
-- Raises error on compilation\x0D
```\x0D
\x0D
You can see the type aliases on line 5/6 and line 8. 5/6 shows a type alias of a Record with a name and an access field and 8 is an alias of a String. We then add a type annotation to the requestAccess function. This function takes a "Person" and a "Location" type, then returns a bool if they're allowed access. You can annotate any type, but you must remember that it doesn't do anything special, it merely is a form of shorthand for the annotations.\x0D
\x0D
Type aliases are much lighter weight than objects in most languages, but I think that maybe they're a bit more transparent too. Pretty neat!\x0D
\x0D
Update: There are also type unions, which as the name suggests groups types together, but I'll go into more depth about those in another post.\x0D
\x0D
Note: Most of the examples here are based on the Elm docs regarding types, check them out [here](https://guide.elm-lang.org/types/).\x0D
\x0D
\x0D
† - I love this article by Steve Yegge where he describes a terrifying world where there are only objects http://steve-yegge.blogspot.co.uk/2006/03/execution-in-kingdom-of-nouns.html\x0D
\x0D
\\* - Rust is cool, I like it for the same main reason I like Elm; it has a clear domain except it's systems programming not web development. I might write some posts on it at some point.\x0D
"""
