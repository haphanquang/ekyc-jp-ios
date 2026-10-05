---
name: kenmen-jikou-kakunin-ap
description: Used in iOS implementation to read the card surface images (front/back), IC chip face photo, and individual number (My Number, 12 digits) from the My Number Card's Card Surface Verification AP. The card surface verification inquiry number (DOB 6 digits + expiry year 4 digits + security code 4 digits) unlocks the front (4 attributes + face photo), and the 12-digit My Number unlocks both front and back (individual number). The face photo is a low-quality compressed image for server-side facial matching. Collecting and storing the individual number requires a legal basis under the Number Use Act (My Number Act); identity verification alone is not a sufficient basis. Includes notes on storage, deletion, and logging prohibition under the Number Use Act.
---

# Reading Card Surface Images, Face Photo, and Individual Number with Card Surface Verification AP

A procedure reference for reading **card surface images (front/back images)**, **IC chip face photo images**, and the **individual number (My Number)** from the My Number Card's `Card Surface Verification AP` (referred to as "Card Surface AP" in Digital Agency materials). The purpose is "detecting tampering of card surface information in face-to-face situations" and "using image information as evidence of identity verification" (Digital Agency "Overview of My Number Card Apps"). The read data has a J-LIS digital signature attached, allowing tamper detection.

**This skill does not perform facial matching on the device.** Matching the face photo and selfie is the responsibility of the server / facial matching component. Do not query J-LIS directly.

Method names (Method He, Method Ka, Method Ru, etc.), method designations, and enforcement dates under the Act on Prevention of Transfer of Criminal Proceeds are not asserted here. See `honnin-kakunin-houhou` / `references/method-map.md` for details.

## When to Use This Skill

- When writing an iOS app implementation to obtain the front/back card surface images and IC chip face photo from the Card Surface Verification AP
- When there is a requirement to read the individual number (My Number) from the card, and checking the permissibility and storage method under the Number Use Act
- When checking the APDU format for Card Surface Verification AP unlocking (inquiry number), SELECT, and READ BINARY

If you only want to retrieve the four basic attributes as **text**, use the `Card Surface Input Assistance AP` (`kenmen-nyuryoku-hojo-ap`). If verifying authenticity with a digital signature, use `jpki-ap-shomei`. For UX regarding locks and remaining attempts, see `pin-lock-handling`. For handling card data within the device (encryption, log prohibition, pinning), see `ios-security`.

## Prerequisites

- `ios-corenfc-apdu` must be completed (establishing `NFCTagReaderSession`, `connect` to `NFCISO7816Tag`, `sendCommand`, segmented READ over 256 bytes, AID listing in `select-identifiers` of `Info.plist`).
- Use only APDU byte sequences in the format recorded in `references/apdu-cheatsheet.md`. The AID, EF identifier, and unlock keyref for the Card Surface Verification AP are `unverified` in that file (the lock count of 10 for the 14-digit Inquiry Number B is verified). **Verify before implementation and do not construct byte sequences by guessing.**
- **Before reading the individual number, legal confirmation must be completed to ensure your company has a legal basis** (see "Notes on the Number Use Act" below). Without a basis, do not perform the unlock for the individual number; only read for card surface verification (front).

## 2 PINs and Retrieved Data

Digital Agency "Overview of My Number Card Apps" explains the access control of the Card Surface AP as an **inquiry number created from values printed on the card surface** (not a 4-digit PIN to remember). Depending on the material, it is also called "Card Surface Verification PIN" and "Individual Number PIN", but the digit count and whether it's a fixed PIN or inquiry number are `unverified` in primary J-LIS materials.

| Category | Value Used for Unlocking | Unlocked Data | Lock Count |
|---|---|---|---|
| Card Surface Verification (Front. Inquiry Number B) | DOB 6 digits + expiry year 4 digits + security code 4 digits (= values printed on card surface. Total 14 digits) | Front card surface image (4 attributes + face photo image), IC chip face photo image | 10 (Verified: Digital Agency `services.digital.go.jp`, Matsuyama City, PocketSign, etc., agree. `references/apdu-cheatsheet.md`) |
| Individual Number (Front + Back. Inquiry Number A) | My Number 12 digits | Above, plus back card surface image (individual number image), individual number | `unverified` (Highly likely to be 10 times, same as Inquiry Number B, but no primary source) |

