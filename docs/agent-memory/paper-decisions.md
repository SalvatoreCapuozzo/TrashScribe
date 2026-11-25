---
name: paper-decisions
description: Content decisions the owner made for the TrashScribe paper (no LENTE citation, rover use case, repo link, venue)
metadata:
  type: project
---

* Venue: Neural Computing and Applications, topical collection "Emerging Trends in Smart Waste Monitoring and Environmental Surveillance", deadline 30 Nov 2026, double-blind (author data only in `paper/title_page.tex`).
* Title: "TrashScribe: Segmenting and Describing Waste across Environments on an Edge Device".
* Do not cite LENTE (the owner's earlier landslide work) in the paper or the cover letter (25 Nov). The adapter is credited to Houlsby et al.; "Describing, Not Naming" (`anon_mirf`) is still cited anonymously.
* Rover use case (20 Nov): the system runs on a remotely guided wheeled land rover with a Jetson Orin Nano surveying beaches and natural habitats. It is in the introduction; autonomous driving is future work; the paper's subject stays the segmentation and description system. Do not invent rover hardware details.
* The owner inserts the anonymized repository link after creating the new repository: leave `\tbd{anonymized repository URL}`.
* On-device numbers come only from runs on the Jetson (JetPack 6.2 runs of 24 and 25 Nov in `tab:edge`).

**Why:** owner decisions recorded in [HISTORY.md](../HISTORY.md) and [CONTEXT.md](../CONTEXT.md).

**How to apply:** respect them in every revision; ask before changing any of them. Related: [[paper-style-rules]], [[honest-sam3-claim]].
