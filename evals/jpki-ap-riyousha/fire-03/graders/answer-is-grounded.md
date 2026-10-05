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

The reply covers the 利用者証明用電子証明書: 4-digit PIN, server-issued nonce -> app signs it -> server verifies + matches the 発行番号, no 基本4情報 in this cert, and the rule that it is for 当人認証 / repeated login and NOT a standalone 犯収法 身元確認 (route that to jpki-ap-shomei / honnin-kakunin-houhou). Japanese; hedges tex2e-single-source APDU detail.

Also acceptable: the assistant explicitly says it consulted the `ekyc-jp:jpki-ap-riyousha` skill and its guidance.
NOT acceptable: an answer that contradicts the skill on the point being asked, invents APDU bytes / AIDs / PIN counts that this plugin marks 未確認, states a 犯収法 method letter with no basis (the plugin now cites e-Gov / references/hourei-eKYC.md for the letters and flags that the 2027 逐条 wording is not fully cross-checked), or tells the app to call J-LIS directly. (Irrelevant NOT-acceptable items — e.g. APDU bytes for a purely legal question — simply do not apply.)
