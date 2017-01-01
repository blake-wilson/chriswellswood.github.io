module Home exposing (..)

import Html
import Html.Attributes
import Html.Events

import Content exposing (allPosts, ContentIndex, PostInfo)
import Messages

home : Html.Html Messages.Msg
home = Html.div []
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

recentPosts : Html.Html Messages.Msg
recentPosts = Html.div []
    [ Html.h2 [] [ Html.text "Recent" ]
    , recentPostList (List.reverse (List.sortBy .date allPosts))
    ]

recentPostList : ContentIndex -> Html.Html Messages.Msg
recentPostList posts = Html.ol [] (List.map makePostDetailItem posts)

makePostDetailItem : PostInfo -> Html.Html Messages.Msg
makePostDetailItem post =
    Html.li []
        [ Html.h4 [ Html.Events.onClick (Messages.GetPost post)]
            [ Html.text (post.title ++ " - " ++ post.category ++ "/" ++ post.subcategory) ]
        , Html.p [] [ Html.text post.description ]
        ]