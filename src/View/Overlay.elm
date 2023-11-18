module View.Overlay exposing (..)

import Html exposing (Attribute, Html)
import Html.Attributes
import Layout


gameMenu : { startGame : msg } -> Html msg
gameMenu args =
    [ [ "🎲" |> Layout.text [ Html.Attributes.class "font-size-title" ]
      , "Game-Template" |> Layout.text [ Html.Attributes.class "font-size-big" ]
      ]
        |> Layout.column Layout.centered
    , Layout.textButton []
        { label = "Start"
        , onPress = Just args.startGame
        }
    ]
        |> Layout.column
            (Html.Attributes.style "gap" "var(--big-space)"
                :: Layout.centered
            )
        |> asFullScreenOverlay
            ([ Html.Attributes.style "background-color" "var(--secondary-color)"
             , Html.Attributes.style "color" "white"
             ]
                ++ Layout.centered
            )


asFullScreenOverlay : List (Attribute msg) -> Html msg -> Html msg
asFullScreenOverlay attrs =
    Layout.el
        ([ Html.Attributes.style "position" "absolute"
         , Html.Attributes.style "inset" "0 0"
         , Html.Attributes.style "height" "100%"
         , Html.Attributes.style "width" "100%"
         ]
            ++ attrs
        )
