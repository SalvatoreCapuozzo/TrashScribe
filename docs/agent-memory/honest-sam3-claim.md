---
name: honest-sam3-claim
description: The exact, verified form of the TrashScribe vs SAM 3 / SegFormer claim, and the "four of five" error to avoid
metadata:
  type: project
---

Waste IoU vs SAM 3 (16 prompts, fair half-image rule), from `paper/tables/tab_ladder.tex`:
* No site data (leave-one-out): SAM 3 leads on **all five** environments. Not "four of five": that count only holds if the 243 indoor negatives (E3b, no site image) are treated as no site data, and the paper repeated it wrongly until 25 Nov.
* Cheap site data (10 labeled images, or SAM 3 labels on unlabeled site images; indoors, generic negatives suffice): at or above SAM 3 on four of five; aerial litter (UAVVaste) is the exception even with 50 labels.
* Site in training (E4): ahead on all five, while SAM 3 still receives no site data.
* A fully fine-tuned SegFormer-B2 transfers as well or better on every environment: the frozen encoder buys efficiency and one shared representation, not transfer.
* Advantages that do hold: 25 to 33 times faster than SAM 3 with TensorRT on the Jetson (8 to 10 FPS at 15 W), descriptions of every object (macro mAP 0.69 vs CLIP 0.31), cheap site adaptation.

**Why:** the owner wanted "edge model equal or better than SAM 3 (always)"; the data support only the conditional form, and a miscount was caught by the owner on 25 Nov.

**How to apply:** recount any claim from the tables, never from memory; keep abstract, introduction, results, conclusions and cover letter consistent. Related: [[paper-decisions]], [[working-preferences]].
