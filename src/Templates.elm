module Templates exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown


basicPage : Html msg -> Html msg
basicPage content =
    div [ id "main" ]
        [ siteHeader
        , content
        , siteFooter
        ]

post : String -> Html msg
post rawContent =
    let
      content = Markdown.toHtml [] rawContent
    in
      basicPage content

siteHeader : Html msg
siteHeader =
    header []
        [ div []
            [ h1 []
                [ a [ href "/index.html"]
                    [ text "Bits and Pieces and Odds and Ends" ] ]
            , h3 [] [ text "Code, science and misc by Chris Wells Wood." ]
            ]
        , socialMedia
        , hr [] []
        ]

socialMedia : Html msg
socialMedia =
    p []
        [ text "GitHub: "
        , a
            [ href "https://github.com/ChrisWellsWood" ]
            [ text "@ChrisWellsWood" ]
        , text " | Twitter: "
        , a
            [ href "https://twitter.com/ChrisWellsWood" ]
            [ text "@ChrisWellsWood" ]
        ]

siteFooter : Html msg
siteFooter =
    footer []
        [ div []
            [ hr [] []
            , text "© Chris Wells Wood, 2016."]
        ]

-- Content views and functions
          
renderPost : String -> Html msg
renderPost content =
    Markdown.toHtml [] content
