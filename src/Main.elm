import Html
import Html.Attributes
import Html.Events
import Markdown

import Home
import EmptyStructs

main = Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model = 
    { content : String
    }

init : (Model, Cmd Msg)
init =
    (Model "home", Cmd.none)


-- UPDATE

type Msg = Home

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Home ->
        ({ model | content = "home" }, Cmd.none)


-- SUBSCRIPTIONS (currently not required)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- VIEW

view : Model -> Html.Html Msg
view model =
    Html.div []
        [ header
        , getContent model
        , footer
        ]

header : Html.Html msg
header =
    Html.header []
        [ Html.h1
            []
            [ Html.text "Bits and Pieces and Odds and Ends" ]
        , Html.h3 [] [ Html.text "Code, science and misc by Chris Wells Wood." ]
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

getContent : Model -> Html.Html msg
getContent model =
    if model.content == "home" then
        home
    else
        home

home : Html.Html msg
home = Html.div []
    [ Html.h2 [] [ Html.text "About Me"]
    , Html.p [] [ Html.text aboutMe]
    ]

aboutMe : String
aboutMe = """
I'm a research scientist that spends a lot of time writing code and
occasionally ventures into the lab. This is sort of a blog with various
articles/posts as well as snippets from other sources.
"""