- The 12-digit My Number is a mechanism intended for "correctness checks of manually entered individual numbers verified visually on the card surface" (Digital Agency material). The individual number side cannot be unlocked without the **premise of knowing the 12 digits**.
- The formatting of the 14 digits (Gregorian/Japanese calendar, zero-padding, order, presence of separators), VERIFY keyref (P2), Lc, and target EF are all `unverified`.

## Properties of the Face Photo

- The face photo in the IC chip is a **low-resolution compressed image**. It is not a high-definition photo for card printing, but a quality sufficient for server-side facial matching (1:1 matching with a selfie).
- It is **reported to be in JPEG2000 (grayscale/monochrome display) format** (`qiita.com/ribig` - 1 source only, needs verification). Treat it as a "compressed image (format needs verification)" and do not hardcode the decoder until the final specification is obtained.
- Facial matching itself is outside the scope of this skill. Do not perform matching or identity determination on the device side. Matching the captured selfie with the face photo is the server / facial matching component's job.

## Notes on the Number Use Act

The individual number (My Number) is **Specific Personal Information**. Stricter handling obligations apply than for general personal information (Personal Information Protection Commission "Guidelines for the Proper Handling of Specific Personal Information (For Business Operators)").

- [ ] **Confirm the basis for collection** — The administrative works that can use the individual number are exhaustively listed in the Number Use Act (areas of social security, tax, and disaster countermeasures). **eKYC identity verification itself is not a basis for collecting the individual number.** Perform legal checks on whether your company's administrative work falls under the appended table of the Number Use Act, and that use outside the intended purpose is prohibited even with the user's consent (the listed contents are not asserted in this skill).
- [ ] **Do not read the individual number without a basis** — Read only the card surface verification (front: 4 attributes + face photo), and **do not implement** unlocking for the individual number using the 12-digit My Number. Adopt an architecture that does not acquire the back image and individual number.
- [ ] **Do not leave in logs** — Do not output the individual number, face photo, and card surface image to app logs, access logs, crash reports, analytics events, or screenshots (`ios-security`).
- [ ] **Encrypt when storing** — Only when retention is necessary, perform encryption at rest, limit access scope (least privilege), and audit (`ios-security`).
- [ ] **Delete when the purpose is fulfilled** — Delete and discard without delay using an irrecoverable method when it is no longer necessary to use. Set a retention period.
- [ ] **Supervise contractors** — When outsourcing facial matching and storage to a third party, require the contractor to take security control measures equivalent to those the outsourcer must fulfill.
- [ ] **Security control measures** — Implement measures to prevent leakage, loss, or damage of Specific Personal Information, and limit and educate personnel handling it.

## Reading Procedure

Send sequentially within 1 session. Interrupt if any response SW is not `90 00`. **The AID, EF identifier, and unlock keyref of the Card Surface Verification AP have not been confirmed in public sources, and the following are all `unverified`.** Follow the confidence table in `references/apdu-cheatsheet.md` and implement after replacing with confirmed values.

- [ ] **1. SELECT Card Surface Verification AP** — `00 A4 04 0C <Lc> <AID>` (CLA INS P1 P2 are common with other APs. **AID is `unverified`**). If `6A 82`, review AID / `select-identifiers` in `Info.plist`.
- [ ] **2. SELECT EF of unlock information** — `00 A4 02 0C 02 <ef-hi ef-lo>` (**EF identifier is `unverified`**).
- [ ] **3. VERIFY inquiry number** — `00 20 00 P2 <Lc> <ASCII byte sequence>`.
  - Front only: 14 digits printed on the card surface (DOB 6 + expiry 4 + security code 4).
  - Front + Back (individual number): 12-digit My Number.
  - **P2 (keyref), Lc, formatting, and separators are `unverified`.**
  - SW: `90 00` Success / `63 CX` Mismatch, `X` attempts remaining (ISO/IEC 7816-4 standard values. Primary sources specific to My Number Card are `unverified`) / `69 83` Locked. Inquiry Number B (14 digits) locks after 10 consecutive failures (verified). Count for Inquiry Number A (12 digits) is `unverified`.
  - **Do not auto-retry.** Delegate presentation of remaining attempts and pre-lock warnings to `pin-lock-handling`.
- [ ] **4. SELECT target data EF → READ BINARY** — The EF identifiers for the front image / face photo / back image / individual number are all `unverified`. Read using the segmented READ (loop incrementing offset) from `ios-corenfc-apdu`.
- [ ] **5. Parse TLV based on confirmed specification** — `qiita.com/ribig` (1 source only, needs verification) reports that under the outer `FF 20 82 <length 2B>`, tags such as `DF 21` (header) / `DF 22` (DOB) / `DF 23` (sex) / `DF 24` (public key) / `DF 27` (face photo) are arranged. The face photo record is JPEG2000 (around the start `00 00 0C 6A 50 20 20` / end `FF D9`). **Tags, lengths, total length, and termination conditions are `unverified`. Do not parse by guessing.**

