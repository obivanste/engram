# TotalReClaude

Session export + clear for Claude Code. One command: `/recall`.

Saves the current session to a dedicated folder in the active project directory, then clears the context. On the next session, Claude reads `.recall/<timestamp>/summary.md` to pick up exactly where things left off — no summarization overhead, no information loss.

## Flow

```
/recall
  → .recall/<timestamp>/summary.md   (skimmable: TL;DR, decisions, files, next steps)
  → .recall/<timestamp>/session.md   (full record: commands, errors, reasoning, tasks)
  → [TotalReClaude] saved → .recall/<timestamp>/
  → /clear
```

On next session:
```
"load context from .recall/<timestamp>/summary.md"
  → Claude reads the file and continues
```

## Why clear instead of compact

`/compact` summarizes the conversation before clearing — overhead we don't need because TotalReClaude already produces a better-structured summary. `/clear` just wipes the window. The `.recall/` folder is the source of truth.

## Output structure

```
<project-root>/
  .recall/
    2026-04-16-103612/
      2026-04-16-103612.md    ← summary at top, full session detail below
    2026-04-15-091500/
      2026-04-15-091500.md
```

## Deployment

```bash
cp recall.md ~/.claude/commands/recall.md
```

That's it — no hook needed. `/recall` is the only entry point.

## Files

- `recall.md` — the `/recall` slash command prompt
- `CLAUDE.md` — this file
- `notes.md` — design decisions, open questions, research
- `recall-hook.sh` — archived PreCompact hook (no longer primary path)
