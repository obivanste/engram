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
const source = path.join(__dirname, "..", "engram.md");
const dest = path.join(commandsDir, "engram.md");

console.log("");
console.log("Engram — installer");
dim("────────────────────");
console.log("");

if (!fs.existsSync(commandsDir)) {
  fs.mkdirSync(commandsDir, { recursive: true });
  ok(`Created ${commandsDir}`);
}

if (fs.existsSync(dest)) {
  fs.copyFileSync(dest, dest + ".bak");
  dim(`  Backed up existing engram.md → engram.md.bak`);
}

fs.copyFileSync(source, dest);
ok(`Installed /engram → ${dest}`);

console.log("");
console.log("All done. Type /engram in any Claude Code session to save your session.");
dim("  Engram files are saved to .engram/ inside your project (gitignored).");
dim("  Use /engram <name> to create a named save instead of an auto-generated slug.");
console.log("");
