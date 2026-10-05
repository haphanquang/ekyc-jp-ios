---
name: ekyc-session-orchestration
description: Use when designing and implementing a single eKYC session on the server side. Covers eKYC session design (server), nonce/challenge generation and binding, state transitions/state machine (created -> nonce_issued -> card_read -> signed -> verifying -> validity_checked -> completed / rejected / expired), device binding via session token, countermeasures against replay and relay attacks, idempotency (Idempotency-Key), image injection countermeasures (server-side liveness and authenticity checks during facial capture), and audit logs for each state transition. Details on IC reading and signature generation on the app side, cryptographic processing of signature verification, and J-LIS validity verification are out of scope (delegated to their respective skills).
---

# Server-Side eKYC Session Design (Nonce, State Machine, Replay/Relay/Injection Countermeasures)

A design reference to prevent replay, relay, and image injection attacks by connecting the following as a **single server-managed session**: the app (`jpki-ap-shomei` / `jpki-ap-riyousha`) reading the IC chip, the server verifying the signature (`signature-verification`), and verifying the electronic certificate's validity (`jlis-yukousei-kakunin`).

This skill covers the **orchestration layer**. It does not re-explain the contents of each step (APDUs, signature algorithms, certificate chains, PF operator APIs), but defines only the state management, transition conditions, nonce binding, and auditing.

The method designations under the Act on Prevention of Transfer of Criminal Proceeds and their application dates are not asserted in this skill. Refer to `honnin-kakunin-houhou` / `references/method-map.md`. For the retention period of verification records under the Act (7 years), see "Creation and Preservation of Verification Records" in `honnin-kakunin-houhou`; for the handling of consent information and its validity period (10 years), see `doui-jouhou-kanri`.

## When to Use This Skill

- When designing and implementing endpoints on the server to start an eKYC session and manage its state transitions.
- When deciding where to generate the nonce/challenge, until which step it is valid, and when to discard it.
- When designing to bind a session token to an app instance to reject reuse from a different context.
- When putting in a mechanism to bind the signature result to "the nonce of this session" against replay and relay attacks.
- When attaching an Idempotency-Key to each state-changing call to prevent moving forward twice on retries.
- When designing liveness/authenticity checks as a server-side responsibility for flows involving facial capture (e.g., Method He).
- When deciding what to record in the audit log per state transition.

For app-side IC reading and signature generation, refer to `jpki-ap-shomei` / `jpki-ap-riyousha`; for signature verification, `signature-verification`; for validity verification, `jlis-yukousei-kakunin`; for role division between PF operators and SP operators, `platform-jigyousha`.

## Session State Transitions

1 session = 1 state machine. Allow **forward transitions only**. If any step fails, drop to `rejected`; if overall TTL or nonce TTL is exceeded, drop to `expired`. `completed` / `rejected` / `expired` are terminal states, and it cannot transition back from them. Upon reaching a terminal state, revoke the session token.

| State | What Happened | Permitted Next Transitions | Timeout |
|---|---|---|---|
| `created` | App requested start of session. Server issued session token and bound it to the requesting app instance. No nonce yet | `nonce_issued` / `expired` | Overall TTL |
| `nonce_issued` | Server generated nonce via CSPRNG, bound it to session, prepared data to be signed (body + nonce), and returned it to app | `card_read` / `rejected` / `expired` | Nonce TTL (short, e.g., a few minutes) |
| `card_read` | App completed IC chip read and PIN VERIFY (for Method He, facial capture is also completed here). Signature not yet received | `signed` / `rejected` / `expired` | Overall TTL |
| `signed` | App sent electronic signature over nonce-containing data (+ certificate DER, and for Method He, facial image with signature) to server | `verifying` / `rejected` / `expired` | Overall TTL |
| `verifying` | Server is executing signature verification, certificate chain, expiration, **nonce matching**, and 4-basic-info matching (`signature-verification`) | `validity_checked` / `rejected` / `expired` | Processing timeout + Overall TTL |
| `validity_checked` | Electronic certificate validity check via PF operator API completed and was "Valid" (`jlis-yukousei-kakunin`) | `completed` / `rejected` / `expired` | Processing timeout + Overall TTL |
| `completed` | All steps successful. Finalize verification record, revoke session token | (Terminal) | — |
| `rejected` | Any step failed (signature mismatch, nonce mismatch, revoked, 4-info mismatch, liveness failed, timeout, etc.). Record reason, revoke session token | (Terminal) | — |
| `expired` | Exceeded overall TTL or nonce TTL. Record reason, revoke session token | (Terminal) | — |

