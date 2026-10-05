---
runs: 3
max_turns: 8
timeout_seconds: 180
allowed_tools: [Read, Grep, Glob, Skill]
tags: [ekyc-session-orchestration, fire, server]
---
design the backend session for a My Number Card eKYC: nonce issuance, the state machine, and idempotency for the state-changing calls
