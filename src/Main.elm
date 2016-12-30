import Html exposing (..)

main = Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model = 
    { activePage : Int
    }

init : (Model, Cmd Msg)
init =
    (Model 0, Cmd.none)


-- UPDATE

type Msg = Home

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Home -> (model, Cmd.none)


-- SUBSCRIPTIONS (currently not required)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Bits and Pieces and Odds and Ends" ] ]