```swift
extension CardReader {
    // Step 3: VERIFY inquiry number. 14 digits for front only, 12-digit My Number if reading individual number too.
    // keyref(P2) / Lc / formatting are unverified, so replace with confirmed byte sequences before use.
    // VerifyOutcome / PINKind / pinBytes / interpret are defined in pin-lock-handling.
    // kind: .shogoB (14 digits) for front only, .shogoA (12 digits) if reading the individual number too
    func verifyKenmenInquiry(_ inquiry: String, kind: PINKind, tag: NFCISO7816Tag) async throws -> VerifyOutcome {
        let bytes = try pinBytes(inquiry, kind: kind)        // full-width to half-width, digit-count check (formatting unverified)
        let p2: UInt8 = 0x80                                 // keyref unverified (placeholder value from JPKI-AP)
        let apdu = rawAPDU([0x00, 0x20, 0x00, p2, UInt8(bytes.count)] + bytes)
        let (_, sw1, sw2) = try await send(apdu, to: tag)
        return interpret(sw1: sw1, sw2: sw2)                // pin-lock-handling
    }

    // Steps 4-5: SELECT data EF and read. Do not implement until EF identifier and TLV are confirmed.
    func readKenmenData(efID: [UInt8], tag: NFCISO7816Tag) async throws -> Data {
        try await selectEF(efID: efID, tag: tag)             // 00 A4 02 0C 02 <ef> (ef unverified)
        // Based on a report (1 source) that the outer TLV is FF 20 82 <2-byte length>, read up to the total length in the header.
        // If a version with extra leading bytes is found, handle it separately with readBinary (ios-corenfc-apdu)
        let raw = try await readSelectedTLV(tag: tag)
        return raw   // Card surface images/face photo are compressed. TLV tags/lengths unverified. Do not hardcode decode
    }
}
```

## What Not to Do

- **Do not read and save the individual number without legal basis.** Identity verification alone is not a basis. Do not implement the 12-digit My Number unlock without a basis.
- **Do not output the individual number, face photo, or card surface image to logs / leave plaintext on the device.** Minimize even in memory, and discard after transmission (`ios-security`).
- **Do not auto-retry on `63 CX`.** Brings it closer to being locked. UX goes to `pin-lock-handling`.
- **Do not guess parse/decode TLV and image formats.** Do not implement hardcoded while tags, lengths, and formats remain `unverified`.
- **Do not perform facial matching or identity determination on the device side.** Matching with the selfie is on the server side. Do not query J-LIS directly.
- Do not assert method names, designations, and enforcement dates under the Act on Prevention of Transfer of Criminal Proceeds in this skill (`honnin-kakunin-houhou` / `references/method-map.md`).

## Sources

PDFs under `references/pdfs/` are third-party works and are not shipped with the plugin. If a file is missing, run `bash references/refresh.sh` to download it (URLs and SHA256 are in `references/sources.md`).

