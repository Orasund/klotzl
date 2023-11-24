module Test.Node exposing (..)

import Dict
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Game
import Game.Level
import Game.Node
import Test exposing (..)


suite : Test
suite =
    let
        node =
            ( [ [ ( 1, 1 ), ( 1, 2 ) ] ], [ ( 0, 1 ) ] )

        game =
            Game.fromBoard
                { board =
                    Dict.fromList
                        [ ( ( 0, 1 ), -1 )
                        , ( ( 1, 1 ), 1 )
                        , ( ( 1, 2 ), 1 )
                        ]
                , goal = []
                }
    in
    [ (\() ->
        node
            |> Game.Node.toGame { goals = [] }
            |> Expect.equal game
      )
        |> Test.test "toGame"
    , (\() ->
        game |> Game.Node.fromGame |> Expect.equal node
      )
        |> Test.test "fromGame"
    ]
        |> Test.describe "Game.Node"
