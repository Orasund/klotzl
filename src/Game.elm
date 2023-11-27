module Game exposing (..)

import Dict exposing (Dict)
import Set exposing (Set)


type alias Tile =
    { topLeft : ( Int, Int )
    , size : ( Int, Int )
    , blocks : Set ( Int, Int )
    }


type alias Game =
    { board : Dict ( Int, Int ) Int
    , width : Int
    , height : Int
    , goal : List ( Int, Int )
    , tiles : Dict Int Tile
    }


singleBlockTile : ( Int, Int ) -> Tile
singleBlockTile pos =
    { topLeft = pos
    , size = ( 1, 1 )
    , blocks = Set.singleton ( 0, 0 )
    }


fromTiles :
    { tiles : List (List ( Int, Int ))
    , balls : List ( Int, Int )
    , goals : List ( Int, Int )
    }
    -> Game
fromTiles args =
    let
        buildTile list =
            case list of
                ( x0, y0 ) :: tail ->
                    tail
                        |> List.foldl
                            (\( x, y ) tile ->
                                { min =
                                    { x = min tile.min.x x
                                    , y = min tile.min.y y
                                    }
                                , max =
                                    { x = max tile.max.x x
                                    , y = max tile.max.y y
                                    }
                                , blocks = Set.insert ( x, y ) tile.blocks
                                }
                            )
                            { min = { x = x0, y = y0 }
                            , max = { x = x0, y = y0 }
                            , blocks = Set.singleton ( x0, y0 )
                            }
                        |> (\tile ->
                                { topLeft = ( tile.min.x, tile.min.y )
                                , size =
                                    ( tile.max.x - tile.min.x + 1
                                    , tile.max.y - tile.min.y + 1
                                    )
                                , blocks =
                                    tile.blocks
                                        |> Set.map
                                            (Tuple.mapBoth
                                                ((+) -tile.min.x)
                                                ((+) -tile.min.y)
                                            )
                                }
                           )

                [] ->
                    { topLeft = ( 0, 0 )
                    , size = ( 0, 0 )
                    , blocks = Set.empty
                    }

        tiles =
            List.indexedMap
                (\i list ->
                    ( i + 1, buildTile list )
                )
                args.tiles
                ++ List.indexedMap (\i pos -> ( -(i + 1), singleBlockTile pos ))
                    args.balls
                |> Dict.fromList

        board =
            tiles
                |> Dict.foldl
                    (\i tile dict ->
                        let
                            ( x0, y0 ) =
                                tile.topLeft
                        in
                        tile.blocks
                            |> Set.foldl
                                (\( x, y ) ->
                                    Dict.insert ( x0 + x, y0 + y )
                                        i
                                )
                                dict
                    )
                    Dict.empty

        { width, height } =
            board
                |> Dict.keys
                |> List.foldl
                    (\( x, y ) dim ->
                        { width = max dim.width (x + 1)
                        , height = max dim.height (y + 1)
                        }
                    )
                    { width = 0, height = 0 }
    in
    { goal = args.goals
    , tiles = tiles
    , width = width
    , height = height
    , board = board
    }


fromMatrix : List ( Int, Int ) -> List (List Int) -> Game
fromMatrix goals rows =
    { board =
        rows
            |> List.indexedMap
                (\y row ->
                    row
                        |> List.indexedMap (\x i -> ( ( x, y ), i ))
                        |> List.filter (\( _, i ) -> i /= 0)
                )
            |> List.concat
            |> Dict.fromList
    , goal = goals
    }
        |> fromBoard


fromBoard :
    { board : Dict ( Int, Int ) Int
    , goal : List ( Int, Int )
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
                                    , blocks = Set.singleton ( x, y )
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
                                        , blocks = Set.insert ( x, y ) tile.blocks
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
                    , blocks =
                        tile.blocks
                            |> Set.map
                                (Tuple.mapBoth
                                    ((+) -tile.min.x)
                                    ((+) -tile.min.y)
                                )
                    }
                )
    }


setBoard : Dict ( Int, Int ) Int -> Game -> Game
setBoard board game =
    fromBoard { board = board, goal = game.goal }


gameWon : Game -> Bool
gameWon game =
    game.goal
        |> List.all
            (\goal ->
                game.board
                    |> Dict.get goal
                    |> Maybe.map (\int -> int < 0)
                    |> Maybe.withDefault False
            )


move : Int -> Game -> Maybe Game
move targetId game =
    let
        movements =
            [ ( -1, 0 ), ( 1, 0 ), ( 0, -1 ), ( 0, 1 ) ]

        isValidPos ( x, y ) =
            if
                ((targetId < 0) && List.member ( x, y ) game.goal)
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
