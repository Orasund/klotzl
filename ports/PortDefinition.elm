module PortDefinition exposing (Flags, FromElm(..), ToElm(..), interop)

import Gen.Sound exposing (Sound)
import TsJson.Decode as TsDecode exposing (Decoder)
import TsJson.Encode as TsEncode exposing (Encoder)


interop :
    { toElm : Decoder ToElm
    , fromElm : Encoder FromElm
    , flags : Decoder Flags
    }
interop =
    { toElm = toElm
    , fromElm = fromElm
    , flags = flags
    }


type FromElm
    = RegisterSounds (List Sound)
    | PlaySound { sound : Sound, looping : Bool }
    | StopSound Sound


type ToElm
    = SoundEnded Sound


type alias Flags =
    {}


fromElm : Encoder FromElm
fromElm =
    let
        soundEncoder =
            TsEncode.string |> TsEncode.map Gen.Sound.toString
    in
    TsEncode.union
        (\playSound stopSound registerSounds value ->
            case value of
                RegisterSounds list ->
                    registerSounds list

                PlaySound args ->
                    playSound args

                StopSound args ->
                    stopSound args
        )
        |> TsEncode.variantTagged "playSound"
            (TsEncode.object
                [ TsEncode.required "sound" (\obj -> obj.sound |> Gen.Sound.toString) TsEncode.string
                , TsEncode.required "looping" .looping TsEncode.bool
                ]
            )
        |> TsEncode.variantTagged "stopSound" soundEncoder
        |> TsEncode.variantTagged "registerSounds" (TsEncode.list soundEncoder)
        |> TsEncode.buildUnion


toElm : Decoder ToElm
toElm =
    TsDecode.discriminatedUnion "type"
        [ ( "soundEnded"
          , TsDecode.succeed SoundEnded
                |> TsDecode.andMap
                    (TsDecode.field "sound"
                        (TsDecode.string
                            |> TsDecode.andThen
                                (TsDecode.andThenInit
                                    (\string ->
                                        string
                                            |> Gen.Sound.fromString
                                            |> Maybe.map TsDecode.succeed
                                            |> Maybe.withDefault (TsDecode.fail ("Unkown sound ended: " ++ string))
                                    )
                                )
                        )
                    )
          )
        ]


flags : Decoder Flags
flags =
    TsDecode.null {}
