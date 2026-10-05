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

The reply covers the iOS project setup (the com.apple.developer.nfc.readersession.iso7816.select-identifiers entitlement listing the AIDs, NFCReaderUsageDescription, the capability, real-device requirement) and the CoreNFC session mechanics (NFCTagReaderSession with .iso14443, didDetect -> connect -> case .iso7816, NFCISO7816APDU, sendCommand). API names are real. It stays generic-transport and routes JPKI-specific APDU (VERIFY/COMPUTE SIGNATURE) to jpki-ap-*. Japanese prose, real Swift.

Also acceptable: the assistant explicitly says it consulted the `ekyc-jp:ios-corenfc-apdu` skill and its guidance.
NOT acceptable: an answer that contradicts the skill on the point being asked, invents APDU bytes / AIDs / PIN counts that this plugin marks 未確認, states a 犯収法 method letter with no basis (the plugin now cites e-Gov / references/hourei-eKYC.md for the letters and flags that the 2027 逐条 wording is not fully cross-checked), or tells the app to call J-LIS directly. (Irrelevant NOT-acceptable items — e.g. APDU bytes for a purely legal question — simply do not apply.)
