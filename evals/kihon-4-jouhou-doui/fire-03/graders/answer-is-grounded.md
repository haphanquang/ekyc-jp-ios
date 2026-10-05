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

The reply covers 基本4情報 (氏名・住所・生年月日・性別, incl. 旧氏 / ふりがな from 2026-05 / 国外転出) and/or the 最新の利用者情報(4情報)提供サービス, and the 同意画面 requirements from the 総務省/デジタル庁 notice — an independent consent screen, the ~15 mandatory/optional consent items, electronic-only collection via 署名用 signature, 10-year validity, revocable per service. Japanese, traceable to PDF 09.

Also acceptable: the assistant explicitly says it consulted the `ekyc-jp:kihon-4-jouhou-doui` skill and its guidance.
NOT acceptable: an answer that contradicts the skill on the point being asked, invents APDU bytes / AIDs / PIN counts that this plugin marks 未確認, states a 犯収法 method letter with no basis (the plugin now cites e-Gov / references/hourei-eKYC.md for the letters and flags that the 2027 逐条 wording is not fully cross-checked), or tells the app to call J-LIS directly. (Irrelevant NOT-acceptable items — e.g. APDU bytes for a purely legal question — simply do not apply.)
