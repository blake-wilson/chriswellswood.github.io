# To Do

1. Make template for header/footer/nav
1. Insert content into page
    1. Make post as elm file
    1. Make it app load articles
1. Remove old markdown pages
1. Beautify
1. Mobile?
1. Embed analytics
1. Change date to date types
1. Home will be a more complex elm app to manage searching and sorting etc
1. Make a crawler in python to automatically find posts

# Notes

* elm-make .\src\Main.elm --output=cww_site.js
* Need to use double backslashes

# Log

* Reviewing Elm architecture, with attention to embedding in html
    * https://guide.elm-lang.org/interop/javascript.html
* Rejigging to use html instead of markdown for the index
* Set up `.gitignore`
* Working on posts
    * posts are content and metadata and so posts in my elm app will be records
    * There will be a content handler view that will gather all the posts together and format them
    * Will this scale well?
        * It doesn't matter, I don't post enough for this to matter, better to be pragmatic and implement the solution I have just now!
    * Each post module contains the actual post content and a bunch of meta data
    * Added a types module