module Index exposing (..)

import Html
import Html.Attributes

import Templates
import Types exposing (ContentMetaData)

import EmptyRustStructs
import Snippets exposing (allSnippets)

main : Html.Html msg
main = Templates.basicPage view

view : Html.Html msg
view = Html.div []
    [ aboutMe
    , Html.hr [] []
    , recentPosts
    , Html.hr [] []
    , recentSnippets
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

-- CONTENT

-- Generic content functionality

recentContentList : List ContentMetaData -> Html.Html msg
recentContentList posts = Html.ol [] (List.map contentDetailItem posts)

contentDetailItem : ContentMetaData -> Html.Html msg
contentDetailItem metaData =
    Html.li []
        [ Html.div []
            [ Html.a [ Html.Attributes.href metaData.url ] [ contentTitle metaData ]
            , Html.p [] [ Html.text metaData.description ]
            ]
        ]

contentTitle : ContentMetaData -> Html.Html msg
contentTitle metaData = Html.h4 []
    [ Html.a [ Html.Attributes.href metaData.url ]
        [ Html.text (metaData.title ++ " - " ++ metaData.category ++ "/" ++ metaData.subcategory) ]
    ]

-- Posts

allPosts : List ContentMetaData
allPosts =
    [ EmptyRustStructs.metaData
    ]

recentPosts : Html.Html msg
recentPosts = Html.div []
    [ Html.h2 [] [ Html.text "Recent Posts" ]
    , recentContentList (List.reverse (List.sortBy .date allPosts))
    ]

-- Snippets

recentSnippets : Html.Html msg
recentSnippets = Html.div []
    [ Html.h2 [] [ Html.text "Recent Snippets" ]
    , recentContentList (List.reverse (List.sortBy .date allSnippets))
    ]