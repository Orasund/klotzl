module Game.Level exposing (..)

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
            Just lvl3_1

        5 ->
            Just lvl4

        6 ->
            Just lvl5

        7 ->
            Just lvl11

        8 ->
            Just lvl12

        9 ->
            Just lvl6

        10 ->
            Just lvl7

        --11 ->
        --    Just lvl9
        --12 ->
        --  Just lvl9
        _ ->
            Nothing


lvl1 : Game
lvl1 =
    Game.fromMatrix [ ( 1, -1 ) ]
        [ [ 1, -1 ] ]


lvl2 : Game
lvl2 =
    Game.fromMatrix [ ( 1, -1 ) ]
        [ [ 1, 0 ]
        , [ 2, -1 ]
        ]


lvl3 : Game
lvl3 =
    Game.fromMatrix [ ( 1, -1 ) ]
        [ [ 1, 4 ]
        , [ 2, 0 ]
        , [ 3, -1 ]
        ]


lvl3_1 : Game
lvl3_1 =
    Game.fromMatrix [ ( 2, -1 ) ]
        [ [ 1, 0, 0 ]
        , [ 2, 2, -1 ]
        ]


lvl4 : Game
lvl4 =
    Game.fromMatrix [ ( 2, -1 ) ]
        [ [ 2, 1, 5 ]
        , [ 3, 1, 0 ]
        , [ 4, 0, -1 ]
        ]


lvl5 : Game
lvl5 =
    Game.fromMatrix [ ( 2, -1 ) ]
        [ [ 1, 0, 2 ]
        , [ 1, 3, 2 ]
        , [ 0, 4, -1 ]
        ]


lvl6 : Game
lvl6 =
    Game.fromMatrix [ ( 0, -1 ), ( 2, -1 ) ]
        [ [ -1, 1, -2 ] ]


lvl7 : Game
lvl7 =
    Game.fromMatrix [ ( 0, -1 ), ( 3, -1 ) ]
        [ [ 1, 0, 0, 3 ]
        , [ -1, 2, 4, -2 ]
        ]



{--lvl8 : Game
lvl8 =
    Game.fromMatrix [ ( 0, -1 ), ( 2, -1 ) ]
        [ [ 0, 1, 0 ]
        , [ 2, 5, 3 ]
        , [ -1, 4, -2 ]
        ]--}


lvl9 : Game
lvl9 =
    Game.fromMatrix [ ( 0, -1 ), ( 3, -1 ) ]
        [ [ 0, 7, 2, 0 ]
        , [ 3, 1, 2, 4 ]
        , [ -1, 1, 6, -2 ]
        ]



{--lvl10 : Game
lvl10 =
    Game.fromMatrix [ ( 0, -1 ), ( 2, -1 ), ( 1, 3 ) ]
        [ [ 0, 1, 4 ]
        , [ 2, 5, 3 ]
        , [ -1, -3, -2 ]
        ]--}


lvl11 : Game
lvl11 =
    Game.fromMatrix [ ( 2, -1 ) ]
        [ [ 1, 0, 0 ]
        , [ 1, 1, -1 ]
        ]


lvl12 : Game
lvl12 =
    Game.fromMatrix [ ( 3, -1 ) ]
        [ [ 1, 0, 2, 2 ]
        , [ 1, 3, 0, 0 ]
        , [ 0, 3, 3, -1 ]
        ]


lvl13 : Game
lvl13 =
    Game.fromMatrix [ ( 3, -1 ) ]
        [ [ 3, 0, 0, 0 ]
        , [ 3, 2, 0, 0 ]
        , [ 0, 2, 1, 1 ]
        , [ 5, 5, 0, -1 ]
        ]
