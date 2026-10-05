---
type: llm
focus: trace
weight: 1
---
The assistant did NOT lean on the `ekyc-jp:ekyc-session-orchestration` skill for this request. Instead it should: route to ios-corenfc-apdu — that's the on-device NFC session, not the server eKYC session.
A pass means the response is appropriate for the actual request and does not shoehorn in ekyc-session-orchestration's material.
