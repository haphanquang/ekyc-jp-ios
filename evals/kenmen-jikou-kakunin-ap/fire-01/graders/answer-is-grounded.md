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

The reply covers 券面事項確認AP: the two credentials (照会番号B / 券面事項確認用 for the card-face images + IC face photo; マイナンバー / 個人番号用 for 個人番号), the low-res compressed face photo for server-side face match, and — the heart of the skill — the 番号法 obligations (collect/store 個人番号 only with a legal basis; never log; encrypt; delete at purpose end; if 個人番号 isn't needed, don't unlock that side). Japanese.

Also acceptable: the assistant explicitly says it consulted the `ekyc-jp:kenmen-jikou-kakunin-ap` skill and its guidance.
NOT acceptable: an answer that contradicts the skill on the point being asked, invents APDU bytes / AIDs / PIN counts that this plugin marks 未確認, states a 犯収法 method letter with no basis (the plugin now cites e-Gov / references/hourei-eKYC.md for the letters and flags that the 2027 逐条 wording is not fully cross-checked), or tells the app to call J-LIS directly. (Irrelevant NOT-acceptable items — e.g. APDU bytes for a purely legal question — simply do not apply.)
