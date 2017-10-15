port module Home exposing (..)

import Content
import Html exposing (..)
import Html.Attributes exposing (..)
import Navigation
import Process
import Skeleton exposing (ContentMetaData, skeleton, contentCard)
import Task
import Time
import UrlParser exposing ((</>))


main : Program Flags Model Msg
main =
    Navigation.programWithFlags UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }


type alias Flags =
    { mobile : Bool
    }


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    ( Model Home
    , Task.perform identity (Task.succeed (UrlChange location))
    )



-- Model


type alias Model =
    { page : Page
    }


type Page
    = Home
    | AllPosts
    | AllSnippets



-- Update


type Msg
    = UrlChange Navigation.Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- The task here is to force an update before highlighting
        UrlChange location ->
            { model | page = getPage location } ! []


getPage : Navigation.Location -> Page
getPage location =
    Maybe.withDefault AllPosts (UrlParser.parseHash route location)


route : UrlParser.Parser (Page -> a) a
route =
    UrlParser.oneOf
        [ UrlParser.map Home UrlParser.top
        , UrlParser.map AllPosts (UrlParser.s "all-posts")
        , UrlParser.map AllSnippets (UrlParser.s "all-snippets")
        ]



-- View


view : Model -> Html Msg
view model =
    skeleton <| content model


content : Model -> Html Msg
content model =
    div [ id "contentSection" ]
        [ getContent model
        ]


getContent : Model -> Html Msg
getContent model =
    case model.page of
        Home ->
            home

        AllPosts ->
            allPostsView

        AllSnippets ->
            allSnippetsView



-- Home


home : Html Msg
home =
    div []
        [ aboutMe
        , hr [] []
        , recentPosts 10
        , hr [] []
        , recentSnippets 5
        ]



-- About Me Section


aboutMe : Html msg
aboutMe =
    div [ id "aboutMe" ]
        [ h2 [] [ text "About Me" ]
        , p [] [ text aboutMeText ]
        ]


aboutMeText : String
aboutMeText =
    """\x0D
I'm a research scientist that spends a lot of time writing code and\x0D
occasionally ventures into the lab. This is sort of a blog with various\x0D
articles/posts as well as snippets from other sources.\x0D
"""



-- Content


recentContentCards : Int -> List ContentMetaData -> Html msg
recentContentCards numToShow posts =
    div [ id "recentContentCards" ]
        (List.take numToShow (List.map contentCard posts))



-- Posts


allPostsView : Html msg
allPostsView =
    div [ id "allPostsView" ]
        [ h2 [] [ text "All Posts" ]
        , div [] (List.map contentCard Content.allPosts |> List.reverse)
        ]


recentPosts : Int -> Html msg
recentPosts numToShow =
    div []
        [ h2 [] [ text "Recent Posts" ]
        , (Content.allPosts
            |> List.sortBy .date
            |> List.reverse
            |> recentContentCards numToShow
          )
        ]



-- Snippets


allSnippetsView : Html msg
allSnippetsView =
    div [ id "allSnippetsView" ]
        [ h2 [] [ text "All Snippets" ]
        , div [] (List.map contentCard Content.allSnippets)
        ]


recentSnippets : Int -> Html msg
recentSnippets numToShow =
    div []
        [ h2 [] [ text "Recent Snippets" ]
        , (Content.allSnippets
            |> List.sortBy .date
            |> List.reverse
            |> recentContentCards numToShow
          )
        ]
