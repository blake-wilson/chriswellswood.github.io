module Templates exposing (..)

import Html
import Html.Attributes
import Markdown


basicPage : Html.Html msg -> Html.Html msg
basicPage content =
    Html.div [ Html.Attributes.id "main" ]
        [ header
        , content
        , footer
        ]

post : String -> Html.Html msg
post rawContent =
    let
      content = Markdown.toHtml [] rawContent
    in
      basicPage content

header : Html.Html msg
header =
    Html.header []
        [ Html.div []
            [ Html.h1 []
                [ Html.a [ Html.Attributes.href "/index.html"]
                    [ Html.text "Bits and Pieces and Odds and Ends" ] ]
            , Html.h3 [] [ Html.text "Code, science and misc by Chris Wells Wood." ]
            ]
        , socialMedia
        ]

socialMedia : Html.Html msg
socialMedia =
    Html.p []
        [ Html.text "GitHub: "
        , Html.a
            [ Html.Attributes.href "https://github.com/ChrisWellsWood" ]
            [ Html.text "@ChrisWellsWood" ]
        , Html.text " | Twitter: "
        , Html.a
            [ Html.Attributes.href "https://twitter.com/ChrisWellsWood" ]
            [ Html.text "@ChrisWellsWood" ]
        ]

footer : Html.Html msg
footer =
    Html.footer []
        [ Html.text "© Chris Wells Wood, 2016."
        ]

-- Content views and functions
          
renderPost : String -> Html.Html msg
renderPost content =
    Markdown.toHtml [] content
