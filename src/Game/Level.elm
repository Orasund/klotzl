module Game.Level exposing (..)

import Dict
import Game exposing (Game)


get : Int -> Maybe Game
get int =
    case int of
        1 ->
            Just lvl1

        2 ->
            Just lvl2

        3 ->
            Just lvl3

        4 ->
            Just lvl4

        5 ->
            Just lvl5

        6 ->
            Just lvl6

        _ ->
            Nothing


lvl1 : Game
lvl1 =
    { board = Dict.fromList [ ( ( 1, 0 ), -1 ), ( ( 0, 0 ), 1 ) ]
    , goal = [ ( 1, -1 ) ]
    }
        |> Game.fromBoard


lvl2 : Game
lvl2 =
    { board = Dict.fromList [ ( ( 1, 1 ), -1 ), ( ( 0, 0 ), 1 ), ( ( 0, 1 ), 2 ) ]
    , goal = [ ( 1, -1 ) ]
    }
        |> Game.fromBoard


lvl3 : Game
lvl3 =
    { board =
        Dict.fromList
            [ ( ( 1, 2 ), -1 )
            , ( ( 0, 0 ), 1 )
            , ( ( 0, 1 ), 2 )
            , ( ( 0, 2 ), 3 )
            , ( ( 1, 0 ), 4 )
            ]
    , goal = [ ( 1, -1 ) ]
    }
        |> Game.fromBoard


lvl4 : Game
lvl4 =
    { board =
        Dict.fromList
            [ ( ( 2, 2 ), -1 )
            , ( ( 1, 0 ), 1 )
            , ( ( 1, 1 ), 1 )
            , ( ( 0, 0 ), 2 )
            , ( ( 0, 1 ), 3 )
            , ( ( 0, 2 ), 4 )
            , ( ( 2, 0 ), 5 )
            ]
    , goal = [ ( 2, -1 ) ]
    }
        |> Game.fromBoard


lvl5 : Game
lvl5 =
    { board =
        Dict.fromList
            [ ( ( 2, 2 ), -1 )
            , ( ( 0, 0 ), 1 )
            , ( ( 0, 1 ), 1 )
            , ( ( 2, 0 ), 2 )
            , ( ( 2, 1 ), 2 )
            , ( ( 1, 1 ), 3 )
            , ( ( 1, 2 ), 4 )
            ]
    , goal = [ ( 2, -1 ) ]
    }
        |> Game.fromBoard


lvl6 : Game
lvl6 =
    { board =
        Dict.fromList
            [ ( ( 0, 2 ), -1 )
            , ( ( 2, 2 ), -2 )
            , ( ( 1, 0 ), 1 )
            , ( ( 0, 1 ), 2 )
            , ( ( 1, 1 ), 2 )
            , ( ( 2, 1 ), 3 )
            , ( ( 1, 2 ), 4 )
            ]
    , goal = [ ( 0, -1 ), ( 2, -1 ) ]
    }
        |> Game.fromBoard
