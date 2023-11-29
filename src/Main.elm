module Main exposing (..)

import Browser
import Game exposing (Game)
import Game.Level
import Gen.Sound exposing (Sound(..))
import Html exposing (Html)
import Json.Decode
import Port
import PortDefinition exposing (FromElm(..), ToElm(..))
import Process
import Task
import View


type alias Model =
    { game : Maybe Game
    , currentLevel : Int
    , transitioning : Bool
    }


type Msg
    = MoveBlock Int
    | Received (Result Json.Decode.Error ToElm)
    | UnloadGame
    | LoadGame


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
    let
        currentLevel =
            1
    in
    ( { game = Nothing --Game.Level.get currentLevel
      , currentLevel = currentLevel
      , transitioning = False
      }
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
        model.game
            |> View.toHtml
                { onClick = MoveBlock
                , currentLevel = model.currentLevel
                , transitioning = model.transitioning
                }
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
                    |> Maybe.andThen (Game.move int)
            of
                Just game ->
                    let
                        won =
                            Game.gameWon game
                    in
                    ( { model
                        | game =
                            Just game
                        , transitioning = won
                      }
                    , if won then
                        [ PlaySound { sound = Move, looping = False }
                            |> Port.fromElm
                        , PlaySound { sound = Win, looping = False }
                            |> Port.fromElm
                        , Task.perform (\() -> UnloadGame) (Process.sleep 1000)
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
                Ok (SoundEnded _) ->
                    model |> withNoCmd

                Err error ->
                    let
                        _ =
                            Debug.log "received invalid json" error
                    in
                    model |> withNoCmd

        UnloadGame ->
            ( { model
                | game = Nothing
                , transitioning = False
                , currentLevel = model.currentLevel + 1
              }
            , Task.perform (\() -> LoadGame) (Process.sleep 20)
            )

        LoadGame ->
            ( { model
                | game = Game.Level.get model.currentLevel
              }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Port.toElm |> Sub.map Received
