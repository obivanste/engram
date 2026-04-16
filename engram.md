---
description: Engram — save session to .engram/ for safe resumption
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

## Instructions

### 1 — Determine the project root

Use this priority order:
1. Git root (from above) — most reliable
2. Nearest directory containing `CLAUDE.md` (from above), excluding `~/.claude/`
3. Working directory as fallback

### 2 — Determine the folder name

Generate a short slug that describes what this session was about — 2 to 4 lowercase words, hyphenated — then append the timestamp.

Format: `<slug>-<YYYY-MM-DD-HHMMSS>`

Examples:
- `auth-refactor-2026-04-16-120603`
- `engram-rename-2026-04-16-120603`
- `api-rate-limit-fix-2026-04-16-120603`

If an argument was passed to `/engram` (e.g. `/engram auth-refactor`), use that as the slug instead of generating one. Still append the timestamp.

Create the output folder at:
```
<project-root>/.engram/<folder-name>/
```

`.engram/` is gitignored — it lives in the repo but is never committed.

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

### 4 — Confirm

Print:
```
[Engram] saved → .engram/<folder-name>/<folder-name>.md
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
