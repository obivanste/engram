#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const os = require("os");

const GREEN = "\x1b[32m";
const DIM = "\x1b[2m";
const RESET = "\x1b[0m";

const ok = (msg) => console.log(`${GREEN}✓${RESET} ${msg}`);
const dim = (msg) => console.log(`${DIM}${msg}${RESET}`);

const commandsDir = path.join(os.homedir(), ".claude", "commands");

const commands = [
  { file: "engram.md", label: "/engram" },
  { file: "recall.md", label: "/recall" },
];

console.log("");
console.log("Engram — installer");
dim("────────────────────");
console.log("");

if (!fs.existsSync(commandsDir)) {
  fs.mkdirSync(commandsDir, { recursive: true });
  ok(`Created ${commandsDir}`);
}

for (const { file, label } of commands) {
  const source = path.join(__dirname, "..", file);
  const dest = path.join(commandsDir, file);

  if (fs.existsSync(dest)) {
    fs.copyFileSync(dest, dest + ".bak");
    dim(`  Backed up existing ${file} → ${file}.bak`);
  }

  fs.copyFileSync(source, dest);
  ok(`Installed ${label} → ${dest}`);
}

console.log("");
console.log("All done.");
dim("  /engram — save the current session to .engram/ in your project");
dim("  /recall  — load the latest engram back into context");
dim("");
dim("  Use /engram <name> or /recall <name> for named saves.");
console.log("");
