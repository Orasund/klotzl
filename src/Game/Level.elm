module Game.Level exposing (..)

import Dict
import Game exposing (Game)


lvl1 : Game
lvl1 =
    { board = Dict.fromList [ ( ( 1, 0 ), -1 ), ( ( 0, 0 ), 1 ) ]
    , width = 2
    , height = 1
    , goal = ( 1, -1 )
    , tiles =
        [ ( -1, { topLeft = ( 1, 0 ), size = ( 1, 1 ) } )
        , ( 1, { topLeft = ( 0, 0 ), size = ( 1, 1 ) } )
        ]
            |> Dict.fromList
    }


lvl2 : Game
lvl2 =
    { board = Dict.fromList [ ( ( 1, 1 ), -1 ), ( ( 0, 0 ), 1 ), ( ( 0, 1 ), 2 ) ]
    , width = 2
    , height = 2
    , goal = ( 1, -1 )
    , tiles =
        [ ( -1, { topLeft = ( 1, 1 ), size = ( 1, 1 ) } )
        , ( 1, { topLeft = ( 0, 0 ), size = ( 1, 1 ) } )
        , ( 2, { topLeft = ( 0, 1 ), size = ( 1, 1 ) } )
        ]
            |> Dict.fromList
    }


lvl3 : Game
lvl3 =
    { board = Dict.fromList [ ( ( 1, 2 ), -1 ), ( ( 0, 0 ), 1 ), ( ( 0, 1 ), 1 ), ( ( 0, 2 ), 2 ) ]
    , width = 2
    , height = 3
    , goal = ( 1, -1 )
    , tiles =
        [ ( -1, { topLeft = ( 1, 2 ), size = ( 1, 1 ) } )
        , ( 1, { topLeft = ( 0, 0 ), size = ( 1, 2 ) } )
        , ( 2, { topLeft = ( 0, 2 ), size = ( 1, 1 ) } )
        ]
            |> Dict.fromList
    }


lvl4 : Game
lvl4 =
    { board = Dict.fromList [ ( ( 2, 2 ), -1 ), ( ( 1, 0 ), 1 ), ( ( 1, 1 ), 1 ), ( ( 0, 0 ), 2 ), ( ( 0, 1 ), 3 ), ( ( 0, 2 ), 4 ) ]
    , width = 3
    , height = 3
    , goal = ( 2, -1 )
    , tiles =
        [ ( -1, { topLeft = ( 2, 2 ), size = ( 1, 1 ) } )
        , ( 1, { topLeft = ( 1, 0 ), size = ( 1, 2 ) } )
        , ( 2, { topLeft = ( 0, 0 ), size = ( 1, 1 ) } )
        , ( 3, { topLeft = ( 0, 1 ), size = ( 1, 1 ) } )
        , ( 4, { topLeft = ( 0, 2 ), size = ( 1, 1 ) } )
        ]
            |> Dict.fromList
    }


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
    , width = 3
    , height = 3
    , goal = ( 2, -1 )
    , tiles =
        [ ( -1, { topLeft = ( 2, 2 ), size = ( 1, 1 ) } )
        , ( 1, { topLeft = ( 0, 0 ), size = ( 1, 2 ) } )
        , ( 2, { topLeft = ( 2, 0 ), size = ( 1, 2 ) } )
        , ( 3, { topLeft = ( 1, 1 ), size = ( 1, 1 ) } )
        , ( 4, { topLeft = ( 1, 2 ), size = ( 1, 1 ) } )
        ]
            |> Dict.fromList
    }
