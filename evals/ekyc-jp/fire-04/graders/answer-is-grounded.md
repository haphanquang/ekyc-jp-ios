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

The reply orients the user to the ekyc-jp skill set: it names the 3 tiers (domain/iOS/server) or points to specific member skills (e.g. honnin-kakunin-houhou for method choice, ios-corenfc-apdu for card reading), and states at least one of the invariant rules (never call J-LIS directly / method names live only in honnin-kakunin-houhou+method-map.md / run sources-refresh when the question touches 2026-2027 timing). Japanese.

Also acceptable: the assistant explicitly says it consulted the `ekyc-jp:ekyc-jp` skill and its guidance.
NOT acceptable: an answer that contradicts the skill on the point being asked, invents APDU bytes / AIDs / PIN counts that this plugin marks 未確認, states a 犯収法 method letter with no basis (the plugin now cites e-Gov / references/hourei-eKYC.md for the letters and flags that the 2027 逐条 wording is not fully cross-checked), or tells the app to call J-LIS directly. (Irrelevant NOT-acceptable items — e.g. APDU bytes for a purely legal question — simply do not apply.)