- **Keep overall TTL short** (realistic required time for IC read, capture, and communication + margin. Long open sessions provide working time for attackers). Decide specific values as a trade-off with operations/drop-off rates, leaving them in `Unverified Items`.
- Reject any transitions that skip states (e.g., `created` -> `signed`), go backward, or originate from a terminal state, logging them as `rejected`.
- Failures in `verifying` / `validity_checked` distinguish between those that can be retried (network, 5xx) and definitive failures (signature mismatch, revoked). Definitive failures are immediately `rejected`. Follow bounded retry design for `jlis-yukousei-kakunin`; drop to `rejected` when the limit is reached.
- **Collecting stagnant sessions (reaper):** In any state from `created` to `validity_checked`, have a **background periodic job** check the overall TTL from creation, nonce TTL from `nonce_issued`, and processing timeouts. Drop exceeded sessions to `expired` (or `rejected` if downstream is unresponsive during processing) and leave an audit entry. Do not leave sessions dangling in `verifying` / `validity_checked` due to process restarts, crashes, or downstream unresponsiveness. Always revoke the session token upon termination.

## Nonce and Device Binding

### Nonce / Challenge

- **The server generates the nonce.** Use a CSPRNG to draw sufficient length (e.g., 128-256 bits) and bind it to the session ID upon entering `nonce_issued`.
- **The app does not invent the nonce.** The app only signs the to-be-signed data (or its hash) assembled by the server from "the body (hash of application contents, etc.) + the nonce" (match the premise in `jpki-ap-shomei` / `jpki-ap-riyousha`. Reconcile whether to pass raw bytes, SHA-256 hash, or wrap in DigestInfo with `Unverified Items` in the app-side skills).
- **Single-use, short TTL.** The nonce can only be used for one signature in one session. Fail the `verifying` step if a signature contains a used, expired, or other-session nonce. Consume it via atomic operation (conditional UPDATE / compare-and-set) matching the check, leaving it consumed even on verification failure (step 4 of `signature-verification`).
- Do not output nonces as-is in logs, URLs, or error messages (leave as identifier/hash in audit logs).
- **The body (to-be-signed) should be concrete wording where "what the user signed" carries meaning (WYSIWYS).** Include transaction/consent contents in human-readable form, like "Consent to identity verification" or "Application for ordinary deposit account at XX Bank". Do not have them sign bare random values or session IDs alone. If an attacker tricks a victim into signing "the body of the attacker's session", discrepancies with the victim's intent can be detected during review/audit. **The default exchange is "the server returns a to-be-signed byte array (canonical form) containing the body and nonce to the app, the app displays the body on screen, and the app itself calculates SHA-256 and signs"** (`jpki-ap-shomei` "Premise"). Because the server verifies against its own held to-be-signed, it fails if the app hashed something else. Configurations passing only the hash are treated as exceptions because users cannot confirm the signed contents and could be made to sign anything upon server/channel compromise. Fix the canonical form (encoding, delimiters) of to-be-signed between server and app, and reconcile with the hash format in `Unverified Items`. The signature is meaningful only against this body.

### Device Binding

