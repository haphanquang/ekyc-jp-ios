---
name: ios-nfc-ux-errors
description: Used when designing NFC reading UX and error messages (Japanese) on iOS. Maps reading failure handling (card moved away too early, wrong PIN, PIN locked, timeout, not a My Number Card, NFC unavailable, session busy, tag connection lost) to NFCReaderError codes and user-friendly messages, covers iPhone antenna position guidance, alertMessage updates during sessions, App Clip for JPKI (install-free flow) use cases, and onboarding before first read. For PIN remaining count and unlock details, see pin-lock-handling; for session/APDU mechanics, see ios-corenfc-apdu.
---

# iOS NFC Reading UX and Error Messages

A reference for translating errors occurring during My Number Card NFC reading into **Japanese messages that tell the user what to do next**, improving read success rates and preventing dropouts. For CoreNFC session establishment and APDU communication, see `ios-corenfc-apdu`; for PIN remaining count display and unlock guidance, see `pin-lock-handling`. Method names and applicable dates under the Act on Prevention of Transfer of Criminal Proceeds are not asserted here (`honnin-kakunin-houhou`).

## When to Use This Skill

- When converting `Error` received in `didInvalidateWithError` to user-facing Japanese messages
- When designing per-cause branching ("try again" / "visit your local office," etc.) for read failures
- When creating guidance text and diagrams for "where to place the card on iPhone" and "don't move"
- When updating `session.alertMessage` as reading progresses
- When considering an App Clip for JPKI without requiring app installation
- When building onboarding before first reading (tap position, PIN, don't move)

## Errors and User-Facing Messages

Cast `error` from `didInvalidateWithError` to `error as? NFCReaderError` and branch on `.code`. `NFCReaderError.Code` values are confirmed in Apple documentation (sources below). **Wrong PIN, PIN locked, and "not a My Number Card" are NOT CoreNFC errors — they come from APDU response SW1SW2 or custom logic**, so there is no corresponding `NFCReaderError` code. Messages are examples; adjust to your product's tone.

| Situation | NFCReaderError, etc. | User-Facing Message (Example) |
|---|---|---|
| Card moved away / connection lost during reading | `readerTransceiveErrorTagConnectionLost` | "The card was moved away. Place the card on the top of your iPhone and don't move it until reading is complete." |
| Retry limit exceeded (poor contact / hand shake) | `readerTransceiveErrorRetryExceeded` | "Could not read properly. Remove your case and try again without moving the card." |
| Unexpected response from card | `readerTransceiveErrorTagResponseError` | "Could not read the card. Please try again." |
| Session timeout (no tag detected within time) | `readerSessionInvalidationErrorSessionTimeout` | "Could not read within the time limit. Please try again." |
| User closed sheet / cancelled | `readerSessionInvalidationErrorUserCanceled` | Don't show an error. Silently return to previous screen (optionally "Reading was cancelled"). |
| System temporarily busy / called `begin()` while another session active | `readerSessionInvalidationErrorSystemIsBusy` | "Cannot start reading right now. Please wait a moment and try again." |
| Session terminated unexpectedly | `readerSessionInvalidationErrorSessionTerminatedUnexpectedly` | "Reading was interrupted. Please try again." |
| NFC radio disabled (airplane mode, etc.) | `readerErrorRadioDisabled` | "NFC is not available. Check settings such as airplane mode and try again." |
| This device does not support NFC reading | Not an error; pre-check with `NFCTagReaderSession.readingAvailable == false` | "This iPhone does not support NFC reading." (Don't show the reading button) |
| Security violation (entitlement misconfiguration, etc.) | `readerErrorSecurityViolation` | Implementation/distribution configuration issue. Show generic failure to user. |
| Invalid APDU parameter / packet length | `readerErrorInvalidParameter` / `readerErrorInvalidParameterLength` / `readerTransceiveErrorPacketTooLong` | Implementation bug. Show "Reading failed." to user. Check APDU in logs. |
| Tapped card is not a My Number Card / no supported AP | No CoreNFC error. `didDetect` shows non-`.iso7816`, or SELECT returns `6A 82`. Self-call `session.invalidate(errorMessage:)` | "Could not read My Number Card. Please verify it is a My Number Card." |
| Wrong PIN | No CoreNFC error. VERIFY response `63 CX` (`X` = remaining count) | "Incorrect PIN. You can try ◯ more times." → Details in `pin-lock-handling` |
| PIN locked | No CoreNFC error. VERIFY response `69 83` | "Your PIN has been locked. Please visit your municipal office for procedures." → Flow in `pin-lock-handling` |

- Close the session with `session.invalidate()` on both success and failure. When you want to show the reason to the user, `session.invalidate(errorMessage:)` displays the message in red on the system scan sheet.
- The detailed messages and screen transitions from the table above should be shown in your own UI. Keep system sheet messages short; show "why it failed" and "what to do next" thoroughly on in-app result screens (PDF 33's "present specific failure reasons").
- Delegate callbacks are called on the session's queue. Dispatch UI updates to `DispatchQueue.main` (`ios-corenfc-apdu`).

## Antenna Position and How to Hold

- **NFC antenna position varies by iPhone model.** What can be said with certainty is only "**place the center of the card on the top of the iPhone (near camera ~ top edge).**" Do not publish per-model coordinate tables as fact (see "Unverified Items" below).
- Key guidance points:
  - Place the **center** of the card on the **top** of the iPhone (focus on the center of the card, not the entire card)
  - **Remove the case** (especially book-type, metal, card case integrated, and MagSafe accessories)
  - After placing, **hold still and wait several seconds**. Don't move either the iPhone or the card during reading
  - Don't stack multiple IC cards (interference with transit IC cards, etc.)
  - Try shifting position slightly and waiting a few seconds. If it doesn't work, move a few millimeters front/back or left/right
- PDF 33 mentions an IC chip auto-detection feature for Android that "allows anyone to easily identify where to tap, even though reading position varies by model." On iOS, "top of device" is the general guideline, but guide with the assumption that exact position varies by device.
- Keep illustrations as a conceptual diagram of "overlaying the card on the top of the iPhone." Don't draw a specific model's placement as the correct answer for all models.

## alertMessage During Session

`session.alertMessage` is the string displayed on the system scan sheet and can be updated at any time during the session. Update it to guide the user as reading progresses.

```swift
// At session start
session.alertMessage = "Place your My Number Card on the top of the iPhone and hold it still."

// After tag detection & connect, during reading
session.alertMessage = "Reading... Please don't move the card."

// When reading of long EF (certificate, etc.) is progressing
session.alertMessage = "Almost done. Please continue holding still."

// Success
session.alertMessage = "Reading complete."
session.invalidate()

// Failure (displayed in red on system sheet)
session.invalidate(errorMessage: "Reading failed. Please remove your case and try again.")
```

- Keep `alertMessage` concise. Show detailed steps and causes in in-app screens.
- PIN entry cannot be done on the system sheet. For flows involving VERIFY, have the user enter the PIN in-app before starting the session, and during the session focus only on "hold still" guidance.

## App Clip Use Cases

- **App Clip** is a lightweight version that allows using some features without installing the full app. Launched from web pages, Spotlight, and other digital pathways. PDF 21 mentions App Clip support for JPKI, shortening the traditional "open App Store → search → download → launch" to "access web → launch App Clip," **eliminating the installation friction to prevent service dropout**.
- **Suitable scenarios**: One-time identity verification for account opening, user registration, etc., where the user doesn't need to continue using the app. Skips the high-dropout "install the app" step.
- **Relationship with NFC / CoreNFC**: CoreNFC is NOT included in Apple's "frameworks that don't work in App Clips" list. NFC capability/entitlement (see `ios-corenfc-apdu`) must also be configured on the App Clip side. However, no official Apple documentation explicitly states "CoreNFC reading sessions work within App Clips" has been confirmed (see "Unverified Items" below). Verify before implementation.
- **Constraints**:
  - App Clips cannot run in the background. NFC **background tag reading** is not available; limited to foreground reader sessions (`NFCTagReaderSession` / `NFCNDEFReaderSession`). My Number Card reading uses foreground sessions, so this is normally not an issue.
  - There is a size limit (15 MB / 100 MB depending on iOS version; details and conditions in sources below). Minimize to the essentials needed for reading and PIN entry.
  - An App Clip is provided as a pair with one corresponding full app, and the full app must include the same functionality as the App Clip.
- Share reading/error handling code between the full app and App Clip, using the same UX messages and onboarding.

## Onboarding

Before the first reading, insert a single screen that proactively explains the main causes of failure (PDF 33's "thorough instruction page that considers all anticipated failure scenarios").

- [ ] **Where to place** — "Overlap the **center** of the card on the **top** of your iPhone." Keep illustrations as conceptual diagrams (don't show per-model coordinates)
- [ ] **Remove the case** — Remove book-type, metal, card-integrated cases, and MagSafe accessories
- [ ] **Don't move** — "Hold still and wait several seconds after placing." Communicate that lifting during reading means starting over
- [ ] **Prepare your PIN** — Clearly state which PIN (digit count, type) is needed. Don't let users confuse PIN types (`pin-lock-handling`)
- [ ] **Estimated time** — Communicate in advance that it will take some time, e.g., "It takes about 10-20 seconds"
- [ ] **It's okay if reading fails** — Reading failure itself does not affect PIN attempt count. However, correctly convey that wrong PINs reduce remaining attempts
- [ ] **Interrupt and resume** — Can stop midway and start over
- In App Clips, structure to complete with just this screen and the reading screen.

## Sources

PDFs under `references/pdfs/` are third-party works and are not shipped with the plugin. If a file is missing, run `bash references/refresh.sh` to download it (URLs and SHA256 are in `references/sources.md`).

- `references/pdfs/21_guide-public-personal-authentication.pdf` (Double Standard Corporation "eKYC Solution Using JPKI" p6 — App Clip: "Access web → Launch App Clip → Hold My Number Card and enter password" without installation; operators "can expect effects in preventing service dropout." Retrieved 2026-09-08)
- `references/pdfs/33_guide-liquid-ekyc.pdf` (Liquid "LIQUID eKYC" p16 "Mechanisms to thoroughly prevent user dropout" — instructions and error handling (instruction pages considering anticipated failure scenarios, presenting specific failure reasons during reading), IC chip auto-detection (Android reading position varies by model), high-level real-time image quality checks. Retrieved 2026-09-08)
- <https://developer.apple.com/documentation/corenfc/nfcreadererror-swift.struct> (`NFCReaderError` and `NFCReaderError.Code`. Confirmed codes listed. HTTP 200. Retrieved 2026-09-08)
- <https://developer.apple.com/documentation/corenfc/nfcreadersessionprotocol/alertmessage> (`alertMessage` displayed on scan sheet, updatable during session. HTTP 200. Retrieved 2026-09-08)
- <https://developer.apple.com/documentation/corenfc/nfctagreadersession> (`readingAvailable`, `invalidate()` / `invalidate(errorMessage:)`. HTTP 200. Retrieved 2026-09-08)
- <https://developer.apple.com/documentation/appclip/choosing-the-right-functionality-for-your-app-clip> (CoreNFC NOT in App Clip's "non-functioning frameworks" list. App Clips cannot run in background. Size limits: iOS 15 and earlier 10 MB / iOS 16 and earlier 15 MB / iOS 17+ up to 100 MB (conditional). Provide as single target with same functionality as full app. HTTP 200. Retrieved 2026-09-08)
- `ekyc-jp/skills/ios-corenfc-apdu/SKILL.md` / `ekyc-jp/skills/pin-lock-handling/SKILL.md` (session implementation, `alertMessage` initial values, SW1SW2 interpretation alignment)

## Last Verified: 2026-09-08

## Unverified Items

- Exact NFC antenna position for each iPhone model. Beyond the general guideline of "top," positions vary by device and no primary source for per-model coordinate tables has been confirmed. Keep guidance to "card center on iPhone top."
- Specifically which operations trigger `readerErrorRadioDisabled` (airplane mode, temporary hardware disabling, etc.). iPhones have no individual ON/OFF setting UI for CoreNFC, and comprehensive triggers are unconfirmed.
- Whether `NFCTagReaderSession`-based ISO7816 reading actually works within an App Clip. CoreNFC is not in Apple's "non-functioning frameworks" list, but official documentation explicitly confirming CoreNFC operation in App Clips is unconfirmed. PDF 21 only states that the vendor provides JPKI via App Clip.
- Whether `readerSessionInvalidationErrorSystemIsBusy` is returned when calling `begin()` while another session is still open within the same app requires behavioral verification (the constraint that multiple simultaneous sessions are not allowed is documented in `ios-corenfc-apdu`).
- User-facing messages in the table above are examples. The correspondence between actual SW1SW2 and My Number Card-specific behavior follows `references/apdu-cheatsheet.md` and `pin-lock-handling` "Unverified Items."
