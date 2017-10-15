module ElmAndNewLanguages exposing (..)

import Html exposing (..)
import Markdown
import Skeleton exposing (ContentMetaData, skeleton, blogPostView, contentUrl)


main =
    blogPostView metaData content
        |> skeleton


name : String
name =
    "elm-and-learning-new-languages"


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
    , title = "Elm and Learning New Programming Languages"
    , date = [ 2016, 8, 25 ]
    , description = "A bit of pontification on learning programming languages and paradigms."
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
    """\x0D
So like most people that have been coding for a while, I've got more and more interested in exploring new programming languages. It's kind of like visiting a foreign country, it's fun to experience other ways of life. Sometimes though you're disappointed when it's too similar to home other times it's a bit overwhelming if it's too different.\x0D
\x0D
What you really want is something in the middle, so maybe you walk through a supermarket when you're abroad and you marvel at the unusual selection of canned goods, and then right in the corner you notice a can of baked beans. It always makes me smile, and then you think "What if they taste different!?", and you end up having beans for lunch, which is nice but you end up thinking that you should have been a bit more adventurous. Anyway, you can see what I'm getting at, it's nice to try something new, but sometimes a bit of familiarity doesn't go amiss.\x0D
\x0D
I learned to code in Python, and while a lot of programming paradigms are captured by the language, it is mainly an imperative language, that is where you make statements to change the state of a program. For example maybe you want to count all the odd numbers in a list, you could do it in a hundred ways but here's one that is classically imperative:\x0D
\x0D
```Python\x0D
my_numbers = [0, 1, 2, 3, 4, 5]\x0D
odd_number_count = 0\x0D
for number in my_numbers:\x0D
  if number % 2:\x0D
    odd_number_count += 1\x0D
print(odd_number_count)\x0D
```\x0D
\x0D
One day I was reading about how to be a good programmer, and people kept mentioning that you should learn more than one language and you should try to make it pretty different from a language you know. One argument for that is that it show you other ways to program, and Haskell is often used as an example of this. So I started to learn a bit of Haskell, using http://learnyouahaskell.com/, and my mind started to melt! I wasn't aware that there was any other way to program apart from using imperative style code.\x0D
\x0D
By this point, I had been exposed to many functional programming paradigms in Python, such as the idea of functions as first-class citizens, map, filter, list comprehensions… but it never occurred to me that programming languages existed that used these traits as the basis for the language and built upon them.\x0D
\x0D
I learned a fair bit of Haskell, but in the I stopped learning it in the end because it was utterly mind-bending trying to think of an algorithm to solve a particular problem. Also, because it was so unfamiliar I couldn't think of anything that I could actually use Haskell for! To make this clear, this was because of my lack of understanding, nothing to do with Haskell itself. It wasn't an utter loss though, functional programming stuck with me, and I definitely started using it more in Python after learning a bit of Haskell.\x0D
\x0D
Time passes and I'm messing around with JavaScript, in particular languages that compile to JavaScript (which is a super interesting topic I'll hopefully discuss in more detail in another article) like TypeScript, and I came across Elm, and it properly intrigued me. Elm is a purely functional programming language that compiles down to HTML, CSS and JavaScript and can be used to make front ends for websites and web applications. It feels a lot like Haskell in syntax.\x0D
\x0D
The nice thing about Elm is that it has a really clear application, in an area I'm interested in at the moment, which makes it easier to learn for me as I have a goal to work towards. I've started learning a bit of Elm just using the main documentation, and it's already starting to cement a lot of the more nebulous aspects of functional programming (things like Currying). I suppose this is to be expected, but what I've been surprised about is that I feel like it's teaching me to be a better web developer too, which is really neat!\x0D
\x0D
Elm is probably not going to replace things like React and Angular any time soon, if ever, and it's still in flux as a language so it probably not ready for "production" code, but for a hobbyist wanting to learn about good web development and FP it seems ideal. I feel like Elm is the programming language equivalent of baked beans in a foreign super-market, it feels new and different, but has familiar aspects (the web development parts!).\x0D
\x0D
I'm going to write about Elm and the little web application that I'm developing using it in upcoming posts. Let me know what you think of Elm, Haskell and FP on Twitter. Have you used Elm? What did you think? Has anyone learned to code using FP and then moved across to an imperative language?\x0D
"""