- `references/apdu-cheatsheet.md` (Card Surface Verification AP's AID, EF identifier, and unlock keyref are `unverified`. Lock count of 10 for Inquiry Number B (14 digits) is verified, Inquiry Number A (12 digits) is `unverified`. Format and confidence of SELECT `00 A4 04 0C` / `00 A4 02 0C`, VERIFY `00 20 00 80`, READ BINARY `00 B0`)
- <https://services.digital.go.jp/mynumbercard/info-passcode/> (Digital Agency "My Number Card Surface Input Assistance PIN" — The inquiry number (Inquiry Number B) for reading the Card Surface AP is 14 digits, and the card locks after 10 consecutive incorrect entries. Retrieved 2026-09-08)
- <https://www.city.matsuyama.ehime.jp/kurashi/tetsuzuki/mynumberseido/syo-go-bango.html> (Matsuyama City "Releasing Inquiry Number B Lock" — Inquiry Number B (14 digits printed on the card) locks after 10 consecutive incorrect entries, face recognition also locks after 10 consecutive failures, release at municipal office. Retrieved 2026-09-08)
- `references/pdfs/33_guide-liquid-ekyc.pdf` p9–11 (LIQUID eKYC Guide IC Chip Method Version. The PDF lists "IC chip face photo image" and "Captured facial image" in the acquired data organized by the terms "Method Ka" and "Method He". It does not explicitly name the Card Surface Verification AP. Method name definitions are in `honnin-kakunin-houhou` / `references/method-map.md`. Vendor material. Retrieved 2026-09-08)
- <https://www.digital.go.jp/assets/contents/node/basic_page/field_ref_resources/68bc86d6-94d7-4fe8-a592-302d78828e1f/d8c514f8/20231102_policies_mynumber_pros-and-safety_outline_01.pdf> (Digital Agency "Overview of My Number Card Apps / AP Configuration" — Card Surface AP uses = detecting tampering of card surface information face-to-face, using images as evidence of identity verification. Recorded information = front: 4 attributes + face photo image / back: My Number image. Access control = 12-digit My Number for front and back, DOB 6 digits + expiry year 4 digits + security code 4 digits for front only. The My Number in the Card Surface Input Assistance AP can only be used for administrative work based on the Number Use Act. Retrieved 2026-09-08)
- <https://zenn.dev/trustdock/articles/66a228895294bc> (TrustDock "Introduction to Public Personal Authentication (JPKI)" — Card Surface AP holds information printed on the card surface (4 attributes image, face photo image, My Number back image), J-LIS digital signature is attached to the read data enabling tamper detection. Retrieved 2026-09-08)
- <https://qiita.com/ribig/items/3814cf7f095854ce0e61> ("Reading face photo data from My Number Card #APDU" — SELECT Card Surface AP, READ data EF after verification, outer `FF 20 82` TLV, `DF 27` is the face photo, face photo is JPEG2000 (around start `00 00 0C 6A 50 20 20` / end `FF D9`, monochrome display). Personal blog, 1 source only, needs verification. Retrieved 2026-09-08)
- <https://www.ppc.go.jp/legal/policy/my_number_guideline_jigyosha/> (Personal Information Protection Commission "Guidelines for the Proper Handling of Specific Personal Information (For Business Operators)" — Administrative work that can use the individual number is exhaustively listed in the Number Use Act, use outside the purpose is prohibited even with user consent, Specific Personal Information no longer needed must be promptly deleted/discarded by irrecoverable means, security control measures, supervision of employees, supervision of contractors. Retrieved 2026-09-08)

## Last Verified: 2026-09-08

## Unverified Items

- **AID of Card Surface Verification AP.** Actual value cannot be confirmed in public sources (`references/apdu-cheatsheet.md` is also `unverified`). The value to list in `select-identifiers` of `Info.plist` is unconfirmed.
- **EF identifiers.** Each EF identifier for unlock information, front image, back image, face photo, and individual number. Not in public sources.
- **Unlock keyref (P2), Lc, and formatting.** P2, Lc, zero-padding, order, presence of separators, and target EF when sending 14 digits (DOB 6 + expiry 4 + security code 4) / 12-digit My Number via VERIFY. `P2=0x80` in the above code is a placeholder using the JPKI-AP value.
- **Actual entity of "Card Surface Verification PIN" and "Individual Number PIN".** Digital Agency materials explain it is based on inquiry numbers (card surface printed values, 12-digit My Number), but whether a separately remembered fixed PIN exists, digit counts, and unified setting possibilities are `unverified` in primary J-LIS materials.
- **Lock count.** Inquiry Number B (14 digits, for Card Surface Verification) locks after 10 consecutive failures (verified: Digital Agency, Matsuyama City, PocketSign, etc.). Inquiry Number A (12-digit My Number, for Individual Number) is `unverified` (highly likely to be 10 times as well). Whether `X` in `63 CX` represents the remaining retry count also needs verification.
- **Face photo image format.** The report of JPEG2000 (grayscale) is from only 1 source, `qiita.com/ribig`. Resolution, color depth, presence of supervisory headers, and differences by issue year need verification.
- **TLV layout.** Each tag, length, total length, READ termination condition, and maximum length for outer `FF 20`, `DF 21`~`DF 27`, etc. `qiita.com/ribig` is the only source. The difference in tag allocation from `DF 21`~`DF 25` of the Card Surface Input Assistance AP (`kenmen-nyuryoku-hojo-ap`) also needs confirmation.
- **Scope included in the back image.** Whether it is only the image of the individual number, or also includes name, date of birth, etc.
- **PDF 33 does not explicitly name the Card Surface Verification AP.** p11 lists "IC chip face photo image" in the acquired data for My Number Card / Method He (Card Surface Input Assistance AP), but the material does not specify which AP the face photo is read from.
