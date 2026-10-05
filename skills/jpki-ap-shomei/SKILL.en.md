---
name: jpki-ap-shomei
description: Used when implementing My Number Card signing certificate reading and JPKI electronic signature generation on iOS. Covers SELECT of JPKI-AP, VERIFY of signing PIN (6-16 alphanumeric characters), signing with COMPUTE DIGITAL SIGNATURE (the app displays the main text of the server-assembled to-be-signed data and computes the hash itself = WYSIWYS), READ of signing certificate EF (DER), and transmission of signature and certificate to the server. Ka-method iOS implementation. Lock/remaining count UX, server-side signature verification/validity check are out of scope.
---

# Using Signing Keys and Certificates with JPKI-AP (Signature Generation)

A procedural reference from **generating an electronic signature with the signing private key** in the `JPKI-AP` of a My Number Card, to **reading the signing certificate (DER)**, and passing them to the server. Signature verification and J-LIS validity verification are performed on the server side (out of scope of this skill).

Method names under the Act on Prevention of Transfer of Criminal Proceeds (Ka-method, etc.) and application timing are not defined here. See `honnin-kakunin-houhou` / `references/method-map.md` for details.

## When to Use This Skill

- When writing iOS implementation to read the signing certificate and generate a JPKI electronic signature
- When checking the APDU (CLA INS P1 P2) and input data format of `COMPUTE DIGITAL SIGNATURE`
- When implementing the VERIFY of the signing PIN (6 to 16 alphanumeric characters) and reading the remaining trial count via SW
- When confirming the division of responsibilities between what is passed to the server (signature value, certificate DER) and what the server prepares (data to be signed)

For lock/remaining count UX, see `pin-lock-handling`. For server-side signature verification, see `signature-verification`. For certificate validity verification, see `jlis-yukousei-kakunin`. For CoreNFC session establishment and APDU transmission/reception, see `ios-corenfc-apdu`.

## Prerequisites

- `ios-corenfc-apdu` must be completed (establishment of `NFCTagReaderSession`, `connect` to `NFCISO7816Tag`, APDU transmission/reception using `sendCommand`, segmented READ exceeding 256 bytes, and AID listing in `select-identifiers` of `Info.plist`).
- Use only the APDU byte arrays in the recorded formats in `references/apdu-cheatsheet.md`. Verify items marked `未確認` (unverified) there before implementation.
- **The data to be signed (to-be-signed) is assembled by the server.** The server creates the to-be-signed data from the main text + the nonce for each session. The app does not issue the nonce.
- **Default: The app receives the to-be-signed data, displays the main text, and calculates the hash itself (WYSIWYS).** Because an electronic signature using a signing key is a heavy signature that may be subject to the presumption of authenticity under Article 3 of the Electronic Signatures Act, do not blindly sign an "opaque hash" sent from the server.
  1. The app receives the to-be-signed byte array (canonical format including the main text and nonce) for that session from the in-house eKYC session API (TLS, pinning policy of `ios-security`).
  2. The app extracts the main text from the to-be-signed data and displays it on the screen, proceeding to the PIN input only after the user confirms the content.
  3. The app calculates the hash itself using `SHA256.hash(data: toBeSigned)` (CryptoKit), and puts it into the DigestInfo in step 5.
  - Do not sign hashes or data arriving from routes outside that session (push notifications, URL schemes, other apps, WebViews, etc.).
  - Configurations where the server can only return raw hashes are treated as exceptions, and even in that case, the main text must always be displayed. For server-side assembly, see `ekyc-session-orchestration` / `signature-verification`.
- The signature algorithm is RSA-2048 / PKCS#1 v1.5 / SHA-256 (`Unverified`: current specification / support for other hashes requires verification. `apdu-cheatsheet.md`). Padding is performed inside the card.

## Signature Generation Procedure

Send the following sequentially within a single session. Abort if the response SW for any step is not `90 00`.

- [ ] **1. SELECT JPKI-AP** — `00 A4 04 0C 0A D3 92 F0 00 26 01 00 00 00 01` (AID matches across 3 sources: tex2e, moritamori, kopaneet). If `6A 82`, review the AID / `select-identifiers` in `Info.plist`.
- [ ] **2. SELECT the EF for signing PIN** — `00 A4 02 0C 02 00 1B` (EF-ID is from tex2e).
- [ ] **3. VERIFY the PIN** — `00 20 00 80` + ASCII byte array of the PIN (keyref P2=`80` matches across 3 sources). 6 to 16 alphanumeric characters (length matches between zenn.dev/trustdock and tex2e). Check the response SW:
  - `90 00`: Verification successful.
  - `63 CX`: Mismatch. The lower nibble `X` is the remaining trial count (ISO/IEC 7816-4 standard value. Primary source for JPKI specifics is `Unverified`). **Do not auto-retry.** Delegate presenting the remaining count, warning before lock, and unlocking flow at lock to `pin-lock-handling`.
  - `69 83`: Locked. See `pin-lock-handling`.
