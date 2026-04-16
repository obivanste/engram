#!/bin/bash
# TotalReClaude — PreCompact hook
# Reads hook stdin, extracts transcript path, invokes Claude to write a session folder
# with summary.md and session.md into the project's .recall/ directory.

set -euo pipefail

# --- Read hook input from stdin ---
INPUT=$(cat)

TRANSCRIPT_PATH=$(echo "$INPUT" | python3 -c "
import json, sys
d = json.load(sys.stdin)
print(d.get('transcript_path', ''))
" 2>/dev/null || echo "")

SESSION_ID=$(echo "$INPUT" | python3 -c "
import json, sys
d = json.load(sys.stdin)
print(d.get('session_id', ''))
" 2>/dev/null || echo "")

TRIGGER=$(echo "$INPUT" | python3 -c "
import json, sys
d = json.load(sys.stdin)
print(d.get('trigger', 'auto'))
" 2>/dev/null || echo "auto")

# Extract cwd from the transcript entries (first message that has a cwd field)
# $PWD in a hook subprocess is /private/tmp — not the session's project directory
CWD=$(python3 -c "
import json, sys
with open('$TRANSCRIPT_PATH') as f:
    for line in f:
        try:
            entry = json.loads(line)
            cwd = entry.get('cwd', '')
            if cwd:
                print(cwd)
                sys.exit(0)
        except Exception:
            continue
" 2>/dev/null || echo "")

# Final fallback — should rarely be needed
if [ -z "$CWD" ]; then
  CWD="${PWD}"
fi

# --- Bail early if no transcript ---
if [ -z "$TRANSCRIPT_PATH" ] || [ ! -f "$TRANSCRIPT_PATH" ]; then
  echo "[TotalReClaude] no transcript available, skipping" >&2
  exit 0
fi

# --- Build prompt ---
RECALL_INSTRUCTIONS=$(cat ~/.claude/commands/recall.md)

PROMPT="You are TotalReClaude running as a PreCompact hook.

Trigger: $TRIGGER
Session ID: $SESSION_ID
Project directory: $CWD
Transcript file: $TRANSCRIPT_PATH

Read the transcript file at the path above. It is a JSONL file — each line is a JSON object.
Focus on entries where:
- type is \"user\" and message.content is a plain string (the user's messages)
- type is \"assistant\" and message.content contains text blocks (Claude's responses)
- Skip file-history-snapshot entries, isMeta entries, and thinking blocks

From this, reconstruct what happened in the session and follow these instructions:

$RECALL_INSTRUCTIONS

Use 'pre-compact' as the trigger value in the output file headers.
Save both files into a session folder at: $CWD/.recall/<YYYY-MM-DD-HHMMSS>/"

# --- Invoke Claude non-interactively ---
claude -p "$PROMPT" \
  --dangerously-skip-permissions \
  2>/dev/null

exit 0
