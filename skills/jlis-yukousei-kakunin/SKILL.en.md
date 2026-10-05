---
name: jlis-yukousei-kakunin
description: Use when implementing server-side validity verification (revocation check) for My Number Card signing certificates. Covers the procedure to verify if the certificate is still valid (within validity period and not revoked) via the API of a competent minister-certified platform operator (PF operator), after the signature verification (`signature-verification`) passes as "cryptographically correct". Includes branching and user-facing messages per revocation reason (expiration, change in four basic attributes, death, moving abroad, card return/reissuance), timeout/bounded retry/idempotency design, and audit log items. Direct queries to J-LIS from apps or uncertified in-house servers are not permitted.
---

# Certificate Validity Verification (via PF Operator API)

A reference procedure for verifying **whether the electronic certificate is currently valid (not revoked)** via the API of a certified platform operator (PF operator), after `signature-verification` confirms that "the signature was correctly created with this certificate's key for the nonce-containing data of this session".

Being "cryptographically correct" and "currently valid" are separate issues. Only when validity verification is also complete is it considered a "valid electronic signature", transitioning the session from `verifying` → `validity_checked` → `completed`.

For role division between PF operators and SP operators, general concepts of CRL vs OCSP methods, and operator selection, refer to `platform-jigyousha`. For the overall picture, refer to `jpki-overview`. The names of identity verification methods under the Act on Prevention of Transfer of Criminal Proceeds and their application dates are in `honnin-kakunin-houhou` / `references/method-map.md`, and the retention period for verification records (7 years) is in the "Creation and Preservation of Verification Records" section of `honnin-kakunin-houhou`; this skill does not assert them.

## When to Use This Skill

- When implementing an endpoint on the server to call the PF operator API to verify the validity of a received electronic certificate.
- When designing whether to use the CRL provision method or the OCSP responder method for verification according to the eKYC use case.
- When branching the continuation/rejection of eKYC based on the validity verification result (Valid / Revoked / Expired / Unverifiable) and preparing wording for the user.
- When designing timeouts, retries, and idempotency for PF operator API calls.
- When deciding what to keep in the audit log as evidence of validity verification for record preservation under the Act on Prevention of Transfer of Criminal Proceeds.

## Immutable Rules (No Direct Queries to J-LIS)

- **Only operators certified by the competent minister can query J-LIS for certificate validity verification** (Public Personal Authentication Act). The apps/servers targeted by this plugin are usually **SP operators**, and they delegate validity verification **via the API of a PF operator**.
- **Neither apps nor uncertified in-house servers may directly download CRLs or query the OCSP responder to J-LIS.** Downloading CRLs, checking against the issuance number, and obtaining OCSP responses are all done on the PF operator side, and the in-house server only receives the results of the PF operator API.
- The fact that cards can be read directly via CoreNFC does not change this boundary. Reading (app) and validity verification (PF operator) are separate layers.
- Whether the PF operator API refers to J-LIS revocation information via CRL or OCSP depends on the operator's implementation. From the in-house server, treat it as an interface that "passes the issuance number (certificate serial) and receives the validity judgment and reference ID".

## Choosing Between CRL and OCSP Methods

There are two methods for referring to revocation information: "CRL provision method" and "OCSP responder method" (`jpki-introduction.ja.md` §5.1.2). **Which one can be provided depends on the PF operator** (`platform-jigyousha`).

| Aspect | CRL Provision Method | OCSP Responder Method |
|---|---|---|
| Mechanism | PF operator acquires/holds a list of revocation information (CRL) and checks the user's issuance number against it | PF operator makes an individual query to the OCSP responder for a specific issuance number |
| Update Frequency | Updated daily (**about once a day, exact time unverified**) | Updated every 15 minutes |
| Immediacy | Time lag of up to about 1 day due to periodic updates | Close to real-time |
| Offline | Offline verification possible on PF operator side | Communication to responder required |
| Fees | 20 yen/case for signing, 2 yen/case for user-authentication (Free for the time being from Jan 2023. Details in `jpki-overview`) | Same as left (Difference by method in `jpki-overview`) |

