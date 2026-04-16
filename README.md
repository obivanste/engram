# Engram

Session memory for Claude Code.

`/engram` saves a structured record of your current session to `.engram/` inside your project — so you can resume cleanly, share context with a teammate, or just not lose what you figured out.

Named after the neuroscience concept: the physical trace a memory leaves in the brain.

---

## What it saves

```
your-project/
  .engram/
    auth-refactor-2026-04-16-120826/
      auth-refactor-2026-04-16-120826.md
```

Each engram is a single `.md` file with four sections:

- **What this session was about** — the goal and context, enough for someone cold to understand the mission
- **What was done** — decisions made, files changed, commands run, errors fixed
- **Where we left off** — exact state at the moment `/engram` was triggered
- **Next steps** — what to do from here, in order

The folder name is auto-generated from the session context with a timestamp appended. `.engram/` is gitignored — it lives in the repo but is never committed.

See [`examples/`](./examples) for a real engram from the session that built this tool.

---

## Install

**npx (no clone needed):**

```bash
npx engram-cc
```

**or clone and run:**

```bash
git clone https://github.com/obivanste/engram
cd engram
bash install.sh
```

Either way, `/engram` is now available in every Claude Code session.

---

## Usage

```
/engram
```
Saves the session. Folder name is derived from the session context — e.g. `auth-refactor-2026-04-16-120826`.

```
/engram <name>
```
Saves with a custom slug — e.g. `/engram before-merge` creates `before-merge-2026-04-16-120826/`. Useful for meaningful checkpoints.

---

## Resuming a session

At the start of a new session, load the engram:

```
read .engram/auth-refactor-2026-04-16-120826/auth-refactor-2026-04-16-120826.md and continue from where we left off
```

Claude reads the file and picks up from the next steps.

---

## Project root detection

Engram saves to the right place automatically, in this order:

1. Git root — if you're in a git repo, `.engram/` goes in the root
2. Directory containing `CLAUDE.md` — next best signal
3. Working directory — fallback

---

## What's in the repo

| File | Purpose |
|------|---------|
| `engram.md` | The `/engram` slash command |
| `bin/engram.js` | npx installer |
| `install.sh` | Bash installer — copies `engram.md` to `~/.claude/commands/` |
| `engram-hook.sh` | PreCompact hook (optional, see below) |
| `examples/` | Real engram output from the session that built this tool |

---

### Optional: auto-save before compaction

If you want Engram to fire automatically before Claude Code compacts the context, add this to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PreCompact": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "/path/to/engram/engram-hook.sh"
          }
        ]
      }
    ]
  }
}
```

The hook reads the session transcript and writes an engram before the context is wiped.
