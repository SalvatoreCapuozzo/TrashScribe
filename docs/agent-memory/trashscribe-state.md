---
name: trashscribe-state
description: State of the TrashScribe project when it left the LENTE repository (25 Nov 2026) and where everything is
metadata:
  type: project
---

As of 25 Nov 2026:
* Experiment grid finished (20 Nov). No run pending. Results in `RESULTS.md` (journal + tables), `runs/<run>/test_metrics.json`, protocol list in `docs/EXPERIMENTS.md`. `runs/` (about 3.7 GB, git-ignored) must be copied by hand if the repository is cloned elsewhere.
* Jetson Orin Nano on JetPack 6.2: final numbers in `tab:edge`; deployment files not in git are listed in `docs/JETSON.md`.
* Paper (`paper/main.tex`): 26 pages, compiles cleanly, abstract 250 words, American English, only red placeholder is the repository link the owner inserts. Cover letter and title page updated.
* Open before submission (30 Nov): anonymized repository link; anonymity check of the reviewer mirror (`docs/MIGRATION.md`); commit and push are the owner's call.
* Environment: conda env `trashscribe` (`environment.yml`), data in `~/data/waste`, Hugging Face cache offline (`HF_HUB_OFFLINE=1`).
* The full narrative of the session that produced all this: `docs/HISTORY.md`.

**Why:** the project moved out of LENTE; this note gives the next session its bearings.

**How to apply:** read `AGENTS.md` first (auto-loaded via `CLAUDE.md`), then check `docs/NEXT_STEPS.md`; anything here older than those files is stale. Related: [[paper-decisions]], [[host-ram-oomd]].
