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

# ── done ─────────────────────────────────────────────────────────────────────
echo ""
echo "All done. Type /engram in any Claude Code session to save your session."
dim "  Engram files are saved to .engram/ inside your project (gitignored)."
dim "  Use /engram <name> to create a named save instead of a timestamp."
echo ""
