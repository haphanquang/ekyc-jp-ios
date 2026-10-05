---
name: pin-lock-handling
description: Used in iOS implementation for handling My Number Card PIN lock and PIN retry. Covers interpreting VERIFY response SW1SW2 (63CX = remaining attempts / 6983 = locked / 9000 = success), retry counts per PIN type, UX for displaying remaining attempts, pre-lock warnings, prohibiting auto-retry, and guidance for My Number Card lock release (municipal office, convenience store, smartphone app). PIN initialization procedures and server-side certificate verification are out of scope.
---

# Handling My Number Card PIN Lock and Retry

A reference for interpreting the response SW1SW2 to VERIFY (`00 20 00 80` + PIN byte sequence) and providing **remaining attempt display, pre-lock warnings, and lock release guidance**. For the SELECT/VERIFY procedures of each AP, see `jpki-ap-shomei` / `jpki-ap-riyousha` / `kenmen-jikou-kakunin-ap` / `kenmen-nyuryoku-hojo-ap`; for CoreNFC APDU communication, see `ios-corenfc-apdu`; for error screen messages, see `ios-nfc-ux-errors`.

PIN initialization and reset cannot be performed by the app (done at municipal offices, convenience store kiosk terminals, or smartphone apps). This skill covers "how to guide the user." Method names and applicability dates under the Act on Prevention of Transfer of Criminal Proceeds are not asserted here (`honnin-kakunin-houhou`).

## When to Use This Skill

- When extracting remaining retry count from a VERIFY response to display in the UI
- When deciding conditions for showing "next incorrect attempt will lock the card" warnings
- When handling `69 83` (locked) and building lock release guidance and messages
- When checking how many consecutive incorrect entries lock each PIN type

## Retry Counts per PIN Type

Values, sources, and confidence levels are primarily recorded in `references/apdu-cheatsheet.md` "PIN Digit Count and Lock Count." This table is an index to that.

| PIN | Digits | Locks After Consecutive Failures | Confidence (see `apdu-cheatsheet.md`) |
|---|---|---|---|
| Signature | 6–16 alphanumeric | 5 times | Verified (J-LIS `jpki.go.jp`) |
| User Authentication | 4 digits | 3 times | Verified (J-LIS `jpki.go.jp`) |
| Card Surface Input Assistance | 4 digits | 3 times | Verified (My Number Card General Site, MynaPortal FAQ, Digital Agency) |
| Card Surface Verification (Inquiry Number B, 14 digits: DOB 6 + expiry 4 + security code 4) | 14 digits | 10 times | Verified (Digital Agency, municipalities, multiple vendor materials agree) |
| Individual Number (Inquiry Number A, My Number 12 digits) | 12 digits | Unverified (likely same 10 as Inquiry Number B) | Unverified |

- The Card Surface Input Assistance **4-digit PIN (3 times)** and the **14-digit Inquiry Number B read from the card surface (10 times)** are different things. Vendor materials (`references/pdfs/33_guide-liquid-ekyc.pdf` p11 etc.) referring to "10 times" mean the latter, which does not contradict the 4-digit PIN's "3 times."
- Retry counts do not reset with time. They only reset to the initial value on a successful VERIFY.

## Reading the Response

VERIFY response SW1SW2. Values are ISO/IEC 7816-4 standard values; primary sources specific to My Number Card are `unverified` (`references/apdu-cheatsheet.md`).

| SW1SW2 | Meaning | Action |
|---|---|---|
| `90 00` | Verification successful | Proceed to next step. May clear remaining count display |
| `63 CX` | PIN mismatch. Lower nibble `X` is remaining retry count (e.g., `63 C2` is 2 remaining. Treat `63 C0` as 0 remaining = locked) | Display remaining count. Warn when `X` is small. **Do not auto-resend** |
| `63 00` | Mismatch (possibly behavior not returning remaining count) | Treat remaining count as unknown; warn cautiously. Present that next attempt may be the last |
| `69 83` | Authentication method locked (blocked) | Further VERIFY is futile. Close PIN entry field and transition to lock release guidance |
| `6A 88` | Referenced data not found (keyref/EF mismatch, etc.) | Suspect implementation bug. Review SELECTed AP/EF. Do not prompt user to re-enter PIN |
| `6A 82` | File/AP not found | Review AID, EF, and `select-identifiers` in `Info.plist` (`ios-corenfc-apdu`) |
| Other | Unknown SW | Do not assume PIN error. Treat as unknown cause; do not assume retry count was consumed |

