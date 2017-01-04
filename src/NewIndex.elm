import Html exposing (..)
import Navigation

main = Navigation.program
    { init = init
    , view = view
    , update = update
    , subscriptions = Nothing
    }

-- Model

type alias Model = 
    { page : Page
    }

type Page = Home | About | Contact

init = (Model Home, Cmd.none)

-- Update

type Msg = UrlChange Navigation.Location

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    UrlChange location ->
       { model | page = (getPage location.hash) } ! [ Cmd.none ]

getPage : String -> Page
getPage hash =
    case hash of
        "#home" ->
            Home

        "#about" ->
            About

        "#contact" ->
            Contact

        _ ->
            Home

-- View

view : Model -> Html Msg
view model = content model

content : Model -> Html Msg
content model =
    case model.page of
        Home ->
            h1 [] [ text "Home page!" ]

        About ->
            h1 [] [ text "About page!" ]

        Contact ->
            h1 [] [ text "Contact page!" ]