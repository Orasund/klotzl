module Gen.Sound exposing (Sound(..), toString, fromString, asList)

{-| This module was generated. Any changes will be overwritten.

@docs Sound, toString, fromString, asList

-}
    
{-| Reprentation of Sound
-}
type Sound = Error | Move | Pass | Win

{-| List of all playable sounds
-}
asList : List Sound
asList =
    [ Error, Move, Pass, Win ]

{-| returns the path to the sound
-}
toString : Sound -> String
toString sound =
    case sound of
      Error -> "error.mp3"

      Move -> "move.mp3"

      Pass -> "pass.mp3"

      Win -> "win.mp3"

fromString : String -> Maybe Sound
fromString string =
    case string of
      "error.mp3" -> Just Error

      "move.mp3" -> Just Move

      "pass.mp3" -> Just Pass

      "win.mp3" -> Just Win
      _ -> Nothing   