- [ ] **4. SELECT the EF for signing private key** — `00 A4 02 0C 02 00 1A` (EF-ID is from tex2e. MSE / Manage Security Environment is not in tex2e's procedure. `Unverified`).
- [ ] **5. COMPUTE DIGITAL SIGNATURE** — `80 2A 00 80` + DigestInfo (DER) built from the SHA-256 hash that the app computed from the to-be-signed data (item 3 of "Prerequisites"). In tex2e's implementation example, the 32-byte hash is appended to the SHA-256 DigestInfo prefix (RFC 8017 compliant) `30 31 30 0D 06 09 60 86 48 01 65 03 04 02 01 05 00 04 20`, and sent with Lc=`33` (0x33 = 51 = prefix 19 + hash 32) (`using DigestInfo as input is from tex2e only, 1 source, requires verification`). The response data is the RSA-2048 signature value (256 bytes, requires verification), and the trailing SW is `90 00`.

```swift
extension CardReader {
    // Steps 2-3: SELECT the EF for signing PIN, then VERIFY. Return the SW to the caller,
    // and delegate retries to pin-lock-handling (VerifyOutcome / pinBytes / interpret are defined there)
    func verifyShomeiPIN(_ pin: String, tag: NFCISO7816Tag) async throws -> VerifyOutcome {
        // The signing PIN is "uppercase letters + digits, 6-16 characters". Convert full-width to half-width,
        // uppercase, and check the format before sending to the card (violations throw and do not consume a try)
        let bytes = try pinBytes(pin, kind: .shomei)
        try await selectEF(efID: [0x00, 0x1B], tag: tag)   // Step 2: Signing PIN EF (00 A4 02 0C 02 00 1B)
        let apdu = rawAPDU([0x00, 0x20, 0x00, 0x80, UInt8(bytes.count)] + bytes)
        let (_, sw1, sw2) = try await send(apdu, to: tag)
        return interpret(sw1: sw1, sw2: sw2)                // pin-lock-handling
    }

    // Steps 4-5: SELECT the EF for signing private key, then compute the signature by attaching
    // DigestInfo to the SHA-256 hash (32B). hash is calculated by the app itself from to-be-signed:
    //   let hash = Data(SHA256.hash(data: toBeSigned))   // import CryptoKit
    func computeSignature(sha256 hash: Data, tag: NFCISO7816Tag) async throws -> Data {
        guard hash.count == 32 else { throw ReaderError.invalidInput }   // do not crash in production
        try await selectEF(efID: [0x00, 0x1A], tag: tag)   // Step 4: Signing private key EF (00 A4 02 0C 02 00 1A)
        // SHA-256 DigestInfo prefix from RFC 8017 (PKCS#1 v1.5). The inner SEQUENCE length is
        // 0x0D (OID 11B + NULL 2B). If tex2e's article writes 0x0B, it is likely a typo (unverified)
        let digestInfoPrefix: [UInt8] = [
            0x30, 0x31, 0x30, 0x0D, 0x06, 0x09, 0x60, 0x86, 0x48, 0x01,
            0x65, 0x03, 0x04, 0x02, 0x01, 0x05, 0x00, 0x04, 0x20,
        ]
        let digestInfo = digestInfoPrefix + Array(hash)     // Total length 0x33 = 51 bytes
        let apdu = rawAPDU([0x80, 0x2A, 0x00, 0x80, UInt8(digestInfo.count)] + digestInfo + [0x00])
        let (sig, sw1, sw2) = try await send(apdu, to: tag)
        guard sw1 == 0x90, sw2 == 0x00 else { throw ReaderError.signFailed(sw1, sw2) }
        return sig                                          // RSA-2048 signature value (256 bytes)
    }
}
```

## Reading the Certificate

The signing certificate is a DER (over 1 KB for RSA-2048), so it must be read using segmented READ.

1. **SELECT the EF for signing certificate** — `00 A4 02 0C 02 00 01` (EF-ID is from tex2e).
2. **READ BINARY the head** — `00 B0 00 00`. Determine the total DER length from the length field (long form) immediately following the ASN.1 SEQUENCE tag at the head of the response.
3. **Advance the offset and READ the rest** — Repeat `00 B0 <offset high> <offset low>` until the total length is reached (use the segmented read from `ios-corenfc-apdu`).

```swift
extension CardReader {
    func readShomeiCertificate(tag: NFCISO7816Tag) async throws -> Data {
        try await selectEF(efID: [0x00, 0x01], tag: tag)    // 00 A4 02 0C 02 00 01
        let der = try await readSelectedTLV(tag: tag)        // ios-corenfc-apdu: segmented READ up to the total length in the DER header
        return der                                           // Do not retain as DER (discard after server transmission)
    }
}
```

The exact termination conditions (`61 xx` / `6C xx` presence, maximum length per EF) for reading over 256 bytes with READ BINARY are `Unverified`. Follow the notes in `ios-corenfc-apdu`.

> Note: Depending on the implementation, there are reports that VERIFY of the **user-authentication (4-digit) PIN** is required before READing the signing certificate (EF `00 01`) (`Unverified Items`). If `63 CX` / `69 82` (security status not satisfied) is returned, question this premise.

## Passing to the Server

- The app sends to the server **`{ signature: signature value, certificate: signing certificate (DER) }`** and an identifier indicating which signature target data it corresponds to (like a session ID issued by the server prior to the procedure).
- What the server does (the app does not):
  - Reconstruct the data to be signed (main text + nonce), and verify the signature using the public key in the certificate → `signature-verification`.
  - Check the validity and revocation of the electronic certificate with J-LIS via the PF operator → `jlis-yukousei-kakunin`.
- Once transmission is complete, discard all signature values, certificates, hashes, and PIN inputs on the device. When retrying, acquire them from the card again.

## Things You Must Not Do

- **Use the PIN only for VERIFY to the card.** Do not send it to servers, analytics SDKs, or pasteboards, and do not save it in Keychain (including biometrically protected "remember PIN"), UserDefaults, logs, or crash reports. Keep it minimal in memory as well, and discard immediately after VERIFY.
- **Do not verify the signature locally on the device.** Certificate chain verification, revocation checks, and validity verification are the responsibility of the server (via the PF operator). Do not inquire directly with J-LIS from the app.
- **Do not generate the nonce for signing within the app.** Always sign the to-be-signed data issued by the server.
- **Do not sign without displaying the main text. Do not sign the hash sent from the server without verification.** The hash is calculated by the app from the to-be-signed data (see "Prerequisites").
- **Do not retain data read from the card (certificate DER, signature value, private key information) beyond the scope of the request.**
- **Do not automatically retry on `63 CX`.** This risks reaching the lock limit. For UX, see `pin-lock-handling`.
- Do not determine the method names or enforcement timing of the Act on Prevention of Transfer of Criminal Proceeds in this skill (`honnin-kakunin-houhou` / `references/method-map.md`).

## Sources

- <https://tex2e.github.io/blog/protocol/jpki-mynumbercard-with-apdu> ("Creating signature data with My Number Card and APDU" — JPKI-AP AID, SELECT `00 A4 04 0C` / `00 A4 02 0C`, signing private key EF `00 1A` / PIN EF `00 1B` / certificate EF `00 01`, VERIFY `00 20 00 80`, COMPUTE DIGITAL SIGNATURE `80 2A 00 80` and SHA-256 DigestInfo (Lc=`33`), `SHA256withRSA` / PKCS#1 v1.5, segmented READ of certificate. Retrieved on 2026-09-08)
- `references/apdu-cheatsheet.md` (Byte arrays for AID, SELECT / VERIFY / READ BINARY / COMPUTE DIGITAL SIGNATURE and their certainty, SW1SW2, PIN length)
- <https://zenn.dev/trustdock/articles/66a228895294bc> (TrustDock "Introduction to Public Personal Authentication (JPKI)" — NFC Type-B, ISO 7816 APDU, signing PIN 6-16 alphanumeric chars, locks after 5 failures. Retrieved on 2026-09-08)
- <https://www.jpki.go.jp/procedure/password.html> (J-LIS "Public Personal Authentication Service Portal Site" — Password for signing certificate (6 to 16 alphanumeric characters) locks upon 5 consecutive incorrect attempts. Retrieved on 2026-09-08)

## Last Verified

2026-09-11

## Unverified Items

- Input format for `COMPUTE DIGITAL SIGNATURE` (DigestInfo or raw hash, need for padding). tex2e shows a specific byte array (SHA-256 prefix + 32B, Lc=`33`) but it remains a single source. Verify before implementation.
- Inner SEQUENCE length of the DigestInfo prefix. This skill adopts RFC 8017 compliant `30 0D` (OID 11B + NULL 2B). If tex2e's article writes `30 0B`, it is likely a typo (the outer `30 31` and Lc=`33` are consistent with the length including NULL). Requires confirmation with actual cards / official specs.
- Necessity of preprocessing such as MSE (Manage Security Environment) before signing. Not in tex2e's procedure.
- Current specifications of the signature algorithm (RSA-2048 / PKCS#1 v1.5 / SHA-256), and support for other hashes/key lengths.
- EF-IDs for signing private key EF `00 1A`, PIN EF `00 1B`, and certificate EF `00 01` (tex2e is a single source).
- Whether the lower nibble of `63 CX` is the remaining trial count, and whether `69 83` means locked (ISO/IEC 7816-4 standard values. Primary sources for JPKI specifics are `Unverified`). The 5-time failure lock limit for signing has been confirmed on J-LIS `jpki.go.jp` (`pin-lock-handling` / `apdu-cheatsheet.md`).
- Termination conditions and maximum read length when reading the certificate EF (over 256 bytes) using READ BINARY.
- **Whether VERIFY of the user-authentication (4-digit) PIN is required beforehand to READ the signing certificate (EF `00 01`).** Several implementations report that "reading the signing certificate requires the user-authentication password" (the user-authentication certificate in `jpki-ap-riyousha` does not require a PIN). If necessary, the design will require two types of PIN input throughout the flow. Requires verification with actual cards / official specs.
