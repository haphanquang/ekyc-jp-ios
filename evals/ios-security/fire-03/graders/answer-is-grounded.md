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

The reply covers on-device handling: private keys never leave the IC, card data held in memory only and cleared after the request, TLS + certificate/public-key pinning, a log-ban list (PIN / hash / signature / 個人番号 / face photo / card images / cleartext 4-info; never os_log %{public}), Keychain (ThisDeviceOnly) not UserDefaults, screenshot protection on the PIN screen, jailbreak detection as a signal not a hard block. Real Apple API names. Japanese.

Also acceptable: the assistant explicitly says it consulted the `ekyc-jp:ios-security` skill and its guidance.
NOT acceptable: an answer that contradicts the skill on the point being asked, invents APDU bytes / AIDs / PIN counts that this plugin marks 未確認, states a 犯収法 method letter with no basis (the plugin now cites e-Gov / references/hourei-eKYC.md for the letters and flags that the 2027 逐条 wording is not fully cross-checked), or tells the app to call J-LIS directly. (Irrelevant NOT-acceptable items — e.g. APDU bytes for a purely legal question — simply do not apply.)
