/// <reference path="../../elm.d.ts" />

import { registerAllSounds, playSound } from "./sound.js";

var app = Elm.Main.init({ node: document.querySelector('main') })
// you can use ports and stuff here

function toElmSoundEnded(sound) {
    app.ports.interopToElm.send({ type: "soundEnded", sound })
}

app.ports.interopFromElm.subscribe(fromElm => {
    switch (fromElm.tag) {
        case "registerSounds":
            return registerAllSounds(fromElm.data);
        case "playSound":
            return playSound(fromElm.data.sound, fromElm.data.looping,
                () => toElmSoundEnded(fromElm.data.sound));
        case "stopSound":
            return stopSound(fromElm.data);
    };

})

