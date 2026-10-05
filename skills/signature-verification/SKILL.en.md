---
name: signature-verification
description: Used when verifying My Number Card's signature digital certificate and JPKI digital signature on the server side. Covers verifying the signature against server-constructed data-to-be-signed (including session nonce = replay countermeasure) for the signature value and signature certificate (DER) received from the app, building the certificate chain up to the Signature CA (Japan Agency for Local Authority Information Systems) (Signature CA is a 1-tier self-signed root, embed and pin all active generations), checking notBefore/notAfter, and matching the basic 4 attributes (name, address, date of birth, sex) from the certificate subject against the application input (absorbing external characters, old character forms, and address notation variations). Also used for verifying the user authentication digital certificate and signature received upon login (person authentication) (chain to User Authentication CA). "Cryptographically correct" is different from "currently valid"; validity confirmation is via Platform Operators (jlis-yukousei-kakunin), and session state transition and nonce design are in ekyc-session-orchestration.
---

# Server-Side Verification of Signature Digital Certificate and Digital Signature

A procedure reference from when the server receives `{ signature: signature value, certificate: signature digital certificate (DER) }` and a session identifier from the app (`jpki-ap-shomei`), to performing **signature verification, certificate chain construction, validity period checking, session nonce matching, and basic 4 attributes matching**.

This skill covers up to "is it cryptographically correct?". **"Is the digital certificate currently valid (not revoked)?" is a separate issue** that can only be verified via certified Platform Operators (`jlis-yukousei-kakunin`). Do not skip that and consider it "verification successful".

Method names for identity verification under the Act on Prevention of Transfer of Criminal Proceeds and their enforcement dates are not asserted in this skill (`honnin-kakunin-houhou` / `references/method-map.md`).

## When to Use This Skill

- When implementing an endpoint on the server to verify JPKI digital signatures
- When writing code to construct and verify the certificate chain from the signature digital certificate to the Signature CA
- When designing to include a session nonce in the data-to-be-signed to prevent signature reuse (replay)
- When writing logic to match the basic 4 attributes (name, address, date of birth, sex) from the certificate subject with the application form input, absorbing notation variations
- When designing/reviewing with a clear distinction between "signature verification passed" and "certificate is valid"

For session state transitions and nonce issuance, see `ekyc-session-orchestration`; for validity confirmation, see `jlis-yukousei-kakunin`; for app-side signature generation, see `jpki-ap-shomei`.

## Prerequisites

