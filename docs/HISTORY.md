# History of the TrashScribe working session (5 to 25 Nov 2026)

Internal record of the long Claude Code session that ran the experiments, wrote the paper and prepared the
move out of LENTE. It keeps what was asked, what was decided and why, the answers worth reusing, and the
mistakes that were caught. **Internal: it names the authors' earlier work. Keep it out of the anonymized
reviewer mirror** ([MIGRATION.md](MIGRATION.md#anonymity-before-the-reviewer-link)).

* Raw transcript (not in the repository, 42 MB, includes tool output and account context, keep private):
  `~/.claude/projects/-home-salvatorecapuozzo-LENTE/d1df9209-9e45-4af7-ad20-583ee4adba14.jsonl`.
  Moving the TrashScribe folder does not delete it. To reopen that exact session, run from `~/LENTE`:
  `claude --resume d1df9209-9e45-4af7-ad20-583ee4adba14`.
* The owner's messages are reproduced verbatim at the end of this file.
* Living sources of truth stay [RESULTS.md](../RESULTS.md), [attempts/ATTEMPTS.md](../attempts/ATTEMPTS.md) and
  [CONTEXT.md](CONTEXT.md); this file is the narrative that connects them.

## Timeline

### 5 Nov: grid launch, memory incident, data fixes
* Request: run every experiment on the workstation GPU and report progressively in a markdown file
  (`RESULTS.md`).
* The first E4 launch from the VS Code terminal made `systemd-oomd` kill the whole VS Code session (system
  RAM, not GPU). Since then every heavy job runs as a capped `systemd-run --user` unit; the grid is the
  service `trashscribe-queue`, RESULTS.md is refreshed by the timer `trashscribe-report` (commands in
  `stop_and_restart.txt`). Data-pipeline RAM was cut (BePLi images with 363 objects, worker copy-on-write
  growth, pinned memory off).
* Two silent data bugs found: MJU-Waste masks were read inverted (the pilot's 0.97 IoU was the background);
  TACO repeats annotation IDs.
* Owner decisions: BePLi gets atlas aliases (7 classes mapped to TACO entries, 5 new entries); 6 evaluable
  held-out classes (Egg carton has no test object); **paper is waste** (ZeroWaste-f negatives are only the
  conveyor belt, found by a color rule); a progress monitor with per-run and overall ETA
  (`scripts/progress.py --watch 30`); a conda env `trashscribe` instead of the venv
  (`environment.yml`).
* Grid restarted from scratch with the new labels.

### 6 Nov: stop and restart
* Owner asked for commands to stop the runs, free memory and resume: now in `stop_and_restart.txt`
  (immediate stop, "safe stop" after the epoch checkpoint, restart of queue and report timer after a reboot).
  The queue was paused twice between 6 and 11 Nov.

### 13 Nov: first reading, refocus question
* Preliminary results written into the article, plus the data-flow figure (`paper/figures/pipeline.tex`) and
  a qualitative figure.
* Owner: "change the purpose of the article ... focus only on the strongest part, but only if ... going
  beyond the existing literature". Answer: not yet, a decisive test was pending. Post-hoc analyses removed
  two claims: raw CLIP beats TrashScribe at naming and retrieving unseen classes; the 98.5 % environment
  probe was confounded by class (within-class: intrinsic pooling +7 points over chance, ring +21). AUSUC
  metric bug fixed.
* Queue pruned (LoRA, adapters-both, depth gate, E2 removed); E7 added (three attribute values never
  supervised).

### 15 Nov: E7 negative, SAM 3 appears, style rules, queue by significance
* E7: the text-space head reads 1 of 3 unseen values; a closed per-value probe describes as well (0.712 vs
  0.691) → **no open-vocabulary description claim**.
* SegFormer runs had all died of a deterministic CUDA OOM at their first validation → fixed (batch-1
  validation, cache freed, resume, OOM give-up in the queue).
* Improvements implemented: E8 (CLIP-distilled dense head), E3b (243 COCO indoor negatives), test-time
  tiling, literature comparison figure (CLIP, Grounding DINO→SAM 2, SAM 3, TrashScribe).
* On five sample images SAM 3 beat the leave-one-out model on four → full-test SAM 3 baseline queued.
* **Paper style rules (binding)**: no em dashes; no ", and"; few subsections; headings without parentheses
  and not whole phrases; roadmap at the end of the introduction; a lead-in before the subsections of every
  section. Applied to the whole paper.
* Owner asked for a way to reach or beat the state of the art with the edge model → **SAM 3 as an offline
  teacher (E9)**: SAM 3 labels the unlabeled train/val images of the new site once on a workstation, the
  leave-one-out model is fine-tuned on them; SAM 3 never runs on the device. Backup idea not run:
  EfficientSAM3 encoder swap.
* Owner: "resettle the queue putting first the runs with most significant potential results" → the queue
  is ordered by expected impact on the claims (keep doing so).
* Finding: with the 4 waste words SAM 3's presence head rejects waste in non-litter scenes (office:
  presence 0.02 to 0.26) → 16 prompts (4 waste words + 12 TACO-supercategory nouns), fixed before results.

### 16 Nov: "nan" explained, fair SAM 3
* "Why are most runs ending with nan?": a display problem. SAM 3 label jobs have no IoU; UAVVaste/MJU have
  a single class, so description and naming are undefined. `progress.py` now prints "n/a".
* The SAM 3 evaluation counted whole-scene masks; the other baselines and the E9 labels drop masks larger
  than half the image → SAM 3 re-evaluated both ways, the paper uses the **fair** (half-image) rule and
  reports the raw one. Longer E9 training rejected: the student ends at its labels' quality.

### 17 Nov: E8, E3b, the SAM 3 claim, handover docs, push
* E8: the distilled head retrieves unseen classes like raw CLIP (0.082 vs 0.078 AP) inside the same pass;
  naming still trails CLIP (H 0.12 vs 0.22).
* E3b: 243 indoor photos without waste raise MJU leave-one-out from 0.055 to 0.363, above SAM 3 (0.221).
* Owner: "i would like to claim that an edge model behave equally or better (always) than sam 3". Answer:
  the data do not support "always"; the defensible claim is conditional on site data. **E10** queued
  (10 labeled site images per site; rule fixed before results: a site still below SAM 3 gets a 50-image
  run → UAVVaste).
* Handover docs written (`AGENTS.md`, `CLAUDE.md`, `docs/*`); Jetson files not in git listed in
  `docs/JETSON.md`; 87 files staged in LENTE.
* Push failed with an auth error: the GitHub CLI token in the keyring was invalid (expired or revoked);
  SSH worked. Fix: `gh auth login -h github.com` (or `gh auth refresh`), or push over SSH
  (`git remote set-url origin git@github.com:<user>/<repo>.git`).

### 19 Nov: Jetson (JetPack 5), related work, severe review, new title
* First Jetson numbers (JetPack 5.1.1, clocks not locked): network 119 ms FP16, pipeline about 5 FPS.
* Related work: no waste segmentation paper by Bruno Vento was found; he co-authored the Illegal Waste
  Dumping Detection contest paper (WACV 2026 Workshops, cited with the full author list) and co-organized
  WasteVision. Added: Garberus, X3D detector, TrashDet, detect-waste, zero-shot CLIP waste classification,
  SAM 3 as a teacher for small detectors, student beating its teacher. Six "VERIFY" bibliography notes
  resolved against primary sources.
* Severe review against the owner's seven criteria (clear abstract; introduction with background, open
  problems, approach, roadmap; complete related work; methods without many subsections; clear and
  exhaustive results; discussion with future work and conclusions so that abstract + introduction +
  conclusions convey everything; clear, well-placed figures with self-explanatory captions).
* New title: "TrashScribe: Segmenting and Describing Waste across Environments on an Edge Device".
* Significance verdict: a solid application contribution, not a new learning method. New and supported:
  the cross-environment benchmark; environment-specific negatives with a cheap fix; a measured answer to
  when a small edge model can replace SAM 3. Use cases: beach litter surveys, recycling-line quality
  control, indoor collection points, street litter from vehicles; **not** aerial drone mapping.

### 20 Nov: grid finished, SegFormer result, the rover
* SegFormer-B2 (fully fine-tuned, 27.3 M) transfers as well as TrashScribe or better on every environment
  (street 74.6 vs 63.0, aerial 48.0 vs 26.2) → "the frozen encoder buys efficiency, not transfer".
* E1-BePLi 0.650: joint training costs 3.4 points on beaches, 12.6 on aerial images.
* **Rover use case (owner)**: the system already runs on a remotely guided wheeled land rover with a
  Jetson Orin Nano that surveys beaches and natural habitats. Added to the introduction; autonomous driving
  is future work; the paper's subject remains the segmentation/description system.
* The owner will create the new repository and insert the anonymized link (`\tbd{anonymized repository
  URL}` stays until then).

### 24 to 25 Nov: Jetson on JetPack 6.2, final review, claim correction
* A separate session on the Jetson (board reflashed to JetPack 6.2, clocks locked, 15 W) measured the
  final numbers and wrote them into `tab:edge` (A22): TrashScribe TensorRT FP16 pipeline 97 to 126 ms
  (8 to 10 FPS), 0.5 GB, 13.8 W; SAM 3 TensorRT FP16 3.2 s/frame, 1.6 GB; SAM 3 PyTorch BF16 5.2 s/frame,
  3.2 GB → TrashScribe 25 to 33 times faster. TensorRT 10.3 needed workarounds in both mask decoders
  ([JETSON.md](JETSON.md)).
* Second severe review: on-device table fitted, implementation paragraph split (Implementation, On-device
  setup, Use of AI tools), interpretations hedged, SegFormer result added to the conclusions, the
  "optional depth gate" removed from Fig. 1.
* **Do not cite LENTE** (owner): related-work sentence removed; the adapter is credited to Houlsby et al.;
  the cover letter names only the anonymized "Describing, Not Naming" work.
* Comparison with the state of the art, as given to the owner (below).
* The owner noticed that the introduction implied TrashScribe always beats SAM 3. Checking it revealed a
  factual error: without site data SAM 3 (fair rule) leads on **all five** environments, while the abstract,
  results, conclusions and the chat summary said "four of five" (true only if the indoor negatives are
  counted as no site data). Fixed everywhere; the introduction now states the three regimes and the
  SegFormer result; the cover letter also lost its stale "five frames per second".
* **American English** (owner): 65 replacements in the paper, cover letter and title page (labeled,
  generalization, anonymized, license, color, gray, behavior, learned, toward, trash, sidewalk, tire); the
  ladder figure legend regenerated. TACO class names and cited titles keep their spelling.
* Recovery files written (this file, [agent-memory/](agent-memory/)) for the move out of LENTE.

## Answers worth keeping

### Is it better than the state of the art? (25 Nov)

Waste IoU (%), test split:

| setting | street (TACO) | conveyor (ZeroWaste-f) | aerial (UAVVaste) | indoor (MJU) | beach (BePLi v2) | vs SAM 3 |
|---|---|---|---|---|---|---|
| SAM 3 zero-shot, 16 prompts, fair rule (848 M) | 71.3 | 78.3 | 42.4 | 22.1 | 42.4 | |
| TrashScribe, site never seen (34 M) | 63.0 | 74.7 | 26.2 | 5.5 (36.3 with indoor negatives) | 28.2 | loses 5/5 |
| + SAM 3 labels (E9) / + 10 labels (E10) | **78.3** / **73.3** | **80.5** / **84.3** | 37.5 / 28.9 (50 labels 29.4) | **23.1** / **75.1** | 39.8 / **45.4** | wins 4/5 |
| site in training (E4) | **88.5** | **91.2** | **49.0** | **89.5** | **61.6** | wins 5/5 |
| SegFormer-B2, site never seen (27.3 M) | 74.6 | 74.1 | 48.0 | 10.4 | 27.6 | |

Bottom line: TrashScribe is **not** a new state of the art in segmentation accuracy (SAM 3 is better with no
site data; SegFormer-B2 transfers as well or better). It **is** the better choice for a cheap offline device
at a known kind of site: with ten labels or SAM 3 used once offline it matches or beats SAM 3 on four of five
environments at 25 to 33 times the speed on the Jetson, and it describes every object (macro mAP 0.69 vs
0.31 for CLIP on crops, 0.23 chance), which neither SAM 3 nor SegFormer does. Aerial litter is the exception.
Text-prompted detectors (OWLv2, Grounding DINO → SAM 2) reach at most 24.3 and 51.0. Published per-dataset
numbers use multi-class mIoU on one dataset and are not comparable.

### What must not be claimed
See [CONTEXT.md](CONTEXT.md#what-the-paper-can-claim-today-evidence-in-experimentsmd): a text-space head
better than a closed classifier; naming unseen classes better than CLIP; environment removal by the
adversary, transplant or MixStyle; better transfer than SegFormer-B2; beating SAM 3 with no site data.

## Mistakes caught (lessons)

| what | how it was caught | rule kept |
|---|---|---|
| Training launched from the VS Code terminal took down VS Code (oomd) | the editor died | heavy jobs only as capped `systemd-run --user` units |
| MJU masks inverted, TACO duplicate annotation IDs | implausible pilot IoU 0.97 | sanity-check data before trusting a number |
| AUSUC underestimated in every run | post-hoc re-implementation | recompute metrics independently when a result matters |
| SAM 3 with 4 waste words found nothing in offices | presence scores inspected | check a baseline's failure mode before reporting it |
| SAM 3 scored with whole-scene masks | its labels matched annotations far better than its test score | same evaluation rule for every method; report both variants |
| SegFormer died 5 times of the same OOM | queue log | give up after two identical OOMs |
| "four of five" without site data (true count: five of five) | the owner questioned the introduction | recount every claim from the table, never from memory |
| Cover letter kept "about five frames per second" after the JetPack 6.2 numbers | review of the letter | update every document when a number changes |

## The owner's messages, verbatim

Times in UTC. Task notifications and "continue" messages omitted.

* **5 Nov 10:31** i was trying to make experiments on the newly built trashscribe, but i can do only now given the nvidia board running on this machine. make all the runs and progressively report results in a dedicated markdown file.
* **5 Nov 12:17** i would like to let you notice that you got oom, continue taking into account that
* **5 Nov 15:04** i want an alias for bepli as well. ok fine with the 6. paper is waste. i would like to see progresses, overall and each step, with a python script continuously seeing progresses and reporting done and next steps, along with all the etas. in the meanwhile, could you already tell me if preliminary results are satisfying enough to be promoted?
* **5 Nov 16:21** could you make a conda env instead of venv? and then you tell me how to launch the progress monitor script
* **5 Nov 17:02** apart from run eta, couldn't you show the overall eta? i would like to see the final date (sab 14 nov) with this script as well
* **6 Nov 09:24** could you write me the lines i should insert to eventually stop the runs freeing memory and then restart them from where i left?
* **13 Nov 15:07** in the meanwhile, could you collect preliminary results, update the article, provide here some first considerations and add to the article some images of detected objects in some sample images, as well as the overall architecture and data flow, from inputs to outputs through the system pipeline
* **13 Nov 15:37** well, change the purpose of the article and system in order to focus only on the strongest part, but only if you are assuring me what's left is something going beyond the existing literature, otherwise let me analyze what can be improved or which task has not been explored yet. if you focus on a specific aspect and some runs cover useless parts, remove them from queue. you can go with the next suggested steps.
* **15 Nov 15:35** provide me the updates, analyze what's going on, implement the improvements, tell me why some runs failed, make some comparative inference images comparing existing literature (if existing for this purpose) with the developed solution
* **15 Nov 17:04** ok, in the meanwhile some fixes on the paper style: - i don't like em dashes and ", and" constructs - i don't want too many subsections - sections/subsections titles should not have parenthesis and should not be whole phrases - the end of the introduction should tell what the following sections cover - at the beginning of the section, there should be a short introduction before the subsections. apart from these fixes, find out if there is a strategy/update to make the current edge system have comparable/surpassing results than the sota
* **15 Nov 17:26** yes, in general resettle the queue putting first the runs with most significant potential results, therefore in priority
* **16 Nov 07:35** what's the current situation? why are most of the runs ending with nan?
* **16 Nov 09:54** if you saw that it could have the possibility to improve, yes
* **17 Nov 16:10** could you already tell something from the current completed runs, which you can report in the article and let me understand here, if the proposed system is something innovative to propose?
* **17 Nov 16:18** point to something effectively significant, i still don't get the weight of a leave-one-out datsset, while the comparison with sam 3 of the edge model is not clear to me yet, i would like to claim that an edge model behave equally or better (always) than sam 3
* **17 Nov 20:58** okay, given that i am going to separate the trashscribe folder from the original lente directory, given that now they became two indipendent works, i want you to generate inside trashscribe an extensive md file or more files which could be read by other agents in order to understand the work, the architecture, the context and what are the next steps to perform, so that once i want to move them to a separate directory, i can do that. in the meanwhile, if there are extra file needed to launch the system on jetson, which are not included in the repo with gitignore, tell me and report in the md files to make the agent warn me. moreover, if there are any updates from runs, update the article and tell me, then you can stage all the edits useful to me to make a new push of lente. in the future, i will move trashscribe, but at the moment it is fine where it is
* **17 Nov 21:41** could you understand why i cannot push (auth error)?
* **19 Nov 09:27** i reached a point where i executed most of the runs, therefore i want you to include updates and consider if the remaining runs are still useful. at the same time, i pulled results obtained so far with jetson orin nano, therefore you can include its updates in the article as well. in the related work, if there's something similar or at least in the same topic, for instance works from bruno vento, you can include as reference. in general, i would like to understand if the contribution is effectively significant and if there's an effective use-case where this exact strategy is effectively useful. after that, i would like to make a fair but severe review, to automatically fix what's wrong at this moment. in particular, i want that this article has: - a clear abstract, allowing anyone to understand everything, context, contributes, results - the introduction needs to have the background, open problems, how we face them, how the paper is structured - related work with all the contributes trying to solve problems in this domain and to improve the current situation - methods well done without milions of subsections - results in a clear and exhaustive way - discussion (and future works) and conclusions, where there's an overall recap, where an user reading abstract, introduction and conclusion has to understand everything - moreover, images should be clear, well paged and with good autoexplicative captions
* **20 Nov 15:08** now every run is finished, therefore you can update the article with latest info. moreover, i would add a new consideration, let's say a use-case for the implementation (already done) of this system to the real world, which is a land wheeled-rover remote-guided which can analyze beaches and natural habitats to detect automatically waste. this could be added as a part of the introduction, while in the future work it can be claimed that there could be an update to make the land wheeled-rover autonomous to drive, but the focus of the article should still be the segmentation/description system already described. the repo anonymized link will be inserted manually by myself, since it will be generated a new repo from the trashscribe folder by me
* **25 Nov 10:51** given that now there are the updated results from the jetson orin nano, [the same severe-review criteria as on 19 Nov]
* **25 Nov 11:02** i don't want to cite lente, therefore remove it from the article. then, could you provide here in chat a sumup of results, to understand if this is a better result than the sota?
* **25 Nov 11:09** ok check again the intro, since you tell that it always beat sam3, while you now are telling me not
* **25 Nov 11:26** one last fix: i use american english, therefore use anonymized instead of anonymised, license instead of licence and so on
* **25 Nov 11:35** could you prepare me some files to recover the info needed and acquired from this chat, since i a m going to remove the trashscribe folder from the lente folder to make it an autonomous repo, but i want to keep memory of info from this chat?