**The definition in this skill is the sole definition for VERIFY pre- and post-processing.** `jpki-ap-shomei` / `jpki-ap-riyousha` / `kenmen-nyuryoku-hojo-ap` / `kenmen-jikou-kakunin-ap` call `pinBytes` and `interpret` here (do not define separate enums in each skill).

- `pinBytes` — Converts input to half-width using NFKC (full-width numbers like "１２３４" from Japanese IME would otherwise become 3 bytes/character in UTF-8, wasting 1 attempt), and validates the format for each type before converting to an ASCII byte sequence. Format violations are thrown without being sent to the card.
- `interpret` — Interprets SW1SW2 (interpretation of values only. No retry control). `63 C0` is treated as `.locked` since remaining count is 0.

```swift
// Types of PIN and Inquiry Number. Used for format validation before sending to the card
enum PINKind {
    case riyousha        // User Authentication: 4 digits
    case kenmenHojo      // Card Surface Input Assistance: 4 digits
    case shomei          // Signature: 6–16 alphanumeric characters
    case shogoB          // Inquiry Number B: 14 digits written on card surface (DOB 6 + expiry 4 + security code 4)
    case shogoA          // Inquiry Number A: Individual Number 12 digits
}

enum PINInputError: Error { case invalidFormat }

/// Normalizes and validates the input, and returns an ASCII byte array to be included in VERIFY.
/// If the format is invalid, it throws (not sent to the card = retry count not consumed).
func pinBytes(_ input: String, kind: PINKind) throws -> [UInt8] {
    // Convert full-width numbers and full-width letters from Japanese IME ("１２３４", "ＡＢＣ") to half-width (NFKC)
    var s = input.precomposedStringWithCompatibilityMapping
    if kind == .shomei { s = s.uppercased() }   // Signature requires uppercase letters + numbers
    let pattern: String
    switch kind {
    case .riyousha, .kenmenHojo: pattern = "^[0-9]{4}$"
    case .shomei:                pattern = "^[A-Z0-9]{6,16}$"
    case .shogoB:                pattern = "^[0-9]{14}$"
    case .shogoA:                pattern = "^[0-9]{12}$"
    }
    guard s.range(of: pattern, options: .regularExpression) != nil else {
        throw PINInputError.invalidFormat
    }
    return Array(s.utf8)   // Only ASCII reaches here
}

enum VerifyOutcome {
    case ok
    case mismatch(remaining: Int?)   // nil = card did not return remaining count
    case locked
    case other(sw1: UInt8, sw2: UInt8)
}

func interpret(sw1: UInt8, sw2: UInt8) -> VerifyOutcome {
    switch (sw1, sw2) {
    case (0x90, 0x00):
        return .ok
    case (0x69, 0x83), (0x63, 0xC0):                   // 63 C0 = 0 remaining (next VERIFY will be 69 83)
        return .locked
    case (0x63, let low) where (low & 0xF0) == 0xC0:
        return .mismatch(remaining: Int(low & 0x0F))   // 63 CX
    case (0x63, 0x00):
        return .mismatch(remaining: nil)
    default:
        return .other(sw1: sw1, sw2: sw2)
    }
}
```

The input field should use `.numberPad` (4, 12, or 14 digits) / `.asciiCapable` (for signature), `isSecureTextEntry = true`, and `textContentType` should not be set (do not target for automatic password entry/saving). The above code was tested in Swift 6 language mode on 2026-09-25 (full-width input, digit count violations, `63 C0` / `63 C2` / `63 00` / `69 83`).

## UX Guidelines

- [ ] **Display remaining count** — Show `X` from `63 CX` to the user after each VERIFY. When count is unavailable, explicitly state "Could not retrieve remaining count"
- [ ] **Warn before final attempt** — Before reaching 1 remaining, convey the gravity: "If you enter incorrectly again, the card will be locked and you will need to visit a municipal office or similar to resolve it"
- [ ] **Do not implement auto-retry** — VERIFY resends must always be initiated by explicit user action. Do not send in a loop
- [ ] **Do not waste attempts** — Perform full-width to half-width normalization, and check for empty strings, insufficient digits, and wrong character types before sending to the card (`pinBytes`). Do not let the wrong type of PIN be sent
- [ ] **If SW is not received, do not assume it was "consumed"** — On communication error or session disconnect, retrieve the remaining count on the next screen before displaying
- [ ] **Do not retain PIN** — Wipe immediately after VERIFY; require re-entry on retry (`ios-security`)
- [ ] **Close entry field on lock** — When `69 83` is received, hide the PIN re-entry field and switch to lock release guidance
- [ ] **Do not confuse PIN types** — Do not show 6–16 digit instructions on a screen requesting 4 digits, and vice versa

