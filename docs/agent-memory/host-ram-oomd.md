---
name: host-ram-oomd
description: The training laptop (RTX 3080 Laptop 8 GB, 15 GB RAM) has systemd-oomd; heavy jobs launched from VS Code got VS Code killed
metadata:
  type: project
---

On the RTX 3080 Laptop workstation (15 GB RAM), VS Code and its extensions hold about 7 GB, and systemd-oomd kills the largest cgroup of the user session when memory pressure stays above 50 % for 20 s. On 5 Nov 2026 a training launched from the VS Code terminal made oomd kill the whole VS Code scope (304 processes), training included. `setsid nohup` does not escape the cgroup.

**Why:** losing the owner's editor session is far worse than a slow job; GPU memory was not the issue.

**How to apply:** launch long or heavy jobs as their own user unit:
`systemd-run --user --unit=<name> --collect -p MemoryMax=8G -p MemorySwapMax=0 -p OOMPolicy=continue --working-directory=$PWD ~/anaconda3/envs/trashscribe/bin/python ...`
(OOMPolicy=continue, otherwise one OOM-killed child stops the whole unit). Watch host RAM, not only VRAM: DataLoader workers, pinned memory and shared-memory batches all count. A GPU job next to a training run caps itself (`torch.cuda.set_per_process_memory_fraction`, about 0.17). Commands for the queue and the report timer: `stop_and_restart.txt`. Related: [[trashscribe-state]].
