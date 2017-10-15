module Skeleton exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


skeleton content =
    div [ id "mainSiteDiv", mainSiteDivStyle ]
        [ siteHeader
        , content
        , siteFooter
        ]


mainSiteDivStyle : Html.Attribute msg
mainSiteDivStyle =
    style
        [ ( "margin-right", "auto" )
        , ( "margin-left", "auto" )
        , ( "max-width", "980px" )
        , ( "padding-right", "2.5%" )
        , ( "padding-left", "2.5%" )
        ]


siteHeader : Html msg
siteHeader =
    header [ id "siteHeader" ]
        [ nameAndTagline
        , socialMedia
        , hr [] []
        , navBar
        , hr [] []
        ]


nameAndTagline : Html msg
nameAndTagline =
    div [ id "nameAndTagline" ]
        [ h1 [ id "siteName", style [ ( "margin-bottom", "0" ), ( "padding-bottom", "0" ) ] ]
            [ a [ href "" ] [ text "Bits and Pieces and Odds and Ends" ] ]
        , h3
            [ style [ ( "margin", "0" ), ( "padding", "0" ) ] ]
            [ text "Code, science and misc by Chris Wells Wood." ]
        ]


socialMedia : Html msg
socialMedia =
    div [ id "socialMedia" ]
        [ p [ style [ ( "font-size", "12px" ) ] ]
            [ text "GitHub: "
            , a [ href "https://github.com/ChrisWellsWood" ]
                [ text "@ChrisWellsWood" ]
            , text " | Twitter: "
            , a [ href "https://twitter.com/ChrisWellsWood" ]
                [ text "@ChrisWellsWood" ]
            ]
        ]


navBar : Html msg
navBar =
    div []
        [ a [ href "/" ] [ text "Home" ]
        , text " | "
        , a [ href "/#all-posts" ] [ text "All Posts" ]
        , text " | "
        , a [ href "/#all-snippets" ] [ text "All Snippets" ]
        ]


siteFooter : Html msg
siteFooter =
    footer []
        [ div [ id "siteFooter" ]
            [ hr [] []
            , p []
                [ a
                    [ class "twitter-follow-button"
                    , style [ ( "padding-top", "10px" ) ]
                    , href "https://twitter.com/ChrisWellsWood"
                    , attribute "data-show-count" "false"
                    ]
                    [ text "Follow @ChrisWellsWood" ]
                ]
            , text "© Chris Wells Wood, 2016-2017."
            ]
        ]



-- General Content


type alias ContentMetaData =
    { name : String
    , title : String
    , date : List Int
    , description : String
    , group : String
    , category : String
    , subcategory : String
    , url : String
    }


contentCard : ContentMetaData -> Html msg
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
        , contentInfo metaData
        , p [] [ text metaData.description ]
        ]


contentInfo : ContentMetaData -> Html msg
contentInfo metaData =
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


contentUrl : String -> String -> String -> String -> String
contentUrl group category subcategory name =
    [ group, category, subcategory, name ]
        |> List.map String.toLower
        |> String.join "/"



-- Blog Post


blogPostView : ContentMetaData -> Html msg -> Html msg
blogPostView metaData content =
    div [ class "blogPostView" ]
        [ blogPostHeader metaData
        , content
        ]


blogPostHeader : ContentMetaData -> Html msg
blogPostHeader metaData =
    div [ class "blogPostHeader" ]
        [ h2
            [ style
                [ ( "margin", "0" )
                , ( "padding", "0" )
                ]
            ]
            [ text metaData.title ]
        , contentInfo metaData
        ]


dateToString : List Int -> String
dateToString dateTuple =
    List.map toString dateTuple
        |> List.reverse
        |> List.intersperse "/"
        |> List.foldr (++) ""