- **The data-to-be-signed is constructed by the server.** The server creates the to-be-signed data from "body text (application/consent contents) + nonce issued for this session", and passes the **to-be-signed data itself** to the app. The app displays the body text, calculates the SHA-256 itself, and signs it (see "Prerequisites" in `jpki-ap-shomei`. An architecture passing only the hash is an exception). The app does not generate the nonce. **The body text must be human-readable, making it meaningful "what the user signed" (WYSIWYS. Do not have them sign just a bare random value).** After successful verification, ensure that audits/reviews can confirm this body text matches the contents of the transaction/consent (design in `ekyc-session-orchestration`).
- What the app signs is an RSA-2048 signature against its DigestInfo (RFC 8017 / PKCS#1 v1.5) (`COMPUTE DIGITAL SIGNATURE` in `jpki-ap-shomei`). The signature algorithm is RSA-2048 / PKCS#1 v1.5 / SHA-256 (current specification, support for other hashes is `unverified`. See note in `jpki-ap-shomei`).
- The self-signed certificate (DER) of the Signature CA should be **embedded and pinned** in the server. Do not fetch it over the network during verification. There are multiple generations (see "Chain Construction" below).
- Verification must always be performed on the server side. Do not verify locally in the app (see "What Not to Do" in `jpki-ap-shomei`).

## Verification Flow

If any step fails, do not execute the subsequent steps; set the session to `rejected` and leave an audit log.

- [ ] **1. Signature Verification** — **Do not write an implementation that manually undoes padding and scans the contents (recover-and-scan)**. Verify using verified library primitives (OpenSSL `EVP_DigestVerify`, Java `Signature.verify`, etc.). If manual implementation is unavoidable, strictly construct the expected encoded message `EM = 0x00 01 || FF…FF || 00 || DigestInfo(SHA-256, H)` from the data-to-be-signed (body text + nonce for the session) held by the server, and compare it for an **exact full-byte match** against the value recovered with the public key. The following must all be treated as failures (Bleichenbacher '06 / BERserk countermeasures): excess bytes at the end / non-`0xFF` mixed in PS / PS is less than 8 bytes / `DigestInfo` OID is not `id-sha256` / algorithm parameters are not absent/NULL. Also verify the public exponent `e` (`e < 65537`, even, or `e = 1` are failures). Confirm that the `subjectPublicKeyInfo` algorithm is `rsaEncryption`, key length is 2048bit, and `nonRepudiation` (contentCommitment) is set in `keyUsage` (mandatory bits and strict key length values are finalized in the profile specification, `Unverified Items`).
- [ ] **1a. Strict Adherence to the Same Leaf Certificate** — Subsequent chain construction, validity period checks, basic 4 attributes extraction, and issuance number passed to `jlis-yukousei-kakunin` must **all be performed against the identical DER of the leaf certificate** sent by the app. Do not mix different objects. If the leaf has `basicConstraints CA:TRUE`, has `keyCertSign` in `keyUsage`, or is self-signed, it fails (blocks attacks that make the leaf act as a CA).
- [ ] **2. Chain Construction** — Confirm that the `issuer` of `certificate` is a **perfect DER match** with the `subject` of the embedded Signature CA certificate (not a visual string comparison of the DN), and verify the signature of `certificate` using the public key of that Signature CA. Also confirm that the `authorityKeyIdentifier` (leaf) / `subjectKeyIdentifier` (CA) chain correctly. On the Signature CA certificate side, check that `basicConstraints` is `CA:TRUE` and `keyUsage` is `keyCertSign, cRLSign`. **The Signature CA is a 1-tier self-signed root** (no intermediate CA), and multiple generations with staggered issuance periods exist in parallel (e.g., `signca01` / `signca02` / `signca03`). **Read the actual values of the validity period, issuer DN, and serial from the embedded `.cer`** (dates and DN strings copied in this skill are reference values and have not been primarily confirmed = `Unverified Items`). **Embed all generations valid at the time of verification, and track generation updates.** When embedding/updating, pin-check that the fingerprint of the embedded **Signature CA certificate (`.cer`)** matches the published Signature CA fingerprint (`sign_fingerprint.pdf` / stated items PDF) (do not compare it with the leaf certificate sent by the app). (Verification should be done using SHA-256, or SHA-256 of the entire certificate DER/SPKI, do not pass with SHA-1 match only).
- [ ] **3. Validity Period** — Check that `notBefore` ≤ verification time ≤ `notAfter` for all certificates in the chain (`certificate` and Signature CA certificate). The validity period of the signature digital certificate is until the 5th birthday after issuance (max approx. 5 years), but confirm the exact rule in the primary specification (`Unverified Items`). Even if within the validity period, it may have been revoked, so passing this does not mean it is judged as "valid" (see below).
- [ ] **4. Nonce Matching** — The server reconstructs the data-to-be-signed in Step 1 from the nonce saved for the session (it does not extract the nonce from the client input). **Checking and consuming the nonce must be done in a single atomic operation** (execute "if unconsumed and within TTL, mark as consumed" via a single conditional UPDATE / compare-and-set statement, and proceed only if the updated count is 1). Using a two-step "check if unconsumed → later update to consumed" allows two requests arriving concurrently (e.g., separate Idempotency-Keys) to both pass the check (TOCTOU). **This consumption must happen before the signature verification in Step 1, and the nonce remains consumed even if subsequent verifications fail** (do not allow retries with a failed nonce. Retries require a new nonce). No live nonce, TTL expired, or already consumed are failures. This prevents replay/relay attacks. See `ekyc-session-orchestration` for nonce issuance and session state transition design.
- [ ] **5. 4 Attributes Matching** — Extract the name, address, date of birth, and sex (basic 4 information) from the subject of the `certificate`, and match them with the values entered by the user in the application form. A simple exact match will often fail due to notation variations, so compare after normalizing as described in "Absorbing Notation Variations" below. Absorb format differences (Japanese/Gregorian calendar, separators) for the date of birth and compare as dates. Normalize sex to a code value. Compare name and address after normalization, and automatically reject (send to visual review) if below the threshold.

## Apply the Same Verification to User Authentication Digital Certificates (Person Authentication / Login)

For `{ signature, certificate: User Authentication Digital Certificate (DER) }` received upon login via `jpki-ap-riyousha`, apply Steps 1-4 **exactly as they are**. The only differences are:

- **The trust anchor is the User Authentication CA.** It is a different self-signed CA from the Signature CA, and its generations exist separately. Embed and pin `.cer` files of all active generations of the User Authentication CA separately, and perform the chain construction in Step 2 against them (Do not mix the two CAs into a single trust store. This prevents a signature certificate being used for login, or a user authentication certificate for identity verification). Publication locations and filenames are `Unverified Items`.
- **Merely verifying the signature with the public key in the certificate proves nothing.** An attacker could create a self-signed certificate containing the victim's issuance number (which is not secret) and sign the nonce with their own key. **Skipping chain verification (Step 2) results in account takeover.**
- `keyUsage` is `digitalSignature` (not `nonRepudiation`. Exact values finalized in profile specification = `Unverified Items`).
- There is no Step 5 (4 attributes matching) (User Authentication Digital Certificates do not contain basic 4 information). Instead, check for a match with the **pair of (issuer DER, issuance number)** saved in the account (see "Identification by Issuance Number" in `jpki-ap-riyousha`).
- Validity confirmation (`jlis-yukousei-kakunin`) is performed every time they log in.

## Absorbing Notation Variations

The notation in the certificate subject and the user input will have character/format variations even for the same person. Matching logic should fundamentally "compare after normalizing," handling the following classes of variations.

### External Characters / Old Character Forms / Variant Characters

The names and addresses in the Basic Resident Register use external characters, old character forms, and variant characters not found in standard Kanji (e.g., "高/髙", "崎/﨑/嵜", "島/嶋", "鉄/鐵", "徳/德", "瀬/瀨"). The certificate side contains these external characters, while user input is often in standard Kanji. **Normalizing via a standard Kanji ⇔ external character mapping table (mapping DB) before comparison** is standard practice. LIQUID states they "possess a standard Kanji / external character database of **over 1,500 characters** to absorb variations, continuously expanded through feedback from financial institutions" (Description in LIQUID's vendor material. The number is the company's claim and not a public specification. `references/pdfs/33_guide-liquid-ekyc.pdf` p17–18). Even if built in-house, Unicode normalization (NFKC, etc.) alone is insufficient, and a proprietary variant character mapping is required.

### Address Normalization

Normalize address notations such as chome, banchi, and go by deletion and hyphen conversion before comparison. Rules cited in `references/pdfs/33_guide-liquid-ekyc.pdf` p18 "Know-how for absorbing notation variations (Address notation examples)" (**An example. Order is specified. Showing ⑥ onwards**):

- ⑥ Convert "番地の" (banchi no) and "番の" (ban no) to half-width hyphen "-"
- ⑦ Convert "丁目" (chome) and "番地" (banchi) to half-width hyphen "-" (execute after ⑥)
- ⑧ Convert "番" (ban) to half-width hyphen "-" (execute after ⑥⑦)
- ⑨ Delete all "号室" (go shitsu)
- ⑩ Delete all "号" (go) (execute after ⑨)
- ⑪ Delete all "大字" (Oaza) and "小字" (Koaza)
- ⑫ Delete all "字" (Aza) (execute after ⑪)
- ⑬ Convert "の" (no) to half-width hyphen "-" (execute after ⑥)
- ⑭ Convert "棟" (to) to half-width hyphen "-"
- ⑮ Convert "条" (jo) to half-width hyphen "-"

These are **excerpts of LIQUID's normalization know-how**, not public normalization specifications (company material p18. For ①-⑤, refer to the relevant section of the material). Additionally, full-width/half-width, Kanji numerals/Arabic numerals, presence of prefectures, and handling of building names/room numbers are also targets for absorption. In in-house implementations, fix the order of rule application and pass both the certificate side and input side through the same normalization.

### Former Surname (Old Surname)

The signature digital certificate can include a **former surname** alongside the current one if the person wishes. There are cases where the user applies using their former surname while the certificate has their current surname (or vice versa), so if the certificate has a former surname field, treat both the current and former surnames as candidates for matching.

### Furigana (Kana Name)

In conjunction with the system to record furigana in the family register, furigana (Kana name) for the name was added to the signature digital certificate (around May 2026. Exact timing and storage format are `unverified` in primary materials). When the Kana name can be obtained, it can be used as a supplementary matching key to compensate for Kanji notation variations. Compare after passing through normalization of half-width/full-width Kana, prolonged sound marks, and voiced sound marks.

### Common Names / Moving Abroad, etc.

Certificates may contain indications like "Moved abroad" or "Scheduled move abroad date" (`references/jpki-introduction.ja.md` §5, feature expansion materials). Rather than matching itself, handle these on the revocation/validity judgment side.

## "Cryptographically Correct" ≠ "Valid"

Even if 1-5 above all pass, it only determines that "this signature was correctly created for this data containing this nonce, using the key of this certificate." **Whether the certificate is currently valid (not revoked even if within the validity period) is a separate matter.**

- Signature digital certificates are revoked due to expiration, as well as **changes in basic 4 information (moving, marriage, etc.), death, moving abroad**, etc. (`jpki-overview` / `references/jpki-introduction.ja.md` §5.1). It is common for them to be already revoked even within the validity period.
- Validity must be confirmed against revocation information (CRL method / OCSP responder method). **This query must ONLY be performed via a Platform Operator certified by the competent minister. Do not query J-LIS directly from the app or an uncertified in-house server** (`jpki-overview` "Architecture Consideration Checklist").
- Therefore, after successful verification in this skill, you must execute `jlis-yukousei-kakunin` (validity confirmation via Platform Operator), and only when that result is obtained can it be considered a "valid digital signature". Divide the session states as well: `verifying` → `validity_checked` → `completed`.

## What to Retain / Not Retain After Verification

While this endpoint receives the customer's signature digital certificate (DER) and digital signature value, **in normal identity verification, only save the minimum: verification result ID, issuance number (certificate serial), and basic 4 information used for matching. Discard the certificate DER and public key themselves** (consistent with the non-retention policy in `ios-security` / `jlis-yukousei-kakunin` / `doui-jouhou-kanri`).

However, there are exceptions. **When conducting transaction verification using Method Ka under the Act on Prevention of Transfer of Criminal Proceeds (New Nu after April 2027)**, the Enforcement Regulations require attaching and preserving "electromagnetic records sufficient to prove that identity verification matters were verified by the said method" (in practice, the digital signature and signature digital certificate) to the verification records. **Design this evidence store under the Act separately from the normal data/consent information above (10 years, non-retention in `doui-jouhou-kanri`), as their purposes differ.** For the relevant designation items, article numbers, retention years (7 years), and start dates, see "Creation and Preservation of Verification Records" in `honnin-kakunin-houhou`; they are not asserted in this skill.

## Sources

PDFs under `references/pdfs/` are third-party works and are not shipped with the plugin. If a file is missing, run `bash references/refresh.sh` to download it (URLs and SHA256 are in `references/sources.md`).

- `references/pdfs/07_types-of-electronic-certificate.pdf` (Properties and recorded data of Signature Digital Certificates / User Authentication Digital Certificates. Signature one records basic 4 information (name, address, date of birth, sex). Flow of tamper detection and validity querying using public key cryptography)
- `references/pdfs/33_guide-liquid-ekyc.pdf` p17–18 (LIQUID eKYC Solution. Name/address match determination, external character absorption, company's claim of a DB with 1,500+ standard Kanji/external characters, address notation normalization rules ⑥-⑮, "identity information match" and "expiration date check" in auto-review items) *Vendor material. Numbers/rules are not public specifications.
- `references/jpki-introduction.ja.md` (§5 Authentication mechanism. Issuer as trust anchor, what is digital certificate validity, revocation conditions, CRL provision method / OCSP responder method, Article 3 of the Act on Electronic Signatures and Certification Business (Presumption of authentic establishment))
- <https://www.jpki.go.jp/ca/ca_rules3.html> (Information on Signature CA operation. Self-signed certificates `signca01.cer` (2015-2025) / `signca02.cer` (2019-2029) / `signca03.cer` (2023-2033), stated items `sign_ca03.pdf`, fingerprints `sign_fingerprint.pdf`, Signature CA Certification Practice Statement `sign_cps.pdf`. Retrieved 2026-09-08)
- <https://www.jpki.go.jp/ca/pdf/sign_fingerprint.pdf> (Signature CA self-signed certificate fingerprints (SHA-1 / SHA-256). Target for pin checks. Retrieved 2026-09-08)
- <https://www.jpki.go.jp/ca/pdf/sign_ca03.pdf> (Stated items of Signature CA self-signed certificate. `sha256RSA`, `basicConstraints CA:TRUE / PathLenConstraint NULL`, `keyUsage keyCertSign, cRLSign`, issuer=subject (self-signed), validity period, Subject Alternative Name "Public Personal Authentication Service Signature / Japan Agency for Local Authority Information Systems". Retrieved 2026-09-08)
- <https://www.jpki.go.jp/ca/pdf/sign_cps.pdf> (Public Personal Authentication Service Signature CA Certification Practice Statement Version 3.3, May 26, 2026. RFC 3647 compliant CP/CPS. Retrieved 2026-09-08)
- <https://www.digital.go.jp/policies/mynumber/private-business/jpki-introduction> (Digital Agency "Public Personal Authentication Service (JPKI)". §5 Authentication mechanism, validity confirmation method, types of digital certificates, feature expansion. Retrieved 2026-09-08)

## Last Verified: 2026-09-11

## Unverified Items

- **`certificatePolicies` policy OID of Signature Digital Certificate (End Entity).** Searches suggest that based on the Public Personal Authentication Service Profile Specification (`https://www.j-lis.go.jp/file/13_profile_genkou.pdf` Version 3.2, March 31, 2026), the policy OID for signature personal certificates is in the `1.2.392.200149.8.5.1.1` series (e.g., `1.2.392.200149.8.5.1.1.40` for mobile phone loading), but the PDF could not be retrieved directly (403), so primary confirmation is pending. Must be finalized with the Profile Specification (Japan Agency for Local Authority Information Systems).
- **The Signature CA's self-signed certificates are publicly available at jpki.go.jp/ca (`signca01/02/03.cer`, stated items/fingerprint PDFs).** However, the complete profile of the end entity certificate (each RDN of subject DN, attribute OIDs and encodings of basic 4 information (name, address, date of birth, sex, former surname, kana name), position of `serialNumber` = issuance number) must be confirmed in the Profile Specification. This skill keeps descriptions at the "recorded data" level of PDF 07.
- **Current specification of signature algorithm and key length** (Whether strictly RSA-2048 / PKCS#1 v1.5 / SHA-256, or if other methods are supported). `unverified` as in `jpki-ap-shomei`.
- **Exact rules for the validity period of the signature digital certificate** (whether it's "until the 5th birthday after issuance" or a maximum number of days). Must be confirmed with primary specifications.
- **Timing of certificate addition and storage format for Kana name (furigana).** Understood to be around May 2026, but primary materials unverified.
- **Details of DigestInfo** (inner SEQUENCE length, etc.) share `unverified items` with the app side `jpki-ap-shomei`. The server's data-to-be-signed construction must also be consistent with this.
- For the specific Platform Operator interface for validity confirmation (CRL/OCSP), see `jlis-yukousei-kakunin`.
- **Publication location, filenames, and generations of the User Authentication CA's self-signed certificates** (equivalent to `signca01/02/03.cer` for signatures) and the strict value of `keyUsage` for user authentication digital certificates. Must be finalized with jpki.go.jp/ca and the Profile Specification.
- Actual values for the Signature CA certificate's validity period, issuer DN, and serial (reference values copied in Step 2 have not been primarily confirmed). Read them from the embedded `.cer`.
