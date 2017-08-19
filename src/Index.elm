port module Index exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Navigation
import Process
import Task
import Time
import UrlParser exposing ((</>))
import CommonViews
import Content


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
    ( Model Home flags.mobile
    , Task.perform identity (Task.succeed (UrlChange location))
    )



-- Model


type alias Model =
    { page : Page
    , mobile : Bool
    }


type Page
    = Home
    | AllPosts
    | Post String
    | AllSnippets



-- Ports


port highlightMarkdown : () -> Cmd msg


port analytics : String -> Cmd msg



-- Update


type Msg
    = UrlChange Navigation.Location
    | Highlight ()


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- The task here is to force an update before highlighting
        UrlChange location ->
            { model | page = getPage location }
                ! [ Task.perform Highlight (Process.sleep (100 * Time.millisecond))
                  , analytics location.href
                  ]

        Highlight _ ->
            ( model, highlightMarkdown () )


getPage : Navigation.Location -> Page
getPage location =
    Maybe.withDefault AllPosts (UrlParser.parseHash route location)


route : UrlParser.Parser (Page -> a) a
route =
    UrlParser.oneOf
        [ UrlParser.map Home UrlParser.top
        , UrlParser.map AllPosts (UrlParser.s "all-posts")
        , UrlParser.map Post (UrlParser.s "blog" </> UrlParser.string)
        , UrlParser.map AllSnippets (UrlParser.s "all-snippets")
        ]



-- View


view : Model -> Html Msg
view model =
    div [ id "mainSiteDiv", mainSiteDivStyle ]
        [ CommonViews.siteHeader
        , content model
        , CommonViews.siteFooter
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
            Content.allPostsView

        Post title ->
            Maybe.withDefault home (Content.getBlogPost title)

        AllSnippets ->
            Content.allSnippetsView



-- Home


home : Html Msg
home =
    div []
        [ aboutMe
        , hr [] []
        , Content.recentPosts 10
        , hr [] []
        , Content.recentSnippets 5
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
