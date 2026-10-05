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

The reply gives the server-side verification steps: verify the signature with the cert's public key over data that includes the session nonce, build the chain to the J-LIS root CA (embedded/pinned; jpki.go.jp/ca is public), check notBefore/notAfter, match 基本4情報 with 表記揺れ normalisation (外字/旧字体, address rules) attributed to LIQUID as vendor material, and the rule that 'cryptographically valid' != '有効' -> validity must be checked separately via a PF事業者 (route to jlis-yukousei-kakunin), never J-LIS directly. Japanese.

Also acceptable: the assistant explicitly says it consulted the `ekyc-jp:signature-verification` skill and its guidance.
NOT acceptable: an answer that contradicts the skill on the point being asked, invents APDU bytes / AIDs / PIN counts that this plugin marks 未確認, states a 犯収法 method letter with no basis (the plugin now cites e-Gov / references/hourei-eKYC.md for the letters and flags that the 2027 逐条 wording is not fully cross-checked), or tells the app to call J-LIS directly. (Irrelevant NOT-acceptable items — e.g. APDU bytes for a purely legal question — simply do not apply.)
