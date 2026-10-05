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

The reply explains JPKI at an overview level: the 署名検証者 / 利用者証明検証者 model, プラットフォーム事業者 (PF) vs サービスプロバイダ事業者 (SP), J-LIS as issuer / trust anchor, and the fee structure (20円 for 署名用 / 2円 for 利用者証明用, currently waived since 2023). It does NOT assert 犯収法 method letters or 2027 reform dates as fact (those belong to honnin-kakunin-houhou). Japanese.

Also acceptable: the assistant explicitly says it consulted the `ekyc-jp:jpki-overview` skill and its guidance.
NOT acceptable: an answer that contradicts the skill on the point being asked, invents APDU bytes / AIDs / PIN counts that this plugin marks 未確認, states a 犯収法 method letter with no basis (the plugin now cites e-Gov / references/hourei-eKYC.md for the letters and flags that the 2027 逐条 wording is not fully cross-checked), or tells the app to call J-LIS directly. (Irrelevant NOT-acceptable items — e.g. APDU bytes for a purely legal question — simply do not apply.)
