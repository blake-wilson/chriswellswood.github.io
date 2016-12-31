import Html
import Markdown

import EmptyStructs

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

view : Model -> Html.Html Msg
view model =
    Html.div []
        [ header
        , Html.p [] [ Markdown.toHtml [] EmptyStructs.postString ]
        , footer
        ]

header : Html.Html msg
header =
    Html.header []
        [ Html.h1 [] [ Html.text "Bits and Pieces and Odds and Ends" ]
        ]

footer : Html.Html msg
footer =
    Html.footer []
        [ Html.text "© Chris Wells Wood, 2016."
        ]
