module View.Game exposing (..)


description : Int -> String
description int =
    case int of
        1 ->
            "Click the ball to move it into the goal"

        2 ->
            "You can move tiles aswell"

        3 ->
            "You can only move something if the direction is unique."

        4 ->
            "Tiles can have different sizes"

        5 ->
            "Sometimes you have to work around a tile"

        6 ->
            "Don't give up"

        7 ->
            "Solve the level step by step"

        8 ->
            "Get all balls into the goals"

        9 ->
            "Apply everything you learned sofar"

        10 ->
            "Every level is solvable"

        _ ->
            ""
