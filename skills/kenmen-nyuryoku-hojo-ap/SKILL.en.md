---
name: kenmen-nyuryoku-hojo-ap
description: Used in iOS implementation to acquire the four basic attributes (name, address, date of birth, sex) as text from the card-face input-assist application. Intended for He-method IC reading (IC reading + facial image capture). Assumes using 6-digit date of birth + 4-digit expiration year (Gregorian) + 4-digit security code written on the card face as unlocking information, but which keyref/EF/formatting these 14 digits correspond to is unverified as it is not in the public specifications (public examples only show 4-digit PIN). Reads the four basic attributes via READ BINARY. This AP is read-only and does not sign. Reading Individual Number, facial image matching, and Ka-method (JPKI signature) are out of scope. The IC facial image required by the He-method text is not in this AP and is acquired by the card-face verification application (kenmen-jikou-kakunin-ap).
---

# Retrieving the 4 Basic Attributes as Text with the Card-Face Input-Assist Application

A procedural reference for **reading the four basic attributes (name, address, date of birth, sex) as text via READ BINARY** from the `card-face input-assist application` of a My Number Card. This is for the He-method (IC reading + facial image capture), used in combination with card-face capture and facial image capture. **This AP does not have an electronic signature function.** Because there is no cryptographic proof of authenticity, the He-method relies on server-side facial image matching (combined with captured facial image) to ensure identity (matching is the server's responsibility. Out of scope of this skill).

Method names such as the Act on Prevention of Transfer of Criminal Proceeds (He-method, Ka-method, etc.) and application timing are not defined here. See `honnin-kakunin-houhou` / `references/method-map.md` for details.

## When to Use This Skill

- When writing iOS implementation to acquire the four basic attributes as text from the IC, in addition to card-face capture + facial image capture (He-method)
- When checking the APDU for SELECT, unlock, and READ BINARY of the four basic attributes for the card-face input-assist application
- When implementing a configuration where the user does not input a 4-digit PIN (unlocked with values written on the card face)

The Individual Number (My Number) is also in the same AP, but reading it requires different unlocking and legal basis under the Numbers Act → `kenmen-jikou-kakunin-ap`. For lock/remaining count UX, see `pin-lock-handling`. To verify authenticity via electronic signature, use the Ka-method → `jpki-ap-shomei`.

## Prerequisites

- `ios-corenfc-apdu` must be completed (establishment of `NFCTagReaderSession`, `connect` to `NFCISO7816Tag`, APDU transmission/reception using `sendCommand`, segmented READ exceeding 256 bytes, and AID listing in `select-identifiers` of `Info.plist`).
- Use only the APDU byte arrays in the recorded formats in `references/apdu-cheatsheet.md`. Verify items marked `未確認` (unverified) there before implementation. Do not assemble byte arrays by guessing.
- Keep the four basic attributes read from the card only in RAM, and discard them after transmission to the server (`ios-security`).

## Unlocking Information

In the He-method, the user transcribes and inputs **values written on the face of the physical card**. It is characterized by being unlockable even without memorizing the PIN (4 digits), leading to low drop-off rates for the He-method (`references/pdfs/33_guide-liquid-ekyc.pdf` p11. Vendor material).

| Element | Length | Remarks |
|---|---|---|
| Date of birth | 6 digits | Date of birth on the card face. Formatting into 6 digits (Gregorian/Japanese calendar, zero-padding, order) is `Unverified` |
| Expiration year | 4 digits | Expiration year in Gregorian calendar (e.g., `2030`). PDF 33 p11 notes "expiration year in 4 Gregorian digits" |
| Security code | 4 digits | 4 digits written on the card face |

Total of 14 digits. Send these 14 digits as unlocking information to VERIFY (PDF 33 p11). **The keyref (P2), Lc, target EF, and character formatting (whether ASCII concatenation or not, presence of delimiters) when sending 14 digits are absent from public sources and `Unverified`.** The tex2e example in the procedure below sends the 4-digit PIN for card-face input assistance, and might be a different path from the 14-digit unlock.

## Reading Procedure

Send the following sequentially within a single session. Abort if the response SW for any step is not `90 00`. The APDU is based on recorded values in `references/apdu-cheatsheet.md` and tex2e's implementation example (`(Requires verification)`).

- [ ] **1. SELECT the card-face input-assist application** — `00 A4 04 0C 0A D3 92 10 00 31 00 01 01 04 08` (AID matches across 2 sources: kopaneet and tex2e. `Unverified` in J-LIS primary materials). If `6A 82`, review the AID / `select-identifiers` in `Info.plist`.
- [ ] **2. SELECT the EF for the card-face input-assist PIN** — `00 A4 02 0C 02 00 11` (EF-ID is from 2 sources: tex2e and kopaneet. `(Requires verification)`).
- [ ] **3. VERIFY the unlocking information** — `00 20 00 80` + ASCII byte array of the unlocking information.
  - tex2e's example is a 4-digit PIN: `00 20 00 80 04 31 32 33 34` (`1234`. keyref P2=`80`).
  - **In the He-method, instead of a 4-digit PIN, you send the 14 digits written on the card face (date of birth 6 + expiration year 4 + security code 4)** (PDF 33 p11). The P2, Lc, and formatting for this case are `Unverified`.
  - SW: `90 00` success / `63 CX` mismatch, `X` attempts remaining (ISO/IEC 7816-4 standard value. Primary source for My Number Card specifics is `Unverified`) / `69 83` locked.
  - **Do not auto-retry.** Delegate presenting the remaining count, warning before lock, and unlocking flow to `pin-lock-handling`.
- [ ] **4. SELECT the EF for the basic 4 information file** — `00 A4 02 0C 02 00 02` (EF-ID is from 2 sources: tex2e and kopaneet. `(Requires verification)`).
- [ ] **5. READ BINARY the data length** — In tex2e's example, it reads only the length byte at the 3rd byte with `00 B0 00 02 01` (`(Only 1 source, requires verification: tex2e)`).
- [ ] **6. READ BINARY the body** — In tex2e's example, `00 B0 00 00 71`. The response is a TLV, where `DF 21` (Header) / `DF 22` (Name) / `DF 23` (Address) / `DF 24` (Date of Birth) / `DF 25` (Sex: 1 byte, `31`=Male `32`=Female `33`=Other) are lined up under `FF 20` (outer). Name and address are UTF-8. **The tags, lengths, total length, and termination conditions for this TLV are from tex2e only (1 source) and are `Unverified`. Do not parse by guessing.**

```swift
extension CardReader {
    // Step 3: VERIFY of unlocking information. The He-method passes 14 digits written on the card face.
    // Since keyref / Lc / formatting are unverified, replace with a confirmed byte array before using.
    // VerifyOutcome / PINKind / pinBytes / interpret are defined in pin-lock-handling.
    // kind: .kenmenHojo for the 4-digit PIN, .shogoB for the 14 digits written on the card face (He-method)
    func verifyKenmenUnlock(_ unlock: String, kind: PINKind, tag: NFCISO7816Tag) async throws -> VerifyOutcome {
        let bytes = try pinBytes(unlock, kind: kind)         // full-width to half-width, digit-count check (violations are not sent to the card)
        let apdu = rawAPDU([0x00, 0x20, 0x00, 0x80, UInt8(bytes.count)] + bytes)
        let (_, sw1, sw2) = try await send(apdu, to: tag)
        return interpret(sw1: sw1, sw2: sw2)                // pin-lock-handling
    }

    // Steps 4-6: Select and read the EF for the 4 basic attributes. Do not implement TLV parsing until formal specs are available.
    func readKihon4(tag: NFCISO7816Tag) async throws -> Data {
        try await selectEF(efID: [0x00, 0x02], tag: tag)     // 00 A4 02 0C 02 00 02 (Requires verification)
        // The body is at most 112 bytes (kopaneet), and some cards prepend 2 bytes before FF 20,
        // so do not derive the total length from the TLV header. Request 256 bytes in one READ and use what comes back with 62 82 (end of file).
        // readBinary throws on anything other than 90 00 / 62 82 (ios-corenfc-apdu)
        let raw = try await readBinary(offset: 0, length: 256, tag: tag)
        return raw   // TLV (FF20 / DF21..DF25). Tags/lengths are unverified. Name/Address are UTF-8
    }
}
```

- There are reports that cards issued around 2023 have an extra 2 bytes prefixed to the response (before `FF 20`) (tex2e addendum, `ny-a`'s fix). Do not hardcode the header position with fixed offsets.
- The body length is stated to be a maximum of 112 bytes (kopaneet). However, exhaustive coverage of EF layouts, such as versions including images of external characters, is `Unverified`.

## Distinguishing from the Ka-method

| | He-method (this skill) | Ka-method |
|---|---|---|
| AP to use | Card-face input-assist application | JPKI-AP / Signing (`jpki-ap-shomei`) |
| Unlocking | Date of birth 6 + Expiration year 4 + Security code 4 written on card face (14 digits) | Signing PIN (6-16 alphanumeric digits) |
| Acquired data | Text of 4 basic attributes (+ Captured facial image / IC facial image) | Signing certificate (DER) + Electronic signature value by private key |
| Authenticity assurance | No cryptographic proof → Combination with server-side facial image matching | Verification of electronic signature + Validity verification of certificate (`signature-verification` / `jlis-yukousei-kakunin`) |
| Signing | None (read only) | Performed |

Method names, item designations, and application timings are not defined. See `honnin-kakunin-houhou` / `references/method-map.md`.

## Things You Must Not Do

- **Do not save the PIN / unlocking information.** Keep it minimal in memory and discard it after VERIFY. Do not leave it in Keychain, UserDefaults, logs, or crash reports.
- **Do not automatically retry on `63 CX`.** This risks lock out. For UX, see `pin-lock-handling`.
- **Do not guess-parse the TLV.** Do not implement fixed parsing while tags, lengths, and total length remain `Unverified`.
- **Do not read the Individual Number as an aside with this AP.** It requires legal basis under the Numbers Act and different unlocking (`kenmen-jikou-kakunin-ap`).
- **Do not perform facial image matching / identity determination on the device side.** Matching against the captured facial image is done on the server side. Do not inquire directly with J-LIS.
- Do not determine the method names or enforcement timing of the Act on Prevention of Transfer of Criminal Proceeds in this skill (`honnin-kakunin-houhou` / `references/method-map.md`).

## Sources

PDFs under `references/pdfs/` are third-party works and are not shipped with the plugin. If a file is missing, run `bash references/refresh.sh` to download it (URLs and SHA256 are in `references/sources.md`).

- `references/apdu-cheatsheet.md` (AID for card-face input-assist application, EF-IDs (`00 11` / `00 02` / `00 01`), Byte arrays for SELECT / VERIFY / READ BINARY and their certainty, SW1SW2, lock counts)
- `references/pdfs/33_guide-liquid-ekyc.pdf` p11 (Information on LIQUID eKYC IC Chip Method Version — Explanation of the He-method, Authentication information for My Number Card = "Date of birth 6 digits + Expiration year in 4 Gregorian digits + Security code 4 digits", Main acquired data = Name / Date of birth / Address / Sex, IC facial image, captured facial image, lock count stated as "10 times" = this is the limit for the 14-digit Verification Number B (card-face verification application) and differs from the 3 times for the 4-digit PIN. Vendor material. Retrieved on 2026-09-08)
- <https://zenn.dev/trustdock/articles/66a228895294bc> (TrustDock "Introduction to Public Personal Authentication (JPKI)" — Card-face items input-assist AP reads the 4 basic attributes and My Number as text, accesses with a 4-digit numeric PIN, locks after 3 consecutive failures. Retrieved on 2026-09-08)
- <https://www.kojinbango-card.go.jp/faq_pin2/> (My Number Card General Site FAQ "What is the PIN for the card-face items input-assist app?" — 4 digits, locks on 3 incorrect inputs, reset at municipality. Retrieved on 2026-09-08)
- <https://services.digital.go.jp/mynumbercard/info-passcode/> (Digital Agency "PIN for input assistance of My Number Card's card-face items" — 4 digits, locks at 3 times. The inquiry number for reading the card-face AP is 14 digits, and making 10 consecutive incorrect attempts locks the card. Retrieved on 2026-09-08)
- <https://tex2e.github.io/blog/protocol/jpki-mynumbercard-with-apdu> ("Creating signature data with My Number Card and APDU" — Card-face input-assist AP DF Name `D3 92 10 00 31 00 01 01 04 08`, SELECT `00 A4 04 0C` / `00 A4 02 0C`, card-face input-assist PIN EF `00 11`, 4 basic attributes EF `00 02`, VERIFY `00 20 00 80 04 31 32 33 34`, READ BINARY `00 B0 00 02 01` → `00 B0 00 00 71`, TLV `FF 20` / `DF 21` to `DF 25`, Sex `31`/`32`/`33`, Name/Address are UTF-8, prefix 2-byte correction for cards issued around 2023. Retrieved on 2026-09-08)
- <https://zenn.dev/kopaneet/articles/1ee74f87eb31d3> ("Acquiring 4 basic attributes from My Number Card" — Card-face input-assist AP AID `D3 92 10 00 31 00 01 01 04 08`, EF-IDs (4 basic attributes `00 02` / Individual Number `00 01` / Input-assist PIN `00 11`), order of SELECT/VERIFY/READ BINARY, body length is at the 3rd byte, max 112 bytes, UTF-8, locks after 3 consecutive failures. Retrieved on 2026-09-08)

## Last Verified

2026-09-11

## Unverified Items

- **Lock count.** The 4-digit PIN for card-face input assistance locks after 3 consecutive times (Confirmed: My Number Card General Site `kojinbango-card.go.jp`, MynaPortal FAQ, Digital Agency `services.digital.go.jp`. `references/apdu-cheatsheet.md`). The "10 times" in `references/pdfs/33_guide-liquid-ekyc.pdf` p11 is not the 4-digit PIN, but the lock limit for the 14-digit Verification Number B (card-face verification application) read with the values written on the card face (Confirmed: Digital Agency, Matsuyama City, PocketSign). **The 3 times for the 4-digit PIN and the 10 times for the 14-digit Verification Number B are different authentication credentials and not a contradiction.** The keyref for the 4-digit PIN unlocking parameter is unverified.
- **How to send the He-method unlocking information (14 digits).** Digit formatting for date of birth 6 + expiration year 4 + security code 4 (Gregorian/Japanese calendar, zero-padding, order), presence of delimiters when concatenated, keyref (P2), Lc, and target EF for VERIFY. Public sources only show examples of VERIFY for the 4-digit PIN.
- **AID `D3 92 10 00 31 00 01 01 04 08`.** Matches across 2 sources (kopaneet, tex2e), but both are personal blogs. Unverified in J-LIS technical specifications (NDA).
- **TLV layout for the 4 basic attributes.** `FF 20` outer, tags `DF 21` to `DF 25`, lengths, total length, READ termination conditions, and maximum length. tex2e is the only 1 source. Differences by issue year (extra prefix bytes, presence of external character images) also require verification.
- **EF-IDs (`00 11` / `00 02` / `00 01`) and VERIFY keyref.** From 2 sources (tex2e, kopaneet) but unverified in J-LIS primary materials.
- **Location of the 4-digit security code written on the card face** and its relation to the card-face input-assist PIN (4 digits).
