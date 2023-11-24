module Game.Node exposing (..)

import Dict
import Game exposing (Game)
import Set


type alias Node =
    ( List (List ( Int, Int ))
    , List ( Int, Int )
    )


fromGame : Game -> Node
fromGame game =
    game.tiles
        |> Dict.toList
        |> List.partition (\( i, _ ) -> i > 0)
        |> Tuple.mapBoth
            (\list ->
                list
                    |> List.map
                        (\( _, tile ) ->
                            let
                                ( x0, y0 ) =
                                    tile.topLeft
                            in
                            tile.blocks
                                |> Set.map (\( x, y ) -> ( x0 + x, y0 + y ))
                                |> Set.toList
                        )
                    |> List.sort
            )
            (\list ->
                list
                    |> List.map (\( _, { topLeft } ) -> topLeft)
                    |> List.sort
            )


toGame : { goals : List ( Int, Int ) } -> Node -> Game
toGame args ( tiles, balls ) =
    Game.fromTiles
        { tiles = tiles
        , balls = balls
        , goals = args.goals
        }
