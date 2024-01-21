const sound =
{
    pool: new Map(),
    ctx: new AudioContext(),
    amountLoaded: 0
};

/**
 * Register all provided sounds 
 * @param {string[]} paths to the audio files
 */
export function registerAllSounds(paths) {
    paths.map(registerSound)
}

/**
 * Register a single audio file
 * @param {string} path to the audio file
 * @returns 
 */
export function registerSound(path) {
    const audio = new Audio();
    sound.ctx.createMediaElementSource(audio)
        .connect(sound.ctx.destination);
    audio.src = "assets/sounds/" + path;
    audio.oncanplay = () => sound.amountLoaded++
    sound.pool.set(path, audio);
}

/**
 * Play an aduio file
 * @param {string} path 
 * @param {bool} playEndlessly 
 * @param {() => void} onended
 */
export function playSound(path, playEndlessly, onended) {
    const audio = sound.pool.get(path)
    if (audio === undefined)
        console.log(path + " not found. Please register it before playing.")

    audio.onended = playEndlessly
        ? () => {
            audio.load();
            audio.play();
        }
        : onended()

    if (sound.ctx.state === "suspended") {
        sound.ctx.resume();
        audio.load();
        audio.play();
        console.log("sound resumed")
    } else {
        audio.load();
        audio.play();
    }

}

export function stopSound(path) {
    const audio = sound.pool.get(path)
    if (audio === undefined)
        console.log(path + " not found. Please register it before playing.")

    audio.load();
}