- At `created`, the server issues a **session token** and binds it to the requesting app instance (installation unit). Demand this token for all subsequent state-change calls, and **reject usage from a context different from issuance (different instance, unexpected route)**, turning them to `rejected`.
- **Device binding alone cannot prevent relay attacks.** Because session tokens are bearer tokens, they can be used from any device if transferred. **For eKYC such as account openings, make app instance verification via Apple's App Attest (`attestKey(_:clientDataHash:)` / `generateAssertion(_:clientDataHash:)` of `DCAppAttestService`) the default** (DeviceCheck's `DCDevice` has a different purpose and is insufficient alone). The server commits a generated **challenge to the same value as the session nonce**, the app includes it in `clientDataHash` to create an assertion, and the server verifies challenge matching, attestation signature (chaining to Apple root), and monotonic counter increment. This binds down to "the genuine app on this device instance signed against this session's nonce". For non-supported devices (older OS, etc.), manage fallbacks separately, such as routing that session to a manual review queue. Before implementation, confirm field validation for attestation object / authenticator data, counter tolerances, re-registration upon key revocation, and Apple root certificate pinning in Apple's primary documentation (`Unverified Items`).
- Device binding only shows "the app is genuine", not "the human with the card and PIN is the person themselves". The latter is ensured by JPKI signature verification, validity check, and (for Method He) facial matching.

## Replay and Relay Countermeasures

- **Single-use nonces + short TTL** (see above). Reject as reuse if the same nonce and same signature value appear twice. Record hashes of accepted signatures for a certain period and match against them.
- **Bind signature results to "the nonce of this session".** In `verifying`, check that the nonce in the to-be-signed data is "the exact value issued by the server to that session" (`signature-verification` nonce matching step). A signature legitimately created in another session cannot be brought into this one.
- **Timestamp / Expiration checks.** Record session creation time and nonce issuance time, and check overall TTL / nonce TTL at each transition. The clock is server-based.
- **Make app instance binding (App Attest) the default** (see "Device Binding" above). Block routes bringing transferred signature blobs + tokens from non-genuine apps via attestation verification where challenge = nonce.
- **Residual risk of relay attacks.** Cases where an attacker **controls the physical card and correct PIN** to interrupt a victim's procedure cannot be prevented by nonce single-use and App Attest alone (the attacker operates via a genuine app and device). Reduce this residual risk by design using facial matching via JPKI + facial capture (Method He), repeated personal authentication (`jpki-ap-riyousha`), and WYSIWYS body (above). For method selection and designations, refer to `honnin-kakunin-houhou` (do not re-derive here).
- The session token, nonce, and to-be-signed data are all held by the server. Do not transition by trusting states self-reported by the app ("liveness checked on device", etc.).

## Idempotency

- **Demand an Idempotency-Key for each state-changing call (start, submit signature, trigger re-verification, etc.).** Allow the app to send the same key on retries, and have the server record the "first result" paired with the key + session ID + target state.
- **Resending the same key returns the first result as-is.** Do not advance the state twice on the second call (do not verify twice upon receiving `signed` twice, do not finalize `completed` twice).
- If the same key arrives while processing, return "processing" and do not run in parallel (session-level lock).
- Do not let a finalized result (`rejected` / `completed` / validity check judgment) morph into another result upon retry (same principle as "Do not mutate results" in `jlis-yukousei-kakunin`).
- Propagate the Idempotency-Key to PF operator API calls as well to prevent double billing/recording (`jlis-yukousei-kakunin`).

## Image Injection Countermeasures (Method He)

When the flow includes facial capture (combining IC chip reading with facial capture. For designations like "Method He" and application dates, see `honnin-kakunin-houhou`), **liveness, authenticity checks, and camera injection detection are the server's responsibility**.

