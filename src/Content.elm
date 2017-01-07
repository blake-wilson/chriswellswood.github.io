module Content exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown

import EmptyRustStructs
import ElmAndNewLanguages
import OOBrainAndTypes
import ElmStaticSiteP1
import Snippets exposing (allSnippets)

type alias ContentMetaData =
    { name : String
    , title : String
    , date : (Int, Int, Int)
    , description : String
    , category : String
    , subcategory : String
    , url : String
    , rawContent : Maybe String
    }

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
    , ElmAndNewLanguages.metaData
    , OOBrainAndTypes.metaData
    , ElmStaticSiteP1.metaData
    ]

getBlogPost : String -> Maybe (Html msg)
getBlogPost title =
    let
      blogMetaData = getBlogMetaData title
    in
      case blogMetaData of
        Just metaData -> Just (div [ style [("max-width", "95%")] ]
            [ Markdown.toHtml [] (Maybe.withDefault "" metaData.rawContent)])
        Nothing -> Nothing

getBlogMetaData : String -> Maybe ContentMetaData
getBlogMetaData title =
    List.head (List.filter (\metaData -> (metaData.name == title)) allPosts)

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