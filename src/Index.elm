module Index exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Templates
import Types exposing (ContentMetaData)

import EmptyRustStructs
import Snippets exposing (allSnippets)

main : Html msg
main = Templates.basicPage view

view : Html msg
view = div []
    [ aboutMe
    , hr [] []
    , recentPosts
    , hr [] []
    , recentSnippets
    , hr [] []
    ]

-- About Me Section

aboutMe : Html msg
aboutMe = div []
    [ h2 [] [ text "About Me"]
    , p [] [ text aboutMeText]
    ]

aboutMeText : String
aboutMeText = """
I'm a research scientist that spends a lot of time writing code and
occasionally ventures into the lab. This is sort of a blog with various
articles/posts as well as snippets from other sources.
"""

-- CONTENT

-- Generic content functionality

recentContentList : List ContentMetaData -> Html msg
recentContentList posts = ol [] (List.map contentDetailItem posts)

contentDetailItem : ContentMetaData -> Html msg
contentDetailItem metaData =
    li []
        [ div []
            [ a [ href metaData.url ] [ contentTitle metaData ]
            , p [] [ text metaData.description ]
            ]
        ]

contentTitle : ContentMetaData -> Html msg
contentTitle metaData = h4 []
    [ a [ href metaData.url ]
        [ text (metaData.title ++ " - " ++ metaData.category ++ "/" ++ metaData.subcategory) ]
    ]

-- Posts

allPosts : List ContentMetaData
allPosts =
    [ EmptyRustStructs.metaData
    ]

recentPosts : Html msg
recentPosts = div []
    [ h2 [] [ text "Recent Posts" ]
    , recentContentList (List.reverse (List.sortBy .date allPosts))
    ]

-- Snippets

recentSnippets : Html msg
recentSnippets = div []
    [ h2 [] [ text "Recent Snippets" ]
    , recentContentList (List.reverse (List.sortBy .date allSnippets))
    ]