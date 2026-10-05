---
name: ios-corenfc-apdu
description: Used when reading My Number Cards with CoreNFC on iOS. Covers creation of NFCTagReaderSession, connection to NFCISO7816Tag, APDU transmission (NFCISO7816APDU / sendCommand), entitlement settings (readersession.formats = TAG), listing AIDs to SELECT in Info.plist under com.apple.developer.nfc.readersession.iso7816.select-identifiers and NFCReaderUsageDescription, Type-B card polling, SELECT / READ BINARY, and segmented reading exceeding 256 bytes. JPKI-specific VERIFY PIN / signature generation are out of scope (see jpki-ap-shomei / jpki-ap-riyousha).
---

# Sending APDUs with iOS CoreNFC (Transport Layer)

A procedural reference summarizing **Xcode project settings** and **how to assemble a CoreNFC session** for interacting with the IC chip of a My Number Card via APDUs. This covers only the generic transport layer (session establishment, tag connection, APDU transmission/reception, SELECT / READ BINARY). APDU commands for specific AIDs, EF identifiers, PINs, and signature generation of each AP are not included (see `mynumber-card-ic` / `references/apdu-cheatsheet.md` / individual AP skills).

## When to Use This Skill

- When starting implementation to read My Number Cards using CoreNFC in an iOS app
- When checking the usage and return values of `NFCTagReaderSession` / `NFCISO7816Tag` / `NFCISO7816APDU` / `sendCommand`
- When configuring NFC entitlements, capabilities, `Info.plist`, and provisioning profiles
- When assembling SELECT FILE or READ BINARY APDUs, and reading EFs exceeding 256 bytes using a loop
- When isolating initial setup defects, such as sessions immediately invalidating or tags not arriving at `didDetect`

For JPKI PIN verification and electronic signature generation procedures, see `jpki-ap-shomei` / `jpki-ap-riyousha`. For card-face items, see `kenmen-nyuryoku-hojo-ap` / `kenmen-jikou-kakunin-ap`. For UX text of errors, see `ios-nfc-ux-errors`. For handling keys and PINs, see `ios-security`.

## Project Settings

- [ ] **Add capability** — Add "Near Field Communication Tag Reading" in Xcode's Signing & Capabilities. This adds the `TAG` format to `com.apple.developer.nfc.readersession.formats`. Also, enable "NFC Tag Reading" in the App ID on the Apple Developer portal, and use a provisioning profile linked to that App ID (if NFC is missing from the profile, actual device builds will fail).
- [ ] **List AIDs to SELECT in `Info.plist`** — Enumerate the AIDs of the APs that the app will select via SELECT FILE (DF Name) as hex strings in `com.apple.developer.nfc.readersession.iso7816.select-identifiers` (string array, iOS 13.0+) of `Info.plist`. AIDs missing from here are filtered by the OS, causing SELECT via `sendCommand` to fail or the tag to not be passed to `didDetect`. See `references/apdu-cheatsheet.md` for actual AID values of each My Number Card AP (as of this plugin, anything other than JPKI-AP is marked `未確認` (unverified) or `（1ソースのみ・要検証）` (single source, needs verification) there. List them after verification). Regarding the acquisition of AIDs for the app to SELECT (application for AID disclosure), see `platform-jigyousha`.
- [ ] **Set `NFCReaderUsageDescription` in `Info.plist`** — Enter a non-empty string explaining why the NFC hardware is used. If unset or empty, the session will fail with `tagReaderSession(_:didInvalidateWithError:)` immediately after creation.
- [ ] **Test on a physical device (Simulator not allowed)** — CoreNFC only works on actual iPhones that support NFC. Even if you can build on the Simulator, reading will not work. The My Number Card is ISO/IEC 14443 **Type-B**. Specify `.iso14443` for polling (both Type A and B are included in `.iso14443`). An actual card is required for testing.

## Session Implementation

