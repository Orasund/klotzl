module Test.Level exposing (..)

import Dict
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Game.Level
import Game.Solve
import Set
import Test exposing (..)
import Test.Game


suite : Test
suite =
    List.range 1 8
        |> List.filterMap (\i -> Game.Level.get i |> Maybe.map (Tuple.pair i))
        |> List.map
            (\( i, game ) ->
                (\() ->
                    game
                        |> Game.Solve.findSoftlocks
                        |> Expect.equalSets Set.empty
                )
                    |> Test.test ("Level" ++ String.fromInt i)
            )
        |> Test.describe "No Softlocks"
