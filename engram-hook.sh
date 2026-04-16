#!/bin/bash
# Engram — PreCompact hook (archived)
# Reads hook stdin, extracts transcript path, invokes Claude to write an engram
# into the project's .engram/ directory before compaction.

set -euo pipefail

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

# Extract cwd from transcript entries — $PWD in a hook subprocess is /private/tmp
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

if [ -z "$CWD" ]; then
  CWD="${PWD}"
fi

if [ -z "$TRANSCRIPT_PATH" ] || [ ! -f "$TRANSCRIPT_PATH" ]; then
  echo "[Engram] no transcript available, skipping" >&2
  exit 0
fi

ENGRAM_INSTRUCTIONS=$(cat ~/.claude/commands/engram.md)

PROMPT="You are Engram running as a PreCompact hook.

Trigger: $TRIGGER
Session ID: $SESSION_ID
Project directory: $CWD
Transcript file: $TRANSCRIPT_PATH

Read the transcript JSONL file. Focus on user messages (plain string content) and assistant text blocks. Skip file-history-snapshot entries, isMeta entries, and thinking blocks.

Reconstruct what happened in the session and follow these instructions:

$ENGRAM_INSTRUCTIONS

Save the engram to: $CWD/.engram/<YYYY-MM-DD-HHMMSS>/<YYYY-MM-DD-HHMMSS>.md"

claude -p "$PROMPT" \
  --dangerously-skip-permissions \
  2>/dev/null

exit 0
