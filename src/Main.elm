import Html
import Html.Attributes
import Html.Events
import Http
import Json.Decode as Decode
import Markdown

import Messages
import Home exposing (home)
import Content exposing (allPosts, ContentIndex, PostInfo)


main = Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model = 
    { post : Maybe PostInfo
    , content : Maybe String
    }

init : (Model, Cmd Msg)
init =
    (Model Nothing Nothing, Cmd.none)


-- UPDATE

type alias Msg = Messages.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Messages.Home ->
        init
    
    Messages.GetPost post ->
        ( model
        , Http.send Messages.ShowContent
            (Http.getString post.url)
        )
    
    Messages.ShowContent (Ok content) ->
        ({ model | content = Just content }, Cmd.none)
    
    Messages.ShowContent (Err content) ->
        (model, Cmd.none)

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

header : Html.Html Msg
header =
    Html.header []
        [ Html.div [ Html.Events.onClick Messages.Home ]
            [ Html.h1 [] [ Html.text "Bits and Pieces and Odds and Ends" ]
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

getContent : Model -> Html.Html Messages.Msg
getContent model =
    case model.content of
        Just content ->
            renderPost content
        Nothing ->
            home
          
renderPost : String -> Html.Html msg
renderPost content =
    Markdown.toHtml [] content
