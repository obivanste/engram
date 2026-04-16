#!/bin/bash
# TotalReClaude — installer
# Installs the /recall command into Claude Code.
# Recall files are saved to .recall/ inside each project repo (gitignored).

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
echo "TotalReClaude — installer"
dim "────────────────────────────"
echo ""

# ── 1. ~/.claude/commands/ ───────────────────────────────────────────────────
if [ ! -d "$COMMANDS_DIR" ]; then
  mkdir -p "$COMMANDS_DIR"
  ok "Created $COMMANDS_DIR"
fi

# Back up existing recall.md if present
if [ -f "$COMMANDS_DIR/recall.md" ]; then
  cp "$COMMANDS_DIR/recall.md" "$COMMANDS_DIR/recall.md.bak"
  dim "  Backed up existing recall.md → recall.md.bak"
fi

cp "$SCRIPT_DIR/recall.md" "$COMMANDS_DIR/recall.md"
ok "Installed /recall → $COMMANDS_DIR/recall.md"

# ── done ─────────────────────────────────────────────────────────────────────
echo ""
echo "All done. Type /recall in any Claude Code session to save your session."
dim "  Recall files are saved to .recall/ inside your project (gitignored)."
dim "  Use /recall <name> to create a named folder instead of a timestamp."
echo ""