- **Do not assume the app guarantees "the real person is actually pictured".** Terminal apps can be modified, emulated, or have video replaced. Perform checks on the images (and accompanying data) received by the server.
- LIQUID eKYC lists the following for fraud detection using facial images (referenced as **LIQUID's approach**. Examples of general principles; CV internals are not re-taught here):
  - **Facial authenticity check** — Authenticity check to detect spoofing via display attacks or photo attacks. The company's AI for spoofing detection for facial recognition, "**Liquid PAD**" (`references/pdfs/33_guide-liquid-ekyc.pdf` p19).
  - **Camera injection attack detection** — Determines if it is an attack where the smartphone/PC camera control was hacked and replaced with virtual video via tools (ibid., p19).
  - **Facial passive check** — A paid option to check authenticity without random actions (facial muscles + flash). If the score is low, routes to manual confirmation (ibid., p10).
  - Matching against past user identical person checks, reuse of face/personal identification matters, and warning lists (approx. 10,000 facial data items, etc.) (ibid., p19).
  - **PAD (Presentation Attack Detection) international standard `ISO/IEC 30107`** is a real standard. LIQUID states "Liquid PAD" received an official `ISO/IEC 30107` confirmation letter from third-party evaluator Fime (ibid., p20). Whether custom-built or adopting another vendor, `ISO/IEC 30107` can be used as a baseline for authenticity evaluation.
- Handling in design: In flows involving facial capture, include "passes server-side liveness / authenticity check" in the completion conditions for `card_read`, and set to `rejected` on failure. Route gray zones where the score is below the threshold to a manual review queue; do not automatically set to `completed`. Leave the judgment result (score, judgment model, presence in warning list) in the audit log.
- For whether facial images themselves can be saved and their retention periods, see `doui-jouhou-kanri`.

## Audit

Record **all state transitions** (including successes, failures, and rejected transition attempts) in an append-only, tamper-resistant manner.

Leave at minimum the following in each entry:

- Session ID, State before transition -> State after transition
- Timestamp (with timezone)
- Actor (app instance ID / session token identifier, server processing, PF operator response, etc.)
- Reason (success, or failure/rejection reason code: `nonce_mismatch` / `nonce_expired` / `signature_invalid` / `chain_invalid` / `four_info_mismatch` / `revoked` / `expired_cert` / `liveness_failed` / `token_context_mismatch` / `ttl_exceeded` / `idempotency_replay`, etc.)
- Identifier of nonce (do not leave raw value), Idempotency-Key
- Reference IDs of related downstream results: Signature verification result ID (`signature-verification`), validity check reference ID, query date/time, and method (`jlis-yukousei-kakunin`), liveness/authenticity score and judgment
- Method He: Result of facial matching, presence/absence in warning lists

- Design logs so they cannot be edited/deleted later (append-only, hash chains / WORM storage, etc. Specific means are determined by operational requirements).
- Audit logs connect to verification records and evidence of verification methods under the Act on Prevention of Transfer of Criminal Proceeds. **The retention period (verification records: 7 years from contract end date, etc.) is in "Creation and Preservation of Verification Records" of `honnin-kakunin-houhou`, and method designations are in `honnin-kakunin-houhou` / `references/method-map.md`; they are not asserted in this skill.**
- Do not leave raw values of four basic attributes, PINs, private keys, or certificate DERs in the audit log (do not hold beyond what is necessary for matching. Match with the "Do Not Save" items in `signature-verification` / `jlis-yukousei-kakunin`).

## Sources

PDFs under `references/pdfs/` are third-party works and are not shipped with the plugin. If a file is missing, run `bash references/refresh.sh` to download it (URLs and SHA256 are in `references/sources.md`).

- `references/pdfs/33_guide-liquid-ekyc.pdf` (p10, p19-20 — Overview of JPKI+ (facial) and conditions for manual confirmation, "Advanced fraud detection judgment functions" = facial authenticity check, camera injection attack detection, past user identical person check, reuse of face/personal identification matters, warning list check, spoofing detection AI "Liquid PAD", received official `ISO/IEC 30107` confirmation letter from Fime) *Vendor document. Methods and figures for fraud detection are the company's explanation, not public specifications.
- `signature-verification` (Signature verification, certificate chain, expiration, nonce matching, and 4-basic-info matching in the `verifying` stage. "Cryptographically correct" != "Valid")
- `jlis-yukousei-kakunin` (Validity verification via PF operator API in the `validity_checked` stage, bounded retry, idempotency key, fail closed, audit log items)
- `jpki-ap-shomei` / `jpki-ap-riyousha` (Premises of IC reading/signature generation on the app side. "The server generates the challenge (nonce)", "The app does not issue the nonce")
- `platform-jigyousha` (Role division between PF operators / SP operators, boundary of validity verification delegation)
- `honnin-kakunin-houhou` / `references/method-map.md` (Sole definer of method designations and application dates under the Act on Prevention of Transfer of Criminal Proceeds. Positioning of methods involving IC reading + facial capture (Method He, etc.). For creation and preservation of verification/transaction records (7 years) under the Act, see "Creation and Preservation of Verification Records")
- `doui-jouhou-kanri` (Management of consent information, permission to save facial images, 10-year validity of consent for latest 4-info provision service. A separate system from the 7-year record preservation under the Act)
- <https://www.digital.go.jp/policies/mynumber/private-business/jpki-introduction> (Digital Agency "Public Personal Authentication Service (JPKI)" §5 Authentication mechanism, challenge-response, validity verification methods. Retrieved 2026-09-08, HTTP 200)
- <https://developer.apple.com/documentation/devicecheck/dcappattestservice> (Apple "DCAppAttestService" — App Attest's `generateKey()` / `attestKey(_:clientDataHash:)` / `generateAssertion(_:clientDataHash:)`. Retrieved 2026-09-08, HTTP 200)
- <https://developer.apple.com/documentation/devicecheck/validating-apps-that-connect-to-your-server> (Apple "Validating apps that connect to your server" — Verification of server-issued challenge, verification of assertion counter. Retrieved 2026-09-08, HTTP 200)

## Last Verified

2026-09-11

## Unverified Items

- **Specific values for Overall TTL and Nonce TTL.** Design decisions made based on trade-offs between realistic required times for IC read/facial capture/communication and drop-off rates. Primary recommended values are not held.
- **Details of App Attest integration.** Confirmed via Apple docs up to the class name (`DCAppAttestService`) and the flow where the app includes the challenge in `clientDataHash` to make an assertion which the server verifies. Validation of attestation object / authenticator data fields, counter tolerances, re-registration flows on key revocation, and Apple root certificate pinning must be confirmed via Apple primary docs before implementation. This skill recommends "challenge = session nonce", but whether the nonce fits Apple's length/format constraints for the challenge must be verified during implementation.
- **Format for passing to-be-signed data** (whether the server passes raw nonces, SHA-256 hashes, necessity of DigestInfo wrapping, hash length). Common with `Unverified Items` in `jpki-ap-shomei` / `jpki-ap-riyousha` / `signature-verification`. Align the server implementation with the app-side skills.
- **Implementation means for audit log tamper-resistance** (hash chains, WORM storage, external timestamps, etc.). Confirm the retention period as a verification record under the Act on Prevention of Transfer of Criminal Proceeds (7 years) and the method designation in `honnin-kakunin-houhou` ("Creation and Preservation of Verification Records").
- **Sufficiency of concrete countermeasures against the residual risk of relay attacks.** How effective facial matching or repeated personal authentication is against an attacker holding the physical card + correct PIN depends on operations and threat models. No primary evaluation criteria are held.
- **Application conditions, accuracy, and false positive rates of LIQUID's fraud detection functions (facial authenticity, camera injection, warning lists).** `references/pdfs/33_guide-liquid-ekyc.pdf` is a vendor document; numbers (like ~10,000 warning list entries) and patented tech details are the company's explanation. Check with the vendor's specifications when adopting.
- **Score thresholds for passive/active facial checks and criteria for routing to manual review.** The same document only states "routes to manual confirmation if the score is low".
