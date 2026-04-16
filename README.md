# Engram

Session memory for Claude Code. Two commands: `/engram` to save, `/recall` to resume.

`/engram` saves a structured record of your current session to `.engram/` inside your project. `/recall` loads the latest one back into context — so you pick up exactly where you left off.

Named after the neuroscience concept: the physical trace a memory leaves in the brain.

---

## Install

**npx:**

```bash
npx engram-cc
```

**or clone:**

```bash
git clone https://github.com/obivanste/engram
cd engram
bash install.sh
```

`/engram` and `/recall` are now available in every Claude Code session.

---

## Usage

```
/engram
```

Saves the session. The folder name is auto-generated from the session context with a timestamp — e.g. `api-rate-limit-fix-2026-04-16-120826`.

```
/engram <name>
```

Custom slug — e.g. `/engram before-merge` → `before-merge-2026-04-16-120826/`. Useful for checkpoints.

---

## Resuming a session

At the start of a new session, run:

```
/recall
```

Loads the most recent engram and prints a summary with the top next step.

```
/recall <name>
```

Load a specific engram by name — e.g. `/recall api-rate-limit` matches `api-rate-limit-fix-2026-04-16-120826`.

---

## What it saves

```
your-project/
  .engram/
    api-rate-limit-fix-2026-04-16-120826/
      api-rate-limit-fix-2026-04-16-120826.md
```

Each engram is a single `.md` file with four sections:

| Section | What it captures |
|---------|-----------------|
| **What this session was about** | The goal and context — enough for someone cold to understand the mission |
| **What was done** | Decisions made, files changed, commands run, errors fixed |
| **Where we left off** | Exact state at the moment `/engram` was triggered |
| **Next steps** | What to do from here, in priority order |

`.engram/` is gitignored — it lives in the repo but is never committed.

---

## Example

This is the engram from the session that built Engram itself.

```markdown
# Engram — 2026-04-16 12:08

**Project:** ~/Desktop/Development/Forge/engram
**Saved at:** engram-build-launch-2026-04-16-120826

## What this session was about

Designing and building Engram from scratch — a Claude Code slash command (`/engram`)
that saves a structured memory of the current session to `.engram/` inside the active
project repo. Named after the neuroscience concept of a memory trace. The session
covered everything from the initial concept through naming, architecture decisions,
testing, installation, and publishing to GitHub.

## What was done

**Concept and naming:**
- Started as `pre-compact-export`, rebranded to `TotalReClaude`, then renamed to
  Engram after exploring sci-fi memory references (Total Recall → Rekall → engrams
  from neuroscience/Dune/Ghost in the Shell)
- Settled on `/engram` as the command name — precise, sci-fi rooted, perfect metaphor

**Architecture decisions:**
- Single `.md` file per session, four narrative sections
- Output goes to `<project-root>/.engram/` — gitignored, lives with the code
- Folder names: auto-generated slug from session context + timestamp
- `/engram <name>` for custom slug, timestamp always appended
- No programmatic context clear — confirmed impossible from a skill

**Technical work:**
- `!` shell commands in command files exit hard on non-zero — fixed with `|| true`
- `$PWD` in PreCompact hook subprocess = `/private/tmp` — fixed by reading `cwd`
  from transcript JSONL entries
- `~/.claude/CLAUDE.md` was matching as project root — added exclusion rule

**Files shipped:**
- `engram.md` — the `/engram` command
- `install.sh` — bash installer
- `bin/engram.js` — npx installer
- `engram-hook.sh` — optional PreCompact hook

## Where we left off

Everything working and shipped. Context-derived folder naming confirmed — slug
`engram-build-launch` generated from session content, timestamp appended, file
landed in the right place.

## Next steps

- Test `/engram` and `/recall` from a different project to confirm git root detection in real use
- Publish `engram-cc` to npm
```

---

## Save location

Engram finds the right place to save automatically:

1. **Git root** — most reliable, saves to `<git-root>/.engram/`
2. **Directory containing `CLAUDE.md`** — next best signal
3. **`DEFAULT_DIR` in `~/.engramrc`** — your chosen fallback for sessions outside a project
4. **`~/Documents/.engram/`** — persistent default, never lost to a reboot

To set a custom fallback location, create `~/.engramrc`:

```bash
DEFAULT_DIR=/Users/you/Documents/engrams
```

Engram will save there whenever there's no git repo or `CLAUDE.md` in scope.

---

## What's in the repo

| File | Purpose |
|------|---------|
| `engram.md` | The `/engram` slash command |
| `recall.md` | The `/recall` slash command |
| `bin/engram.js` | npx installer |
| `install.sh` | Bash installer |
| `engram-hook.sh` | Archived PreCompact hook (optional) |
| `examples/` | Real engram output from the session that built this tool |
