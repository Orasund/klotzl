module Test.Game exposing (..)

import Dict
import Expect
import Game
import Game.Level
import Test exposing (..)


suite : Test
suite =
    (\() ->
        { board = Dict.fromList [ ( ( 1, 0 ), -1 ), ( ( 0, 0 ), 1 ) ]
        , width = 1
        , height = 2
        , goal = [ ( 1, -1 ) ]
        , tiles =
            Dict.fromList
                [ ( -1, Game.singleBlockTile ( 1, 0 ) )
                , ( 1, Game.singleBlockTile ( 0, 0 ) )
                ]
        }
            |> (\game -> Game.fromBoard { board = game.board, goal = game.goal })
            |> Expect.equal Game.Level.lvl1
    )
        |> Test.test "Game.fromBoard"
