module View.Game exposing (..)


description : Int -> String
description int =
    case int of
        1 ->
            "Click the ball to move it into the goal"

        2 ->
            "You can only move something if the direction is unique."

        3 ->
            "If you think you're stuck, just try around for a bit"

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
            "You can solve this level"

        _ ->
            ""
