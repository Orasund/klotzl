module Test.Game exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Game
import Game.Level
import Test exposing (..)


suite : Test
suite =
    (\() ->
        Game.Level.lvl1
            |> (\game -> Game.fromBoard { board = game.board, goal = game.goal })
            |> Expect.equal Game.Level.lvl1
    )
        |> Test.test "Game.fromBoard"
