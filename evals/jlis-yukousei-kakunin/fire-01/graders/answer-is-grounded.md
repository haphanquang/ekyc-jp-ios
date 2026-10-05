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

The reply establishes the invariant (validity check only via a 主務大臣認定 holder; the SP server calls the PF事業者's API, never J-LIS directly), covers CRL (daily, offline-checkable) vs OCSP (realtime, ~15 min), the 失効事由 branches (有効期限切れ / 基本4情報変更 = 引越し・改氏名 / 死亡 / カード返納) with a helpful user message, fail-closed on 'couldn't check', and audit logging of the result + PF reference id. Japanese; retention period routed to honnin-kakunin-houhou.

Also acceptable: the assistant explicitly says it consulted the `ekyc-jp:jlis-yukousei-kakunin` skill and its guidance.
NOT acceptable: an answer that contradicts the skill on the point being asked, invents APDU bytes / AIDs / PIN counts that this plugin marks 未確認, states a 犯収法 method letter with no basis (the plugin now cites e-Gov / references/hourei-eKYC.md for the letters and flags that the 2027 逐条 wording is not fully cross-checked), or tells the app to call J-LIS directly. (Irrelevant NOT-acceptable items — e.g. APDU bytes for a purely legal question — simply do not apply.)
