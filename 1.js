const fs = require("fs");

const content = fs.readFileSync(__dirname + "/test.txt", "utf-8");

const parts = content.replace(/\\\n\s+/g, "").split("\n").filter(item => item);

for (const item of parts) {
    console.log(item);
}