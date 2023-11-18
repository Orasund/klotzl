module Main exposing (..)

import Browser
import Game exposing (Game)
import Game.Level
import Gen.Sound exposing (Sound(..))
import Html exposing (Html)
import Json.Decode exposing (Value)
import Port
import PortDefinition exposing (FromElm(..), ToElm(..))
import View


type alias Model =
    { game : Game }


type Msg
    = MoveBlock Int
    | Received (Result Json.Decode.Error ToElm)


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : () -> ( Model, Cmd Msg )
init () =
    ( { game = Game.Level.lvl5 }
    , Gen.Sound.asList |> RegisterSounds |> Port.fromElm
    )


view :
    Model
    ->
        { title : String
        , body : List (Html Msg)
        }
view model =
    { title = "Test"
    , body =
        View.toHtml MoveBlock
            model.game
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        withNoCmd a =
            ( a, Cmd.none )
    in
    case msg of
        MoveBlock int ->
            case
                model.game
                    |> Game.move int
            of
                Just game ->
                    ( { game =
                            game
                      }
                    , if Game.gameWon game then
                        [ PlaySound { sound = Move, looping = False }
                            |> Port.fromElm
                        , PlaySound { sound = Win, looping = False }
                            |> Port.fromElm
                        ]
                            |> Cmd.batch

                      else
                        PlaySound { sound = Move, looping = False }
                            |> Port.fromElm
                    )

                Nothing ->
                    ( model
                    , PlaySound { sound = Pass, looping = False }
                        |> Port.fromElm
                    )

        Received result ->
            case result of
                Ok (SoundEnded sound) ->
                    model |> withNoCmd

                Err error ->
                    let
                        _ =
                            Debug.log "received invalid json" error
                    in
                    model |> withNoCmd


subscriptions : Model -> Sub Msg
subscriptions _ =
    Port.toElm |> Sub.map Received
