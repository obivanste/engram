#!/bin/bash
# Engram — installer
# Installs the /engram command into Claude Code.
# Engram files are saved to .engram/ inside each project repo (gitignored).

set -euo pipefail

COMMANDS_DIR="$HOME/.claude/commands"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── colors ───────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
DIM='\033[2m'
RESET='\033[0m'

ok()  { echo -e "${GREEN}✓${RESET} $1"; }
dim() { echo -e "${DIM}$1${RESET}"; }

echo ""
echo "Engram — installer"
dim "────────────────────"
echo ""

# ── ~/.claude/commands/ ───────────────────────────────────────────────────────
if [ ! -d "$COMMANDS_DIR" ]; then
  mkdir -p "$COMMANDS_DIR"
  ok "Created $COMMANDS_DIR"
fi

if [ -f "$COMMANDS_DIR/engram.md" ]; then
  cp "$COMMANDS_DIR/engram.md" "$COMMANDS_DIR/engram.md.bak"
  dim "  Backed up existing engram.md → engram.md.bak"
fi

cp "$SCRIPT_DIR/engram.md" "$COMMANDS_DIR/engram.md"
ok "Installed /engram → $COMMANDS_DIR/engram.md"

if [ -f "$COMMANDS_DIR/recall.md" ]; then
  cp "$COMMANDS_DIR/recall.md" "$COMMANDS_DIR/recall.md.bak"
  dim "  Backed up existing recall.md → recall.md.bak"
fi

cp "$SCRIPT_DIR/recall.md" "$COMMANDS_DIR/recall.md"
ok "Installed /recall → $COMMANDS_DIR/recall.md"

# ── done ─────────────────────────────────────────────────────────────────────
echo ""
echo "All done."
dim "  /engram — save the current session to .engram/ in your project"
dim "  /recall  — load the latest engram back into context"
dim ""
dim "  Use /engram <name> or /recall <name> for named saves."
echo ""
