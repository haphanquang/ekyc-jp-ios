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

The reply covers 券面入力補助AP for ヘ方式: unlocked by the 14-digit card-face string (生年月日6 + 有効期限4 + セキュリティコード4), reads 基本4情報 as text, does NOT sign (so ヘ方式 pairs it with 容貌撮影 + server-side face match), and contrasts with カ方式 (JPKI 署名用). Japanese; APDU/lock-count detail mirrors apdu-cheatsheet's hedges.

Also acceptable: the assistant explicitly says it consulted the `ekyc-jp:kenmen-nyuryoku-hojo-ap` skill and its guidance.
NOT acceptable: an answer that contradicts the skill on the point being asked, invents APDU bytes / AIDs / PIN counts that this plugin marks 未確認, states a 犯収法 method letter with no basis (the plugin now cites e-Gov / references/hourei-eKYC.md for the letters and flags that the 2027 逐条 wording is not fully cross-checked), or tells the app to call J-LIS directly. (Irrelevant NOT-acceptable items — e.g. APDU bytes for a purely legal question — simply do not apply.)