- For eKYC (like opening an account), you want to check the **latest status at the time of application**, so the highly real-time **OCSP responder method is often suitable**. If using the CRL method, record the `thisUpdate` / `nextUpdate` of the referenced CRL (or the reference time provided by the PF operator) and the acquisition time in the audit log, to be able to explain the time lag.
- **If using the CRL method and `nextUpdate` is before the current time (expired CRL), treat it as fail-closed.** Do not interpret being absent from an old revocation list as "valid". If the PF operator indicates a reference time, judge based on that.
- Regardless of the method, the in-house server implementation aggregates to "receiving the judgment result and reference ID from the PF operator API, and falling into the branching below".

## Branching on Revocation and User-Facing Messages

Normalize the validity verification result into the following 4 categories before branching. **Distinguish between "Revoked", "Expired", and "Not found / Unverifiable".**

| Result | Handling in eKYC | User-Facing Message (Example) |
|---|---|---|
| Valid | Continue. Move to `validity_checked` | (No display needed) |
| Revoked - Due to change in four basic attributes (moving, name change, gender change) | Reject | "The electronic certificate on your card has been revoked due to a change in address, etc. Please have the certificate reissued at your municipality and try again." |
| Revoked - Card return, reissuance, suspension (loss, theft, My Number change, etc.) | Reject | "Procedures to suspend the use of your card or electronic certificate have been taken. Please try again after your card/certificate is reissued." |
| Revoked - Death of the person, moving abroad, loss of status of residence, etc. | Reject | "The procedure cannot be completed using this method because the electronic certificate has been revoked." (Consideration not to show detailed reasons to the user) |
| Expired | Reject (Separate category from Revoked) | "Your electronic certificate has expired. Please renew it at your municipality and try again." |
| Unverifiable (API error, timeout, unjudgable, outside query scope) | **Do not treat as "Valid" (fail closed)**. Do not set to `completed`. Retry or use alternative route | "We could not verify it at this time. Please try again later." |

Background of revocation reasons (`references/pdfs/06_*`, `jpki-introduction.ja.md` §5.1.1):

