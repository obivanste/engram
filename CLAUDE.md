# Engram

Session memory for Claude Code. One command: `/engram`.

Saves the current session to a structured `.md` file inside `.engram/` in the project root — gitignored, lives with the code. On the next session, load the engram to pick up exactly where things left off.

## Flow

```
/engram
  → .engram/<timestamp>/<timestamp>.md
  → [Engram] saved → .engram/<timestamp>/<timestamp>.md
```

Named saves:
```
/engram auth-refactor
  → .engram/auth-refactor/auth-refactor.md
```

## Output structure

```
<project-root>/
  .engram/
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
- `install.sh` — installs `/engram` into Claude Code
- `engram-hook.sh` — archived PreCompact hook
- `CLAUDE.md` — this file
- `notes.md` — design decisions and research
