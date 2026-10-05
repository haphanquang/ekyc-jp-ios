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

The reply describes the My Number Card IC chip's applications (JPKI-AP with the 署名用 + 利用者証明用 pairs, 券面入力補助AP, 券面事項確認AP, 住基AP), what data / which 暗証番号 each needs, and routes byte-level detail to apdu-cheatsheet.md. It does NOT print an AID hex string in this skill and mirrors apdu-cheatsheet's confidence markers (未確認 / 確認済). Japanese.

Also acceptable: the assistant explicitly says it consulted the `ekyc-jp:mynumber-card-ic` skill and its guidance.
NOT acceptable: an answer that contradicts the skill on the point being asked, invents APDU bytes / AIDs / PIN counts that this plugin marks 未確認, states a 犯収法 method letter with no basis (the plugin now cites e-Gov / references/hourei-eKYC.md for the letters and flags that the 2027 逐条 wording is not fully cross-checked), or tells the app to call J-LIS directly. (Irrelevant NOT-acceptable items — e.g. APDU bytes for a purely legal question — simply do not apply.)