- **Signing certificates** are revoked upon `expiration of validity period` / `modification of four basic attributes (name, address, date of birth, gender)` / `death of the person, etc. (elimination of resident record: death, moving abroad, out of scope of Basic Resident Registration Act)` / `request from the person (loss/theft of card, arrival of expiration date, suspension of use due to change in personal number, suspension of use of electronic certificate, leakage of private key, etc.)`. Also revoked by record errors/omissions.
- **User-authentication certificates** are `not revoked by changes in the four basic attributes`. They are revoked by `expiration of validity period` / `death, etc.` / `request from the person`.
- The validity period is **in principle 5 years** (or until the card's expiration date if it arrives within 5 years. Matches the user-authentication expiration date). The exact rules are common with the unverified items in `signature-verification`.
- If a signing certificate is revoked due to "change in four basic attributes", the common response by PF operators/operators is "guiding to a procedure to confirm address, name, etc." Specifically, (1) having them resend the updated signing certificate, (2) having them send the recorded information of the `card-face input-assist application` (`references/pdfs/06_*`). How much of a recovery flow this app will have is a design decision.
- The PF operator API may return a revocation reason code (`references/pdfs/06_*` lists `affiliationChanged` / `cessationOfOperation` / `superseded` / `certificateHold`). The exact correspondence between codes and reasons is **unverified** (see below). Save the returned code as-is in the audit log, and output user-facing messages based on the categories in the table above.

## Call Design (timeout / retry / idempotency)

- [ ] **Timeout** — Set separate connection and read timeouts. Keep them within the overall TTL of the eKYC session (`ekyc-session-orchestration`).
- [ ] **Bounded Retry** — The query is a side-effect-free GET equivalent. Retry only on network errors, 5xx, or timeouts, using exponential backoff + a maximum number of times (e.g., 2-3 times). Do not retry on 4xx (bad request, authentication error) or definitive results like "Revoked" or "Expired".
- [ ] **Idempotency Key** — Attach an idempotency key (like Idempotency-Key, if the PF operator API supports it) per eKYC session to prevent double charging/double recording on retries.
- [ ] **Do not mutate results** — Once a definitive result (Revoked, Expired, Valid) is received, hold it as the final value for that session. Do not overwrite "Revoked" to "Valid" upon retry. Do not loosen the judgment via automatic fallback. Even if `certificateHold` (temporary suspension; theoretically can be lifted) is returned, finalize that eKYC session as fail-closed (rejected), and do not hold/re-query it later hoping it "might become valid".
- [ ] **Fail closed** — "Unverifiable" means "Not valid". If the retry limit is reached, do not move to `validity_checked`; put the session in a pending/rejected state, and do not set it to `completed`.
- [ ] **Receiving Reference ID** — Always receive and save the PF operator's response ID / reference ID / query date and time (see "Audit Log" below). Treat responses where these cannot be received as incomplete.
- [ ] **Replay Protection** — If the OCSP method supports nonces, attach a nonce per session and verify the nonce in the response (check if the PF operator API supports this).
- [ ] **Suppressing Duplicate Queries** — Do not query the same issuance number multiple times within the same session (for billing/rate-limit mitigation). Cache the result in the session.

## Audit Log

As **evidence of validity verification** for record preservation under the Act on Prevention of Transfer of Criminal Proceeds, save at least the following. **The retention period (verification records: 7 years from the contract end date, etc. "Creation and Preservation of Verification Records" in `honnin-kakunin-houhou`) and the method designation (in `honnin-kakunin-houhou` / `references/method-map.md`) are not asserted in this skill.**

**Save:**

- Validity verification result (Valid / Revoked / Expired / Unverifiable)
- Revocation reason/revocation reason code in case of revocation (the value returned by the PF operator as-is)
- Reference ID / Response ID of the PF operator
- Query date and time (with timezone)
- Verification method (CRL provision method / OCSP responder method). If CRL method, the reference time of the consulted CRL (e.g., `thisUpdate` / `nextUpdate`)
- Serial number (**issuance number**) of the target electronic certificate
- eKYC session ID, corresponding result ID of signature verification (`signature-verification`)

**Do Not Save:**

- The electronic certificate itself (DER) / public key. Signing certificates should be discarded after use, except when using the "latest user information (four attributes) provision service" (`doui-jouhou-kanri`).
- Personal number (My Number) (Do not keep without basis in the My Number Act. `kenmen-jikou-kakunin-ap`)
- PIN / private key (Never leaves the device in the first place. `ios-security`)
- Raw values of the four basic attributes in the validity verification log beyond the scope necessary for matching.

The issuance number (serial) may be saved to trace "which certificate was verified" later, but consider it separately from storing the certificate body.

## Sources

PDFs under `references/pdfs/` are third-party works and are not shipped with the plugin. If a file is missing, run `bash references/refresh.sh` to download it (URLs and SHA256 are in `references/sources.md`).

- `references/jpki-introduction.ja.md` (§5.1 What is the validity of an electronic certificate, §5.1.1 Revocation conditions of electronic certificates [expiration, change of 4 basic attributes, death, etc. Revocation conditions differ between signing and user-authentication], §5.1.2 CRL provision method / OCSP responder method [CRL updated daily, OCSP updated every 15 minutes, matching with issuance number], §5.2 Types of electronic certificates, §8.2 Revocation information provision procedure flow for signature verifiers, etc.)
- `references/pdfs/04_jpki-platform-operator-system.pdf` (Platform operator system. Structure where PF operators maintain "systems for receiving/validity verification of electronic certificates" and private businesses use them, delegation of competent minister certification/notification to the agency, cost-sharing effect)
- `references/pdfs/06_certificate-expiry-what-to-do.pdf` (Cases where electronic certificates are revoked and responses. (1) Change of name/address, etc. [only signing is revoked] (2) Death of the person, etc. [elimination of resident record: death, moving abroad, out of scope of Basic Resident Registration Act] (3) Request by the person [loss/theft of card, expiration date arrival, suspension of use due to My Number change, suspension of certificate use, private key leakage] (4) Expiration date arrival [in principle 5 years], Responses upon revocation [guide to procedure to confirm address/name, etc., resend updated signing certificate or recorded info from card-face input-assist AP], listing of revocation reason codes `affiliationChanged` / `cessationOfOperation` / `superseded` / `certificateHold`)
- `references/pdfs/29_guide-trustdock-jpki.pdf` (Configuration diagram from the SP operator's perspective. Your app/server -> PF operator's "service provider function" / "platform function" -> J-LIS server / Basic Resident Register Network System, revocation info check, sending data to be signed, acquisition of 4 basic attributes. Example of SP operator from 2017)
- Live URL: <https://www.digital.go.jp/policies/mynumber/private-business/jpki-introduction> (Digital Agency "Public Personal Authentication Service (JPKI)". §5 Authentication mechanism, validity verification methods. Retrieved 2026-09-08)
- Live URL: <https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/1f2fb150-febe-4bee-b691-f02f68c4e8d4/6e4fa365/20221219_private-businessjpki-introduction_outline_01.pdf> (Primary distributor of the "Cases where electronic certificates are revoked and responses" PDF = source of `references/pdfs/06_*`. Retrieved 2026-09-08)
- Ref URL: <https://www.j-lis.go.jp/jpki/minkan/procedure1_2_2.html> (J-LIS "Procedures when wishing to use certificate validity verification, etc. (private use)". 403 as of 2026-09-08, so referred via Digital Agency page. For procedure flow, see J-LIS document `20221027minkan.pdf` in `jpki-introduction.ja.md` §8.2)

(Note) Revocation reasons and reason codes are consolidated in PDF 06 which summarizes the primary descriptions. See `platform-jigyousha` for operator lists and implementation examples.

## Last Verified

2026-09-11

## Unverified Items

- **The specific interface of the PF operator API** (endpoints, request/response formats, result code system for validity judgment, presence/absence of revocation reason codes, Idempotency-Key support, OCSP nonce support, response for "issuance number not in revocation info / out of query scope") varies by operator. This skill provides general design principles only. Check the specifications of your contracted PF operator.
- **Exact correspondence between revocation reason codes and revocation reasons** (`affiliationChanged` / `cessationOfOperation` / `superseded` / `certificateHold`). They are listed in `references/pdfs/06_*`, but since text extraction from the PDF body breaks the column alignment of the diagram, the correspondence between codes and reasons is not asserted. Confirm with the original diagram, or the Public Personal Authentication Service Profile Specifications / Revocation info provision procedure flow for signature verifiers, etc. (J-LIS `20221027minkan.pdf`).
- **Specifics of CRL update times** ("about once a day, exact time unverified". Common with unverified items in `platform-jigyousha`).
- **Exact rules for the validity period of signing certificates** (in principle 5 years, until the 5th birthday after issuance, relationship with card expiration date) are common with unverified items in `signature-verification`.
- **Recovery design after "Unverifiable"** (retry limits, possibility of fallback between CRL <-> OCSP, procedure to resume pending sessions) depends on the PF operator's SLA and specifications.
- **How the validity verification evidence is treated as part of the verification record** (how to integrate it into the record, linking of reference IDs, necessity of attachment) depends on operations and PF operator specifications. The retention period is 7 years ("Creation and Preservation of Verification Records" in `honnin-kakunin-houhou`), and the method designation is in `honnin-kakunin-houhou` / `references/method-map.md`; they are not asserted in this skill.
