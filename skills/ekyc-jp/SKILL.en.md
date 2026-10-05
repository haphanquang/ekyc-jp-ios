---
name: ekyc-jp
description: Used first when designing and implementing iOS apps that support Japan's eKYC (My Number Card and JPKI Public Personal Authentication). Guides you to the appropriate individual skills for My Number Card CoreNFC reading, signature verification server, and selection of identity verification methods under the Act on Prevention of Transfer of Criminal Proceeds.
---

# ekyc-jp (Router)

The entry point of the `ekyc-jp` plugin. Detailed knowledge is not placed here. It only provides a table guiding you to the individual skills corresponding to your purpose, and 5 invariable rules. Explanations of JPKI, method names, APDU, etc., are in each skill and `references/`.

## About This Skill Group

Total of 19 skills in 3 tiers + maintenance (including this router). First, identify the applicable tier, check the business/legal affairs (Tier 1), and then open the implementation skills (Tier 2/3).

### Tier 1 — Business / Legal (Reference)

| Skill | Scope |
|---|---|
| `jpki-overview` | JPKI overall picture, actors, trust model, fees |
| `honnin-kakunin-houhou` | Method selection for Act on Prevention of Transfer of Criminal Proceeds / Mobile Phone Fraud Prevention Act / Secondhand Articles Dealer Act, legal revisions (the sole defining source of method names) |
| `mynumber-card-ic` | IC chip structure and AP list |
| `kihon-4-jouhou-doui` | Four basic attributes, latest 4 attributes provision service, consent screen requirements |
| `platform-jigyousha` | PF/SP operators, CRL/OCSP, operator selection, introduction procedures |

### Tier 2 — iOS Implementation (Procedure + Checklist)

| Skill | Scope |
|---|---|
| `ios-corenfc-apdu` | CoreNFC/APDU foundation, project setup |
| `jpki-ap-shomei` | Reading signing certificates and generating electronic signatures |
| `jpki-ap-riyousha` | User-authentication certificates, challenge-response |
| `kenmen-nyuryoku-hojo-ap` | Acquiring four basic attributes with the card-face input-assist application |
| `kenmen-jikou-kakunin-ap` | Acquiring card-face images, facial photos, and personal numbers |
| `pin-lock-handling` | PIN lock counts, SW1SW2, unlock guidance |
| `ios-nfc-ux-errors` | Reading UX, error wording, antenna position, App Clip |
| `ios-security` | Handling card data, certificate pinning, prohibited log items |

### Tier 3 — Server / Integration (Procedure + Checklist)

| Skill | Scope |
|---|---|
| `signature-verification` | Signature verification, certificate chain, four basic attributes matching, notation variations |
| `jlis-yukousei-kakunin` | Certificate validity verification (always via PF operator), CRL/OCSP, branching upon revocation |
| `ekyc-session-orchestration` | Nonce / challenge, state transition, replay/relay countermeasures |
| `doui-jouhou-kanri` | Saving/managing consent records, consent validity period, disclosure requests |

### Maintenance

| Skill | Scope |
|---|---|
| `sources-refresh` | Re-acquiring primary sources and checking for diffs (document updates) |
| `ekyc-jp` (This skill) | Entry point, standard routes, invariable rules |

## What You Want to Do → Skill to Open

| Situation / What you want to do | Skill to open (Sequence) |
|---|---|
| Understand the overall picture, actors, trust model, and fees of JPKI and eKYC | `jpki-overview` |
| Select an identity verification method (Act on Prevention of Transfer of Criminal Proceeds / Mobile Phone Fraud Prevention Act / Secondhand Articles Dealer Act), know the impact of legal revisions | `honnin-kakunin-houhou` (→ `references/method-map.md`) |
| Understand the IC chip structure and AP list of the My Number Card | `mynumber-card-ic` |
| Check the requirements for the four basic attributes, latest 4 attributes provision service, and consent screen | `kihon-4-jouhou-doui` → `doui-jouhou-kanri` |
| Consider PF/SP operator selection, CRL/OCSP, and introduction procedures | `platform-jigyousha` |
| Start IC chip reading on iOS (project setup, CoreNFC/APDU) | `ios-corenfc-apdu` |
| Generate an electronic signature with a signing certificate and verify it on the server | `ekyc-session-orchestration` → `ios-corenfc-apdu` → `jpki-ap-shomei` → `signature-verification` → `jlis-yukousei-kakunin` |
| Perform challenge-response authentication with a user-authentication certificate | `ios-corenfc-apdu` → `jpki-ap-riyousha` → `ekyc-session-orchestration` |
| Acquire the four basic attributes with the card-face input-assist application | `ios-corenfc-apdu` → `kenmen-nyuryoku-hojo-ap` |
| Acquire card-face images, facial photos, and personal numbers | `ios-corenfc-apdu` → `kenmen-jikou-kakunin-ap` |
| Handle PIN locks, SW1SW2, and unlock guidance | `pin-lock-handling` |
| Design reading UX, error wording, antenna position, and App Clip | `ios-nfc-ux-errors` |
| Check card data handling, certificate pinning, and prohibited log items | `ios-security` |
| Perform signature verification, certificate chain, and four basic attributes matching on the server | `signature-verification` |
| Check the validity of electronic certificates | `jlis-yukousei-kakunin` (Always via a PF operator in `platform-jigyousha`) |
| Design eKYC session state transitions, nonce, and replay/relay countermeasures | `ekyc-session-orchestration` |
| Support saving/managing consent records, consent validity periods, and disclosure requests | `doui-jouhou-kanri` |
| Re-acquire primary sources and check for diffs (when documents are old or questions relate to era boundaries) | `sources-refresh` |

## Invariable Rules

1. Do not inquire directly to J-LIS. Certificate validity verification must always be performed via a platform operator (PF operator). Do not access J-LIS directly from apps or uncertified in-house servers.
2. Legal dates and method names (such as the method designations of the Act on Prevention of Transfer of Criminal Proceeds) are defined solely in `honnin-kakunin-houhou` and `references/method-map.md`. Do not assert them elsewhere in this skill group. Do not write legal dates without a dated source.
3. When the last update of `references/sources.md` was about 3 months or more ago, or when answering questions related to the 2026/2027 periods, execute `sources-refresh` first before answering.
4. Pass the PIN only to the VERIFY command to the card. Do not send it to the server, logs, or analytics SDKs, and do not save it on the device (even "remembering" it with biometric authentication is prohibited). For details, see `ios-security`.
5. Trust an electronic certificate only after verifying the chain up to the JPKI certificate authority (signing / user-authentication) that issued it. Simply passing the signature with the public key contained in the certificate proves nothing (`signature-verification`).

## Sources

This skill does not hold detailed knowledge. Refer to each skill and `references/` for facts, figures, and procedures.

- `references/method-map.md` — Defining source for method names and dates of the Act on Prevention of Transfer of Criminal Proceeds, etc.
- `references/yougoshuu.md` — Glossary
- `references/apdu-cheatsheet.md` — APDU cheat sheet
- `references/sources.md` — List of primary sources and acquisition dates/hashes
- `references/jpki-introduction.ja.md` — Digital Agency "Identity Verification by Public Personal Authentication Service (JPKI)"
- Live URL: <https://www.digital.go.jp/policies/mynumber/private-business/jpki-introduction> (Acquired 2026-09-08)

## Last Verified

2026-09-08

## Unverified Items

None
