---
description: TotalReClaude — export session to project folder for safe resumption
---

# TotalReClaude — /recall

**Invocation context:**
- Git root: !`git rev-parse --show-toplevel 2>/dev/null || true`
- Working directory: !`pwd`
- Timestamp: !`date +"%Y-%m-%d-%H%M%S"`
- Git status: !`git status --short 2>/dev/null | head -20 || true`
- Recent commits: !`git log --oneline -5 2>/dev/null || true`
- CLAUDE.md locations: !`find . -name "CLAUDE.md" -maxdepth 4 2>/dev/null || true`

## Instructions

### 1 — Determine the project name

Use this priority order to get the project root path:
1. Git root (from above) — most reliable
2. Nearest directory containing `CLAUDE.md` (from above)
3. Working directory as fallback

The **project name** is the basename of that path (e.g. `/Users/macbookpro/Desktop/Development/totalreclaude` → `totalreclaude`).

### 2 — Create the output folder

Save location is always:
```
~/Desktop/TotalReClaude/<project-name>/
```

Create it if it doesn't exist.

### 3 — Write the recall file

Filename: `<YYYY-MM-DD-HHMMSS>.md` (use the timestamp from invocation context above).

Four sections, in this order:

**1. What this session was about**
The goal and context. What problem was being solved, what was being built, and why. One short paragraph — enough for someone coming in cold to understand the mission.

**2. What was done**
Everything that happened: decisions made and why, files created or changed, commands run, errors hit and how they were fixed. This is the full record — don't skim it.

**3. Where we recalled**
The exact state at the moment `/recall` was triggered. What's complete, what's in progress, what's half-finished. If someone picked this up right now, what would they find?

**4. Next steps**
What to do from here, in priority order. Be specific — not "continue the work" but "do X, then Y, watch out for Z."

### 4 — Confirm

Print:
```
[TotalReClaude] saved → ~/Desktop/TotalReClaude/<project-name>/<timestamp>.md
```

---

## Output Format

```markdown
# TotalReClaude — <YYYY-MM-DD HH:MM>

**Project:** <project-name>
**Path:** <project-root>
**Recalled at:** <timestamp>

## What this session was about
<one paragraph — goal, context, why>

## What was done
<decisions and why, files changed, commands run, errors and fixes — full record>

## Where we recalled
<exact state at time of /recall — what's done, what's in progress, what's half-finished>

## Next steps
- ...
- ...
```
