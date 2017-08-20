module Carpyt exposing (..)

import Html exposing (..)
import Markdown
import Types exposing (ContentMetaData)


name : String
name =
    "carpyt"


metaData : ContentMetaData msg
metaData =
    { name = name
    , title = "Carpyt, a module creation tool for Python."
    , date = [ 2017, 8, 19 ]
    , description = "Making modules in Python is hard, carpyt make it easier!"
    , category = "Code"
    , subcategory = "Python"
    , url = "#blog/" ++ name
    , content = Just content
    }


content : Html msg
content =
    Markdown.toHtml [] rawContent


rawContent : String
rawContent =
    """
I've started a new project called **carpyt**, it's a program that makes it easy to write Python modules. In this article, I'll give a little bit of information about why I started writing **carpyt**, what problems it seeks to address and then a bit of info about the application itself.

I've not talked about it here, or on any of my videos really, but in my day job I'm a research scientist. I research protein structure and folding, mainly from the perspective of protein design. While I do still go into the lab from time to time, I spend most of my day writing software to aid protein design. If you're interested, take a look at, at [ISAMBARD](https://github.com/woolfson-group/isambard) or [CCBuilder 2.0](https://github.com/woolfson-group/ccbuilder2).

One of the things I've been doing for the project recently was building binary `whl` files so I could distribute the software through PyPi. If you're not familiar with this, when a Python package has compiled modules, you can make precompiled builds for Windows, MacOS and Linux, so that people don't need to compile the module themselves. The whole process is a bit awkward, but the worst part is getting the structure for your project right to begin with. If you do have the correct structure, everything else becomes much easier.

One of my favourite features in Rust is `cargo`, it makes it really easy to start a project, compile it, run it, test it and distribute it. When I was about to start another Python project for work, I went looking for the Python equivalent, only to find out that there isn't anything similar. So I thought I'd make one! And so **carpyt** was born, the bastard child of `pip` and `cargo`.

### Stop Writing Scripts, Start Writing Programs

Python is flexible and powerful programming language, it can be used for simple scripting, interactive data analysis and processing, to full on number crunching for applications like machine learning (with a bit of help from some C modules of course!). In my experience, all of my Python projects start small usually as a single `.py` file, then some of them become increasingly useful, get extended and then at some point, it's no longer just a script, it's a proper piece of software. Then it gets painful. As the project wasn't originally envisaged as a full on program, the whole thing needs to be totally restructured. You've never really though about documentation or unit testing, because, let's face it, they're rarely covered in introductory Python tutorials, and they are just an extra cognitive burdon while you're learning the core language.

But this is something that Rust gets right, the easy way to get started is also the correct way. Type `cargo new` to create your library or binary project and the correct structure for the module is all laid out for you. By the time you're ready to share code in Rust, you've already been writing it the right way (hopefully). You can use cargo to run your tests and build your documentation, and best of all, the [Rust book]() covers these things pretty early on, and has multiple example projects using things like test driven development, and this is in a language where it's harder to make mistakes!

The main function of **carpyt** is to create the file structure of a Python module. For a lot of a will create the basic
"""
