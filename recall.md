---
description: Recall — load the latest engram into context to resume a session
argument-hint: "[folder-name] (optional — load a specific engram instead of the latest)"
---

# Recall — /recall

**Invocation context:**
- Git root: !`git rev-parse --show-toplevel 2>/dev/null || true`
- Working directory: !`pwd`
- Engram config: !`cat ~/.engramrc 2>/dev/null || true`
- Engrams in project: !`ls -1t "$(git rev-parse --show-toplevel 2>/dev/null || echo ".")/.engram/" 2>/dev/null | head -20 || true`
- Engrams in ~/Documents/.engram/: !`ls -1t ~/Documents/.engram/ 2>/dev/null | head -20 || true`

## Instructions

### 1 — Determine where engrams are stored

Use the same priority order as `/engram`:
1. `<git-root>/.engram/` — preferred, lives with the code
2. `DEFAULT_DIR` from `~/.engramrc` if present
3. `~/Documents/.engram/` — persistent fallback

### 2 — Find the engram to load

**If an argument was passed** (e.g. `/recall auth-refactor-2026-04-16-120603`):
- Look for a folder matching that name (exact or partial prefix match) in the engram directory
- If multiple matches, pick the most recent

**If no argument:**
- Load the most recently modified folder in the engram directory

### 3 — Read the engram file

The file is at `<engram-dir>/<folder-name>/<folder-name>.md`.

Read the full contents.

### 4 — Present the session

Output the engram contents in full, then add a short **Ready to continue** line that states:
- What the session was about (one sentence)
- The single most important next step from the "Next steps" section

Format:

```
[Recall] loaded → <full-path-to-engram-file>

---

<engram contents verbatim>

---

**Ready to continue:** <one sentence summary>. First up: <most important next step>.
```

If no engrams are found anywhere, print:
```
[Recall] no engrams found. Run /engram at the end of a session to save one.
```
