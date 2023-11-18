const zl = require("zip-lib");

const OUTPUT = process.argv[2] ?? "Game.zip"

const zip = new zl.Zip()
zip.addFolder("assets", "assets")
zip.addFile("index.html")
zip.archive(OUTPUT)

console.log(OUTPUT + " created")
console.log("    | index.html")
console.log("    | assets/*")
console.log("")