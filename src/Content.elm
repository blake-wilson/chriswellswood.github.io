module Content exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown
import String

import EmptyRustStructs
import ElmAndNewLanguages
import OOBrainAndTypes
import ElmStaticSiteP1
import Snippets exposing (allSnippets)

type alias ContentMetaData =
    { name : String
    , title : String
    , date : (List Int)
    , description : String
    , category : String
    , subcategory : String
    , url : String
    , rawContent : Maybe String
    }

recentContentCards : List ContentMetaData -> Int -> Html msg
recentContentCards posts numToShow =
    div [ id "recentContentCards", recentContentCardsStyle ] 
        (List.take numToShow (List.map contentCard posts))

recentContentCardsStyle : Html.Attribute msg
recentContentCardsStyle = 
    style 
        [ ("width", "90%")
        , ("margin", "0 auto")
        ]

contentCard : ContentMetaData -> Html msg
contentCard metaData =
    div 
        [ style 
            [ ("border-left", "3px solid #bdc696")
            , ("background-color", "#dfe0dc")
            , ("margin-top", "10px")
            , ("margin-bottom", "10px")
            , ("padding", "10px 10px 1px 10px")
            ]
        ]
        [ h4
            [ style 
                [ ("margin", "0")
                , ("padding", "0")]]
            [ a [ href metaData.url ] [ text metaData.title ] ]
        , cardInfo metaData
        , p [] [ text metaData.description ]
        ]

cardInfo : ContentMetaData -> Html msg
cardInfo metaData =
    p 
        [ style 
            [ ("font-size", "12px")
            , ("margin", "0")
            , ("padding", "0")
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

recentPosts : Int -> Html msg
recentPosts numToShow = div []
    [ h2 [] [ text "Recent Posts" ]
    , recentContentCards (List.reverse (List.sortBy .date allPosts)) numToShow
    ]

-- Snippets

recentSnippets : Int -> Html msg
recentSnippets numToShow = div []
    [ h2 [] [ text "Recent Snippets" ]
    , recentContentCards (List.reverse (List.sortBy .date allSnippets)) numToShow
    ]