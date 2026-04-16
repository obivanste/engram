# Engram

Session memory for Claude Code. Two commands: `/engram` to save, `/recall` to resume.

Saves the current session to a structured `.md` file inside `engram/` in the project root — gitignored, lives with the code. On the next session, `/recall` loads it back into context.

## Flow

```
/engram
  → engram/<slug-timestamp>/<slug-timestamp>.md
  → [Engram] saved → engram/...

/recall
  → reads latest engram/ file
  → [Recall] loaded → engram/...
```

Named saves:
```
/engram auth-refactor
  → engram/auth-refactor-<timestamp>/auth-refactor-<timestamp>.md

/recall auth-refactor
  → loads the matching engram
```

## Output structure

```
<project-root>/
  engram/
    2026-04-16-120013/
      2026-04-16-120013.md
    auth-refactor/
      auth-refactor.md
```

## Deployment

```bash
git clone https://github.com/obivanste/engram
cd engram
bash install.sh
```

## Files

- `engram.md` — the `/engram` slash command
- `recall.md` — the `/recall` slash command
- `install.sh` — installs both commands into Claude Code
- `engram-hook.sh` — archived PreCompact hook
- `CLAUDE.md` — this file
- `notes.md` — design decisions and research
