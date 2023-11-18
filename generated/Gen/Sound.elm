module Gen.Sound exposing (Sound(..), toString, fromString, asList)

{-| This module was generated. Any changes will be overwritten.

@docs Sound, toString, fromString, asList

-}
    
{-| Reprentation of Sound
-}
type Sound = ClickButton

{-| List of all playable sounds
-}
asList : List Sound
asList =
    [ ClickButton ]

{-| returns the path to the sound
-}
toString : Sound -> String
toString sound =
    case sound of
      ClickButton -> "ClickButton.mp3"

fromString : String -> Maybe Sound
fromString string =
    case string of
      "ClickButton.mp3" -> Just ClickButton
      _ -> Nothing   
