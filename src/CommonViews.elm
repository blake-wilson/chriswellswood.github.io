module CommonViews exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

siteHeader : Html msg
siteHeader =
    header [ id "siteHeader"]
        [ nameAndTagline
        , socialMedia
        , hr [] []
        ]

nameAndTagline : Html msg
nameAndTagline = 
    div [ id "nameAndTagline"]
        [ h1 [ id "siteName", style [("margin-bottom", "0"), ("padding-bottom", "0")] ]
            [ a [ href "#home"] [ text "Bits and Pieces and Odds and Ends" ] ]
        , h3
            [ style [("margin", "0"), ("padding", "0")] ]
            [ text "Code, science and misc by Chris Wells Wood." ]
        ]

socialMedia : Html msg
socialMedia = div [ id "socialMedia" ]
    [ p [ style [("font-size", "12px")] ]
        [ text "GitHub: "
        , a [ href "https://github.com/ChrisWellsWood" ]
            [ text "@ChrisWellsWood" ]
        , text " | Twitter: "
        , a [ href "https://twitter.com/ChrisWellsWood" ]
            [ text "@ChrisWellsWood" ]
        ]
    ]
    
siteFooter : Html msg
siteFooter =
    footer []
        [ div [ id "siteFooter" ]
            [ hr [] []
            , text "© Chris Wells Wood, 2016."]
        ]
