# Sound

To play sound, two things must have happend before:

1. The user has already interacted with the game. Like clicking a button or setting the focus on an element of the game.
2. The file has to be loaded.

This repository comes with a sound engine, located at `assets/js/sound.js`, that takes care of these two things.

## Setup

If you use this repository as is, then everything is already setup.

If you start with an existing codebase, then just add the following lines as `Cmd` in your init function.

```
Gen.Sound.asList |> RegisterSounds |> Port.fromElm
```

** Background**

Sounds have to be registered before they can be played. Without registering the sounds, you could only ever play one sound at a time.

## Adding a new Sound

You can find free sounds at [kenney.nl](https://kenney.nl/assets/category:Audio) and [pixabay.com](https://pixabay.com/sound-effects/). But make sure to give credits!

To add a new Sound to the system, you have to

1. Place the file inside `asserts\sounds`, and
2. Run `npm run generateSound`(See [docs](/docs/Scripts.md#generatesoundelmjs) for more info). This will generate the file `generated/Gen/Sound.elm` containing a representation of your Sounds.

## Play Sound

```
import PortDefinition exposing (FromElm(..))

--Playing the sound "ClickButton.mp3"
PlaySound { sound = ClickButton, looping = False }
    |> InteropPorts.fromElm
```

This will play the sound and send a `SoundEnded` message after its finished.

```
update msg model =
    case msg of
        Received result ->
            case result of
                Ok (SoundEnded sound) ->
                    --Add your logic here.
```