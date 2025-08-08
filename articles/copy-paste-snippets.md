# Copy‑Paste Snippets for AI Coding Agents

Drop these into your agent’s rules/context to adopt patterns from this repo quickly.

## Boss-on-Top routing (summary)
```
System: You are the deciding agent. Plan, delegate to external specialists, review, and merge. Centralize judgment; distribute execution.

When speed is key → ask Groq.
When context is huge → ask Gemini.
When tasks are narrow → use small purpose-built tools.
Log worker outputs to logs/agent_log.jsonl and review before merging.
```

## macOS finish notifications (Cursor rule)
```
- When a task completes, run: /Users/erick/bin/notify_done.sh "${TASK_NAME:-Task finished}" Submarine  # auto-emoji based on task
```

## Guardrails (quick start)
```
Refuse destructive actions unless explicitly approved. Respect least-privilege for tools. Enforce cost ceilings, timeouts, and recursion limits. Always show diffs and ask for confirmation before irreversible steps.
```

## Eval nudge (commit gate)
```
Before proposing a large change, run the project evals. Include a short summary of results and any regressions in your PR or message.
```
