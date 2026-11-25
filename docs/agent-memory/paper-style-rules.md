---
name: paper-style-rules
description: Binding writing rules for the TrashScribe paper and cover letter (no em dashes, no ", and", American English, structure)
metadata:
  type: feedback
---

* No em dashes. No ", and" constructs (`grep -c ', and' paper/main.tex` must only hit the comment on line 6).
* Few subsections; section and subsection titles without parentheses and not whole phrases.
* The introduction ends with a roadmap of the sections; every section with subsections opens with a short lead-in.
* American English (labeled, generalization, anonymized, license, color, gray, toward, trash, sidewalk). Dataset class names (TACO "Crisp packet") and titles of cited works keep their own spelling; figure text drawn by scripts counts too.
* Review criteria the owner uses: clear abstract (context, contributions, results); introduction with background, open problems, approach, roadmap; complete related work; methods without many subsections; clear and exhaustive results; discussion with future work and conclusions such that abstract + introduction + conclusions convey everything; clear, well-placed figures with self-explanatory captions.
* Abstract at most 250 words.

**Why:** owner's rules of 15 Nov (style), 19 and 25 Nov (review criteria), 25 Nov (American English).

**How to apply:** after every edit of `paper/*.tex`, check em dashes, ", and", spelling and the abstract length, then recompile. Related: [[paper-decisions]].