```swift
import CoreNFC

final class CardReader: NSObject, NFCTagReaderSessionDelegate {
    private var session: NFCTagReaderSession?

    func begin() {
        guard NFCTagReaderSession.readingAvailable else { return }   // false on unsupported devices and Simulator
        // convenience init?(pollingOption:delegate:queue:) — queue: nil uses a dedicated dispatch queue
        session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self, queue: nil)
        session?.alertMessage = "Hold your My Number Card near the top of your iPhone and keep it still"
        session?.begin()
    }

    // The session became active (the scan sheet is displayed here)
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {}

    // Session ended (user cancel / timeout / error / invalidate call)
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        self.session = nil
        // Display the error in Japanese using the mapping from ios-nfc-ux-errors. Dispatch UI updates to main
    }

    // Tag detected. Multiple may arrive, so pick only one ISO 7816 tag
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        guard let firstTag = tags.first, case let .iso7816(iso7816Tag) = firstTag else {
            session.invalidate(errorMessage: "This card is not supported")
            return
        }
        Task {
            do {
                try await session.connect(to: firstTag)         // func connect(to:) async throws
                try await self.readCard(tag: iso7816Tag, session: session)
                session.alertMessage = "Reading completed"
                session.invalidate()                            // Always close even on success
            } catch {
                session.invalidate(errorMessage: "Failed to read. Please try again")
            }
        }
    }
}
```

