module Main exposing (..)

import Browser
import Game exposing (Game)
import Game.Level
import Gen.Sound exposing (Sound(..))
import Html exposing (Html)
import Json.Decode exposing (Value)
import Port
import PortDefinition exposing (FromElm(..), ToElm(..))
import Process
import Task
import View


type alias Model =
    { game : Maybe Game
    , currentLevel : Int
    , transitionTo : Maybe Game
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
    ( { game = Just Game.Level.lvl1
      , currentLevel = 1
      , transitionTo = Nothing
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
            |> Maybe.map (View.toHtml MoveBlock)
            |> Maybe.withDefault []
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
                    ( { model
                        | game =
                            Just game
                      }
                    , if Game.gameWon game then
                        [ PlaySound { sound = Move, looping = False }
                            |> Port.fromElm
                        , PlaySound { sound = Win, looping = False }
                            |> Port.fromElm
                        , Task.perform (\() -> UnloadGame) (Process.sleep 500)
                        , Task.perform (\() -> LoadGame) (Process.sleep 1000)
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

        UnloadGame ->
            ( { model
                | game = Nothing
                , transitionTo = Game.Level.get (model.currentLevel + 1)
                , currentLevel = model.currentLevel + 1
              }
            , Cmd.none
            )

        LoadGame ->
            ( { model | game = model.transitionTo, transitionTo = Nothing }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Port.toElm |> Sub.map Received
