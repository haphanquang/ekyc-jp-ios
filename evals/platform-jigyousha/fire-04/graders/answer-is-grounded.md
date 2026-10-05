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

The reply explains why an eKYC app still needs a licensed プラットフォーム事業者 (only a 主務大臣認定 holder may query J-LIS validity), covers CRL vs OCSP, lists / characterises the main operators (LIQUID, TRUSTDOCK, POCKETSIGN, GMO, etc.), gives selection criteria, and the onboarding steps/timeline (AID開示申請 + 利用申込 + J-LIS審査). It does NOT invent per-operator method support or pricing (各社に要確認). Japanese.

Also acceptable: the assistant explicitly says it consulted the `ekyc-jp:platform-jigyousha` skill and its guidance.
NOT acceptable: an answer that contradicts the skill on the point being asked, invents APDU bytes / AIDs / PIN counts that this plugin marks 未確認, states a 犯収法 method letter with no basis (the plugin now cites e-Gov / references/hourei-eKYC.md for the letters and flags that the 2027 逐条 wording is not fully cross-checked), or tells the app to call J-LIS directly. (Irrelevant NOT-acceptable items — e.g. APDU bytes for a purely legal question — simply do not apply.)
