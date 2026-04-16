# Engram — 2026-04-16 12:08

**Project:** ~/Desktop/Development/Forge/engram
**Saved at:** engram-build-launch-2026-04-16-120826

## What this session was about

Designing and building Engram from scratch — a Claude Code slash command (`/engram`) that saves a structured memory of the current session to `.engram/` inside the active project repo. Named after the neuroscience concept of a memory trace. The session covered everything from the initial concept through naming, architecture decisions, testing, installation, and publishing to GitHub.

## What was done

**Concept and naming:**
- Started as `pre-compact-export`, rebranded to `TotalReClaude`, then renamed to Engram after exploring sci-fi memory references (Total Recall → Rekall → broader genre → engrams from neuroscience/Dune/Ghost in the Shell)
- Settled on `/engram` as the command name — precise, sci-fi rooted, perfect metaphor

**Architecture decisions:**
- Single `.md` file per session (not two files), four narrative sections: what it was about, what was done, where we left off, next steps
- Output goes to `<project-root>/.engram/` — gitignored, lives with the code
- Folder names: auto-generated slug from session context + timestamp (e.g. `engram-build-launch-2026-04-16-120826`)
- `/engram <name>` for custom slug, timestamp always appended
- No programmatic context clear — confirmed impossible from a skill; accepted clean slate is a manual step
- No subagent needed — parent Claude has live context; `Task` tool adds complexity with no gain

**Technical work:**
- `!` shell commands in command files exit hard on non-zero — fixed with `|| true` on all git commands
- `$PWD` in PreCompact hook subprocess = `/private/tmp` — fixed by reading `cwd` from transcript JSONL entries
- `~/.claude/CLAUDE.md` was matching as project root — added exclusion rule
- Built and tested PreCompact hook (`engram-hook.sh`) — works, available as optional add-on
- Researched `allthingsclaude/blueprints` — confirmed `!` injection pattern, confirmed nobody solves programmatic context clear

**Files shipped:**
- `engram.md` — the `/engram` command (deployed to `~/.claude/commands/engram.md`)
- `install.sh` — bash installer
- `bin/engram.js` — npx installer
- `engram-hook.sh` — optional PreCompact hook
- `CLAUDE.md`, `notes.md`, `.gitignore`

**Repo:**
- Initialized git, pushed to GitHub as `obivanste/totalreclaude`, renamed to `obivanste/engram`
- Cleaned up accidentally committed `.recall/` folder with `git rm --cached`
- Removed leftover `.recall/` untracked directory

## Where we left off

Everything is working and shipped. Context-derived folder naming confirmed working — the slug `engram-build-launch` was generated from the session content, timestamp appended, file landed in the right place. The repo is clean, the command is deployed.

## Next steps

- Test `/engram` from a completely different project to confirm git root detection and `.engram/` placement work in real-world use
- Consider a `/pickup` companion command that reads the latest `.engram/*.md` and loads it into context at the start of a new session
- Publish `engram-cc` to npm so `npx engram-cc` works without cloning
