module Index exposing (..)

import Html
import Html.Attributes

import Content exposing (allPosts, ContentIndex, PostInfo)
import Templates

main : Html.Html msg
main = Templates.basicPage view

view : Html.Html msg
view = Html.div []
    [ aboutMe
    , Html.hr [] []
    , recentPosts
    , Html.hr [] []
    ]

-- About Me Section

aboutMe : Html.Html msg
aboutMe = Html.div []
    [ Html.h2 [] [ Html.text "About Me"]
    , Html.p [] [ Html.text aboutMeText]
    ]

aboutMeText : String
aboutMeText = """
I'm a research scientist that spends a lot of time writing code and
occasionally ventures into the lab. This is sort of a blog with various
articles/posts as well as snippets from other sources.
"""

-- Recent Posts

recentPosts : Html.Html msg
recentPosts = Html.div []
    [ Html.h2 [] [ Html.text "Recent" ]
    , recentPostList (List.reverse (List.sortBy .date allPosts))
    ]

recentPostList : ContentIndex -> Html.Html msg
recentPostList posts = Html.ol [] (List.map makePostDetailItem posts)

makePostDetailItem : PostInfo -> Html.Html msg
makePostDetailItem post =
    Html.li []
        [ Html.h4 []
            [ Html.text (post.title ++ " - " ++ post.category ++ "/" ++ post.subcategory) ]
        , Html.p [] [ Html.text post.description ]
        ]