## Lock Release Guidance

The app cannot perform lock release or initialization. Guide the user to the following (sources from `references/apdu-cheatsheet.md` source column, `jpki.go.jp`, etc.).

**If Signature or User Authentication PIN is Locked**

- If the other PIN (user authentication 4-digit or signature 6–16 alphanumeric) is usable, initialization and reset can be done via the smartphone app and convenience store kiosk terminal (limited to supported terminals and devices).
- If both are locked or the above is unavailable, bring the My Number Card to the municipal office of the registered residence for reset. Cannot be done by mail or online.

**If Card Surface Input Assistance PIN is Locked**

- PIN reset procedure at the municipal office of registered residence is required (My Number Card General Site).

**If Card Surface Value (Inquiry Number) is Locked**

- When the Card Surface Verification AP inquiry number is locked, lock release and initialization must be done at a municipal office (municipal guidance).

**Distinguishing "Temporarily Unable to Enter" from "Initialization Required"**

- Card blocking (`69 83`) does not resolve with time. A successful VERIFY with the correct PIN, or initialization at a counter/convenience store, is required.
- App-side temporary input suspension is a dropout/misoperation prevention measure separate from the card's lock state. If the card is blocked, clearly state "waiting will not resolve this" and guide to counter/convenience store channels.

## Sources

PDFs under `references/pdfs/` are third-party works and are not shipped with the plugin. If a file is missing, run `bash references/refresh.sh` to download it (URLs and SHA256 are in `references/sources.md`).

- `references/apdu-cheatsheet.md` ("PIN Digit Count and Lock Count" and "SW1SW2" — primary record for values, sources, and confidence levels. This skill is its index)
- `references/pdfs/06_certificate-expiry-what-to-do.pdf` (J-LIS "When Digital Certificates are Revoked and How to Respond" — Revocation reasons and reason codes. No direct description of PIN lock, but background on both revocation and lock leading to "procedures at the counter")
- https://www.jpki.go.jp/procedure/password.html (J-LIS "How to release lock / if you forgot your digital certificate password" — Signature locks after 5, user authentication after 3. Release via smartphone app + convenience store kiosk, or reset at municipal office. Not available by mail or online. HTTP 200. Retrieved 2026-09-08)
- https://www.jpki.go.jp/ (J-LIS portal top — User authentication (4 digits) 3 times, signature (6–16 alphanumeric) 5 times locks. HTTP 200. Retrieved 2026-09-08)
- https://www.kojinbango-card.go.jp/faq_pin2/ (My Number Card General Site FAQ "What is the Card Surface Input Assistance App PIN?" — 4-digit number, locks after 3 incorrect entries, reset at municipal office. HTTP 200. Retrieved 2026-09-08)
- https://services.digital.go.jp/mynumbercard/info-passcode/ (Digital Agency "My Number Card Surface Input Assistance PIN" — 4 digits, locks after 3. Card surface AP reading 14-digit inquiry number locks after 10 consecutive errors. HTTP 200. Retrieved 2026-09-08)
- https://www.city.matsuyama.ehime.jp/kurashi/tetsuzuki/mynumberseido/syo-go-bango.html (Matsuyama City "Releasing Inquiry Number B Lock" — Inquiry Number B (14 digits) locks after 10 consecutive errors, face recognition locks after 10 consecutive failures, release at municipal office. HTTP 200. Retrieved 2026-09-08)

## Last Verified: 2026-09-08

## Unverified Items

- SW1SW2 values (`63 CX` / `63 00` / `69 83` / `6A 88` / `6A 82`) are all ISO/IEC 7816-4 standard values. No JPKI-specific primary source confirming the actual behavior on My Number Cards (especially whether the lower nibble of `63 CX` is strictly the remaining retry count, or whether some APs return `63 00` on mismatch) has been identified.
- Lock count for Inquiry Number A (My Number 12 digits, individual number). Inquiry Number B (14 digits) at 10 times is consistent across multiple sources, but no primary source explicitly states Inquiry Number A's count.
- VERIFY keyref (P2), Lc, target EF, and digit formatting for Card Surface Input Assistance and Card Surface Verification PINs (corresponding rows in `references/apdu-cheatsheet.md` are also `unverified`).
- Range of terminals and devices supporting convenience store/smartphone initialization. Whether the Card Surface Input Assistance PIN can be reset outside of municipal offices.
- Response when performing non-VERIFY operations (certificate READ, etc.) on a locked card. Whether blocking is per-AP or card-wide is unverified.
