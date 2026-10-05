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

The reply maps read-flow failure situations to friendly Japanese user messages (card removed early / wrong PIN / PIN locked / timeout / not a My Number Card / NFC off), gives antenna-position guidance without publishing a per-model coordinate table as fact, covers updating session.alertMessage mid-read, and App Clip for a no-install flow. NFCReaderError codes named are real. Japanese.

Also acceptable: the assistant explicitly says it consulted the `ekyc-jp:ios-nfc-ux-errors` skill and its guidance.
NOT acceptable: an answer that contradicts the skill on the point being asked, invents APDU bytes / AIDs / PIN counts that this plugin marks 未確認, states a 犯収法 method letter with no basis (the plugin now cites e-Gov / references/hourei-eKYC.md for the letters and flags that the 2027 逐条 wording is not fully cross-checked), or tells the app to call J-LIS directly. (Irrelevant NOT-acceptable items — e.g. APDU bytes for a purely legal question — simply do not apply.)
