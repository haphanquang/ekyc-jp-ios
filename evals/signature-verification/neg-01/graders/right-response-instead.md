---
type: llm
focus: trace
weight: 1
---
The assistant did NOT lean on the `ekyc-jp:signature-verification` skill for this request. Instead it should: route to jpki-ap-shomei — client-side signature generation, not server verification.
A pass means the response is appropriate for the actual request and does not shoehorn in signature-verification's material.
