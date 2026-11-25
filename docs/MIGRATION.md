# Moving TrashScribe out of the LENTE repository

Today TrashScribe lives in `LENTE/TrashScribe/` (git remote of the parent: `SalvatoreCapuozzo/LENTE`). It is an
independent work and is meant to become its own repository. The owner will decide when; until then it stays.

## What makes the move easy

* **No code dependency on LENTE.** Every path in code and configs resolves against the TrashScribe folder
  (`PKG_ROOT` in `trashscribe/engine.py`) or against `data_root` (`~/data/waste`). Mentions of LENTE in the code
  are comments; the paper no longer cites LENTE (owner, 25 Nov). No file outside the folder refers to TrashScribe.
* `.gitignore` is already inside the folder and works at the new repository root.

## What changes with the path

| Item | Action |
|---|---|
| `stop_and_restart.txt`, RESULTS.md header | replace `~/LENTE/TrashScribe` with the new path |
| systemd units (`trashscribe-queue`, `trashscribe-report`) | **stop the queue first** (between jobs or after the grid; `stop_and_restart.txt` "SAFE STOP"), move, restart with the new `--working-directory` |
| `runs/` (3.7 GB, git-ignored: checkpoints, exports, post-hoc dumps) | moves with the folder; copy it if the repository is cloned elsewhere (`init_from` paths in E9/E10 configs are relative, `runs/e3_lodo_<site>/best.pt`) |
| `runs/_queue_status.json` | contains absolute command lines: informational only, can stay |
| `~/data/waste` | outside the repository, unchanged |
| Hugging Face cache (`~/.cache/huggingface/hub`) | unchanged |
| conda env `trashscribe` | unchanged |
| assistant memory | Claude Code keys its memory by project path: notes kept for `.../LENTE` are not visible from the new path. Run `bash docs/agent-memory/restore.sh` in the new location ([agent-memory/README.md](agent-memory/README.md)). |
| session history | the 5 to 25 Nov session is summarized in [HISTORY.md](HISTORY.md); its raw transcript stays in `~/.claude/projects/-home-salvatorecapuozzo-LENTE/` (not deleted by the move; reopen from `~/LENTE` with `claude --resume d1df9209-9e45-4af7-ad20-583ee4adba14`) |

## Keeping the git history

Commits touching TrashScribe so far: `8cff538 Addition of TrashScribe Project` plus later work. To keep history:

```bash
# from a fresh clone of LENTE
git subtree split -P TrashScribe -b trashscribe-only          # or: git filter-repo --subdirectory-filter TrashScribe
mkdir ../TrashScribe-repo && cd ../TrashScribe-repo && git init
git pull ../LENTE trashscribe-only
git remote add origin <new remote> && git push -u origin main
```

Then remove `TrashScribe/` from LENTE in a separate commit, if the owner wants it gone there. Do not do any of
this without the owner's go-ahead.

## Checklist after the move

1. `python -m pytest tests -q` (14 pass).
2. `python scripts/run_queue.py --dry` lists the remaining jobs.
3. `python scripts/progress.py` renders.
4. `cd paper && pdflatex main && bibtex main && pdflatex main && pdflatex main` compiles.
5. Update the paths in `stop_and_restart.txt` and the RESULTS.md header.
6. `bash docs/agent-memory/restore.sh` to seed the assistant memory for the new path.
7. Before creating the reviewer link: the anonymity check below.

## Anonymity before the reviewer link

The submission is double-blind and the code link goes to reviewers. An anonymizing mirror (for example
anonymous.4open.science) shows the files of the repository, so whatever the files say about the authors reaches
the reviewers. Checked on 25 Nov with `git ls-files | xargs grep -il` for the terms below.

**Terms to replace** in the mirror settings: `LENTE`, `MIRF`, `Capuozzo`, `Salvatore`, `SalvatoreCapuozzo`,
`salvatorecapuozzo` (home paths), `Naples`, `Salerno`, `unisa`. Check that file names are replaced too: one config
is named `configs/exp/e5_ablate_lente_rgb.yaml`.

**Files that identify the authors or their earlier work:**

| file | what it reveals | suggestion |
|---|---|---|
| `paper/title_page.tex`, `paper/cover_letter.tex` (+ PDFs) | names, affiliation, ORCID | keep out of the reviewer copy (they go to the editor only) |
| `paper/README.md`, `docs/SOTA.md` | affiliation, shared university with guest editors | keep out or anonymize |
| `docs/HISTORY.md`, `docs/agent-memory/`, `docs/CONTEXT.md`, `docs/MIGRATION.md` | the owner's earlier works, machine, paths | keep out of the reviewer copy |
| `attempts/ATTEMPTS.md`, `RESULTS.md`, `stop_and_restart.txt`, `AGENTS.md`, `README.md` | LENTE, `~/LENTE` paths | term replacement is enough |
| `runs/_queue_status.prelim.json` | absolute home paths | delete from git or rely on term replacement |
| `trashscribe/models/{backbone,peft,heads,trashscribe}.py`, `trashscribe/naming.py`, `scripts/{make_grid,baseline_zeroshot}.py`, `configs/{base,gpu_queue,synthetic_sam2}.yaml` | LENTE / MIRF in comments | term replacement is enough |

The simplest safe route is a separate reviewer branch (or repository) without the first three rows, mirrored
with the term list; never give reviewers the GitHub URL itself, since commit authors are visible there. The
owner decides; agents must not publish anything.

