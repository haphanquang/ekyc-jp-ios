---
type: llm
focus: last_message
weight: 1
---
The user asked one specific question (see the prompt). Judge whether the
answer resolves THAT question correctly, using this skill's material. The
paragraph below describes the skill's full scope for reference — a focused
answer only needs to cover the part the question actually asks about, and
should not be marked down for omitting the rest.

The reply gives a server-side session state machine (created -> nonce_issued -> card_read -> signed -> verifying -> validity_checked -> completed/rejected/expired, forward-only, short TTL), CSPRNG nonce bound to the session and included in the to-be-signed data (app never invents it), replay/relay defences (one-time nonce, timestamp, binding, reuse detection), idempotency keys, server-side liveness / camera-injection detection for ヘ方式 (attributed to LIQUID / ISO/IEC 30107), and append-only audit of every transition. Japanese.

Also acceptable: the assistant explicitly says it consulted the `ekyc-jp:ekyc-session-orchestration` skill and its guidance.
NOT acceptable: an answer that contradicts the skill on the point being asked, invents APDU bytes / AIDs / PIN counts that this plugin marks 未確認, states a 犯収法 method letter with no basis (the plugin now cites e-Gov / references/hourei-eKYC.md for the letters and flags that the 2027 逐条 wording is not fully cross-checked), or tells the app to call J-LIS directly. (Irrelevant NOT-acceptable items — e.g. APDU bytes for a purely legal question — simply do not apply.)
