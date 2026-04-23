---
description: Engram — save session to engram/ for safe resumption
argument-hint: "[folder-name] (optional — defaults to timestamp)"
---

# Engram — /engram

**Invocation context:**
- Git root: !`git rev-parse --show-toplevel 2>/dev/null || true`
- Working directory: !`pwd`
- Timestamp: !`date +"%Y-%m-%d-%H%M%S"`
- Git status: !`git status --short 2>/dev/null | head -20 || true`
- Recent commits: !`git log --oneline -5 2>/dev/null || true`
- CLAUDE.md locations: !`find . -name "CLAUDE.md" -maxdepth 4 2>/dev/null || true`
- Engram config: !`cat ~/.engramrc 2>/dev/null || true`
- Default engram dir exists: !`test -d ~/Documents/engram && echo "yes" || echo "no"`

## Instructions

### 1 — Determine the project root

Use this priority order:
1. Git root (from above) — most reliable
2. Nearest directory containing `CLAUDE.md` (from above), excluding `~/.claude/`
3. `DEFAULT_DIR` from `~/.engramrc` if present (e.g. `DEFAULT_DIR=/Users/you/Documents/engrams`)
4. `~/Documents/engram/` — persistent fallback, never disappears on reboot

For the fallback (priority 4): check whether `~/Documents/engram/` already exists (from the context above). If it does not exist, create it with `mkdir -p ~/Documents/engram` before saving. Never create `.engram` (with a leading dot) — always use `engram` without a dot prefix.

Never use `/private/tmp` or any other temp directory as the save location.

### 2 — Determine the folder name

Generate a short slug that describes what this session was about — 2 to 4 lowercase words, hyphenated — then append the timestamp.

Format: `<slug>-<YYYY-MM-DD-HHMMSS>`

Examples:
- `engram-build-launch-2026-04-16-120603`
- `api-rate-limit-fix-2026-04-16-120603`
- `dashboard-layout-2026-04-16-120603`

If an argument was passed to `/engram` (e.g. `/engram before-merge`), use that as the slug instead of generating one. Still append the timestamp.

Create the output folder at:
```
<project-root>/engram/<folder-name>/
```

If saving to the `~/Documents/engram/` fallback or a custom `DEFAULT_DIR`, create the folder directly inside that directory (no extra `engram/` nesting needed).

`engram/` is gitignored when inside a project — it lives with the code but is never committed.

### 3 — Write the engram file

Filename: `<folder-name>.md`

Four sections, in this order:

**1. What this session was about**
The goal and context. What problem was being solved, what was being built, and why. One short paragraph — enough for someone coming in cold to understand the mission.

**2. What was done**
Everything that happened: decisions made and why, files created or changed, commands run, errors hit and how they were fixed. Full record — don't skim it.

**3. Where we left off**
The exact state at the moment `/engram` was triggered. What's complete, what's in progress, what's half-finished.

**4. Next steps**
What to do from here, in priority order. Specific — not "continue the work" but "do X, then Y, watch out for Z."

### 4 — Ask where to save

After writing the file, show the user where it was saved and ask if they want to copy it to a different folder:

```
[Engram] saved → <full-path-to-folder>/<folder-name>.md

Save a copy to a different folder? Enter a path or press Enter to skip.
```

Wait for the user's response:
- If they enter a path: copy the file to `<their-path>/<folder-name>.md` (create the directory if it doesn't exist), then confirm: `[Engram] also copied → <their-path>/<folder-name>.md`
- If they press Enter or respond with nothing: skip silently, no additional output

### 5 — Confirm

Print:
```
[Engram] saved → <full-path-to-folder>/<folder-name>.md
```

---

## Output Format

```markdown
# Engram — <YYYY-MM-DD HH:MM>

**Project:** <project-root>
**Saved at:** <slug>-<timestamp>

## What this session was about
<one paragraph — goal, context, why>

## What was done
<decisions and why, files changed, commands run, errors and fixes — full record>

## Where we left off
<exact state at time of /engram — what's done, what's in progress, what's half-finished>

## Next steps
- ...
- ...
```
