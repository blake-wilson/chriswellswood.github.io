module Content exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (ContentMetaData)
import EmptyRustStructs
import ElmAndNewLanguages
import OOBrainAndTypes
import ElmStaticSiteP1
import CounterReusableView
import Snippets exposing (allSnippets)


allPosts : List (ContentMetaData msg)
allPosts =
    [ EmptyRustStructs.metaData
    , ElmAndNewLanguages.metaData
    , OOBrainAndTypes.metaData
    , ElmStaticSiteP1.metaData
    , CounterReusableView.metaData
    ]


recentContentCards : List (ContentMetaData msg) -> Int -> Html msg
recentContentCards posts numToShow =
    div [ id "recentContentCards" ]
        (List.take numToShow (List.map contentCard posts))


contentCard : ContentMetaData msg -> Html msg
contentCard metaData =
    div
        [ class "contentCard"
        , style
            [ ( "border-left", "3px solid #bdc696" )
            , ( "border-right", "3px solid #bdc696" )
            , ( "background-color", "#dfe0dc" )
            , ( "margin-top", "10px" )
            , ( "margin-bottom", "10px" )
            , ( "padding", "10px 10px 1px 10px" )
            ]
        ]
        [ h4
            [ style
                [ ( "margin", "0" )
                , ( "padding", "0" )
                ]
            ]
            [ a [ href metaData.url ] [ text metaData.title ] ]
        , cardInfo metaData
        , p [] [ text metaData.description ]
        ]


cardInfo : ContentMetaData msg -> Html msg
cardInfo metaData =
    p
        [ style
            [ ( "font-size", "12px" )
            , ( "margin", "0" )
            , ( "padding", "0" )
            ]
        ]
        [ b [] [ text "Date Posted: " ]
        , text ((dateToString metaData.date) ++ " | ")
        , b [] [ text "Category: " ]
        , text (metaData.category ++ "/" ++ metaData.subcategory)
        ]


dateToString : List Int -> String
dateToString dateTuple =
    List.map toString dateTuple
        |> List.reverse
        |> List.intersperse "/"
        |> List.foldr (++) ""



-- Posts


allPostsView : Html msg
allPostsView =
    div [ id "allPostsView" ]
        [ h2 [] [ text "All Posts" ]
        , div [] (List.map contentCard allPosts |> List.reverse)
        ]


getBlogPost : String -> Maybe (Html msg)
getBlogPost title =
    let
        blogMetaData =
            getBlogMetaData title
    in
        case blogMetaData of
            Just metaData ->
                Just (blogPostView metaData)

            Nothing ->
                Nothing


getBlogMetaData : String -> Maybe (ContentMetaData msg)
getBlogMetaData title =
    List.head (List.filter (\metaData -> (metaData.name == title)) allPosts)


recentPosts : Int -> Html msg
recentPosts numToShow =
    div []
        [ h2 [] [ text "Recent Posts" ]
        , recentContentCards (List.reverse (List.sortBy .date allPosts)) numToShow
        ]


blogPostView : ContentMetaData msg -> Html msg
blogPostView metaData =
    div [ class "blogPostView" ]
        [ blogPostHeader metaData
        , metaData.content
        ]


blogPostHeader : ContentMetaData msg -> Html msg
blogPostHeader metaData =
    div [ class "blogPostHeader" ]
        [ h2
            [ style
                [ ( "margin", "0" )
                , ( "padding", "0" )
                ]
            ]
            [ text metaData.title ]
        , cardInfo metaData
        ]



-- Snippets


allSnippetsView : Html msg
allSnippetsView =
    div [ id "allSnippetsView" ]
        [ h2 [] [ text "All Snippets" ]
        , div [] (List.map contentCard Snippets.allSnippets)
        ]


recentSnippets : Int -> Html msg
recentSnippets numToShow =
    div []
        [ h2 [] [ text "Recent Snippets" ]
        , recentContentCards (List.reverse (List.sortBy .date allSnippets)) numToShow
        ]