- Delegate callbacks are called on the queue passed to `queue:` (or CoreNFC's dedicated queue if `nil`). Dispatch UI updates to `DispatchQueue.main`.
- If the card moves away during reading, the next `sendCommand` will throw. In principle, redo the entire session (re-polling is also possible with `session.restartPolling()`).
- Multiple APDUs can be sent during one session. `connect` is called once, followed by calling `sendCommand` the necessary number of times.
- **A single session is automatically invalidated by the system about 60 seconds after activation** (`NFCReaderError.readerSessionInvalidationErrorSessionTimeout` in `didInvalidateWithError`). Complete the signing flow (segmented READ of certificate + VERIFY + signature generation) within this time. **Do not make server round-trips during the session** — acquire the data to be signed (to-be-signed) from the server before `session.begin()`, finish displaying the text and calculating the hash before the session (`jpki-ap-shomei`), and send the signature value/certificate to the server after closing the session. PIN input should also be completed before starting the session (`ios-nfc-ux-errors`).

## Sending and Receiving APDUs

The structure of an APDU (ISO/IEC 7816-4) is `CLA INS P1 P2 [Lc Data] [Le]`. `NFCISO7816APDU` represents each of these fields.

```swift
extension CardReader {
    // (A) Create by specifying fields (Lc / Le are added by the framework)
    //     init(instructionClass:instructionCode:p1Parameter:p2Parameter:data:expectedResponseLength:)
    func readBinaryAPDU(offset: Int, expectedLen: Int) -> NFCISO7816APDU {
        NFCISO7816APDU(instructionClass: 0x00,
                       instructionCode: 0xB0,                        // READ BINARY
                       p1Parameter: UInt8((offset >> 8) & 0xFF),     // offset high
                       p2Parameter: UInt8(offset & 0xFF),            // offset low
                       data: Data(),
                       expectedResponseLength: expectedLen)          // If negative, Le field is not sent
    }

    // (B) Create from a raw byte array (include Lc yourself) — init?(data:)
    func rawAPDU(_ bytes: [UInt8]) -> NFCISO7816APDU {
        NFCISO7816APDU(data: Data(bytes))!
    }

    // Send. The async version overloads are determined by the return type
    func send(_ apdu: NFCISO7816APDU, to tag: NFCISO7816Tag) async throws -> (Data, UInt8, UInt8) {
        // func sendCommand(apdu:) async throws -> (Data, UInt8, UInt8)
        //   data = response data body, sw1 sw2 = status words
        // Another overload: async throws -> NFCISO7816ResponseAPDU
        //   (.payload / .statusWord1 / .statusWord2)
        // completionHandler version: (Data, UInt8, UInt8, Error?) -> Void
        let (data, sw1, sw2) = try await tag.sendCommand(apdu: apdu)
        return (data, sw1, sw2)
    }
}
```

- `sw1 == 0x90 && sw2 == 0x00` means normal termination. For the meaning of other SW1SW2 values, refer to `references/apdu-cheatsheet.md` and `pin-lock-handling` (`63 CX` = remaining attempts, `69 83` = locked, `6A 82` = no file / AP, etc. These are all ISO/IEC 7816-4 standard values, and My Number Card-specific behavior requires verification).
- Tag information can be acquired via the properties of `NFCISO7816Tag` (`initialSelectedAID`, `identifier`, `historicalBytes`, `applicationData`).

## SELECT and READ BINARY

For APDU byte arrays, use the pre-recorded formats in `references/apdu-cheatsheet.md` (do not copy guessed values. Items marked `未確認` (unverified) there should be verified before implementation).

| Operation | CLA INS P1 P2 | Data | Remarks |
|---|---|---|---|
| SELECT (DF Name / AID) | `00 A4 04 0C` | AID | Selects an AP. P2=`0C` specifies not to return response data |
| SELECT (EF identifier) | `00 A4 02 0C` | EF-ID (2 bytes) | Selects an EF within the AP after SELECTing the AP. Identifiers differ for each AP and most are `Unverified` |
| READ BINARY | `00 B0` + offset high + offset low | ― | Reads the selected EF from offset |

```swift
// Errors thrown during reading/signing. Keep SW as is, and interpret in ios-nfc-ux-errors / pin-lock-handling
enum ReaderError: Error {
    case selectFailed(UInt8, UInt8)
    case readFailed(offset: Int, sw1: UInt8, sw2: UInt8)
    case signFailed(UInt8, UInt8)
    case malformedTLV
    case truncated(expected: Int, got: Int)
    case offsetOutOfRange(Int)
    case invalidInput
}

extension CardReader {
    // SELECT by AID: Raw byte array is 00 A4 04 0C <Lc> <AID...>
    func selectAP(aid: [UInt8], tag: NFCISO7816Tag) async throws {
        let apdu = rawAPDU([0x00, 0xA4, 0x04, 0x0C, UInt8(aid.count)] + aid)
        let (_, sw1, sw2) = try await send(apdu, to: tag)
        guard sw1 == 0x90, sw2 == 0x00 else { throw ReaderError.selectFailed(sw1, sw2) }
    }

    // SELECT by EF id: 00 A4 02 0C 02 <ef-hi> <ef-lo>
    func selectEF(efID: [UInt8], tag: NFCISO7816Tag) async throws {
        let apdu = rawAPDU([0x00, 0xA4, 0x02, 0x0C, 0x02] + efID)
        let (_, sw1, sw2) = try await send(apdu, to: tag)
        guard sw1 == 0x90, sw2 == 0x00 else { throw ReaderError.selectFailed(sw1, sw2) }
    }

    // Sends READ BINARY once. Always throws for anything other than 90 00 (does not silently return partial data)
    func readBinary(offset: Int, length: Int, tag: NFCISO7816Tag) async throws -> Data {
        // If the highest bit of P1 is 1, it means "short EF identifier" specification, so offset is up to 15 bits
        guard (0...0x7FFF).contains(offset) else { throw ReaderError.offsetOutOfRange(offset) }
        var (data, sw1, sw2) = try await send(readBinaryAPDU(offset: offset, expectedLen: length), to: tag)
        if sw1 == 0x6C {   // Le error: Resend exactly once with the length indicated by the card (ISO/IEC 7816-4)
            let le = sw2 == 0 ? 256 : Int(sw2)
            (data, sw1, sw2) = try await send(readBinaryAPDU(offset: offset, expectedLen: le), to: tag)
        }
        switch (sw1, sw2) {
        case (0x90, 0x00): return data
        case (0x62, 0x82): return data   // End of file reached before requested length. The returned data itself is valid
        default: throw ReaderError.readFailed(offset: offset, sw1: sw1, sw2: sw2)
        }
    }

    // Reads a single TLV (like a certificate's DER) at the beginning of the selected EF, exactly to the length indicated by the header.
    // Does not read the rest of the EF (padding). Throws if anything other than 90 00 is returned at any point
    func readSelectedTLV(tag: NFCISO7816Tag, chunk: Int = 256) async throws -> Data {
        let head = try await readBinary(offset: 0, length: 8, tag: tag)   // Sufficient for tag + length fields
        let total = try Self.tlvTotalLength(head)                         // Total length including header
        var result = Data(head.prefix(total))
        while result.count < total {
            let want = min(chunk, total - result.count)
            let part = try await readBinary(offset: result.count, length: want, tag: tag)
            guard !part.isEmpty else { throw ReaderError.truncated(expected: total, got: result.count) }
            result.append(part.prefix(want))
        }
        return result
    }

    // Calculates the total length including the header from the BER-TLV header (tag 1+ bytes + length 1-4 bytes)
    static func tlvTotalLength(_ head: Data) throws -> Int {
        let b = [UInt8](head)
        guard !b.isEmpty else { throw ReaderError.malformedTLV }
        var i = 1
        if b[0] & 0x1F == 0x1F {                           // Multi-byte tag (e.g., FF 20)
            while i < b.count, b[i] & 0x80 != 0 { i += 1 }
            i += 1
        }
        guard i < b.count else { throw ReaderError.malformedTLV }
        let first = b[i]
        if first < 0x80 { return i + 1 + Int(first) }        // Short form
        let n = Int(first & 0x7F)                           // Long form: the following n bytes are the length
        guard (1...3).contains(n), i + n < b.count else { throw ReaderError.malformedTLV }
        let len = b[(i + 1)...(i + n)].reduce(0) { $0 << 8 | Int($1) }
        return i + 1 + n + len
    }
}
```

- A single READ BINARY can read a maximum of 256 bytes with a short Le. For large EFs (like electronic certificates), **calculate the total length from the TLV / ASN.1 header at the beginning, and advance the offset exactly up to that length** (`readSelectedTLV`). If you stop by "terminating if the return is shorter than requested length", you will end up reading the padding in the latter half of the EF.
- **Do not silently break the loop for values other than `90 00`.** If you exit with `69 82` (security status not satisfied), you will return a partially cut certificate as a normal value. For `62 82` (end of file), use the returned data, for `6C xx`, resend exactly once with the indicated Le, and for anything else, throw. The SW at termination and maximum length per EF that the My Number Card actually returns is `Unverified` (see below).
- For EFs that do not have a TLV at the beginning (e.g., the four basic attributes in the card-face input-assist application where 2 bytes precede `FF 20` on some cards), do not use `readSelectedTLV`, but follow the instructions in each AP's skill.
- The `readBinary` / `readSelectedTLV` / `tlvTotalLength` above have been verified in Swift 6 language mode using a mock card for "EFs with padding, `62 82`, `6C xx`, intermediate `69 82`, and multi-byte tag `FF 20`" (2026-09-25). Behavior with actual cards requires separate verification.
- Whether the P1P2 for SELECT (`00 A4 04 0C` / `00 A4 02 0C`) is common across all APs should be checked against the certainty table in `apdu-cheatsheet.md`.
- **JPKI-specific APDUs (PIN verification via VERIFY, signature generation via COMPUTE DIGITAL SIGNATURE) are out of scope of this skill.** See `apdu-cheatsheet.md` for byte arrays, `jpki-ap-shomei` for signing procedures, and `jpki-ap-riyousha` for user-authentication procedures. This skill only covers the generic transport layer.

## Common Failures

- **Testing on Simulator** — NFC requires a physical device. `NFCTagReaderSession.readingAvailable` returns `false`.
- **Writing AIDs in `.entitlements` / Forgetting to list them in `Info.plist`** — `select-identifiers` is a key in `Info.plist` (only `readersession.formats` goes into `.entitlements`). Trying to SELECT an AID not in `select-identifiers` of `Info.plist` fails / the tag does not arrive at `didDetect`.
- **No NFC in provisioning profile** — If NFC Tag Reading is not enabled in the App ID, physical device builds / execution are impossible.
- **`NFCReaderUsageDescription` not set** — The session terminates immediately with `didInvalidateWithError` right after creation.
- **Incorrect `pollingOption`** — If anything other than `.iso14443` is specified, the Type-B My Number Card will not be detected.
- **Assuming you can read more than 256 bytes at once** — It will get cut off. Advance the offset and loop.
- **Breaking the loop on error SW to return partial data / Reading until the padding at the end of the EF** — The certificate will be corrupted. Calculate the total length like in `readSelectedTLV`, and throw for anything other than `90 00`.
- **Not calling `invalidate()` / Creating multiple sessions** — Always close even on success. You cannot hold multiple sessions simultaneously.
- **Inserting a server round-trip during a session** — The system will cut it off after about 60 seconds (`readerSessionInvalidationErrorSessionTimeout`). Perform hash acquisition and signature transmission outside the session.
- **Updating UI while ignoring the callback thread** — Delegates are called on a dedicated queue. Dispatch to `DispatchQueue.main`.
- **Unconditionally using the first tag in `didDetect`** — Select the ISO 7816 tag with `case .iso7816`, and call `invalidate(errorMessage:)` if it doesn't match.
- **Not retrying when the card moves away / Retrying too much** — A throw from `sendCommand` requires redoing the session. Do not automatically retry operations involving PIN verification (`pin-lock-handling`).

## Sources

- <https://developer.apple.com/documentation/corenfc/nfctagreadersession> (`init(pollingOption:delegate:queue:)`, `PollingOption` (`.iso14443` / `.iso15693` / `.iso18092`), `connect(to:) async throws`, `invalidate()` / `invalidate(errorMessage:)`, `restartPolling()`, `readingAvailable`, required entitlements and `NFCReaderUsageDescription`. Retrieved on 2026-09-08)
- <https://developer.apple.com/documentation/corenfc/nfciso7816tag> (Each overload of `sendCommand(apdu:)` and return values `(Data, UInt8, UInt8)` / `NFCISO7816ResponseAPDU` (`payload` / `statusWord1` / `statusWord2`), properties like `initialSelectedAID`, `NFCTag`'s `case .iso7816(any NFCISO7816Tag)`. Retrieved on 2026-09-08)
- <https://developer.apple.com/documentation/corenfc/nfciso7816apdu> (`init(instructionClass:instructionCode:p1Parameter:p2Parameter:data:expectedResponseLength:)`, `init?(data:)`, if `expectedResponseLength` is negative the Le field is not sent. Retrieved on 2026-09-08)
- <https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.developer.nfc.readersession.iso7816.select-identifiers> (String array of AIDs the app SELECTs. iOS 13.0+. Although documented under Entitlements, the `NFCISO7816Tag` page states it is an "information property list key", and in implementations it is placed in `Info.plist` (same for TRETJapanNFCReader's README). Retrieved on 2026-09-08, re-verified on 2026-09-25)
- <https://zenn.dev/trustdock/articles/66a228895294bc> (TrustDock "Introduction to Public Personal Authentication (JPKI)" — My Number Card is NFC Type-B, communication is ISO/IEC 7816-4 APDU. iOS implementation code is not in Vol.1 but checked as a premise. Retrieved on 2026-09-08)
- `references/apdu-cheatsheet.md` (Byte arrays for SELECT / READ BINARY `00 A4 04 0C` / `00 A4 02 0C` / `00 B0`, AIDs, SW1SW2 and certainty of each value)

## Last Verified

2026-09-11

## Unverified Items

- AID strings of each My Number Card AP that should be listed in the entitlement `select-identifiers`. Anything other than JPKI-AP is marked `未確認` (unverified) or `（1ソースのみ・要検証）` in `references/apdu-cheatsheet.md` as well. Verify before implementation.
- Exact termination conditions for the My Number Card when reading more than 256 bytes with READ BINARY (whether maximum length can be requested with Le=0, whether it returns `61 xx` / `6C xx`, maximum read length per EF). The above code terminates at the total length of the TLV header and handles `62 82` / `6C xx` according to ISO/IEC 7816-4, but actual behavior on physical cards requires verification.
- Whether the P1P2 `00 A4 02 0C` for SELECT (EF identifier) is common across all APs. `apdu-cheatsheet.md` only has examples for JPKI-AP.
- Whether the My Number Card (ISO/IEC 14443 Type-B) is reliably passed as `case .iso7816` when `.iso14443` is specified. TrustDock specifies Type-B, but Apple documentation does not explicitly distinguish between Type A / B.
- Whether the My Number Card supports APDU Extended Length (Lc / Le being 3 bytes). The code in this skill assumes a short Le.
