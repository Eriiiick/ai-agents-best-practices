# Architectures

- Single-agent with tool-use: simplest; great for many workflows
- Multi-agent orchestration: specialize roles; coordinate via planner/router
- Planner–executor: separate planning from tool execution for clarity
- Retrieval-augmented agents: ground answers with indexed knowledge
- Event-driven agents: react to triggers; use durable queues and retries

Key design choices:
- Memory: ephemeral vs. long-term; vector DB vs. structured store
- Tool layer: idempotent actions, timeouts, schema validation, audit logs
- Routing: rules + models; fallback order and circuit-breakers
- Isolation: sandbox risky tools; rate-limit external services
