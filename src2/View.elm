module View exposing (..)

import Config
import Html exposing (Html)
import Html.Attributes


viewportMeta : Html msg
viewportMeta =
    let
        width : String
        width =
            --device-width
            String.fromFloat Config.screenMinWidth
    in
    Html.node "meta"
        [ Html.Attributes.name "viewport"
        , Html.Attributes.attribute "content" ("user-scalable=no,width=" ++ width)
        ]
        []


stylesheet : Html msg
stylesheet =
    --In-Elm Stylesheet is usually easier to load by itch.io
    "" |> Html.text |> List.singleton |> Html.node "style" []
