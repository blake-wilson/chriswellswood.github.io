port module Index exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown
import Navigation
import Process
import Task
import Time
import UrlParser exposing ((</>))

import CommonViews
import Types exposing (ContentMetaData)

import EmptyRustStructs
import ElmAndNewLanguages
import OOBrainAndTypes
import ElmStaticSiteP1
import Snippets exposing (allSnippets)

main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }

init : Navigation.Location -> (Model, Cmd Msg)
init _ = (Model Home, Cmd.none)

-- Model

type alias Model =
    { page: Page
    }

type Page
    = Home
    | AllPosts
    | Post String

-- Ports

port highlightMarkdown : () -> Cmd msg

-- Update

type Msg
    = UrlChange Navigation.Location
    | Highlight ()

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- The task here is to force an update before highlighting
        UrlChange location ->
            { model | page = getPage location } !
                [ Task.perform Highlight (Process.sleep (50 * Time.millisecond)) ]
        
        Highlight _ ->
            (model, highlightMarkdown ())



getPage : Navigation.Location -> Page
getPage location =
    Maybe.withDefault Home (UrlParser.parseHash route location)

route : UrlParser.Parser (Page -> a) a
route =
    UrlParser.oneOf
        [ UrlParser.map Home UrlParser.top
        , UrlParser.map Post (UrlParser.s "blog" </> UrlParser.string)
        ]

-- View

view : Model -> Html Msg
view model = div [ id "mainSiteDiv", mainSiteDivStyle ]
    [ CommonViews.siteHeader
    , content model
    , CommonViews.siteFooter
    ]

mainSiteDivStyle : Html.Attribute msg
mainSiteDivStyle = 
    style 
        [ ("margin-right", "auto")
        , ("margin-left", "auto")
        , ("max-width", "980px")
        , ("padding-right", "2.5%")
        , ("padding-left", "2.5%")
        ]

content : Model -> Html Msg
content model = div [ id "contentSection" ]
    [ getContent model
    ]

getContent : Model -> Html Msg
getContent model =
    case model.page of
      Home -> home
      AllPosts -> home
      Post title -> getBlogPost title

-- Home

home : Html Msg
home =
    div []
        [ aboutMe
        , hr [] []
        , recentPosts
        , hr [] []
        , recentSnippets
        ]

-- About Me Section

aboutMe : Html msg
aboutMe = div [ id "aboutMe" ]
    [ h2 [] [ text "About Me"]
    , p [] [ text aboutMeText]
    ]

aboutMeText : String
aboutMeText = """
I'm a research scientist that spends a lot of time writing code and
occasionally ventures into the lab. This is sort of a blog with various
articles/posts as well as snippets from other sources.
"""

-- CONTENT

-- Generic content functionality

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

-- Blog

getBlogPost : String -> Html msg
getBlogPost title =
    let
      blogMetaData = getBlogMetaData title
    in
      case blogMetaData of
        Just metaData -> div [ style [("max-width", "95%")] ]
            [ Markdown.toHtml [] (Maybe.withDefault "" metaData.rawContent)]
        Nothing -> aboutMe
          

getBlogMetaData : String -> Maybe ContentMetaData
getBlogMetaData title =
    List.head (List.filter (\metaData -> (metaData.name == title)) allPosts)