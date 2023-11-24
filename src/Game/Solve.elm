module Game.Solve exposing (..)

import Dict exposing (Dict)
import Game exposing (Game)
import Game.Node exposing (Node)
import Set exposing (Set)


type alias Graph =
    { nodes : Set Node
    , winning : Set Node
    }


validMoves : Game -> List Game
validMoves game =
    if Game.gameWon game then
        []

    else
        game.tiles
            |> Dict.keys
            |> List.filterMap
                (\id ->
                    Game.move id game
                )


getNodes :
    { remaining : List Node
    , nodes : Set Node
    , winning : Set Node
    , pathTo : Dict Node (Set Node)
    }
    -> Game
    ->
        { nodes : Set Node
        , winning : Set Node
        , pathTo : Dict Node (Set Node)
        }
getNodes args game =
    case args.remaining of
        head :: tail ->
            let
                g : Game
                g =
                    Game.Node.toGame { goals = game.goal } head

                moves : List Node
                moves =
                    validMoves g
                        |> List.map Game.Node.fromGame

                nodes : Set Node
                nodes =
                    args.nodes |> Set.insert head

                remaining =
                    List.filter (\move -> Set.member move nodes |> not) moves ++ tail
            in
            getNodes
                { remaining = remaining
                , nodes = nodes
                , winning =
                    if moves == [] && Game.gameWon g then
                        args.winning |> Set.insert head

                    else
                        args.winning
                , pathTo =
                    moves
                        |> List.foldl
                            (\m ->
                                Dict.update m
                                    (\maybe ->
                                        maybe
                                            |> Maybe.map (Set.insert head)
                                            |> Maybe.withDefault (Set.singleton head)
                                            |> Just
                                    )
                            )
                            args.pathTo
                }
                game

        [] ->
            { nodes = args.nodes
            , winning = args.winning
            , pathTo = args.pathTo
            }


buildGraph : Game -> Graph
buildGraph game =
    let
        getWinnings :
            { nodes : Set Node
            , remaining : Set Node
            , output : Set Node
            , pathTo : Dict Node (Set Node)
            }
            -> Set Node
        getWinnings args =
            if Set.isEmpty args.remaining then
                args.output

            else
                args.remaining
                    |> Set.foldl
                        (\a ->
                            Set.union
                                (args.pathTo
                                    |> Dict.get a
                                    |> Maybe.withDefault Set.empty
                                )
                        )
                        Set.empty
                    |> (\set ->
                            { args
                                | remaining = Set.diff set args.output
                                , output = Set.union args.output set
                            }
                                |> getWinnings
                       )
    in
    game
        |> getNodes
            { remaining = List.singleton (Game.Node.fromGame game)
            , nodes = Set.empty
            , winning = Set.empty
            , pathTo = Dict.empty
            }
        |> (\{ winning, nodes, pathTo } ->
                { nodes = nodes
                , winning =
                    getWinnings
                        { nodes = nodes
                        , remaining = winning
                        , output = winning
                        , pathTo = pathTo
                        }
                }
           )


findSoftlocks : Game -> Set Node
findSoftlocks game =
    let
        graph =
            game
                |> buildGraph
    in
    Set.diff graph.nodes graph.winning
