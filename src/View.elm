module View exposing (..)

import Config
import Css
import Dict exposing (Dict)
import Game exposing (Game, Tile)
import Html exposing (Attribute, Html)
import Html.Attributes
import Html.Keyed
import Layout
import Set


square : List (Attribute msg) -> Html msg
square attrs =
    Layout.el
        attrs
        Layout.none


goal : List (Attribute msg) -> Html msg
goal attrs =
    Layout.el
        ([ Html.Attributes.style "width" (String.fromInt Config.squareSize ++ "px")
         , Html.Attributes.style "height" (String.fromInt Config.squareSize ++ "px")
         ]
            ++ attrs
        )
        Layout.none


tile :
    { nodes : Dict ( Int, Int ) Int
    , width : Int
    , height : Int
    , tiles : Dict Int Tile
    , onClick : Int -> msg
    , goal : List ( Int, Int )
    }
    -> Html msg
tile args =
    List.range -1 args.height
        |> List.concatMap
            (\y ->
                List.range -1 args.width
                    |> List.filterMap
                        (\x ->
                            Dict.get ( x, y ) args.nodes
                                |> Maybe.map
                                    (\i ->
                                        let
                                            { size, topLeft } =
                                                args.tiles
                                                    |> Dict.get i
                                                    |> Maybe.withDefault
                                                        { topLeft = ( 0, 0 )
                                                        , size = ( 0, 0 )
                                                        , blocks = Set.empty
                                                        }

                                            ( width, height ) =
                                                size

                                            ( offsetX, offsetY ) =
                                                topLeft
                                        in
                                        (if i < 0 then
                                            [ Html.Attributes.style "border-radius" (String.fromInt Config.squareSize ++ "px") ]

                                         else
                                            [ ( Css.top_left
                                              , (Dict.get ( x - 1, y ) args.nodes == Just i)
                                                    || (Dict.get ( x, y - 1 ) args.nodes == Just i)
                                              )
                                            , ( Css.top_right
                                              , (Dict.get ( x + 1, y ) args.nodes == Just i)
                                                    || (Dict.get ( x, y - 1 ) args.nodes == Just i)
                                              )
                                            , ( Css.bottom_left
                                              , (Dict.get ( x - 1, y ) args.nodes == Just i)
                                                    || (Dict.get ( x, y + 1 ) args.nodes == Just i)
                                              )
                                            , ( Css.bottom_right
                                              , (Dict.get ( x + 1, y ) args.nodes == Just i)
                                                    || (Dict.get ( x, y + 1 ) args.nodes == Just i)
                                              )
                                            ]
                                                |> List.filterMap
                                                    (\( attr, bool ) ->
                                                        if bool then
                                                            Nothing

                                                        else
                                                            Just attr
                                                    )
                                        )
                                            |> (++)
                                                [ (String.fromInt (max height width * Config.squareSize) ++ "px")
                                                    |> (\string -> string ++ " " ++ string)
                                                    |> Html.Attributes.style "background-size"
                                                , (String.fromInt (-(x - offsetX) * Config.squareSize) ++ "px")
                                                    ++ " "
                                                    ++ (String.fromInt (-(y - offsetY) * Config.squareSize) ++ "px")
                                                    |> Html.Attributes.style "background-position"
                                                , Html.Attributes.style "position" "absolute"
                                                , background i |> Html.Attributes.style "background-image"
                                                , Html.Attributes.style "transition" "left ease-in-out 0.2s, top ease-in-out 0.2s"
                                                ]
                                            |> (++)
                                                (Layout.asButton
                                                    { label = "Click"
                                                    , onPress = Just (args.onClick i)
                                                    }
                                                )
                                            |> (++)
                                                (if i < 0 then
                                                    [ Html.Attributes.style "left" (String.fromInt (x * Config.squareSize + ((Config.squareSize - Config.circleSize) // 2)) ++ "px")
                                                    , Html.Attributes.style "top" (String.fromInt (y * Config.squareSize + ((Config.squareSize - Config.circleSize) // 2)) ++ "px")
                                                    , Html.Attributes.style "width" (String.fromInt Config.circleSize ++ "px")
                                                    , Html.Attributes.style "height" (String.fromInt Config.circleSize ++ "px")
                                                    ]

                                                 else
                                                    [ Html.Attributes.style "left" (String.fromInt (x * Config.squareSize) ++ "px")
                                                    , Html.Attributes.style "top" (String.fromInt (y * Config.squareSize) ++ "px")
                                                    , Html.Attributes.style "width" (String.fromInt Config.squareSize ++ "px")
                                                    , Html.Attributes.style "height" (String.fromInt Config.squareSize ++ "px")
                                                    ]
                                                )
                                            |> square
                                            |> (\html ->
                                                    ( String.fromInt i
                                                        ++ "-"
                                                        ++ String.fromInt (x - offsetX)
                                                        ++ "-"
                                                        ++ String.fromInt (y - offsetY)
                                                    , html
                                                    )
                                               )
                                    )
                        )
            )
        |> (++)
            (args.goal
                |> List.indexedMap
                    (\i ( goalX, goalY ) ->
                        ( "goal" ++ String.fromInt i
                        , ([ ( Html.Attributes.style "border-top-left-radius" (String.fromInt (Config.squareSize // 2) ++ "px")
                             , goalY == args.height || goalX == args.width
                             )
                           , ( Html.Attributes.style "border-top-right-radius" (String.fromInt (Config.squareSize // 2) ++ "px")
                             , goalY == args.height || goalX == -1
                             )
                           , ( Html.Attributes.style "border-bottom-left-radius" (String.fromInt (Config.squareSize // 2) ++ "px")
                             , goalY == -1 || goalX == args.width
                             )
                           , ( Html.Attributes.style "border-bottom-right-radius" (String.fromInt (Config.squareSize // 2) ++ "px")
                             , goalY == -1 || goalX == -1
                             )
                           ]
                            |> List.filterMap
                                (\( attr, bool ) ->
                                    if not bool then
                                        Just attr

                                    else
                                        Nothing
                                )
                            |> (++)
                                [ Html.Attributes.style "left" (String.fromInt (goalX * Config.squareSize) ++ "px")
                                , Html.Attributes.style "top" (String.fromInt (goalY * Config.squareSize) ++ "px")
                                , Html.Attributes.style "background-color" "var(--dark-gray)"
                                , Html.Attributes.style "position" "absolute"
                                , Html.Attributes.style "z-index" "-1"
                                ]
                          )
                            |> goal
                        )
                    )
            )
        |> List.sortBy Tuple.first
        |> Html.Keyed.node "div"
            ([ ( Css.top_left, List.member ( 0, -1 ) args.goal || List.member ( -1, 0 ) args.goal )
             , ( Css.top_right, List.member ( args.width - 1, -1 ) args.goal || List.member ( args.width, 0 ) args.goal )
             , ( Css.bottom_left, List.member ( -1, args.height - 1 ) args.goal || List.member ( 0, args.height ) args.goal )
             , ( Css.bottom_right, List.member ( args.width, args.height - 1 ) args.goal || List.member ( args.width - 1, args.height ) args.goal )
             ]
                |> List.filterMap
                    (\( attr, bool ) ->
                        if not bool then
                            Just attr

                        else
                            Nothing
                    )
                |> (++)
                    [ Html.Attributes.style "position" "relative"
                    , Html.Attributes.style "height" (String.fromInt (args.height * Config.squareSize) ++ "px")
                    , Html.Attributes.style "width" (String.fromInt (args.width * Config.squareSize) ++ "px")
                    , Html.Attributes.style "background-color" "var(--dark-gray)"
                    ]
            )


background : Int -> String
background int =
    let
        ( c1, c2 ) =
            case int of
                1 ->
                    ( "var(--red)", "var(--orange)" )

                5 ->
                    ( "var(--orange)", "var(--yellow)" )

                2 ->
                    ( "var(--yellow)", "var(--green)" )

                6 ->
                    ( "var(--green)", "var(--cyan)" )

                3 ->
                    ( "var(--cyan)", "var(--blue)" )

                7 ->
                    ( "var(--blue)", "var(--violette)" )

                4 ->
                    ( "var(--violette)", "var(--purple)" )

                8 ->
                    ( "var(--purple)", "var(--red)" )

                _ ->
                    ( "white", "darkGray" )
    in
    "linear-gradient(to bottom right," ++ c1 ++ ", " ++ c2 ++ ")"


viewportMeta : Html msg
viewportMeta =
    let
        width : String
        width =
            String.fromFloat 400
    in
    Html.node "meta"
        [ Html.Attributes.name "viewport"
        , Html.Attributes.attribute "content" ("user-scalable=no,width=" ++ width)
        ]
        []


toHtml :
    { onClick : Int -> msg
    , currentLevel : Int
    , transitioning : Bool
    }
    -> Maybe Game
    -> List (Html msg)
toHtml args maybe =
    [ maybe
        |> Maybe.map
            (\game ->
                [ String.fromInt args.currentLevel
                    ++ " / 10"
                    |> Layout.text
                        [ Html.Attributes.style "color" "white"
                        , Html.Attributes.style "position" "relative"
                        , Html.Attributes.style "bottom" (Config.squareSize * 3 // 2 |> String.fromInt)
                        , Html.Attributes.style "font-size" "50px"
                        ]
                , { nodes = game.board
                  , width = game.width
                  , height = game.height
                  , tiles = game.tiles
                  , onClick = args.onClick
                  , goal = game.goal
                  }
                    |> tile
                ]
                    |> Layout.column
                        ([ Html.Attributes.style "height" "100%"
                         , if args.transitioning then
                            Css.container_loading

                           else
                            Css.container
                         ]
                            ++ Layout.centered
                        )
            )
        |> Maybe.withDefault
            ([ "Thanks for playing"
                |> Layout.text
                    [ Html.Attributes.style "color" "white"
                    , Html.Attributes.style "font-size" "50px"
                    ]
             ]
                |> Layout.column
                    ([ Html.Attributes.style "height" "100%"
                     , if args.transitioning then
                        Css.container_loading

                       else
                        Css.container
                     ]
                        ++ Layout.centered
                    )
            )
    , viewportMeta
    , Html.node "link"
        [ Html.Attributes.rel "stylesheet"
        , Html.Attributes.href "style.css"
        ]
        []
    ]
