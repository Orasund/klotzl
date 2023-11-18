# Node.js Scripts

## CreateZip.js

Compresses the folder `assets` and the file `index.html` into a zip.

```
node script/createZip.js <OutputPath>
```

* OutputPath - The path to the resulting zip.
    Default: Game.zip

Example:

```
# Zip the content and save it as Output.zip
node scripts/createZip.js Output.zip
```

## GenerateSoundElm.js

Generates the file `generated/Gen/Sound.elm` based on sound files located under `assets/sounds`.

```
node script/generateSoundElm.js
```