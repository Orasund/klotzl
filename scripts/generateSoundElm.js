
const path = require("path");
const fs = require("fs");

const soundSources = fs.readdirSync("assets/sounds");

/** converts the string into a customType constructor name
 * @param {string} string 
 * @returns {string}
 */
function toName(string) {
    return string
        .split(".")[0]
        .split(/[^a-zA-Z0-9]/g)
        .map(it => it.replace(/[^a-zA-Z0-9]/g, ''))
        .map(it => it[0].toUpperCase() + it.slice(1))
        .join("")
}

const content =
    `module Gen.Sound exposing (Sound(..), toString, fromString, asList)

{-| This module was generated. Any changes will be overwritten.

@docs Sound, toString, fromString, asList

-}
    
{-| Reprentation of Sound
-}
type Sound = ${soundSources.map(toName).join(" | ")}

{-| List of all playable sounds
-}
asList : List Sound
asList =
    [ ${soundSources.map(toName).join(", ")} ]

{-| returns the path to the sound
-}
toString : Sound -> String
toString sound =
    case sound of
${soundSources
        .map(source =>
            `      ${toName(source)} -> "${source}"`
        )
        .join("\n\n")
    }

fromString : String -> Maybe Sound
fromString string =
    case string of
${soundSources
        .map(source =>
            `      "${source}" -> Just ${toName(source)}`
        )
        .join("\n\n")
    }
      _ -> Nothing   
`;
if (!fs.existsSync("generated")) fs.mkdirSync("generated");
if (!fs.existsSync("generated/Gen")) fs.mkdirSync("generated/Gen");
fs.writeFileSync("generated/Gen/Sound.elm", content);