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

The reply covers server-side 同意情報 management for the 最新4情報 service: what to store (consent timestamp = 機構システム反映日, scope, per-service unit, consent-text version, 発行番号), what NOT to keep (the customer's 署名用電子証明書; raw signature after registration), 10-year validity from the day after consent, per-service revocation, 開示請求 handling, the electronic-only submission via a PF事業者 to 機構 (never J-LIS/機構 directly), and that the 犯収法 record-retention period is a different thing (route to honnin-kakunin-houhou). Japanese; the 15-item checklist points to kihon-4-jouhou-doui.

Also acceptable: the assistant explicitly says it consulted the `ekyc-jp:doui-jouhou-kanri` skill and its guidance.
NOT acceptable: an answer that contradicts the skill on the point being asked, invents APDU bytes / AIDs / PIN counts that this plugin marks 未確認, states a 犯収法 method letter with no basis (the plugin now cites e-Gov / references/hourei-eKYC.md for the letters and flags that the 2027 逐条 wording is not fully cross-checked), or tells the app to call J-LIS directly. (Irrelevant NOT-acceptable items — e.g. APDU bytes for a purely legal question — simply do not apply.)
