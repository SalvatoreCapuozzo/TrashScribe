# Assistant memory seed

Claude Code keeps per-project notes in `~/.claude/projects/<path-slug>/memory/`, keyed by the absolute path of
the project. While TrashScribe lived in `~/LENTE/TrashScribe`, those notes belonged to `~/LENTE` and will not be
visible from the new repository. The files in this folder are the up-to-date versions of those notes
(25 Nov 2026), written in Claude Code's memory format.

| file | content |
|---|---|
| `MEMORY.md` | the index Claude Code loads each session |
| `working-preferences.md` | commits, queue order, reporting, initiative |
| `paper-style-rules.md` | binding writing rules and review criteria |
| `american-english.md` | spelling preference |
| `paper-decisions.md` | venue, title, no LENTE citation, rover, repository link |
| `honest-sam3-claim.md` | the verified form of the comparison with SAM 3 and SegFormer-B2 |
| `host-ram-oomd.md` | the training laptop's memory killer and the safe way to launch jobs |
| `trashscribe-state.md` | where the project stood when it left LENTE |

## Restore after the move

```bash
cd <new TrashScribe repository>
bash docs/agent-memory/restore.sh --dry-run   # shows the target folder
bash docs/agent-memory/restore.sh             # copies, never overwrites existing notes
```

Even without this step an agent is briefed: `CLAUDE.md` loads `AGENTS.md`, which links every document in
`docs/`. The seed only adds the notes Claude Code would otherwise have to relearn. These files describe the
owner's machine and earlier work: keep this folder out of the anonymized reviewer mirror
([MIGRATION.md](../MIGRATION.md#anonymity-before-the-reviewer-link)).
