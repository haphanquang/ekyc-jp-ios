---
type: llm
focus: trace
weight: 1
---
The assistant did NOT lean on the `ekyc-jp:jpki-ap-shomei` skill for this request. Instead it should: route to jpki-ap-riyousha — that's the 当人認証 / challenge-response cert, not the signing cert.
A pass means the response is appropriate for the actual request and does not shoehorn in jpki-ap-shomei's material.
