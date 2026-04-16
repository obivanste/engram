# Notes

## PreCompact Hook — What We Know

Claude Code fires `PreCompact` hooks before compacting the conversation context.
Hook input arrives via stdin as JSON.

Known fields (from docs + observed behavior):
```json
{
  "session_id": "...",
  "transcript_path": "/path/to/transcript.jsonl",
  "trigger": "auto" | "manual",
  "hook_event_name": "PreCompact"
}
```

`transcript_path` points to a JSONL file — each line is a message object.  
Claude Code waits for the hook to finish before compacting, so we have time to write.

## Custom Slash Commands

User-level commands: `~/.claude/commands/<name>.md` → available as `/<name>` everywhere.  
Project-level commands: `.claude/commands/<name>.md` → available only in that project.

Both `engram.md` and `recall.md` deploy to `~/.claude/commands/` via `install.sh`.

## Output Location Decision

**Decision: save to `.recall/<timestamp>/` inside the active project root (cwd).**

Each session gets its own folder. Two files inside: `summary.md` and `session.md`.

Rationale:
- Session context lives with the code it describes
- One folder per session — clean, no appending, easy to browse
- Easy to `git ignore` or commit selectively
- Portable — no global state

Alternative considered: `~/.claude/sessions/` (global)  
Rejected: disconnected from the project, harder to find, not portable

## Two-File Format Decision

**Two files per session folder: `summary.md` + `session.md`.**

- `summary.md` — standalone skimmable doc, read in 30s
- `session.md` — full reconstruction reference, not meant to be read linearly

Why two files vs. one file with two sections:
- `summary.md` can be opened and read without scrolling past detail
- Easier to share or reference just the summary
- Cleaner as project artifacts

## /recall is a capture tool, not a compact trigger

TotalReClaude is about session preservation, not compaction.
`/recall` = capture and save the session. That's it.
The PreCompact hook fires the same capture automatically before compaction.
Compaction is Claude Code's concern, not ours.

## Open Questions

- [ ] Does `claude /recall` work as a hook command, or does the hook need to be a shell script?
      Need to test: `PreCompact` hook calling `claude /recall` directly.
- [ ] Does Claude have access to cwd inside a hook invocation?
- [ ] Should `.recall/` be added to a global `.gitignore_global`, or left to per-project choice?
- [ ] Is `transcript_path` reliably populated, or only sometimes?

## .gitignore Recommendation

Add to project `.gitignore` (optional — user decides):
```
.recall/
```

Or commit it as a useful project artifact — lean toward committing summaries.

## References

- Claude Code hooks: https://docs.anthropic.com/en/docs/claude-code/hooks
- Claude Code slash commands: https://docs.anthropic.com/en/docs/claude-code/slash-commands
- Existing `/handoff` skill — similar output, good reference for tone/format
