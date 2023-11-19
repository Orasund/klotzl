module Game exposing (..)

import Dict exposing (Dict)
import Set


type alias Game =
    { board : Dict ( Int, Int ) Int
    , width : Int
    , height : Int
    , goal : ( Int, Int )
    , tiles :
        Dict
            Int
            { topLeft : ( Int, Int )
            , size : ( Int, Int )
            }
    }


fromBoard :
    { board : Dict ( Int, Int ) Int
    , goal : ( Int, Int )
    }
    -> Game
fromBoard args =
    let
        { width, height } =
            args.board
                |> Dict.keys
                |> List.foldl
                    (\( x, y ) dim ->
                        { width = max dim.width (x + 1)
                        , height = max dim.height (y + 1)
                        }
                    )
                    { width = 0, height = 0 }
    in
    { board = args.board
    , width = width
    , height = height
    , goal = args.goal
    , tiles =
        args.board
            |> Dict.foldl
                (\( x, y ) int ->
                    Dict.update int
                        (\maybe ->
                            maybe
                                |> Maybe.withDefault
                                    { min = { x = x, y = y }
                                    , max = { x = x, y = y }
                                    }
                                |> (\tile ->
                                        { min =
                                            { x = min tile.min.x x
                                            , y = min tile.min.y y
                                            }
                                        , max =
                                            { x = max tile.max.x x
                                            , y = max tile.max.y y
                                            }
                                        }
                                   )
                                |> Just
                        )
                )
                Dict.empty
            |> Dict.map
                (\_ tile ->
                    { topLeft = ( tile.min.x, tile.min.y )
                    , size =
                        ( tile.max.x - tile.min.x + 1
                        , tile.max.y - tile.min.y + 1
                        )
                    }
                )
    }


setBoard : Dict ( Int, Int ) Int -> Game -> Game
setBoard board game =
    fromBoard { board = board, goal = game.goal }


test : Game
test =
    { board =
        [ ( ( 0, 0 ), 1 )
        , ( ( 0, 1 ), 2 )
        , ( ( 1, 0 ), 3 )
        , ( ( 1, 1 ), 3 )
        , ( ( 0, 2 ), 4 )
        , ( ( 0, 3 ), 4 )
        , ( ( 1, 2 ), 5 )
        , ( ( 1, 3 ), 6 )
        , ( ( 2, 3 ), -1 )
        ]
            |> Dict.fromList
    , width = 3
    , height = 4
    , goal = ( 2, -1 )
    , tiles =
        [ ( -1, { topLeft = ( 2, 3 ), size = ( 1, 1 ) } )
        , ( 1, { topLeft = ( 0, 0 ), size = ( 1, 1 ) } )
        , ( 2, { topLeft = ( 0, 1 ), size = ( 1, 1 ) } )
        , ( 3, { topLeft = ( 1, 0 ), size = ( 1, 2 ) } )
        , ( 4, { topLeft = ( 0, 2 ), size = ( 1, 2 ) } )
        , ( 5, { topLeft = ( 1, 2 ), size = ( 1, 1 ) } )
        , ( 6, { topLeft = ( 1, 3 ), size = ( 1, 1 ) } )
        ]
            |> Dict.fromList
    }


gameWon : Game -> Bool
gameWon game =
    game.board
        |> Dict.get game.goal
        |> (==) (Just -1)


move : Int -> Game -> Maybe Game
move targetId game =
    let
        movements =
            [ ( -1, 0 ), ( 1, 0 ), ( 0, -1 ), ( 0, 1 ) ]

        isValidPos ( x, y ) =
            if
                ((targetId == -1) && (( x, y ) == game.goal))
                    || ((0 <= x && x < game.width) && (0 <= y && y < game.height))
            then
                Just ( x, y )

            else
                Nothing
    in
    movements
        |> List.filterMap
            (\( x1, y1 ) ->
                game.board
                    |> Dict.foldl
                        (\( x2, y2 ) tileId ->
                            Maybe.andThen
                                (\list ->
                                    if tileId == targetId then
                                        ( x1 + x2, y1 + y2 )
                                            |> isValidPos
                                            |> Maybe.andThen
                                                (\pos ->
                                                    if
                                                        game.board
                                                            |> Dict.get pos
                                                            |> Maybe.map ((==) targetId)
                                                            |> Maybe.withDefault True
                                                    then
                                                        pos :: list |> Just

                                                    else
                                                        Nothing
                                                )

                                    else
                                        Just list
                                )
                        )
                        (Just [])
                    |> Maybe.map
                        (\list ->
                            { game
                                | board =
                                    list
                                        |> List.foldl (\pos -> Dict.insert pos targetId)
                                            (Dict.filter (\_ tileId -> tileId /= targetId) game.board)
                                , tiles =
                                    game.tiles
                                        |> Dict.update targetId
                                            (Maybe.map
                                                (\tile ->
                                                    { tile
                                                        | topLeft =
                                                            Tuple.mapBoth
                                                                ((+) x1)
                                                                ((+) y1)
                                                                tile.topLeft
                                                    }
                                                )
                                            )
                            }
                        )
            )
        |> (\list ->
                case list of
                    [ g ] ->
                        g |> Just

                    _ ->
                        Nothing
           )
