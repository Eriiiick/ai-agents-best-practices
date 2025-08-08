# Boss-on-Top: One Decision Maker, Many Specialists

This pattern runs a single “boss” agent that plans, routes, reviews, and merges. Specialist workers handle speed, long context, and narrow skills. Keep judgment centralized; keep throughput distributed.

![Boss-on-Top diagram](../cover.png)

## TL;DR
- Cursor Agent on GPT-5 acts as the boss (inside the IDE)
- Workers execute externally via their own CLIs (Groq, Gemini, tools)
- Boss plans → dispatches → reviews logs/diffs → merges
- Clear ownership, cost control, and auditable traces

## Bitter Truth
There’s no documented public Cursor Agent CLI today. Forum posts show requests and UI-only workflows. Run the boss inside Cursor, while workers run via their own CLIs. When Cursor ships an Agent CLI, swap it in.

## Minimal Controller for Specialists

```python
# router.py
# Boss is Cursor Agent on GPT-5 in the IDE.
# This script triggers external specialists and logs results.

import json, subprocess, sys, shutil, time, pathlib

def run(cmd, stdin=None):
    p = subprocess.Popen(cmd, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    out, err = p.communicate(stdin)
    return {"cmd": cmd, "rc": p.returncode, "out": out, "err": err, "ts": time.time()}

task = "summarize repo and propose next steps" if len(sys.argv) == 1 else " ".join(sys.argv[1:])

def token_estimate(s):
    return max(1, int(len(s.split())/0.75))

TOKENS = token_estimate(task)

logs = []
pathlib.Path("logs").mkdir(exist_ok=True)

# Speed worker: Groq CLI
if shutil.which("groq"):
    logs.append(run(["groq", "ask", "--json"], stdin=task))

# Long context worker: Gemini CLI
if TOKENS > 300000 and shutil.which("gemini"):
    logs.append(run(["gemini", "ask", "--json", "--model", "gemini-2.5-pro"], stdin=task))

# Optional math or static analysis worker
if shutil.which("python"):
    analysis = f"Tokens≈{TOKENS}. Heuristic OK."
    logs.append({"cmd": ["python", "-c", "..."], "rc": 0, "out": analysis, "err": "", "ts": time.time()})

with open("logs/agent_log.jsonl", "a") as f:
    for rec in logs:
        f.write(json.dumps(rec) + "\n")

print("Workers finished. Review in Cursor Agent GPT-5 and merge.")
```

## How to Use
1. In Cursor, set Agent model to GPT-5 and apply your rules.
2. Run: `python router.py "<your task>"` to gather specialist outputs into `logs/agent_log.jsonl`.
3. In Cursor, have the boss read logs, review diffs, and merge.

## Why It Works
- Context isolation: only the worker that needs long context pays for it
- Cost control: boss delegates selectively; use ceilings and timeouts
- Auditability: append-only JSONL logs for every worker action
- Ownership: a single decision-maker merges changes

## Forward Look
When a Cursor Agent CLI is public, add:

```bash
# Future placeholder once public:
# cursor-agent --model gpt-5 --prompt "$TASK" --json >> logs/agent_log.jsonl
```

Until then, keep the boss in Cursor and workers in their own CLIs.
