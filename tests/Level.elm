module Level exposing (..)

import Dict
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Game
import Game.Level
import Game.Solve
import Set
import Test exposing (..)


trivial : Test
trivial =
    [ (\() ->
        { board = Dict.fromList [ ( ( 1, 1 ), -1 ), ( ( 0, 1 ), 1 ) ]
        , width = 2
        , height = 2
        , goal = ( 1, -1 )
        , tiles =
            [ ( -1, { topLeft = ( 1, 1 ), size = ( 1, 1 ) } )
            , ( 1, { topLeft = ( 0, 1 ), size = ( 1, 1 ) } )
            ]
                |> Dict.fromList
        }
            |> Game.Solve.findSoftlocks
            |> Expect.equalSets
                (Set.fromList
                    [ [ ( ( 0, 0 ), 1 ), ( ( 1, 1 ), -1 ) ]
                    , [ ( ( 0, 1 ), 1 ), ( ( 1, 0 ), -1 ) ]
                    ]
                )
      )
        |> Test.test "Trivially False"
    ]
        |> Test.describe "Trivial"


suite : Test
suite =
    List.range 1 5
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
        |> Test.describe "Solvable"
